
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
The operation to create or update a network interface.
Please note some properties can be set only during network interface creation.
.Description
The operation to create or update a network interface.
Please note some properties can be set only during network interface creation.

.Outputs
Microsoft.Azure.PowerShell.Cmdlets.StackHCIVM.Models.INetworkInterfaces
.Notes
COMPLEX PARAMETER PROPERTIES

To create the parameters described below, construct a hash table containing the appropriate properties. For information on hash tables, run Get-Help about_Hash_Tables.

IPCONFIGURATION <IIPConfiguration[]>: IPConfigurations - A list of IPConfigurations of the network interface.
  [IPAddress <String>]: PrivateIPAddress - Private IP address of the IP configuration.
  [Name <String>]: Name - The name of the resource that is unique within a resource group. This name can be used to access the resource.
  [SubnetId <String>]: ID - The ARM resource id in the form of /subscriptions/{SubscriptionId}/resourceGroups/{ResourceGroupName}/...
.Link
https://learn.microsoft.com/powershell/module/az.stackhcivm/new-azstackhcivmnetworkinterface
#>
function New-AzStackHCIVMNetworkInterface {
[OutputType([Microsoft.Azure.PowerShell.Cmdlets.StackHCIVM.Models.INetworkInterfaces])]
[CmdletBinding(PositionalBinding=$false, SupportsShouldProcess, ConfirmImpact='Medium')]
param(
    [Parameter(Mandatory)]
    [Alias('NetworkInterfaceName')]
    [Microsoft.Azure.PowerShell.Cmdlets.StackHCIVM.Category('Path')]
    [System.String]
    # Name of the Network Interface
    ${Name},

    [Parameter(Mandatory)]
    [Microsoft.Azure.PowerShell.Cmdlets.StackHCIVM.Category('Path')]
    [System.String]
    # The name of the resource group.
    # The name is case insensitive.
    ${ResourceGroupName},

    [Parameter()]
    [Microsoft.Azure.PowerShell.Cmdlets.StackHCIVM.Category('Path')]
    [Microsoft.Azure.PowerShell.Cmdlets.StackHCIVM.Runtime.DefaultInfo(Script='(Get-AzContext).Subscription.Id')]
    [System.String]
    # The ID of the target subscription.
    ${SubscriptionId},

    [Parameter(Mandatory)]
    [Microsoft.Azure.PowerShell.Cmdlets.StackHCIVM.Category('Body')]
    [System.String]
    # The geo-location where the resource lives
    ${Location},

    [Parameter(Mandatory)]
    [Microsoft.Azure.PowerShell.Cmdlets.StackHCIVM.Category('Body')]
    [System.String]
    # The name of the extended location.
    ${CustomLocationId},

    [Parameter()]
    [AllowEmptyCollection()]
    [Microsoft.Azure.PowerShell.Cmdlets.StackHCIVM.Category('Body')]
    [System.String[]]
    # List of DNS server IP Addresses for the interface
    ${DnsServer},

    [Parameter()]
    [Microsoft.Azure.PowerShell.Cmdlets.StackHCIVM.Category('Body')]
    [System.String]
    # PrivateIPAddress - Private IP address of the IP configuration.
    ${IpAddress},

    [Parameter()]
    [Microsoft.Azure.PowerShell.Cmdlets.StackHCIVM.Category('Body')]
    [System.String]
    # MacAddress - The MAC address of the network interface.
    ${MacAddress},
    
    [Parameter()]
    [Microsoft.Azure.PowerShell.Cmdlets.StackHCIVM.Category('Body')]
    [System.String]
    #  The ARM resource id of the Subnet.
    ${SubnetId},

    [Parameter()]
    [Microsoft.Azure.PowerShell.Cmdlets.StackHCIVM.Category('Body')]
    [System.String]
    #  The name of the Subnet.
    ${SubnetName},

    [Parameter()]
    [Microsoft.Azure.PowerShell.Cmdlets.StackHCIVM.Category('Body')]
    [System.String]
    # Resource Group of the Subnet.
    ${SubnetResourceGroup},

    [Parameter()]
    [Microsoft.Azure.PowerShell.Cmdlets.StackHCIVM.Category('Body')]
    [System.Collections.Hashtable[]]
    # A list of IPConfigurations of the network interface.
    ${IpConfiguration},

    [Parameter()]
    [Microsoft.Azure.PowerShell.Cmdlets.StackHCIVM.Category('Body')]
    [Microsoft.Azure.PowerShell.Cmdlets.StackHCIVM.Runtime.Info(PossibleTypes=([Microsoft.Azure.PowerShell.Cmdlets.StackHCIVM.Models.ITrackedResourceTags]))]
    [System.Collections.Hashtable]
    # Resource tags.
    ${Tag},

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

  if ($Name -notmatch $nicNameRegex){
      Write-Error "Invalid Name:  $Name. The name must start with an alphanumeric character, contain all alphanumeric characters or '-' or '_' or '.' and end with an alphanumeric character or '_'. The max length is 80 characters." -ErrorAction Stop
  }
  if ($CustomLocationId -notmatch $customLocationRegex){
      Write-Error "Invalid CustomLocationId: $CustomLocationId" -ErrorAction Stop
  } 

  $null = $PSBoundParameters.Remove("MacAddress")
  $null = $PSBoundParameters.Remove("DnsServer")
  $null = $PSBoundParameters.Remove("Tag")


  if (-Not $IpConfiguration){
      $IpConfig = @{}
      if ($SubnetName){
        $rg = $ResourceGroupName
        if ($SubnetResourceGroup){
          $rg = $SubnetResourceGroup
        }
        $SubnetId = "/subscriptions/$SubscriptionId/resourceGroups/$rg/providers/Microsoft.AzureStackHCI/logicalNetworks/$SubnetName"
        $null = $PSBoundParameters.Remove("SubnetName")
        $null = $PSBoundParameters.Remove("SubnetResourceGroup")
      }

      if (-Not $SubnetId){
        Write-Error "No Subnet provided. Either IpConfigurations or SubnetId or SubnetName is required." -ErrorAction Stop
      } else {
          if ($SubnetId -notmatch $vnetRegex){
            Write-Error "Invalid SubnetId: $SubnetId" -ErrorAction Stop
          }
      }
        
      $null = $PSBoundParameters.Remove("Name")
      $null = $PSBoundParameters.Remove("ResourceGroupName")
      $null = $PSBoundParameters.Remove("SubscriptionId")
      $null = $PSBoundParameters.Remove("Location")
      $null = $PSBoundParameters.Remove("CustomLocationId")
      $null = $PSBoundParameters.Remove("SubnetId")
      $null = $PSBoundParameters.Remove("IpAddress")
       
      $PSBoundParameters.Add("ResourceId", $SubnetId)
      $subnet = Az.StackHCIVM\Get-AzStackHCIVMLogicalNetwork @PSBoundParameters


      if ($subnet -eq $null) {
        Write-Error "A Logical Network with id : $SubnetId does not exist." -ErrorAction Stop
      }   

      $IpConfig["SubnetId"] = $SubnetId

      $null = $PSBoundParameters.Remove("ResourceId")
      $PSBoundParameters.Add("Name", $Name)
      $PSBoundParameters.Add("ResourceGroupName", $ResourceGroupName)
      $PSBoundParameters.Add("SubscriptionId", $SubscriptionId)
      $PSBoundParameters.Add("Location", $Location)
      $PSBoundParameters.Add("CustomLocationId", $CustomLocationId)

      
    
      if ($IpAddress){
        if ($IpAddress -notmatch $ipv4Regex){
            Write-Error "Invalid Ip Address provided : $IpAddress" -ErrorAction Stop
        } 
        $IpConfig["IPAddress"] = $IpAddress   
      }
      

      $PSBoundParameters.Add("IPConfiguration", $IpConfig)

  }
  
  if ($MacAddress){
    if ($MacAddress -notmatch $macAddressRegex){
      Write-Error "Invalid MacAddress: $MacAddress." -ErrorAction Stop
    }
    $PSBoundParameters.Add("MacAddress", $MacAddress)
  }

  if ($DnsServer){
      foreach ($DnsServ in $DnsServer){
        if ($DnsServ -notmatch $ipv4Regex){
            Write-Error "Invalid ipaddress provided for Dns Servers : $DnsServ." -ErrorAction Stop
        }
      }
      $PSBoundParameters.Add("DnsServer", $DnsServer)
  }

  if ($Tag){
    $PSBoundParameters.Add("Tag", $Tag)
  }
  
  try{
    Az.StackHCIVM.internal\New-AzStackHCIVMNetworkInterface -ErrorAction Stop @PSBoundParameters 
  } catch {
    $e = $_
    if ($e.FullyQualifiedErrorId -match "MissingAzureKubernetesMapping" ){
        Write-Error "An older version of the Arc VM cluster extension is installed on your cluster. Please downgrade the Az.StackHCIVm version to 1.0.1 to proceed." -ErrorAction Stop
    } else {
        Write-Error $e.Exception.Message -ErrorAction Stop
    }
  }
  
}

# SIG # Begin signature block
# MIIoKQYJKoZIhvcNAQcCoIIoGjCCKBYCAQExDzANBglghkgBZQMEAgEFADB5Bgor
# BgEEAYI3AgEEoGswaTA0BgorBgEEAYI3AgEeMCYCAwEAAAQQH8w7YFlLCE63JNLG
# KX7zUQIBAAIBAAIBAAIBAAIBADAxMA0GCWCGSAFlAwQCAQUABCAbCUbCocXnc6PX
# vPSufNkz/0Dh7+w9qoER2F/mWW8GcqCCDXYwggX0MIID3KADAgECAhMzAAADrzBA
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
# /Xmfwb1tbWrJUnMTDXpQzTGCGgkwghoFAgEBMIGVMH4xCzAJBgNVBAYTAlVTMRMw
# EQYDVQQIEwpXYXNoaW5ndG9uMRAwDgYDVQQHEwdSZWRtb25kMR4wHAYDVQQKExVN
# aWNyb3NvZnQgQ29ycG9yYXRpb24xKDAmBgNVBAMTH01pY3Jvc29mdCBDb2RlIFNp
# Z25pbmcgUENBIDIwMTECEzMAAAOvMEAOTKNNBUEAAAAAA68wDQYJYIZIAWUDBAIB
# BQCgga4wGQYJKoZIhvcNAQkDMQwGCisGAQQBgjcCAQQwHAYKKwYBBAGCNwIBCzEO
# MAwGCisGAQQBgjcCARUwLwYJKoZIhvcNAQkEMSIEIDOfCDHqycBaCzirb72u2eVA
# hBzLevWE1vsKJuKGYC+gMEIGCisGAQQBgjcCAQwxNDAyoBSAEgBNAGkAYwByAG8A
# cwBvAGYAdKEagBhodHRwOi8vd3d3Lm1pY3Jvc29mdC5jb20wDQYJKoZIhvcNAQEB
# BQAEggEAf3os+xgdFdnTAghj+6mzAPJ/JhsjotWU1boTn4bSqWwYg3hHZj25ztI0
# YGSlRz3FKPb4neyTFgD3HIuxmDNFucRzbq/g/j0uwgCD5jdSfo61/M/IcC6CbojG
# WyJ8lSHx6oJLdgpkeNzJ+/DrPCDyvoTJBdsdYBk8klAKl7PlNr7FzoFjABkDGxmh
# BCo6msQEL46Z3AE/Vvi9tohEwrfSL7hZfrVPq1N5FbHDbzk6AaQ8ZGaYls2MHpDJ
# QyambnThEN8Bdefunn6jRQlCXB73bxTpd7vIrFSCFjXAb3VvZ1wRRc4iXUaDsY9J
# XI0nR7Wc+rzeRJ+EmFm8u3m/BRsEZ6GCF5MwghePBgorBgEEAYI3AwMBMYIXfzCC
# F3sGCSqGSIb3DQEHAqCCF2wwghdoAgEDMQ8wDQYJYIZIAWUDBAIBBQAwggFRBgsq
# hkiG9w0BCRABBKCCAUAEggE8MIIBOAIBAQYKKwYBBAGEWQoDATAxMA0GCWCGSAFl
# AwQCAQUABCAR5kAogbnmY7TMbUaVHB0FsxRtR30NdMBkLv4Ap+rwCwIGZuLUsdqz
# GBIyMDI0MTAwODA1MDcwMi4xMVowBIACAfSggdGkgc4wgcsxCzAJBgNVBAYTAlVT
# MRMwEQYDVQQIEwpXYXNoaW5ndG9uMRAwDgYDVQQHEwdSZWRtb25kMR4wHAYDVQQK
# ExVNaWNyb3NvZnQgQ29ycG9yYXRpb24xJTAjBgNVBAsTHE1pY3Jvc29mdCBBbWVy
# aWNhIE9wZXJhdGlvbnMxJzAlBgNVBAsTHm5TaGllbGQgVFNTIEVTTjpGMDAyLTA1
# RTAtRDk0NzElMCMGA1UEAxMcTWljcm9zb2Z0IFRpbWUtU3RhbXAgU2VydmljZaCC
# EeowggcgMIIFCKADAgECAhMzAAAB8j4y12SscJGUAAEAAAHyMA0GCSqGSIb3DQEB
# CwUAMHwxCzAJBgNVBAYTAlVTMRMwEQYDVQQIEwpXYXNoaW5ndG9uMRAwDgYDVQQH
# EwdSZWRtb25kMR4wHAYDVQQKExVNaWNyb3NvZnQgQ29ycG9yYXRpb24xJjAkBgNV
# BAMTHU1pY3Jvc29mdCBUaW1lLVN0YW1wIFBDQSAyMDEwMB4XDTIzMTIwNjE4NDU1
# OFoXDTI1MDMwNTE4NDU1OFowgcsxCzAJBgNVBAYTAlVTMRMwEQYDVQQIEwpXYXNo
# aW5ndG9uMRAwDgYDVQQHEwdSZWRtb25kMR4wHAYDVQQKExVNaWNyb3NvZnQgQ29y
# cG9yYXRpb24xJTAjBgNVBAsTHE1pY3Jvc29mdCBBbWVyaWNhIE9wZXJhdGlvbnMx
# JzAlBgNVBAsTHm5TaGllbGQgVFNTIEVTTjpGMDAyLTA1RTAtRDk0NzElMCMGA1UE
# AxMcTWljcm9zb2Z0IFRpbWUtU3RhbXAgU2VydmljZTCCAiIwDQYJKoZIhvcNAQEB
# BQADggIPADCCAgoCggIBALzl88sXCmliDHBjGRIR5i9AG2dglO0oqPYUrHMfHR+B
# XpeAgiuYJaakqX0g7O858n+TqI/RGehGjkXz0B3b153MZ2VZsKPVDLHkdQc1jzK7
# 0SUk6Z2B6429MrhFbjC72IHn/PZJ4K5irJf+/zPo+m/b2HW201axJz8o8566HNIB
# eqQDbrkFIVPmTKTG/MHQvGjFLqhahdYrrDHXvY1ElFhwg19cOFRG9R8PvSOKgT3a
# tb86CNw4rFmR9DEuXBoVKtKcazteEyun1OxSCbCzJxMQ4F0ZWZ/UcIPtY5rPkQRx
# DIhLYGlFhjCw8xsHre4eInXnyo2HVIle6gvnAYO79tlTM34HNwuP3qLELvAkZAwG
# LFYf1375XxuXXRFh1cNmWWNEC9LqIXA3OtqG7gOthvtvwzu+/CEQvTEI69vtYUyy
# y2xxd+R0TmD41JpymGAV9yh+1Dmo8PY81WasbfwOYcOhiGCP26o8s/u+ehd/uPr4
# tbxWifXnwPRauaTsK6a5xBOIdHJ6kRpUOecDYaSImh6H+vd9KEvoIeA+hMHuhhT9
# 3ok6dxGKgNiqpF9XbCWkpU7xv5VgcvyGfXUlEXHqnr2YvwFG1Jnp0b8YURUT59Wa
# DFh8gJSumCHJCURMk8hMQFLXkixpS5bQa9eUtKh8Z/a3kMCgOS4oJsL7dV0+aVhV
# AgMBAAGjggFJMIIBRTAdBgNVHQ4EFgQUlVuHACbq0DEEzlwfwGDT5jrihnkwHwYD
# VR0jBBgwFoAUn6cVXQBeYl2D9OXSZacbUzUZ6XIwXwYDVR0fBFgwVjBUoFKgUIZO
# aHR0cDovL3d3dy5taWNyb3NvZnQuY29tL3BraW9wcy9jcmwvTWljcm9zb2Z0JTIw
# VGltZS1TdGFtcCUyMFBDQSUyMDIwMTAoMSkuY3JsMGwGCCsGAQUFBwEBBGAwXjBc
# BggrBgEFBQcwAoZQaHR0cDovL3d3dy5taWNyb3NvZnQuY29tL3BraW9wcy9jZXJ0
# cy9NaWNyb3NvZnQlMjBUaW1lLVN0YW1wJTIwUENBJTIwMjAxMCgxKS5jcnQwDAYD
# VR0TAQH/BAIwADAWBgNVHSUBAf8EDDAKBggrBgEFBQcDCDAOBgNVHQ8BAf8EBAMC
# B4AwDQYJKoZIhvcNAQELBQADggIBAD1Lp47gex8HTRek6A9ptw3dBl7KKmCKVxBI
# NnyDpUK/0VUfN1Kr1ekCyWNlIo1ZIKWEkTPk6jdSb+1o+ehsX7wKQB2RwtCEt2RK
# F+v3WTPL28M+s6aUIDYVD2NWEVpq3ZAzffPWn4YI/m26+KsVpRbNRZUMU6mj87nM
# OnOg9i1OvRwWDe5dpEtPnhRDdji49heqfrC6dm1RBEyIkzPGlSW919YZS0K+dbd4
# MGKQOSLHVcT3xVxgjPb7l91y+sdV5RqsZfLgtG3DObCmwK1SHu1HrCEKtViRvoW5
# 0F1YztNW+OLukaB+N6yCcBJoP8KEu7Hro8bBohoX7EvOTRs3GwCPS6F3pB1avpNP
# f2b9I1nX9RdTuTMSh3S8BjeYifxfkDgj7397WcE2lREnpiIMpB3lhWDGy5kJa/hD
# BvSZeEch70K5t9KpmO8NrB/Yjbb03cuy0MlRKvW8YUHyJDlbxkszk/BPy+2woQHA
# cRibCy5aazGSKYgXkFBtLOD3DPU7qN1ZPEYbQ5S3VxdY4wlQnPIQfhZIpkc7Hnep
# wC8P2HRTqMQXZ+4GO0n9AOtZtvi6u8B+u+o2f2UfuBU+mWo08Mi9DwORneW9tCxi
# qXPrXt7vqBrtJjTDvX5A/XrkI93NRjfp63ZKbim+ykQryGWWrchhzJfS/z3v5f1h
# 55wzU9vWMIIHcTCCBVmgAwIBAgITMwAAABXF52ueAptJmQAAAAAAFTANBgkqhkiG
# 9w0BAQsFADCBiDELMAkGA1UEBhMCVVMxEzARBgNVBAgTCldhc2hpbmd0b24xEDAO
# BgNVBAcTB1JlZG1vbmQxHjAcBgNVBAoTFU1pY3Jvc29mdCBDb3Jwb3JhdGlvbjEy
# MDAGA1UEAxMpTWljcm9zb2Z0IFJvb3QgQ2VydGlmaWNhdGUgQXV0aG9yaXR5IDIw
# MTAwHhcNMjEwOTMwMTgyMjI1WhcNMzAwOTMwMTgzMjI1WjB8MQswCQYDVQQGEwJV
# UzETMBEGA1UECBMKV2FzaGluZ3RvbjEQMA4GA1UEBxMHUmVkbW9uZDEeMBwGA1UE
# ChMVTWljcm9zb2Z0IENvcnBvcmF0aW9uMSYwJAYDVQQDEx1NaWNyb3NvZnQgVGlt
# ZS1TdGFtcCBQQ0EgMjAxMDCCAiIwDQYJKoZIhvcNAQEBBQADggIPADCCAgoCggIB
# AOThpkzntHIhC3miy9ckeb0O1YLT/e6cBwfSqWxOdcjKNVf2AX9sSuDivbk+F2Az
# /1xPx2b3lVNxWuJ+Slr+uDZnhUYjDLWNE893MsAQGOhgfWpSg0S3po5GawcU88V2
# 9YZQ3MFEyHFcUTE3oAo4bo3t1w/YJlN8OWECesSq/XJprx2rrPY2vjUmZNqYO7oa
# ezOtgFt+jBAcnVL+tuhiJdxqD89d9P6OU8/W7IVWTe/dvI2k45GPsjksUZzpcGkN
# yjYtcI4xyDUoveO0hyTD4MmPfrVUj9z6BVWYbWg7mka97aSueik3rMvrg0XnRm7K
# MtXAhjBcTyziYrLNueKNiOSWrAFKu75xqRdbZ2De+JKRHh09/SDPc31BmkZ1zcRf
# NN0Sidb9pSB9fvzZnkXftnIv231fgLrbqn427DZM9ituqBJR6L8FA6PRc6ZNN3SU
# HDSCD/AQ8rdHGO2n6Jl8P0zbr17C89XYcz1DTsEzOUyOArxCaC4Q6oRRRuLRvWoY
# WmEBc8pnol7XKHYC4jMYctenIPDC+hIK12NvDMk2ZItboKaDIV1fMHSRlJTYuVD5
# C4lh8zYGNRiER9vcG9H9stQcxWv2XFJRXRLbJbqvUAV6bMURHXLvjflSxIUXk8A8
# FdsaN8cIFRg/eKtFtvUeh17aj54WcmnGrnu3tz5q4i6tAgMBAAGjggHdMIIB2TAS
# BgkrBgEEAYI3FQEEBQIDAQABMCMGCSsGAQQBgjcVAgQWBBQqp1L+ZMSavoKRPEY1
# Kc8Q/y8E7jAdBgNVHQ4EFgQUn6cVXQBeYl2D9OXSZacbUzUZ6XIwXAYDVR0gBFUw
# UzBRBgwrBgEEAYI3TIN9AQEwQTA/BggrBgEFBQcCARYzaHR0cDovL3d3dy5taWNy
# b3NvZnQuY29tL3BraW9wcy9Eb2NzL1JlcG9zaXRvcnkuaHRtMBMGA1UdJQQMMAoG
# CCsGAQUFBwMIMBkGCSsGAQQBgjcUAgQMHgoAUwB1AGIAQwBBMAsGA1UdDwQEAwIB
# hjAPBgNVHRMBAf8EBTADAQH/MB8GA1UdIwQYMBaAFNX2VsuP6KJcYmjRPZSQW9fO
# mhjEMFYGA1UdHwRPME0wS6BJoEeGRWh0dHA6Ly9jcmwubWljcm9zb2Z0LmNvbS9w
# a2kvY3JsL3Byb2R1Y3RzL01pY1Jvb0NlckF1dF8yMDEwLTA2LTIzLmNybDBaBggr
# BgEFBQcBAQROMEwwSgYIKwYBBQUHMAKGPmh0dHA6Ly93d3cubWljcm9zb2Z0LmNv
# bS9wa2kvY2VydHMvTWljUm9vQ2VyQXV0XzIwMTAtMDYtMjMuY3J0MA0GCSqGSIb3
# DQEBCwUAA4ICAQCdVX38Kq3hLB9nATEkW+Geckv8qW/qXBS2Pk5HZHixBpOXPTEz
# tTnXwnE2P9pkbHzQdTltuw8x5MKP+2zRoZQYIu7pZmc6U03dmLq2HnjYNi6cqYJW
# AAOwBb6J6Gngugnue99qb74py27YP0h1AdkY3m2CDPVtI1TkeFN1JFe53Z/zjj3G
# 82jfZfakVqr3lbYoVSfQJL1AoL8ZthISEV09J+BAljis9/kpicO8F7BUhUKz/Aye
# ixmJ5/ALaoHCgRlCGVJ1ijbCHcNhcy4sa3tuPywJeBTpkbKpW99Jo3QMvOyRgNI9
# 5ko+ZjtPu4b6MhrZlvSP9pEB9s7GdP32THJvEKt1MMU0sHrYUP4KWN1APMdUbZ1j
# dEgssU5HLcEUBHG/ZPkkvnNtyo4JvbMBV0lUZNlz138eW0QBjloZkWsNn6Qo3GcZ
# KCS6OEuabvshVGtqRRFHqfG3rsjoiV5PndLQTHa1V1QJsWkBRH58oWFsc/4Ku+xB
# Zj1p/cvBQUl+fpO+y/g75LcVv7TOPqUxUYS8vwLBgqJ7Fx0ViY1w/ue10CgaiQuP
# Ntq6TPmb/wrpNPgkNWcr4A245oyZ1uEi6vAnQj0llOZ0dFtq0Z4+7X6gMTN9vMvp
# e784cETRkPHIqzqKOghif9lwY1NNje6CbaUFEMFxBmoQtB1VM1izoXBm8qGCA00w
# ggI1AgEBMIH5oYHRpIHOMIHLMQswCQYDVQQGEwJVUzETMBEGA1UECBMKV2FzaGlu
# Z3RvbjEQMA4GA1UEBxMHUmVkbW9uZDEeMBwGA1UEChMVTWljcm9zb2Z0IENvcnBv
# cmF0aW9uMSUwIwYDVQQLExxNaWNyb3NvZnQgQW1lcmljYSBPcGVyYXRpb25zMScw
# JQYDVQQLEx5uU2hpZWxkIFRTUyBFU046RjAwMi0wNUUwLUQ5NDcxJTAjBgNVBAMT
# HE1pY3Jvc29mdCBUaW1lLVN0YW1wIFNlcnZpY2WiIwoBATAHBgUrDgMCGgMVAGuL
# 3jdwUsfZN9AR8HTlIsgKDvgIoIGDMIGApH4wfDELMAkGA1UEBhMCVVMxEzARBgNV
# BAgTCldhc2hpbmd0b24xEDAOBgNVBAcTB1JlZG1vbmQxHjAcBgNVBAoTFU1pY3Jv
# c29mdCBDb3Jwb3JhdGlvbjEmMCQGA1UEAxMdTWljcm9zb2Z0IFRpbWUtU3RhbXAg
# UENBIDIwMTAwDQYJKoZIhvcNAQELBQACBQDqru8QMCIYDzIwMjQxMDA3MjMzNjQ4
# WhgPMjAyNDEwMDgyMzM2NDhaMHQwOgYKKwYBBAGEWQoEATEsMCowCgIFAOqu7xAC
# AQAwBwIBAAICEHwwBwIBAAICFREwCgIFAOqwQJACAQAwNgYKKwYBBAGEWQoEAjEo
# MCYwDAYKKwYBBAGEWQoDAqAKMAgCAQACAwehIKEKMAgCAQACAwGGoDANBgkqhkiG
# 9w0BAQsFAAOCAQEAXBQfFFETeWQRzuFVTR9NZOD+qkbDORr9AKPWP8z6vRhdvm6R
# /Wa5OpIZCUcTII+1SrZ9Mpcl4XPAuafmn0clZAyajvToMODVrnFnZ7jwrU4HLVpi
# s3ohO1d7et74V92WEsHwFcsZkydSIJEk372gumcSWzZVe5AxhXyEEURpTEjnJ7nn
# 9//rVpkcBjjRFUS4n6vPuwJfQBsWzIW+fERRbw4uZRJIFflAEnS38wlSXd08rkxO
# t2LnJTFvIpJkNypGYxLSVn1VyK+HtnpXYOIHVBuM6eOhCgOpb/3XIlYB3gI6hFq3
# bTwDjLBX87s46LSW2+CV61qK//5XLFpnlZ3FiTGCBA0wggQJAgEBMIGTMHwxCzAJ
# BgNVBAYTAlVTMRMwEQYDVQQIEwpXYXNoaW5ndG9uMRAwDgYDVQQHEwdSZWRtb25k
# MR4wHAYDVQQKExVNaWNyb3NvZnQgQ29ycG9yYXRpb24xJjAkBgNVBAMTHU1pY3Jv
# c29mdCBUaW1lLVN0YW1wIFBDQSAyMDEwAhMzAAAB8j4y12SscJGUAAEAAAHyMA0G
# CWCGSAFlAwQCAQUAoIIBSjAaBgkqhkiG9w0BCQMxDQYLKoZIhvcNAQkQAQQwLwYJ
# KoZIhvcNAQkEMSIEIOZfpTtu4BSsInNm9xSGr0USnvg8beBA5Ce5Ebr0+pRaMIH6
# BgsqhkiG9w0BCRACLzGB6jCB5zCB5DCBvQQg+No+HS4xUlzTj5jhG7kFRRscTiy5
# nqdEdJS7RddKQ0QwgZgwgYCkfjB8MQswCQYDVQQGEwJVUzETMBEGA1UECBMKV2Fz
# aGluZ3RvbjEQMA4GA1UEBxMHUmVkbW9uZDEeMBwGA1UEChMVTWljcm9zb2Z0IENv
# cnBvcmF0aW9uMSYwJAYDVQQDEx1NaWNyb3NvZnQgVGltZS1TdGFtcCBQQ0EgMjAx
# MAITMwAAAfI+MtdkrHCRlAABAAAB8jAiBCCud81ZbCuVdwRpyNWaTuVYiK7oN2io
# Nms+03FkmXdL9TANBgkqhkiG9w0BAQsFAASCAgBq9PR4FN8zFQ+5OASVs7Tnwtyr
# jJkS6Xwl3p+w07Ts1BMTLt6552EV7RxXPmLZdogjNru198cwp0n4bJ4YwCoK9bbL
# B74cYk04qt1Zfg0yRDqX3NTeo+p9+m6kef2UtNp9ju9q2uMajQewMrcTTeNVaWgL
# SDa5Onpf1CgUff18HTqHUBYtfLd7UlYpIyjoU55Sb87FulzC5Wl8D0zxbVEKCC+w
# vJyi7DT5Sac2bE2u9jHuRgAAA2yDsjuGDzEzTY3nzdLbeyQJ1gvNJowdF+fm55mv
# wqs52jwMD1+HUwjo7M4pXN7sD5YvASPkpbsWvfFghSv6KMQZfkCBmvYgfZ8V8dB5
# usvXl8hpL9sWhNMDlNCLdwGJexOGBJ0opz1ErfpXd+BB7NH0RGkILzqLKR+fImmb
# mBnxkurqb+eL/8dNimgCfJ2sN5QkMk7hx9jjapfqBLI7IJ83eDDvNLxOPEcqzB6V
# Y2chE5CO61UWqfrToK5hcdl5UBbknzxsxwc2QNcamHd9L0vycIsVRmpVOwds0hin
# 9XaJy9W95hfoqPaKtgD1m+x+FYE8zSzWgLrzZhtJDlwdEVwZ8cSEc4rHQ6BFkkGr
# /4rxLejaFn1G9JoEYsIFRucqQeDyJlwVUugT12viPEWJacFS65tSJ9Ax7Uu0XgmG
# BxxmJ/2BbkIW7d2bdA==
# SIG # End signature block
