
# ----------------------------------------------------------------------------------
#
# Copyright Microsoft Corporation
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
# http://www.apache.org/licenses/LICENSE-2.0
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
# ----------------------------------------------------------------------------------

<#
.Synopsis
The operation to delete a network interface from a virtual machine.
.Description
The operation to delete a network interface from a  virtual machine.

.Outputs
Microsoft.Azure.PowerShell.Cmdlets.StackHCIVM.Models.IVirtualMachineInstance
.Link
https://learn.microsoft.com/powershell/module/az.stackhcivm/remove-azstackhcivmvirtualmachinenetworkinterface
#>

function Remove-AzStackHCIVMVirtualMachineNetworkInterface {
    [OutputType([Microsoft.Azure.PowerShell.Cmdlets.StackHCIVM.Models.IVirtualMachineInstance])]
    [CmdletBinding(PositionalBinding=$false, SupportsShouldProcess, ConfirmImpact='Medium')]
    param(
        [Parameter(ParameterSetName='ByName', Mandatory)]
        [Alias('VirtualMachineName')]
        [Microsoft.Azure.PowerShell.Cmdlets.StackHCIVM.Category('Path')]
        [System.String]
        # Name of the virtual machine
        ${Name},
    
        [Parameter(ParameterSetName='ByName', Mandatory)]
        [Microsoft.Azure.PowerShell.Cmdlets.StackHCIVM.Category('Path')]
        [System.String]
        # The name of the resource group.
        # The name is case insensitive.
        ${ResourceGroupName},
    
        [Parameter(ParameterSetName='ByResourceId', Mandatory)]
        [Microsoft.Azure.PowerShell.Cmdlets.StackHCIVM.Category('Path')]
        [System.String]
        # The ARM Resource ID of the virtual machine.
        ${ResourceId},
    
        [Parameter(ParameterSetName='ByName')]
        [Microsoft.Azure.PowerShell.Cmdlets.StackHCIVM.Category('Path')]
        [Microsoft.Azure.PowerShell.Cmdlets.StackHCIVM.Runtime.DefaultInfo(Script='(Get-AzContext).Subscription.Id')]
        [System.String]
        # The ID of the target subscription.
        ${SubscriptionId},
    
        [Parameter(ParameterSetName='ByResourceId')]
        [Parameter(ParameterSetName='ByName')]
        [AllowEmptyCollection()]
        [Microsoft.Azure.PowerShell.Cmdlets.StackHCIVM.Category('Body')]
        [System.String[]]
        # NetworkInterfaces - list of network interfaces to be attached from  the virtual machine in id format. 
        ${NicId},
    
        [Parameter(ParameterSetName='ByResourceId')]
        [Parameter(ParameterSetName='ByName')]
        [AllowEmptyCollection()]
        [Microsoft.Azure.PowerShell.Cmdlets.StackHCIVM.Category('Body')]
        [System.String[]]
        # NetworkInterfaces - list of network interfaces to be removed from the virtual machine in name format.
        ${NicName},
    
        [Parameter(ParameterSetName='ByResourceId')]
        [Parameter(ParameterSetName='ByName')]
        [AllowEmptyCollection()]
        [Microsoft.Azure.PowerShell.Cmdlets.StackHCIVM.Category('Body')]
        [System.String]
        # NetworkInterfaces - resource group of the network interfaces 
        ${NicResourceGroup},

        
        [Parameter(DontShow)]
        [Microsoft.Azure.PowerShell.Cmdlets.StackHCIVM.Category('Runtime')]
        [System.Management.Automation.SwitchParameter]
        # Wait for .NET debugger to attach
        ${Break},
    
        [Parameter(DontShow)]
        [ValidateNotNull()]
        [Microsoft.Azure.PowerShell.Cmdlets.StackHCIVM.Category('Runtime')]
        [Microsoft.Azure.PowerShell.Cmdlets.StackHCIVM.Runtime.SendAsyncStep[]]
        # SendAsync Pipeline Steps to be appended to the front of the pipeline
        ${HttpPipelineAppend},
    
        [Parameter(DontShow)]
        [ValidateNotNull()]
        [Microsoft.Azure.PowerShell.Cmdlets.StackHCIVM.Category('Runtime')]
        [Microsoft.Azure.PowerShell.Cmdlets.StackHCIVM.Runtime.SendAsyncStep[]]
        # SendAsync Pipeline Steps to be prepended to the front of the pipeline
        ${HttpPipelinePrepend},
    
        [Parameter()]
        [Microsoft.Azure.PowerShell.Cmdlets.StackHCIVM.Category('Runtime')]
        [System.Management.Automation.SwitchParameter]
        # Run the command asynchronously
        ${NoWait},
    
        [Parameter(DontShow)]
        [Microsoft.Azure.PowerShell.Cmdlets.StackHCIVM.Category('Runtime')]
        [System.Uri]
        # The URI for the proxy server to use
        ${Proxy},
    
        [Parameter(DontShow)]
        [ValidateNotNull()]
        [Microsoft.Azure.PowerShell.Cmdlets.StackHCIVM.Category('Runtime')]
        [System.Management.Automation.PSCredential]
        # Credentials for a proxy server to use for the remote call
        ${ProxyCredential},
    
        [Parameter(DontShow)]
        [Microsoft.Azure.PowerShell.Cmdlets.StackHCIVM.Category('Runtime')]
        [System.Management.Automation.SwitchParameter]
        # Use the default credentials for the proxy
        ${ProxyUseDefaultCredentials}
    )
    
        if (($ResourceId -match $vmRegex) -or ($Name -and $ResourceGroupName -and $SubscriptionId)){
            if ($ResourceId -match $vmRegex){
                $SubscriptionId = $($Matches['subscriptionId'])
                $ResourceGroupName = $($Matches['resourceGroupName'])
                $Name = $($Matches['machineName'])
            }
        $null = $PSBoundParameters.Remove("Name")
        $null = $PSBoundParameters.Remove("ResourceGroupName")
        $null = $PSBoundParameters.Remove("SubscriptionId")
        $null = $PSBoundParameters.Remove("ResourceId")
        $resourceUri = "/subscriptions/" + $subscriptionId + "/resourceGroups/" + $ResourceGroupName + "/providers/Microsoft.HybridCompute/machines/" + $Name
        $PSBoundParameters.Add("ResourceUri", $resourceUri)
        } else {             
            Write-Error "One or more input parameters are invalid. Resource ID is: $ResourceId, name is $name, resource group name is $resourcegroupname, subscription id is $subscriptionid"
        }
        
        $NewNetworkProfileNetworkInterface =  [System.Collections.ArrayList]::new()
        $nicList =  [System.Collections.ArrayList]::new()
        $VM = Az.StackHCIVM.internal\Get-AzStackHCIVMVirtualMachine -ResourceUri $resourceUri

        if ($VM.NetworkProfileNetworkInterface.Id.GetType() -eq [System.String]){
            [void]$nicList.add($VM.NetworkProfileNetworkInterface.Id)
        } else {
            $nicList = [System.Collections.ArrayList]$VM.NetworkProfileNetworkInterface.Id
        }

        if ($NicId){
            $NicId = $PSBoundParameters['NicId']
            $null = $PSBoundParameters.Remove("NicId")
            
            foreach ($NId in $NicId){
                $nicName = ($NId -split "/")[8]
                if ($NId -in $nicList){
                    $nicList.Remove($NId)
                } elseif ($nicName -in $nicList){
                    $nicList.Remove($nicName)
                } else {
                    Write-Error "Network Interface not currently attached: $NId"
                }
            }
    
        } elseif ($NicName){
            $rg = $ResourceGroupName
            if($NicResourceGroup){
              $rg = $NicResourceGroup
            }
    
            $null = $PSBoundParameters.Remove("NicName")
            $null = $PSBoundParameters.Remove("NicResourceGroup")

            
            foreach ($NName in $NicName){
                $NId = "/subscriptions/$SubscriptionId/resourceGroups/$rg/providers/Microsoft.AzureStackHCI/networkInterfaces/$NName"
                if ($NId -in $nicList){
                    [void]$nicList.Remove($NId)
                } elseif ($NName -in $nicList) {
                    $nicList.Remove($NName)
                } else {
                    Write-Error "Network Interface not currently attached: $NName"
                }
            }
    
        }

        foreach ($nic in $nicList){
            $Nic = @{Id = $nic}
            [void]$NewNetworkProfileNetworkInterface.Add($Nic)
        }
       

        $PSBoundParameters.Add('NetworkProfileNetworkInterface',  $NewNetworkProfileNetworkInterface)
        
        return Az.StackHCIVM.internal\Update-AzStackHCIVMVirtualMachine @PSBoundParameters
    }
# SIG # Begin signature block
# MIIoPAYJKoZIhvcNAQcCoIIoLTCCKCkCAQExDzANBglghkgBZQMEAgEFADB5Bgor
# BgEEAYI3AgEEoGswaTA0BgorBgEEAYI3AgEeMCYCAwEAAAQQH8w7YFlLCE63JNLG
# KX7zUQIBAAIBAAIBAAIBAAIBADAxMA0GCWCGSAFlAwQCAQUABCClmkA56mLT64J9
# hx/mqfKvrES2pUZqXHU1lwu+VsMYrqCCDYUwggYDMIID66ADAgECAhMzAAADri01
# UchTj1UdAAAAAAOuMA0GCSqGSIb3DQEBCwUAMH4xCzAJBgNVBAYTAlVTMRMwEQYD
# VQQIEwpXYXNoaW5ndG9uMRAwDgYDVQQHEwdSZWRtb25kMR4wHAYDVQQKExVNaWNy
# b3NvZnQgQ29ycG9yYXRpb24xKDAmBgNVBAMTH01pY3Jvc29mdCBDb2RlIFNpZ25p
# bmcgUENBIDIwMTEwHhcNMjMxMTE2MTkwODU5WhcNMjQxMTE0MTkwODU5WjB0MQsw
# CQYDVQQGEwJVUzETMBEGA1UECBMKV2FzaGluZ3RvbjEQMA4GA1UEBxMHUmVkbW9u
# ZDEeMBwGA1UEChMVTWljcm9zb2Z0IENvcnBvcmF0aW9uMR4wHAYDVQQDExVNaWNy
# b3NvZnQgQ29ycG9yYXRpb24wggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIB
# AQD0IPymNjfDEKg+YyE6SjDvJwKW1+pieqTjAY0CnOHZ1Nj5irGjNZPMlQ4HfxXG
# yAVCZcEWE4x2sZgam872R1s0+TAelOtbqFmoW4suJHAYoTHhkznNVKpscm5fZ899
# QnReZv5WtWwbD8HAFXbPPStW2JKCqPcZ54Y6wbuWV9bKtKPImqbkMcTejTgEAj82
# 6GQc6/Th66Koka8cUIvz59e/IP04DGrh9wkq2jIFvQ8EDegw1B4KyJTIs76+hmpV
# M5SwBZjRs3liOQrierkNVo11WuujB3kBf2CbPoP9MlOyyezqkMIbTRj4OHeKlamd
# WaSFhwHLJRIQpfc8sLwOSIBBAgMBAAGjggGCMIIBfjAfBgNVHSUEGDAWBgorBgEE
# AYI3TAgBBggrBgEFBQcDAzAdBgNVHQ4EFgQUhx/vdKmXhwc4WiWXbsf0I53h8T8w
# VAYDVR0RBE0wS6RJMEcxLTArBgNVBAsTJE1pY3Jvc29mdCBJcmVsYW5kIE9wZXJh
# dGlvbnMgTGltaXRlZDEWMBQGA1UEBRMNMjMwMDEyKzUwMTgzNjAfBgNVHSMEGDAW
# gBRIbmTlUAXTgqoXNzcitW2oynUClTBUBgNVHR8ETTBLMEmgR6BFhkNodHRwOi8v
# d3d3Lm1pY3Jvc29mdC5jb20vcGtpb3BzL2NybC9NaWNDb2RTaWdQQ0EyMDExXzIw
# MTEtMDctMDguY3JsMGEGCCsGAQUFBwEBBFUwUzBRBggrBgEFBQcwAoZFaHR0cDov
# L3d3dy5taWNyb3NvZnQuY29tL3BraW9wcy9jZXJ0cy9NaWNDb2RTaWdQQ0EyMDEx
# XzIwMTEtMDctMDguY3J0MAwGA1UdEwEB/wQCMAAwDQYJKoZIhvcNAQELBQADggIB
# AGrJYDUS7s8o0yNprGXRXuAnRcHKxSjFmW4wclcUTYsQZkhnbMwthWM6cAYb/h2W
# 5GNKtlmj/y/CThe3y/o0EH2h+jwfU/9eJ0fK1ZO/2WD0xi777qU+a7l8KjMPdwjY
# 0tk9bYEGEZfYPRHy1AGPQVuZlG4i5ymJDsMrcIcqV8pxzsw/yk/O4y/nlOjHz4oV
# APU0br5t9tgD8E08GSDi3I6H57Ftod9w26h0MlQiOr10Xqhr5iPLS7SlQwj8HW37
# ybqsmjQpKhmWul6xiXSNGGm36GarHy4Q1egYlxhlUnk3ZKSr3QtWIo1GGL03hT57
# xzjL25fKiZQX/q+II8nuG5M0Qmjvl6Egltr4hZ3e3FQRzRHfLoNPq3ELpxbWdH8t
# Nuj0j/x9Crnfwbki8n57mJKI5JVWRWTSLmbTcDDLkTZlJLg9V1BIJwXGY3i2kR9i
# 5HsADL8YlW0gMWVSlKB1eiSlK6LmFi0rVH16dde+j5T/EaQtFz6qngN7d1lvO7uk
# 6rtX+MLKG4LDRsQgBTi6sIYiKntMjoYFHMPvI/OMUip5ljtLitVbkFGfagSqmbxK
# 7rJMhC8wiTzHanBg1Rrbff1niBbnFbbV4UDmYumjs1FIpFCazk6AADXxoKCo5TsO
# zSHqr9gHgGYQC2hMyX9MGLIpowYCURx3L7kUiGbOiMwaMIIHejCCBWKgAwIBAgIK
# YQ6Q0gAAAAAAAzANBgkqhkiG9w0BAQsFADCBiDELMAkGA1UEBhMCVVMxEzARBgNV
# BAgTCldhc2hpbmd0b24xEDAOBgNVBAcTB1JlZG1vbmQxHjAcBgNVBAoTFU1pY3Jv
# c29mdCBDb3Jwb3JhdGlvbjEyMDAGA1UEAxMpTWljcm9zb2Z0IFJvb3QgQ2VydGlm
# aWNhdGUgQXV0aG9yaXR5IDIwMTEwHhcNMTEwNzA4MjA1OTA5WhcNMjYwNzA4MjEw
# OTA5WjB+MQswCQYDVQQGEwJVUzETMBEGA1UECBMKV2FzaGluZ3RvbjEQMA4GA1UE
# BxMHUmVkbW9uZDEeMBwGA1UEChMVTWljcm9zb2Z0IENvcnBvcmF0aW9uMSgwJgYD
# VQQDEx9NaWNyb3NvZnQgQ29kZSBTaWduaW5nIFBDQSAyMDExMIICIjANBgkqhkiG
# 9w0BAQEFAAOCAg8AMIICCgKCAgEAq/D6chAcLq3YbqqCEE00uvK2WCGfQhsqa+la
# UKq4BjgaBEm6f8MMHt03a8YS2AvwOMKZBrDIOdUBFDFC04kNeWSHfpRgJGyvnkmc
# 6Whe0t+bU7IKLMOv2akrrnoJr9eWWcpgGgXpZnboMlImEi/nqwhQz7NEt13YxC4D
# dato88tt8zpcoRb0RrrgOGSsbmQ1eKagYw8t00CT+OPeBw3VXHmlSSnnDb6gE3e+
# lD3v++MrWhAfTVYoonpy4BI6t0le2O3tQ5GD2Xuye4Yb2T6xjF3oiU+EGvKhL1nk
# kDstrjNYxbc+/jLTswM9sbKvkjh+0p2ALPVOVpEhNSXDOW5kf1O6nA+tGSOEy/S6
# A4aN91/w0FK/jJSHvMAhdCVfGCi2zCcoOCWYOUo2z3yxkq4cI6epZuxhH2rhKEmd
# X4jiJV3TIUs+UsS1Vz8kA/DRelsv1SPjcF0PUUZ3s/gA4bysAoJf28AVs70b1FVL
# 5zmhD+kjSbwYuER8ReTBw3J64HLnJN+/RpnF78IcV9uDjexNSTCnq47f7Fufr/zd
# sGbiwZeBe+3W7UvnSSmnEyimp31ngOaKYnhfsi+E11ecXL93KCjx7W3DKI8sj0A3
# T8HhhUSJxAlMxdSlQy90lfdu+HggWCwTXWCVmj5PM4TasIgX3p5O9JawvEagbJjS
# 4NaIjAsCAwEAAaOCAe0wggHpMBAGCSsGAQQBgjcVAQQDAgEAMB0GA1UdDgQWBBRI
# bmTlUAXTgqoXNzcitW2oynUClTAZBgkrBgEEAYI3FAIEDB4KAFMAdQBiAEMAQTAL
# BgNVHQ8EBAMCAYYwDwYDVR0TAQH/BAUwAwEB/zAfBgNVHSMEGDAWgBRyLToCMZBD
# uRQFTuHqp8cx0SOJNDBaBgNVHR8EUzBRME+gTaBLhklodHRwOi8vY3JsLm1pY3Jv
# c29mdC5jb20vcGtpL2NybC9wcm9kdWN0cy9NaWNSb29DZXJBdXQyMDExXzIwMTFf
# MDNfMjIuY3JsMF4GCCsGAQUFBwEBBFIwUDBOBggrBgEFBQcwAoZCaHR0cDovL3d3
# dy5taWNyb3NvZnQuY29tL3BraS9jZXJ0cy9NaWNSb29DZXJBdXQyMDExXzIwMTFf
# MDNfMjIuY3J0MIGfBgNVHSAEgZcwgZQwgZEGCSsGAQQBgjcuAzCBgzA/BggrBgEF
# BQcCARYzaHR0cDovL3d3dy5taWNyb3NvZnQuY29tL3BraW9wcy9kb2NzL3ByaW1h
# cnljcHMuaHRtMEAGCCsGAQUFBwICMDQeMiAdAEwAZQBnAGEAbABfAHAAbwBsAGkA
# YwB5AF8AcwB0AGEAdABlAG0AZQBuAHQALiAdMA0GCSqGSIb3DQEBCwUAA4ICAQBn
# 8oalmOBUeRou09h0ZyKbC5YR4WOSmUKWfdJ5DJDBZV8uLD74w3LRbYP+vj/oCso7
# v0epo/Np22O/IjWll11lhJB9i0ZQVdgMknzSGksc8zxCi1LQsP1r4z4HLimb5j0b
# pdS1HXeUOeLpZMlEPXh6I/MTfaaQdION9MsmAkYqwooQu6SpBQyb7Wj6aC6VoCo/
# KmtYSWMfCWluWpiW5IP0wI/zRive/DvQvTXvbiWu5a8n7dDd8w6vmSiXmE0OPQvy
# CInWH8MyGOLwxS3OW560STkKxgrCxq2u5bLZ2xWIUUVYODJxJxp/sfQn+N4sOiBp
# mLJZiWhub6e3dMNABQamASooPoI/E01mC8CzTfXhj38cbxV9Rad25UAqZaPDXVJi
# hsMdYzaXht/a8/jyFqGaJ+HNpZfQ7l1jQeNbB5yHPgZ3BtEGsXUfFL5hYbXw3MYb
# BL7fQccOKO7eZS/sl/ahXJbYANahRr1Z85elCUtIEJmAH9AAKcWxm6U/RXceNcbS
# oqKfenoi+kiVH6v7RyOA9Z74v2u3S5fi63V4GuzqN5l5GEv/1rMjaHXmr/r8i+sL
# gOppO6/8MO0ETI7f33VtY5E90Z1WTk+/gFcioXgRMiF670EKsT/7qMykXcGhiJtX
# cVZOSEXAQsmbdlsKgEhr/Xmfwb1tbWrJUnMTDXpQzTGCGg0wghoJAgEBMIGVMH4x
# CzAJBgNVBAYTAlVTMRMwEQYDVQQIEwpXYXNoaW5ndG9uMRAwDgYDVQQHEwdSZWRt
# b25kMR4wHAYDVQQKExVNaWNyb3NvZnQgQ29ycG9yYXRpb24xKDAmBgNVBAMTH01p
# Y3Jvc29mdCBDb2RlIFNpZ25pbmcgUENBIDIwMTECEzMAAAOuLTVRyFOPVR0AAAAA
# A64wDQYJYIZIAWUDBAIBBQCgga4wGQYJKoZIhvcNAQkDMQwGCisGAQQBgjcCAQQw
# HAYKKwYBBAGCNwIBCzEOMAwGCisGAQQBgjcCARUwLwYJKoZIhvcNAQkEMSIEIPvM
# tTI6U1lhzhcHQu3RolrJAaZeK4H98zLacDLs9zeHMEIGCisGAQQBgjcCAQwxNDAy
# oBSAEgBNAGkAYwByAG8AcwBvAGYAdKEagBhodHRwOi8vd3d3Lm1pY3Jvc29mdC5j
# b20wDQYJKoZIhvcNAQEBBQAEggEADFC9u8HpvGiNq/hCEtx5iF0hImvnKCtdIFCJ
# 5/7RBUowDYr5nAl6wsRkMQFjYEFVGaqoyybRDdBdTUO7NHz670tu73mD4JQ/x5XT
# ym/lQUTD+tfw1ODgDdjbAHI1OzOlpxYesLy1K6iYfazObY77ts3rTukQS8rhGonL
# AFrCr9JqK2AMgpD9vg0HQlnXFDcQ3KmTW3g41eX6pCglYta6Ja+xm9OdTXQhwJ3r
# 7bNgPVObTMWKkJdc/MEQuWvMvzCfD4RCcvkIJs149a3qMeSdpioweW7JkO75h9U3
# 5HZtpIzhVbbJZReOiWK9mXVqg5wapqw16ar/IsrTMs/03paiT6GCF5cwgheTBgor
# BgEEAYI3AwMBMYIXgzCCF38GCSqGSIb3DQEHAqCCF3AwghdsAgEDMQ8wDQYJYIZI
# AWUDBAIBBQAwggFSBgsqhkiG9w0BCRABBKCCAUEEggE9MIIBOQIBAQYKKwYBBAGE
# WQoDATAxMA0GCWCGSAFlAwQCAQUABCCR7+0Sj8CuZFVmHANqr1rxp3RiTwVHjmV1
# cKj9PYINJQIGZuLjUgR1GBMyMDI0MTAwODA1MDcwNS43ODJaMASAAgH0oIHRpIHO
# MIHLMQswCQYDVQQGEwJVUzETMBEGA1UECBMKV2FzaGluZ3RvbjEQMA4GA1UEBxMH
# UmVkbW9uZDEeMBwGA1UEChMVTWljcm9zb2Z0IENvcnBvcmF0aW9uMSUwIwYDVQQL
# ExxNaWNyb3NvZnQgQW1lcmljYSBPcGVyYXRpb25zMScwJQYDVQQLEx5uU2hpZWxk
# IFRTUyBFU046QTAwMC0wNUUwLUQ5NDcxJTAjBgNVBAMTHE1pY3Jvc29mdCBUaW1l
# LVN0YW1wIFNlcnZpY2WgghHtMIIHIDCCBQigAwIBAgITMwAAAevgGGy1tu847QAB
# AAAB6zANBgkqhkiG9w0BAQsFADB8MQswCQYDVQQGEwJVUzETMBEGA1UECBMKV2Fz
# aGluZ3RvbjEQMA4GA1UEBxMHUmVkbW9uZDEeMBwGA1UEChMVTWljcm9zb2Z0IENv
# cnBvcmF0aW9uMSYwJAYDVQQDEx1NaWNyb3NvZnQgVGltZS1TdGFtcCBQQ0EgMjAx
# MDAeFw0yMzEyMDYxODQ1MzRaFw0yNTAzMDUxODQ1MzRaMIHLMQswCQYDVQQGEwJV
# UzETMBEGA1UECBMKV2FzaGluZ3RvbjEQMA4GA1UEBxMHUmVkbW9uZDEeMBwGA1UE
# ChMVTWljcm9zb2Z0IENvcnBvcmF0aW9uMSUwIwYDVQQLExxNaWNyb3NvZnQgQW1l
# cmljYSBPcGVyYXRpb25zMScwJQYDVQQLEx5uU2hpZWxkIFRTUyBFU046QTAwMC0w
# NUUwLUQ5NDcxJTAjBgNVBAMTHE1pY3Jvc29mdCBUaW1lLVN0YW1wIFNlcnZpY2Uw
# ggIiMA0GCSqGSIb3DQEBAQUAA4ICDwAwggIKAoICAQDBFWgh2lbgV3eJp01oqiaF
# BuYbNc7hSKmktvJ15NrB/DBboUow8WPOTPxbn7gcmIOGmwJkd+TyFx7KOnzrxnoB
# 3huvv91fZuUugIsKTnAvg2BU/nfN7Zzn9Kk1mpuJ27S6xUDH4odFiX51ICcKl6EG
# 4cxKgcDAinihT8xroJWVATL7p8bbfnwsc1pihZmcvIuYGnb1TY9tnpdChWr9EARu
# Co3TiRGjM2Lp4piT2lD5hnd3VaGTepNqyakpkCGV0+cK8Vu/HkIZdvy+z5EL3ojT
# dFLL5vJ9IAogWf3XAu3d7SpFaaoeix0e1q55AD94ZwDP+izqLadsBR3tzjq2RfrC
# NL+Tmi/jalRto/J6bh4fPhHETnDC78T1yfXUQdGtmJ/utI/ANxi7HV8gAPzid9TY
# jMPbYqG8y5xz+gI/SFyj+aKtHHWmKzEXPttXzAcexJ1EH7wbuiVk3sErPK9MLg1X
# b6hM5HIWA0jEAZhKEyd5hH2XMibzakbp2s2EJQWasQc4DMaF1EsQ1CzgClDYIYG6
# rUhudfI7k8L9KKCEufRbK5ldRYNAqddr/ySJfuZv3PS3+vtD6X6q1H4UOmjDKdjo
# W3qs7JRMZmH9fkFkMzb6YSzr6eX1LoYm3PrO1Jea43SYzlB3Tz84OvuVSV7NcidV
# tNqiZeWWpVjfavR+Jj/JOQIDAQABo4IBSTCCAUUwHQYDVR0OBBYEFHSeBazWVcxu
# 4qT9O5jT2B+qAerhMB8GA1UdIwQYMBaAFJ+nFV0AXmJdg/Tl0mWnG1M1GelyMF8G
# A1UdHwRYMFYwVKBSoFCGTmh0dHA6Ly93d3cubWljcm9zb2Z0LmNvbS9wa2lvcHMv
# Y3JsL01pY3Jvc29mdCUyMFRpbWUtU3RhbXAlMjBQQ0ElMjAyMDEwKDEpLmNybDBs
# BggrBgEFBQcBAQRgMF4wXAYIKwYBBQUHMAKGUGh0dHA6Ly93d3cubWljcm9zb2Z0
# LmNvbS9wa2lvcHMvY2VydHMvTWljcm9zb2Z0JTIwVGltZS1TdGFtcCUyMFBDQSUy
# MDIwMTAoMSkuY3J0MAwGA1UdEwEB/wQCMAAwFgYDVR0lAQH/BAwwCgYIKwYBBQUH
# AwgwDgYDVR0PAQH/BAQDAgeAMA0GCSqGSIb3DQEBCwUAA4ICAQCDdN8voPd8C+VW
# ZP3+W87c/QbdbWK0sOt9Z4kEOWng7Kmh+WD2LnPJTJKIEaxniOct9wMgJ8yQywR8
# WHgDOvbwqdqsLUaM4NrertI6FI9rhjheaKxNNnBZzHZLDwlkL9vCEDe9Rc0dGSVd
# 5Bg3CWknV3uvVau14F55ESTWIBNaQS9Cpo2Opz3cRgAYVfaLFGbArNcRvSWvSUbe
# I2IDqRxC4xBbRiNQ+1qHXDCPn0hGsXfL+ynDZncCfszNrlgZT24XghvTzYMHcXio
# LVYo/2Hkyow6dI7uULJbKxLX8wHhsiwriXIDCnjLVsG0E5bR82QgcseEhxbU2d1R
# VHcQtkUE7W9zxZqZ6/jPmaojZgXQO33XjxOHYYVa/BXcIuu8SMzPjjAAbujwTawp
# azLBv997LRB0ZObNckJYyQQpETSflN36jW+z7R/nGyJqRZ3HtZ1lXW1f6zECAeP+
# 9dy6nmcCrVcOqbQHX7Zr8WPcghHJAADlm5ExPh5xi1tNRk+i6F2a9SpTeQnZXP50
# w+JoTxISQq7vBij2nitAsSLaVeMqoPi+NXlTUNZ2NdtbFr6Iir9ZK9ufaz3FxfvD
# Zo365vLOozmQOe/Z+pu4vY5zPmtNiVIcQnFy7JZOiZVDI5bIdwQRai2quHKJ6ltU
# dsi3HjNnieuE72fT4eWhxtmnN5HYCDCCB3EwggVZoAMCAQICEzMAAAAVxedrngKb
# SZkAAAAAABUwDQYJKoZIhvcNAQELBQAwgYgxCzAJBgNVBAYTAlVTMRMwEQYDVQQI
# EwpXYXNoaW5ndG9uMRAwDgYDVQQHEwdSZWRtb25kMR4wHAYDVQQKExVNaWNyb3Nv
# ZnQgQ29ycG9yYXRpb24xMjAwBgNVBAMTKU1pY3Jvc29mdCBSb290IENlcnRpZmlj
# YXRlIEF1dGhvcml0eSAyMDEwMB4XDTIxMDkzMDE4MjIyNVoXDTMwMDkzMDE4MzIy
# NVowfDELMAkGA1UEBhMCVVMxEzARBgNVBAgTCldhc2hpbmd0b24xEDAOBgNVBAcT
# B1JlZG1vbmQxHjAcBgNVBAoTFU1pY3Jvc29mdCBDb3Jwb3JhdGlvbjEmMCQGA1UE
# AxMdTWljcm9zb2Z0IFRpbWUtU3RhbXAgUENBIDIwMTAwggIiMA0GCSqGSIb3DQEB
# AQUAA4ICDwAwggIKAoICAQDk4aZM57RyIQt5osvXJHm9DtWC0/3unAcH0qlsTnXI
# yjVX9gF/bErg4r25PhdgM/9cT8dm95VTcVrifkpa/rg2Z4VGIwy1jRPPdzLAEBjo
# YH1qUoNEt6aORmsHFPPFdvWGUNzBRMhxXFExN6AKOG6N7dcP2CZTfDlhAnrEqv1y
# aa8dq6z2Nr41JmTamDu6GnszrYBbfowQHJ1S/rboYiXcag/PXfT+jlPP1uyFVk3v
# 3byNpOORj7I5LFGc6XBpDco2LXCOMcg1KL3jtIckw+DJj361VI/c+gVVmG1oO5pG
# ve2krnopN6zL64NF50ZuyjLVwIYwXE8s4mKyzbnijYjklqwBSru+cakXW2dg3viS
# kR4dPf0gz3N9QZpGdc3EXzTdEonW/aUgfX782Z5F37ZyL9t9X4C626p+Nuw2TPYr
# bqgSUei/BQOj0XOmTTd0lBw0gg/wEPK3Rxjtp+iZfD9M269ewvPV2HM9Q07BMzlM
# jgK8QmguEOqEUUbi0b1qGFphAXPKZ6Je1yh2AuIzGHLXpyDwwvoSCtdjbwzJNmSL
# W6CmgyFdXzB0kZSU2LlQ+QuJYfM2BjUYhEfb3BvR/bLUHMVr9lxSUV0S2yW6r1AF
# emzFER1y7435UsSFF5PAPBXbGjfHCBUYP3irRbb1Hode2o+eFnJpxq57t7c+auIu
# rQIDAQABo4IB3TCCAdkwEgYJKwYBBAGCNxUBBAUCAwEAATAjBgkrBgEEAYI3FQIE
# FgQUKqdS/mTEmr6CkTxGNSnPEP8vBO4wHQYDVR0OBBYEFJ+nFV0AXmJdg/Tl0mWn
# G1M1GelyMFwGA1UdIARVMFMwUQYMKwYBBAGCN0yDfQEBMEEwPwYIKwYBBQUHAgEW
# M2h0dHA6Ly93d3cubWljcm9zb2Z0LmNvbS9wa2lvcHMvRG9jcy9SZXBvc2l0b3J5
# Lmh0bTATBgNVHSUEDDAKBggrBgEFBQcDCDAZBgkrBgEEAYI3FAIEDB4KAFMAdQBi
# AEMAQTALBgNVHQ8EBAMCAYYwDwYDVR0TAQH/BAUwAwEB/zAfBgNVHSMEGDAWgBTV
# 9lbLj+iiXGJo0T2UkFvXzpoYxDBWBgNVHR8ETzBNMEugSaBHhkVodHRwOi8vY3Js
# Lm1pY3Jvc29mdC5jb20vcGtpL2NybC9wcm9kdWN0cy9NaWNSb29DZXJBdXRfMjAx
# MC0wNi0yMy5jcmwwWgYIKwYBBQUHAQEETjBMMEoGCCsGAQUFBzAChj5odHRwOi8v
# d3d3Lm1pY3Jvc29mdC5jb20vcGtpL2NlcnRzL01pY1Jvb0NlckF1dF8yMDEwLTA2
# LTIzLmNydDANBgkqhkiG9w0BAQsFAAOCAgEAnVV9/Cqt4SwfZwExJFvhnnJL/Klv
# 6lwUtj5OR2R4sQaTlz0xM7U518JxNj/aZGx80HU5bbsPMeTCj/ts0aGUGCLu6WZn
# OlNN3Zi6th542DYunKmCVgADsAW+iehp4LoJ7nvfam++Kctu2D9IdQHZGN5tggz1
# bSNU5HhTdSRXud2f8449xvNo32X2pFaq95W2KFUn0CS9QKC/GbYSEhFdPSfgQJY4
# rPf5KYnDvBewVIVCs/wMnosZiefwC2qBwoEZQhlSdYo2wh3DYXMuLGt7bj8sCXgU
# 6ZGyqVvfSaN0DLzskYDSPeZKPmY7T7uG+jIa2Zb0j/aRAfbOxnT99kxybxCrdTDF
# NLB62FD+CljdQDzHVG2dY3RILLFORy3BFARxv2T5JL5zbcqOCb2zAVdJVGTZc9d/
# HltEAY5aGZFrDZ+kKNxnGSgkujhLmm77IVRrakURR6nxt67I6IleT53S0Ex2tVdU
# CbFpAUR+fKFhbHP+CrvsQWY9af3LwUFJfn6Tvsv4O+S3Fb+0zj6lMVGEvL8CwYKi
# excdFYmNcP7ntdAoGokLjzbaukz5m/8K6TT4JDVnK+ANuOaMmdbhIurwJ0I9JZTm
# dHRbatGePu1+oDEzfbzL6Xu/OHBE0ZDxyKs6ijoIYn/ZcGNTTY3ugm2lBRDBcQZq
# ELQdVTNYs6FwZvKhggNQMIICOAIBATCB+aGB0aSBzjCByzELMAkGA1UEBhMCVVMx
# EzARBgNVBAgTCldhc2hpbmd0b24xEDAOBgNVBAcTB1JlZG1vbmQxHjAcBgNVBAoT
# FU1pY3Jvc29mdCBDb3Jwb3JhdGlvbjElMCMGA1UECxMcTWljcm9zb2Z0IEFtZXJp
# Y2EgT3BlcmF0aW9uczEnMCUGA1UECxMeblNoaWVsZCBUU1MgRVNOOkEwMDAtMDVF
# MC1EOTQ3MSUwIwYDVQQDExxNaWNyb3NvZnQgVGltZS1TdGFtcCBTZXJ2aWNloiMK
# AQEwBwYFKw4DAhoDFQCABol1u1wwwYgUtUowMnqYvbul3qCBgzCBgKR+MHwxCzAJ
# BgNVBAYTAlVTMRMwEQYDVQQIEwpXYXNoaW5ndG9uMRAwDgYDVQQHEwdSZWRtb25k
# MR4wHAYDVQQKExVNaWNyb3NvZnQgQ29ycG9yYXRpb24xJjAkBgNVBAMTHU1pY3Jv
# c29mdCBUaW1lLVN0YW1wIFBDQSAyMDEwMA0GCSqGSIb3DQEBCwUAAgUA6q79pjAi
# GA8yMDI0MTAwODAwMzkwMloYDzIwMjQxMDA5MDAzOTAyWjB3MD0GCisGAQQBhFkK
# BAExLzAtMAoCBQDqrv2mAgEAMAoCAQACAgYoAgH/MAcCAQACAhRHMAoCBQDqsE8m
# AgEAMDYGCisGAQQBhFkKBAIxKDAmMAwGCisGAQQBhFkKAwKgCjAIAgEAAgMHoSCh
# CjAIAgEAAgMBhqAwDQYJKoZIhvcNAQELBQADggEBADuZOP2XsjTUTAddFAcJgn7Z
# reDVgD7Uj6AyuNxYRSwytIX3x6I+qhdqUDbFsAN2X4ocuPwz2nNW2TRDafh9tYI4
# sMHsI2cuN9EQU4Ek7QDTdV+9y1sVUeIE3cJyMS0WJtCYZfgToVDezTNCrdr0FcZl
# 0tJDfKW7o2Joturyn+2N/8LDm4v+yJguS+xFCdR8lkPDJAr9RKWZcmuTDygGwNCL
# MVBjKyLvgie3KBd2mA6JwZPoyr5B5HeOVKv803IAVEt7OIMJ1S6KVDNMV2dCD/Va
# oe8MESk1d3iFiHLLb0lgxgwmIz+h1BEWxsl3F+OBkHIDFQrMXRW/1tmW4dIg/4gx
# ggQNMIIECQIBATCBkzB8MQswCQYDVQQGEwJVUzETMBEGA1UECBMKV2FzaGluZ3Rv
# bjEQMA4GA1UEBxMHUmVkbW9uZDEeMBwGA1UEChMVTWljcm9zb2Z0IENvcnBvcmF0
# aW9uMSYwJAYDVQQDEx1NaWNyb3NvZnQgVGltZS1TdGFtcCBQQ0EgMjAxMAITMwAA
# AevgGGy1tu847QABAAAB6zANBglghkgBZQMEAgEFAKCCAUowGgYJKoZIhvcNAQkD
# MQ0GCyqGSIb3DQEJEAEEMC8GCSqGSIb3DQEJBDEiBCBPKI8Q7xwmJ5dO0k2grjUp
# 8wbhpRdJVCsf1TV4esCpyzCB+gYLKoZIhvcNAQkQAi8xgeowgecwgeQwgb0EIM63
# a75faQPhf8SBDTtk2DSUgIbdizXsz76h1JdhLCz4MIGYMIGApH4wfDELMAkGA1UE
# BhMCVVMxEzARBgNVBAgTCldhc2hpbmd0b24xEDAOBgNVBAcTB1JlZG1vbmQxHjAc
# BgNVBAoTFU1pY3Jvc29mdCBDb3Jwb3JhdGlvbjEmMCQGA1UEAxMdTWljcm9zb2Z0
# IFRpbWUtU3RhbXAgUENBIDIwMTACEzMAAAHr4BhstbbvOO0AAQAAAeswIgQgfIvS
# IZ43t9DfrYheO+6jfcqRdpF8I6Nm+Uw5jYB5eOowDQYJKoZIhvcNAQELBQAEggIA
# APlqiJkYzyVrRgLI4/cW/Sf9b9vSsI+BjVsYvnGro48sPWub6JlKYc0Q6beVylCU
# mGA0UVI5oq+Io5v4ekCbRMnxvTjoqpS5Luhshf+T1AgHWeUhECVqS+xHvvtnGoFO
# aM4gZ3eSfsXNFmmd/fmIEU8+DiyaU5zL9uvBkD5br9qlAOw3QlYp7fWSZieOWp7s
# ibChAhwSAvL2T/PaJ0qF99jKVAM4BQ7781NW5J/deVkPK8j8BhNTi2mqjHKR3SnJ
# dJkYXR3bXS3E3STzB7CP6deaUa8usJQZ89W8sh7HftIaFo4AUulpwSpY5LQOikTE
# cwm+0PxRtp6BPRGEaY6j49SUMlqbL0KfPMPFq7zP3t1tnO7szHKukiyH4JPP7v3o
# TfgQWm0f6KSjrfSB7Oa1wUGg6XSGO3OU3hRmUxIxFcXZ39f5cG5vJn4Q6u5zuDwC
# yykFousIx67oXfwKeIHMkn9Hkye+0NkGwdb4cx5uvDuWepBIPQK4eytmU/eQNPOI
# cTzkn3AcNotBdK7Sxlt+QQbhw9kvQ3GBDiO77yaQC6jxI8MbBppFsAW+oysPb2TS
# qs7owXMylyM8I7J7cy84lNuvDjfMvMW/HBFayXL/+wEK70rC+8XKVcj/B2Gki0dY
# AgOCS6g0bSSS2AQ5d1yeey5LJr+9Pj8b22FLdrT07W8=
# SIG # End signature block
