
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
The operation to update a virtual machine instance.
.Description
The operation to update a virtual machine instance.

.Outputs
Microsoft.Azure.PowerShell.Cmdlets.StackHCIVM.Models.IVirtualMachineInstance
.Notes
COMPLEX PARAMETER PROPERTIES



NETWORKPROFILENETWORKINTERFACE <INetworkProfileUpdateNetworkInterfacesItem[]>: NetworkInterfaces - list of network interfaces to be attached to the virtual machine instance
  [Id <String>]: ID - Resource ID of the network interface

STORAGEPROFILEDATADISK <IStorageProfileUpdateDataDisksItem[]>: adds data disks to the virtual machine instance for the update call
  [Id <String>]: 
.Link
https://learn.microsoft.com/powershell/module/az.stackhcivm/update-azstackhcivmvirtualmachine
#>
function Update-AzStackHCIVMVirtualMachine {
    [OutputType([Microsoft.Azure.PowerShell.Cmdlets.StackHCIVM.Models.IVirtualMachineInstance])]
    [CmdletBinding(DefaultParameterSetName='ByName', PositionalBinding=$false, SupportsShouldProcess, ConfirmImpact='Medium')]   

    param( 
        [Parameter(ParameterSetName='ByResourceId', Mandatory)]  
        [Microsoft.Azure.PowerShell.Cmdlets.StackHCIVM.Category('Path')]
        [System.String]
        # The ARM Resource ID of the virtual network.
        ${ResourceId},

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

        [Parameter(ParameterSetName='ByName', Mandatory)]
        [Microsoft.Azure.PowerShell.Cmdlets.StackHCIVM.Category('Path')]
        [Microsoft.Azure.PowerShell.Cmdlets.StackHCIVM.Runtime.DefaultInfo(Script='(Get-AzContext).Subscription.Id')]
        [System.String]
        # The ID of the target subscription.
        ${SubscriptionId},

        [Parameter()]
        [Microsoft.Azure.PowerShell.Cmdlets.StackHCIVM.Category('Body')]
        [System.Management.Automation.SwitchParameter]
        # Indicates whether virtual machine agent should be provisioned on the virtual machine.
        ${ProvisionVMAgent},
  
        [Parameter()]
        [Microsoft.Azure.PowerShell.Cmdlets.StackHCIVM.Category('Body')]
        [System.Management.Automation.SwitchParameter]
        # Indicates whether virtual machine configuration agent should be provisioned on the virtual machine.
        ${ProvisionVMConfigAgent},

        [Parameter()]
        [Microsoft.Azure.PowerShell.Cmdlets.StackHCIVM.Category('Body')]
        [System.Int64]
        # RAM in MB for the virtual machine instance
        ${VmMemoryInMB},
    
        [Parameter()]
        [Microsoft.Azure.PowerShell.Cmdlets.StackHCIVM.Category('Body')]
        [System.Int32]
        # number of processors for the virtual machine instance
        ${VmProcessor},
    
        [Parameter()]
        [Microsoft.Azure.PowerShell.Cmdlets.StackHCIVM.PSArgumentCompleterAttribute("Default", "Standard_A2_v2", "Standard_A4_v2", "Standard_D2s_v3", "Standard_D4s_v3", "Standard_D8s_v3", "Standard_D16s_v3", "Standard_D32s_v3", "Standard_DS2_v2", "Standard_DS3_v2", "Standard_DS4_v2", "Standard_DS5_v2", "Standard_DS13_v2", "Standard_K8S_v1", "Standard_K8S2_v1", "Standard_K8S3_v1", "Standard_K8S4_v1", "Standard_NK6", "Standard_NK12", "Standard_NV6", "Standard_NV12", "Standard_K8S5_v1", "Custom")]
        [Microsoft.Azure.PowerShell.Cmdlets.StackHCIVM.Category('Body')]
        [System.String]
        # .
        ${VmSize},

        [Parameter()]
        [Alias('AzureRMContext', 'AzureCredential')]
        [ValidateNotNull()]
        [Microsoft.Azure.PowerShell.Cmdlets.StackHCIVM.Category('Azure')]
        [System.Management.Automation.PSObject]
        # The credentials, account, tenant, and subscription used for communication with Azure.
        ${DefaultProfile},
    
        [Parameter()]
        [Microsoft.Azure.PowerShell.Cmdlets.StackHCIVM.Category('Runtime')]
        [System.Management.Automation.SwitchParameter]
        # Run the command as a job
        ${AsJob},
    
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
      process {

        if (($ResourceId -match $vmRegex) -or ($Name -and $ResourceGroupName -and $SubscriptionId)){
            if ($ResourceId -match $vmRegex){
                $SubscriptionId = $($Matches['subscriptionId'])
                $ResourceGroupName = $($Matches['resourceGroupName'])
                $Name = $($Matches['machineName'])
            }
            $resourceUri = "/subscriptions/" + $subscriptionId + "/resourceGroups/" + $ResourceGroupName + "/providers/Microsoft.HybridCompute/machines/" + $Name
            $PSBoundParameters.Add("ResourceUri", $resourceUri)
            if ($VmMemoryInMB)
            {
                $PSBoundParameters.Add("HardwareProfileMemoryMb", $VmMemoryInMB)
                $null = $PSBoundParameters.Remove("VmMemoryInMB")
            }
            if ($VmProcessor)
            {
                $PSBoundParameters.Add("HardwareProfileProcessor", $VmProcessor)
                $null = $PSBoundParameters.Remove("VmProcessor")
            }
            if ($VmSize)
            {
                $PSBoundParameters.Add("HardwareProfileVMSize", $VmSize)    
                $null = $PSBoundParameters.Remove("VmSize")
            }

            if ($ProvisionVMAgent){
                $PSBoundParameters.Add("LinuxConfigurationProvisionVMAgent", $true)
                $PSBoundParameters.Add("WindowConfigurationProvisionVMAgent", $true)
            }
            if ($ProvisionVMConfigAgent){
                $PSBoundParameters.Add("LinuxConfigurationProvisionVMConfigAgent", $true)
                $PSBoundParameters.Add("WindowConfigurationProvisionVMConfigAgent", $true)
            }

            $null = $PSBoundParameters.Remove("ProvisionVMAgent")
            $null = $PSBoundParameters.Remove("ProvisionVMConfigAgent")
            

            $null = $PSBoundParameters.Remove("SubscriptionId")
            $null = $PSBoundParameters.Remove("ResourceGroupName")
            $null = $PSBoundParameters.Remove("ResourceId")
            $null = $PSBoundParameters.Remove("Name")
            try{
                Az.StackHCIVM.internal\Update-AzStackHCIVMVirtualMachine -ErrorAction Stop @PSBoundParameters 
            } catch {
                $e = $_
                if ($e.FullyQualifiedErrorId -match "MissingAzureKubernetesMapping" ){
                    Write-Error "An older version of the Arc VM cluster extension is installed on your cluster. Please downgrade the Az.StackHCIVm version to 1.0.1 to proceed." -ErrorAction Stop
                } else {
                    Write-Error $e.Exception.Message -ErrorAction Stop
                }
            }
            
            } else {             
                Write-Error "One or more input parameters are invalid. Resource ID is: $ResourceId, name is $name, resource group name is $resourcegroupname, subscription id is $subscriptionid"
            }  
    }
} 
# SIG # Begin signature block
# MIIoQgYJKoZIhvcNAQcCoIIoMzCCKC8CAQExDzANBglghkgBZQMEAgEFADB5Bgor
# BgEEAYI3AgEEoGswaTA0BgorBgEEAYI3AgEeMCYCAwEAAAQQH8w7YFlLCE63JNLG
# KX7zUQIBAAIBAAIBAAIBAAIBADAxMA0GCWCGSAFlAwQCAQUABCBOUU5lwQWtA102
# BUinqyMp/HaMpfH5UxcguliBPQbOcaCCDXYwggX0MIID3KADAgECAhMzAAADrzBA
# DkyjTQVBAAAAAAOvMA0GCSqGSIb3DQEBCwUAMH4xCzAJBgNVBAYTAlVTMRMwEQYD
# VQQIEwpXYXNoaW5ndG9uMRAwDgYDVQQHEwdSZWRtb25kMR4wHAYDVQQKExVNaWNy
# b3NvZnQgQ29ycG9yYXRpb24xKDAmBgNVBAMTH01pY3Jvc29mdCBDb2RlIFNpZ25p
# bmcgUENBIDIwMTEwHhcNMjMxMTE2MTkwOTAwWhcNMjQxMTE0MTkwOTAwWjB0MQsw
# CQYDVQQGEwJVUzETMBEGA1UECBMKV2FzaGluZ3RvbjEQMA4GA1UEBxMHUmVkbW9u
# ZDEeMBwGA1UEChMVTWljcm9zb2Z0IENvcnBvcmF0aW9uMR4wHAYDVQQDExVNaWNy
# b3NvZnQgQ29ycG9yYXRpb24wggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIB
# AQDOS8s1ra6f0YGtg0OhEaQa/t3Q+q1MEHhWJhqQVuO5amYXQpy8MDPNoJYk+FWA
# hePP5LxwcSge5aen+f5Q6WNPd6EDxGzotvVpNi5ve0H97S3F7C/axDfKxyNh21MG
# 0W8Sb0vxi/vorcLHOL9i+t2D6yvvDzLlEefUCbQV/zGCBjXGlYJcUj6RAzXyeNAN
# xSpKXAGd7Fh+ocGHPPphcD9LQTOJgG7Y7aYztHqBLJiQQ4eAgZNU4ac6+8LnEGAL
# go1ydC5BJEuJQjYKbNTy959HrKSu7LO3Ws0w8jw6pYdC1IMpdTkk2puTgY2PDNzB
# tLM4evG7FYer3WX+8t1UMYNTAgMBAAGjggFzMIIBbzAfBgNVHSUEGDAWBgorBgEE
# AYI3TAgBBggrBgEFBQcDAzAdBgNVHQ4EFgQURxxxNPIEPGSO8kqz+bgCAQWGXsEw
# RQYDVR0RBD4wPKQ6MDgxHjAcBgNVBAsTFU1pY3Jvc29mdCBDb3Jwb3JhdGlvbjEW
# MBQGA1UEBRMNMjMwMDEyKzUwMTgyNjAfBgNVHSMEGDAWgBRIbmTlUAXTgqoXNzci
# tW2oynUClTBUBgNVHR8ETTBLMEmgR6BFhkNodHRwOi8vd3d3Lm1pY3Jvc29mdC5j
# b20vcGtpb3BzL2NybC9NaWNDb2RTaWdQQ0EyMDExXzIwMTEtMDctMDguY3JsMGEG
# CCsGAQUFBwEBBFUwUzBRBggrBgEFBQcwAoZFaHR0cDovL3d3dy5taWNyb3NvZnQu
# Y29tL3BraW9wcy9jZXJ0cy9NaWNDb2RTaWdQQ0EyMDExXzIwMTEtMDctMDguY3J0
# MAwGA1UdEwEB/wQCMAAwDQYJKoZIhvcNAQELBQADggIBAISxFt/zR2frTFPB45Yd
# mhZpB2nNJoOoi+qlgcTlnO4QwlYN1w/vYwbDy/oFJolD5r6FMJd0RGcgEM8q9TgQ
# 2OC7gQEmhweVJ7yuKJlQBH7P7Pg5RiqgV3cSonJ+OM4kFHbP3gPLiyzssSQdRuPY
# 1mIWoGg9i7Y4ZC8ST7WhpSyc0pns2XsUe1XsIjaUcGu7zd7gg97eCUiLRdVklPmp
# XobH9CEAWakRUGNICYN2AgjhRTC4j3KJfqMkU04R6Toyh4/Toswm1uoDcGr5laYn
# TfcX3u5WnJqJLhuPe8Uj9kGAOcyo0O1mNwDa+LhFEzB6CB32+wfJMumfr6degvLT
# e8x55urQLeTjimBQgS49BSUkhFN7ois3cZyNpnrMca5AZaC7pLI72vuqSsSlLalG
# OcZmPHZGYJqZ0BacN274OZ80Q8B11iNokns9Od348bMb5Z4fihxaBWebl8kWEi2O
# PvQImOAeq3nt7UWJBzJYLAGEpfasaA3ZQgIcEXdD+uwo6ymMzDY6UamFOfYqYWXk
# ntxDGu7ngD2ugKUuccYKJJRiiz+LAUcj90BVcSHRLQop9N8zoALr/1sJuwPrVAtx
# HNEgSW+AKBqIxYWM4Ev32l6agSUAezLMbq5f3d8x9qzT031jMDT+sUAoCw0M5wVt
# CUQcqINPuYjbS1WgJyZIiEkBMIIHejCCBWKgAwIBAgIKYQ6Q0gAAAAAAAzANBgkq
# hkiG9w0BAQsFADCBiDELMAkGA1UEBhMCVVMxEzARBgNVBAgTCldhc2hpbmd0b24x
# EDAOBgNVBAcTB1JlZG1vbmQxHjAcBgNVBAoTFU1pY3Jvc29mdCBDb3Jwb3JhdGlv
# bjEyMDAGA1UEAxMpTWljcm9zb2Z0IFJvb3QgQ2VydGlmaWNhdGUgQXV0aG9yaXR5
# IDIwMTEwHhcNMTEwNzA4MjA1OTA5WhcNMjYwNzA4MjEwOTA5WjB+MQswCQYDVQQG
# EwJVUzETMBEGA1UECBMKV2FzaGluZ3RvbjEQMA4GA1UEBxMHUmVkbW9uZDEeMBwG
# A1UEChMVTWljcm9zb2Z0IENvcnBvcmF0aW9uMSgwJgYDVQQDEx9NaWNyb3NvZnQg
# Q29kZSBTaWduaW5nIFBDQSAyMDExMIICIjANBgkqhkiG9w0BAQEFAAOCAg8AMIIC
# CgKCAgEAq/D6chAcLq3YbqqCEE00uvK2WCGfQhsqa+laUKq4BjgaBEm6f8MMHt03
# a8YS2AvwOMKZBrDIOdUBFDFC04kNeWSHfpRgJGyvnkmc6Whe0t+bU7IKLMOv2akr
# rnoJr9eWWcpgGgXpZnboMlImEi/nqwhQz7NEt13YxC4Ddato88tt8zpcoRb0Rrrg
# OGSsbmQ1eKagYw8t00CT+OPeBw3VXHmlSSnnDb6gE3e+lD3v++MrWhAfTVYoonpy
# 4BI6t0le2O3tQ5GD2Xuye4Yb2T6xjF3oiU+EGvKhL1nkkDstrjNYxbc+/jLTswM9
# sbKvkjh+0p2ALPVOVpEhNSXDOW5kf1O6nA+tGSOEy/S6A4aN91/w0FK/jJSHvMAh
# dCVfGCi2zCcoOCWYOUo2z3yxkq4cI6epZuxhH2rhKEmdX4jiJV3TIUs+UsS1Vz8k
# A/DRelsv1SPjcF0PUUZ3s/gA4bysAoJf28AVs70b1FVL5zmhD+kjSbwYuER8ReTB
# w3J64HLnJN+/RpnF78IcV9uDjexNSTCnq47f7Fufr/zdsGbiwZeBe+3W7UvnSSmn
# Eyimp31ngOaKYnhfsi+E11ecXL93KCjx7W3DKI8sj0A3T8HhhUSJxAlMxdSlQy90
# lfdu+HggWCwTXWCVmj5PM4TasIgX3p5O9JawvEagbJjS4NaIjAsCAwEAAaOCAe0w
# ggHpMBAGCSsGAQQBgjcVAQQDAgEAMB0GA1UdDgQWBBRIbmTlUAXTgqoXNzcitW2o
# ynUClTAZBgkrBgEEAYI3FAIEDB4KAFMAdQBiAEMAQTALBgNVHQ8EBAMCAYYwDwYD
# VR0TAQH/BAUwAwEB/zAfBgNVHSMEGDAWgBRyLToCMZBDuRQFTuHqp8cx0SOJNDBa
# BgNVHR8EUzBRME+gTaBLhklodHRwOi8vY3JsLm1pY3Jvc29mdC5jb20vcGtpL2Ny
# bC9wcm9kdWN0cy9NaWNSb29DZXJBdXQyMDExXzIwMTFfMDNfMjIuY3JsMF4GCCsG
# AQUFBwEBBFIwUDBOBggrBgEFBQcwAoZCaHR0cDovL3d3dy5taWNyb3NvZnQuY29t
# L3BraS9jZXJ0cy9NaWNSb29DZXJBdXQyMDExXzIwMTFfMDNfMjIuY3J0MIGfBgNV
# HSAEgZcwgZQwgZEGCSsGAQQBgjcuAzCBgzA/BggrBgEFBQcCARYzaHR0cDovL3d3
# dy5taWNyb3NvZnQuY29tL3BraW9wcy9kb2NzL3ByaW1hcnljcHMuaHRtMEAGCCsG
# AQUFBwICMDQeMiAdAEwAZQBnAGEAbABfAHAAbwBsAGkAYwB5AF8AcwB0AGEAdABl
# AG0AZQBuAHQALiAdMA0GCSqGSIb3DQEBCwUAA4ICAQBn8oalmOBUeRou09h0ZyKb
# C5YR4WOSmUKWfdJ5DJDBZV8uLD74w3LRbYP+vj/oCso7v0epo/Np22O/IjWll11l
# hJB9i0ZQVdgMknzSGksc8zxCi1LQsP1r4z4HLimb5j0bpdS1HXeUOeLpZMlEPXh6
# I/MTfaaQdION9MsmAkYqwooQu6SpBQyb7Wj6aC6VoCo/KmtYSWMfCWluWpiW5IP0
# wI/zRive/DvQvTXvbiWu5a8n7dDd8w6vmSiXmE0OPQvyCInWH8MyGOLwxS3OW560
# STkKxgrCxq2u5bLZ2xWIUUVYODJxJxp/sfQn+N4sOiBpmLJZiWhub6e3dMNABQam
# ASooPoI/E01mC8CzTfXhj38cbxV9Rad25UAqZaPDXVJihsMdYzaXht/a8/jyFqGa
# J+HNpZfQ7l1jQeNbB5yHPgZ3BtEGsXUfFL5hYbXw3MYbBL7fQccOKO7eZS/sl/ah
# XJbYANahRr1Z85elCUtIEJmAH9AAKcWxm6U/RXceNcbSoqKfenoi+kiVH6v7RyOA
# 9Z74v2u3S5fi63V4GuzqN5l5GEv/1rMjaHXmr/r8i+sLgOppO6/8MO0ETI7f33Vt
# Y5E90Z1WTk+/gFcioXgRMiF670EKsT/7qMykXcGhiJtXcVZOSEXAQsmbdlsKgEhr
# /Xmfwb1tbWrJUnMTDXpQzTGCGiIwghoeAgEBMIGVMH4xCzAJBgNVBAYTAlVTMRMw
# EQYDVQQIEwpXYXNoaW5ndG9uMRAwDgYDVQQHEwdSZWRtb25kMR4wHAYDVQQKExVN
# aWNyb3NvZnQgQ29ycG9yYXRpb24xKDAmBgNVBAMTH01pY3Jvc29mdCBDb2RlIFNp
# Z25pbmcgUENBIDIwMTECEzMAAAOvMEAOTKNNBUEAAAAAA68wDQYJYIZIAWUDBAIB
# BQCgga4wGQYJKoZIhvcNAQkDMQwGCisGAQQBgjcCAQQwHAYKKwYBBAGCNwIBCzEO
# MAwGCisGAQQBgjcCARUwLwYJKoZIhvcNAQkEMSIEIEN31Yai8fT/SsYLW8fRgGUU
# ZSHZJxv8+G3r1asVPeIvMEIGCisGAQQBgjcCAQwxNDAyoBSAEgBNAGkAYwByAG8A
# cwBvAGYAdKEagBhodHRwOi8vd3d3Lm1pY3Jvc29mdC5jb20wDQYJKoZIhvcNAQEB
# BQAEggEAA2DWFMK2fxmc4P15JTj2LgPCTz7TjT2I7dmJpn0uoV/ras343Qe68uwh
# qi7+OD4VxyBOPYlO55MKzN3cCPjolqDOPO8mhTLJ62FEEAH43rw0o6XwBeroEpHt
# EBP8nSqucygX8OvIVUVMitpNgj6MBsvsoQvtPijoP9veH0iZWcOBffcoo0OziNnf
# 6hHOeBvBcw60misxAvyFZBEsf84bNjpoEFrolu1nx+fcOajj1wymrTj6JPihA+uy
# 2MGw5/5e2rsqy9tglfaT9IqRH437/WPkINRtVUwUKSqEGy15sdP1xoulzF47KTQ1
# vLoOMpRHErUcfKgSzY+3AsGbctgzLaGCF6wwgheoBgorBgEEAYI3AwMBMYIXmDCC
# F5QGCSqGSIb3DQEHAqCCF4UwgheBAgEDMQ8wDQYJYIZIAWUDBAIBBQAwggFZBgsq
# hkiG9w0BCRABBKCCAUgEggFEMIIBQAIBAQYKKwYBBAGEWQoDATAxMA0GCWCGSAFl
# AwQCAQUABCCvY2Qo2TbwYNJlFAFTuyM80aV9aY0QQoXdg6Z8d+0xsQIGZutJu7w6
# GBIyMDI0MTAwODA1MDcwNC42N1owBIACAfSggdmkgdYwgdMxCzAJBgNVBAYTAlVT
# MRMwEQYDVQQIEwpXYXNoaW5ndG9uMRAwDgYDVQQHEwdSZWRtb25kMR4wHAYDVQQK
# ExVNaWNyb3NvZnQgQ29ycG9yYXRpb24xLTArBgNVBAsTJE1pY3Jvc29mdCBJcmVs
# YW5kIE9wZXJhdGlvbnMgTGltaXRlZDEnMCUGA1UECxMeblNoaWVsZCBUU1MgRVNO
# OjRDMUEtMDVFMC1EOTQ3MSUwIwYDVQQDExxNaWNyb3NvZnQgVGltZS1TdGFtcCBT
# ZXJ2aWNloIIR+zCCBygwggUQoAMCAQICEzMAAAH/Ejh898Fl1qEAAQAAAf8wDQYJ
# KoZIhvcNAQELBQAwfDELMAkGA1UEBhMCVVMxEzARBgNVBAgTCldhc2hpbmd0b24x
# EDAOBgNVBAcTB1JlZG1vbmQxHjAcBgNVBAoTFU1pY3Jvc29mdCBDb3Jwb3JhdGlv
# bjEmMCQGA1UEAxMdTWljcm9zb2Z0IFRpbWUtU3RhbXAgUENBIDIwMTAwHhcNMjQw
# NzI1MTgzMTE5WhcNMjUxMDIyMTgzMTE5WjCB0zELMAkGA1UEBhMCVVMxEzARBgNV
# BAgTCldhc2hpbmd0b24xEDAOBgNVBAcTB1JlZG1vbmQxHjAcBgNVBAoTFU1pY3Jv
# c29mdCBDb3Jwb3JhdGlvbjEtMCsGA1UECxMkTWljcm9zb2Z0IElyZWxhbmQgT3Bl
# cmF0aW9ucyBMaW1pdGVkMScwJQYDVQQLEx5uU2hpZWxkIFRTUyBFU046NEMxQS0w
# NUUwLUQ5NDcxJTAjBgNVBAMTHE1pY3Jvc29mdCBUaW1lLVN0YW1wIFNlcnZpY2Uw
# ggIiMA0GCSqGSIb3DQEBAQUAA4ICDwAwggIKAoICAQDJ6JXSkHtuDz+pz+aSIN0l
# efMlY9iCT2ZMZ4jenNCmzKtElERZwpgd3/11v6DfPh1ThUKQBkReq+TE/lA1O0Eb
# kil7GmmHg+FuIkrC9f5RLgqRIWF/XB+UMBjW270JCqGHF8cVXu+G2aocsIKYPGFk
# +YIGH39d8UlAhTBVlHxG1SSDOY31uZaJiB9fRH5sMCedxR22nXGMaYKl0EzKCT8r
# SHdtRNTNAdviQ9/bKWQo+hYVifYY1iBbDw8YFQ7S9MwqNgPqkt4E/SFkOHk/d/jG
# EYubrH3zG4hCn9EWfMFuC2HJJcaX41PVxkCobISFPsvRJ1HupCW/mnAM16tsrdhI
# QMqTewOH1LrSEsk2o/vWIcqQbXvkcDKDrOYTmnd842v398gSk8CULxiKzFdoZfhG
# kMFhUqkaPQUJnCKyJmzGbRf3DplKTw45d/wnFNhYip9G5bN1SKvRneOI461oOrtd
# 3KkHiBmuGv3Qpw9MNHC/LrTOtBxr/UPUns9AkAk5tuJpuiLXa6xXxrG2VP90J48L
# id1wVxqvW/5+cKWGz27cWfouQcNFl83OFeAsMTBvp0DjLezob6BDfmj3SPaLpqZp
# rwmxX9wIX6INIbMDFljWxDWat0ybPF9bNc3qw8kzLj212xZMiBlZU5JL25QeFJiR
# uAzGct6Ipd4HkwH1Axw5JwIDAQABo4IBSTCCAUUwHQYDVR0OBBYEFMP6leT+tP93
# sT/RATuEfTDP7pRhMB8GA1UdIwQYMBaAFJ+nFV0AXmJdg/Tl0mWnG1M1GelyMF8G
# A1UdHwRYMFYwVKBSoFCGTmh0dHA6Ly93d3cubWljcm9zb2Z0LmNvbS9wa2lvcHMv
# Y3JsL01pY3Jvc29mdCUyMFRpbWUtU3RhbXAlMjBQQ0ElMjAyMDEwKDEpLmNybDBs
# BggrBgEFBQcBAQRgMF4wXAYIKwYBBQUHMAKGUGh0dHA6Ly93d3cubWljcm9zb2Z0
# LmNvbS9wa2lvcHMvY2VydHMvTWljcm9zb2Z0JTIwVGltZS1TdGFtcCUyMFBDQSUy
# MDIwMTAoMSkuY3J0MAwGA1UdEwEB/wQCMAAwFgYDVR0lAQH/BAwwCgYIKwYBBQUH
# AwgwDgYDVR0PAQH/BAQDAgeAMA0GCSqGSIb3DQEBCwUAA4ICAQA5I03kykuLK6eb
# zrp+tYiLSF1rMo0uBGndZk9+FiA8Lcr8M0zMuWJhBQCnpa2CiUitq2K9eM4bWUiN
# rIb2vp7DgfWfldl0N8nXYMuOilqnl7WJT9iTR660/J86J699uwjNOT8bnX66JQmT
# vvadXNq7qEjYobIYEk68BsBUVHSDymlnAuCFPjPeaQZmOr87hn89yZUa2MamzZMK
# 0jitmM81bw7hz/holGZhD811b3UlGs5dGnJetMpQ97eQ3w3nqOmX2Si0uF293z1F
# s6wk1/ZfOpsBXteNXhxoKCUDZu3MPFzJ9/BeEu70cxTd0thMAj3WBM1QXsED2rUS
# 9KUIoqU3w3XRjiJTSfIiR+lHFjIBtHKrlA9g8kcYDRPLQ8PzdoK3v1FrQh0MgxK7
# BeWlSfIjLHCsPKWB84bLKxYHBD+Ozbj1upA5g92nI52BF7y1d0auAOgF65U4r5xE
# KVemKY1jCvrWhnb+Q8zNWvNFRgyQFd71ap1J7OHy3K266VhhxEr3mqKEXSKtCzr9
# Y5AmW1Bfv2XMVcT0UWWf0yLHRqz4Lgc/N35LRsE3cDddFE7AC/TXogK5PyFjUifJ
# buPBWY346RDXN6LroutTlG0DPSdPHHk54/KOdNoi1NJjg4a4ZTVJdofj0lI/e3zI
# ZgD++ittbhWd54PvbUWDBolOgcWQ4jCCB3EwggVZoAMCAQICEzMAAAAVxedrngKb
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
# ELQdVTNYs6FwZvKhggNWMIICPgIBATCCAQGhgdmkgdYwgdMxCzAJBgNVBAYTAlVT
# MRMwEQYDVQQIEwpXYXNoaW5ndG9uMRAwDgYDVQQHEwdSZWRtb25kMR4wHAYDVQQK
# ExVNaWNyb3NvZnQgQ29ycG9yYXRpb24xLTArBgNVBAsTJE1pY3Jvc29mdCBJcmVs
# YW5kIE9wZXJhdGlvbnMgTGltaXRlZDEnMCUGA1UECxMeblNoaWVsZCBUU1MgRVNO
# OjRDMUEtMDVFMC1EOTQ3MSUwIwYDVQQDExxNaWNyb3NvZnQgVGltZS1TdGFtcCBT
# ZXJ2aWNloiMKAQEwBwYFKw4DAhoDFQCpE4xsxLwlxSVyc+TBEsVE9cWymaCBgzCB
# gKR+MHwxCzAJBgNVBAYTAlVTMRMwEQYDVQQIEwpXYXNoaW5ndG9uMRAwDgYDVQQH
# EwdSZWRtb25kMR4wHAYDVQQKExVNaWNyb3NvZnQgQ29ycG9yYXRpb24xJjAkBgNV
# BAMTHU1pY3Jvc29mdCBUaW1lLVN0YW1wIFBDQSAyMDEwMA0GCSqGSIb3DQEBCwUA
# AgUA6q7TpjAiGA8yMDI0MTAwNzIxMzk1MFoYDzIwMjQxMDA4MjEzOTUwWjB0MDoG
# CisGAQQBhFkKBAExLDAqMAoCBQDqrtOmAgEAMAcCAQACAga9MAcCAQACAhLNMAoC
# BQDqsCUmAgEAMDYGCisGAQQBhFkKBAIxKDAmMAwGCisGAQQBhFkKAwKgCjAIAgEA
# AgMHoSChCjAIAgEAAgMBhqAwDQYJKoZIhvcNAQELBQADggEBAGKk8+cLJWW+yyBD
# gr7eivIMn1WQvT1oS9t7pGwg+ggdshVrKK0Kz1QUnqIiZw0s4BjAMBGyiyOUmg+f
# YFDJ9dZBvEhmIIxzvhU6u6Cubhp4KMAZAlzD2R4HqTfHac/rhAbKLXb7oXM3aFFG
# CPnShXg6pzyFxao3JJuxYkSe8NYVYWB+Yw83IvrwHc/a9WM96IoGkjh8EUuXa/0H
# ZdrxgZ+k9MWNx152HJvI6xYMUh+hYrLQ5Xfwzf3zNOfWt4NlhhSPIOTmB4vgGoKa
# aChR/HxlawX+7zGqrzb9p/Z6eTAfsbRSTb+vnuquhhQKAO/hTchYUJMhYkcVtTh6
# tD777EQxggQNMIIECQIBATCBkzB8MQswCQYDVQQGEwJVUzETMBEGA1UECBMKV2Fz
# aGluZ3RvbjEQMA4GA1UEBxMHUmVkbW9uZDEeMBwGA1UEChMVTWljcm9zb2Z0IENv
# cnBvcmF0aW9uMSYwJAYDVQQDEx1NaWNyb3NvZnQgVGltZS1TdGFtcCBQQ0EgMjAx
# MAITMwAAAf8SOHz3wWXWoQABAAAB/zANBglghkgBZQMEAgEFAKCCAUowGgYJKoZI
# hvcNAQkDMQ0GCyqGSIb3DQEJEAEEMC8GCSqGSIb3DQEJBDEiBCBJdAMdBtNTFg0J
# RNhX1bJQzc+L4N5CC1y4mgBEsNt5VjCB+gYLKoZIhvcNAQkQAi8xgeowgecwgeQw
# gb0EIOQy777JAndprJwi4xPq8Dsk24xpU4jeoONIRXy6nKf9MIGYMIGApH4wfDEL
# MAkGA1UEBhMCVVMxEzARBgNVBAgTCldhc2hpbmd0b24xEDAOBgNVBAcTB1JlZG1v
# bmQxHjAcBgNVBAoTFU1pY3Jvc29mdCBDb3Jwb3JhdGlvbjEmMCQGA1UEAxMdTWlj
# cm9zb2Z0IFRpbWUtU3RhbXAgUENBIDIwMTACEzMAAAH/Ejh898Fl1qEAAQAAAf8w
# IgQgSkNFeAJRcSTtDDI2TirVAvv/jkY1tLK7UQrnmnjk/8EwDQYJKoZIhvcNAQEL
# BQAEggIAaUjX7WwmQuY+4JNLhD+Hf5H0RR5JL5sImSlEB2CqIAJERoPqhfsIRAt/
# UEQSnZ1uWC24gEa8Pp5WmE1gCwKlXxUKJCCDPq9fzH/mQ2nAXTxXABl8dEngSa//
# U35C7l1ekHh9kZYqIVMu2ABwrL3nFBXfr0H/CBvPw6BlFR7kG5dGF7x6JhPu/dEQ
# X5X5ZIBZMuztO91jpfm6xYekLo9U3zjhQF3w9m1s9QO1Er08L1rKLBDVMRDa+Fbk
# /fs7SGWsAWmjKkotg5PcSU5zv1orULFwSPO7xp0soTMr2lfjIS2tpKEcHgD7n9iC
# Er2e/fRpIqduQIHRBMpVepCfwGTpSWGdvluhqzQw6sgEbO9tXbhht+a/If5HQqNv
# NDVrwcOdj+fGvJSo0hdocIpcN2ZNKd9zbLa7w6wHZx7c6eaykStWY/dhMH7W8aKV
# i6a+GNMIPhoo00VSyef91KdThUZEqc5cBTjZYyTNNXOZGg9J+No0+T6juZ7IMqjV
# 4pHpEUMtD9kcdXNUnC6qDU2htYyISoYty5VvkOJDD0bXC6FVFWo7eibRGIcITUWZ
# ytyOnNtphXVaMDJlLqYlBiWDxA2z8RaWy2lSJ+CEDcFNNI13p6Coz8ICB0d4upeS
# uxTIk+nv5pcMwclofN4LeJ//Th9m1F5WisfGCvm+vd6f2RjyCe0=
# SIG # End signature block
