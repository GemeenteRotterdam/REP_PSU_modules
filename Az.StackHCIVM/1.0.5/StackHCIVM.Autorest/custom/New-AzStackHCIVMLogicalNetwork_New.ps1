
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
The operation to create or update a logical network.
Please note some properties can be set only during logical network creation.
.Description
The operation to create or update a logical network.
Please note some properties can be set only during logical network creation.

.Outputs
Microsoft.Azure.PowerShell.Cmdlets.StackHCIVM.Models.ILogicalNetworks
.Notes
COMPLEX PARAMETER PROPERTIES

To create the parameters described below, construct a hash table containing the appropriate properties. For information on hash tables, run Get-Help about_Hash_Tables.

SUBNET <ISubnet[]>: Subnet - list of subnets under the logical network
  [AddressPrefix <String>]: The address prefix for the subnet: Cidr for this subnet - IPv4, IPv6.
  [IPAllocationMethod <IPAllocationMethodEnum?>]: IPAllocationMethod - The IP address allocation method. Possible values include: 'Static', 'Dynamic'
  [IPConfigurationReference <ISubnetPropertiesFormatIPConfigurationReferencesItem[]>]: IPConfigurationReferences - list of IPConfigurationReferences
    [Id <String>]: IPConfigurationID
  [IPPool <IIPPool[]>]: network associated pool of IP Addresses
    [End <String>]: End of the IP address pool
    [Name <String>]: Name of the IP-Pool
    [Start <String>]: Start of the IP address pool
    [Type <IPPoolTypeEnum?>]: Type of the IP Pool [vm, vippool]
  [Name <String>]: Name - The name of the resource that is unique within a resource group. This name can be used to access the resource.
  [PropertiesAddressPrefixes <String[]>]: List of address prefixes for the subnet.
  [Route <IRoute[]>]: Collection of routes contained within a route table.
    [AddressPrefix <String>]: The destination CIDR to which the route applies.
    [Name <String>]: Name - name of the subnet
    [NextHopIPAddress <String>]: The IP address packets should be forwarded to. Next hop values are only allowed in routes where the next hop type is VirtualAppliance.
  [Vlan <Int32?>]: Vlan to use for the subnet
.Link
https://learn.microsoft.com/powershell/module/az.stackhcivm/new-azstackhcivmlogicalnetwork
#>

function New-AzStackHCIVMLogicalNetwork {
  [OutputType([Microsoft.Azure.PowerShell.Cmdlets.StackHCIVM.Models.ILogicalNetworks])]
  [CmdletBinding( PositionalBinding=$false, SupportsShouldProcess, ConfirmImpact='Medium')]
  param(
      [Parameter(Mandatory)]
      [Alias('LogicalNetworkName')]
      [Microsoft.Azure.PowerShell.Cmdlets.StackHCIVM.Category('Path')]
      [System.String]
      # Name of the virtual network
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
      # The list of DNS servers IP addresses.
      ${DnsServer},
  
      [Parameter()]
      [Microsoft.Azure.PowerShell.Cmdlets.StackHCIVM.Category('Body')]
      [Microsoft.Azure.PowerShell.Cmdlets.StackHCIVM.Runtime.Info(PossibleTypes=([Microsoft.Azure.PowerShell.Cmdlets.StackHCIVM.Models.ITrackedResourceTags]))]
      [System.Collections.Hashtable]
      # Resource tags.
      ${Tag},
  
      [Parameter()]
      [Microsoft.Azure.PowerShell.Cmdlets.StackHCIVM.Category('Body')]
      [System.String]
      # Name of the network switch to be used for VMs
      ${VMSwitchName},
  
  
      [Parameter()]
      [Microsoft.Azure.PowerShell.Cmdlets.StackHCIVM.Category('Body')]
      [System.String[]]
      # List of address prefixes for the subnet.
      $AddressPrefix,
  
      [Parameter()]
      [Microsoft.Azure.PowerShell.Cmdlets.StackHCIVM.PSArgumentCompleterAttribute("Static", "Dynamic")]
      [Microsoft.Azure.PowerShell.Cmdlets.StackHCIVM.Category('Body')]
      [System.String]
      # The IP address allocation method. Possible values include: 'Static', 'Dynamic'
      $IpAllocationMethod, 
  
      [Parameter()]
      [Microsoft.Azure.PowerShell.Cmdlets.StackHCIVM.Category('Body')]
      [System.String]
      # End of the ip address pool
      $IpPoolEnd, 
  
      [Parameter()]
      [Microsoft.Azure.PowerShell.Cmdlets.StackHCIVM.Category('Body')]
      [System.String]
      # Start of the ip address pool
      $IpPoolStart, 
  
      [Parameter()]
      [Microsoft.Azure.PowerShell.Cmdlets.StackHCIVM.PSArgumentCompleterAttribute("vm", "vippool")]
      [Microsoft.Azure.PowerShell.Cmdlets.StackHCIVM.Category('Body')]
      [System.String]
      # Ip pool type
      $IpPoolType, 
  
      [Parameter()]
      [Microsoft.Azure.PowerShell.Cmdlets.StackHCIVM.Category('Body')]
      [System.Collections.Hashtable[]]
      # Network associated pool of IP Addresses
      $IpPool,
  
      [Parameter()]
      [Microsoft.Azure.PowerShell.Cmdlets.StackHCIVM.Category('Body')]
      [System.Collections.Hashtable[]]
      # Collection of routes contained within a route table.
      $Route, 
  
      [Parameter()]
      [Microsoft.Azure.PowerShell.Cmdlets.StackHCIVM.Category('Body')]
      [System.String]
      # Name of the subnet
      $SubnetName, 
  
      [Parameter()]
      [Microsoft.Azure.PowerShell.Cmdlets.StackHCIVM.Category('Body')]
      [System.Collections.Hashtable[]]
      # List of subnets under the virtual network
      $Subnet, 
  
      [Parameter()]
      [Microsoft.Azure.PowerShell.Cmdlets.StackHCIVM.Category('Body')]
      [System.Int32]
      # Vlan to use for the subnet
      $Vlan ,

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
  
      if ($Name -notmatch $vnetNameRegex){
        Write-Error "Invalid Name:  $Name. The name must start with an alphanumeric character, contain all alphanumeric characters or '-' or '_' or '.' and end with an alphanumeric character or '_'. The max length is 64 characters." -ErrorAction Stop
      }
  
      if ($CustomLocationId -notmatch $customLocationRegex){
        Write-Error "Invalid CustomLocationId: $CustomLocationId" -ErrorAction Stop
      } 
  
      if ($DnsServer){
        foreach ($DnsServ in $DnsServer){
          if ($DnsServ -notmatch $ipv4Regex){
              Write-Error "Invalid ipaddress provided for Dns Servers : $DnsServ." -ErrorAction Stop
          }
        }
      }
  
      if ($Subnet){
        Confirm-Subnets -Subnets $Subnet
  
      } else{
          $SubnetNew = @{}
          if ($IpAllocationMethod){
            if ($IpAllocationMethod.ToLower() -ne "dynamic" -and $IpAllocationMethod.ToLower() -ne "static"){
              Write-Error "Invalid Ip Allocation method provided: $IpAllocationMethod. Accepted values are 'dynamic' or 'static'" -ErrorAction Stop
            }
            $IpAllocationMethod = $IpAllocationMethod.ToLower()
            
            if ($IpAllocationMethod -eq "static"){
              $SubnetNew["IPAllocationMethod"] = 'Static'
              if (-Not $AddressPrefix){
                Write-Error "Invalid Configuration for Static IpAllocationMethod. AddressPrefix are required for Static IpAllocationMethod." -ErrorAction Stop
              }
            }
          } else {
            $SubnetNew["IPAllocationMethod"] = 'Dynamic'
          }
  
          if ($IpPoolStart -and $IpPoolEnd){
            if($IpPoolStart -notmatch $ipv4Regex){
              Write-Error "Invalid Ip Address provided : $IpPoolStart" -ErrorAction Stop
            }
  
            if($IpPoolEnd -notmatch $ipv4Regex){
              Write-Error "Invalid Ip Address provided : $IpPoolEnd" -ErrorAction Stop
            }
            $IpPoolNew = @{End = $IpPoolEnd; Start = $IpPoolStart}
            if ($IpPoolType){
              $IpPoolType = $IpPoolType.ToLower()
              if ($IpPoolType -ne "vm" -and $IpPoolType -ne "vippool"){
                Write-Error "Invalid IpPoolType provided: $IpPoolType. Accepted values are 'vm' and 'vippool'." -ErrorAction Stop
              }
              $IpPoolNew['Type'] = $IpPoolType
            }
            $SubnetNew["IPPool"] = @($IpPoolNew)
          } elseif ($IpPoolStart -or $IpPoolEnd){
              Write-Error "Both IpPoolStart and IpPoolEnd must be specified together." -ErrorAction Stop
          }
  
          if ($IpPool){
            Confirm-IpPools -IpPools $IpPool
            $SubnetNew["IPPool"] = $IpPool
          }
  
          if($Vlan){
            if ($Vlan -gt 4094 -or $Vlan -lt 1){
              Write-Error "Invalid value for Vlan : $Vlan. Valid range is 1-4094" -ErrorAction Stop
            }
            $SubnetNew["Vlan"] = $Vlan
          }
  
          if ($SubnetName){
            if ($SubnetName -notmatch $subnetNameRegex){
               Write-Error "Invalid SubnetName: $SubnetName. The name must start with an alphanumeric character, contain all alphanumeric characters or '-' or '_' or '.' and end with an alphanumeric character or '_'. The max length is 80 characters." -ErrorAction Stop
            }
            $SubnetNew["Name"] = $SubnetName
          }
  
          if ($AddressPrefix){
            foreach ($addPrefix in $AddressPrefix){
              if ($addPrefix -notmatch $cidrRegex){
                Write-Error "Invalid AddressPrefix: $addPrefix. Please use valid CIDR format." -ErrorAction Stop
              }
            }
  
            if ($AddressPrefix.length -eq 1){
              $SubnetNew["AddressPrefix"] = $AddressPrefix[0]
            } else {
              $SubnetNew["AddressPrefixes"] = $AddressPrefix
            }
  
          }
  
          if ($Route){
            Confirm-Routes -Routes $Route
            $SubnetNew["Route"] = $Route
  
          }
        
          $null = $PSBoundParameters.Remove("IpAllocationMethod")
          $null = $PSBoundParameters.Remove("IpPoolStart")
          $null = $PSBoundParameters.Remove("IpPoolEnd")
          $null = $PSBoundParameters.Remove("IpPoolType")
          $null = $PSBoundParameters.Remove("AddressPrefix")
          $null = $PSBoundParameters.Remove("Vlan")
          $null = $PSBoundParameters.Remove("SubnetName")
          $null = $PSBoundParameters.Remove("IpPool")
          $null = $PSBoundParameters.Remove("Route")
          $PSBoundParameters.Add("Subnet", $SubnetNew)
  
      } 

      try{
        Az.StackHCIVM.internal\New-AzStackHCIVMLogicalNetwork -ErrorAction Stop @PSBoundParameters 
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
# MIIoPAYJKoZIhvcNAQcCoIIoLTCCKCkCAQExDzANBglghkgBZQMEAgEFADB5Bgor
# BgEEAYI3AgEEoGswaTA0BgorBgEEAYI3AgEeMCYCAwEAAAQQH8w7YFlLCE63JNLG
# KX7zUQIBAAIBAAIBAAIBAAIBADAxMA0GCWCGSAFlAwQCAQUABCA7K8barCnHh0II
# oGIl53Xv5fVootrnBor1nOtkf54jaqCCDYUwggYDMIID66ADAgECAhMzAAADri01
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
# HAYKKwYBBAGCNwIBCzEOMAwGCisGAQQBgjcCARUwLwYJKoZIhvcNAQkEMSIEIOzp
# +f3N3rkXdvPafG6OKpw95QRIa2SXvv0rhS84X/4bMEIGCisGAQQBgjcCAQwxNDAy
# oBSAEgBNAGkAYwByAG8AcwBvAGYAdKEagBhodHRwOi8vd3d3Lm1pY3Jvc29mdC5j
# b20wDQYJKoZIhvcNAQEBBQAEggEA6T2YBVTfEr7LQ+6pQxDdLkF+CMOYYVKLD090
# 0pHeGKvUJ36uJCe4t8lqTNe3wrKE4Cy+kmYQB6ifekVsvim5fdUaNUY84e5CP5ky
# C10afJU90nSdR5V4Eh6GqR1f2EGHwK6HQ5pNTpjagby4sRcLg4q0Cac6+38Eu579
# +AFiG/ejypJMoIwEhvCfeKjCDPLGmpq/nmu6g/HBCoebc6kF85QLOw9yM2UGA5CR
# nfu+F8u2QBnQSAWN5MS1BP74U8+ReYPTZl+w0X6WP0TnLhwNNtbA/iQpd2swejF+
# oHz3Yf5ymO57xHNq7pQrUV2qQM2DGB+L7H9fMxyNov1z6NsW16GCF5cwgheTBgor
# BgEEAYI3AwMBMYIXgzCCF38GCSqGSIb3DQEHAqCCF3AwghdsAgEDMQ8wDQYJYIZI
# AWUDBAIBBQAwggFSBgsqhkiG9w0BCRABBKCCAUEEggE9MIIBOQIBAQYKKwYBBAGE
# WQoDATAxMA0GCWCGSAFlAwQCAQUABCAl+F6RZMBxtXwYVG3uWAIMr1VAEkv868ik
# u683IGlVeQIGZuMQ9mPbGBMyMDI0MTAwODA1MDcwMi4wNjRaMASAAgH0oIHRpIHO
# MIHLMQswCQYDVQQGEwJVUzETMBEGA1UECBMKV2FzaGluZ3RvbjEQMA4GA1UEBxMH
# UmVkbW9uZDEeMBwGA1UEChMVTWljcm9zb2Z0IENvcnBvcmF0aW9uMSUwIwYDVQQL
# ExxNaWNyb3NvZnQgQW1lcmljYSBPcGVyYXRpb25zMScwJQYDVQQLEx5uU2hpZWxk
# IFRTUyBFU046MzcwMy0wNUUwLUQ5NDcxJTAjBgNVBAMTHE1pY3Jvc29mdCBUaW1l
# LVN0YW1wIFNlcnZpY2WgghHtMIIHIDCCBQigAwIBAgITMwAAAeqaJHLVWT9hYwAB
# AAAB6jANBgkqhkiG9w0BAQsFADB8MQswCQYDVQQGEwJVUzETMBEGA1UECBMKV2Fz
# aGluZ3RvbjEQMA4GA1UEBxMHUmVkbW9uZDEeMBwGA1UEChMVTWljcm9zb2Z0IENv
# cnBvcmF0aW9uMSYwJAYDVQQDEx1NaWNyb3NvZnQgVGltZS1TdGFtcCBQQ0EgMjAx
# MDAeFw0yMzEyMDYxODQ1MzBaFw0yNTAzMDUxODQ1MzBaMIHLMQswCQYDVQQGEwJV
# UzETMBEGA1UECBMKV2FzaGluZ3RvbjEQMA4GA1UEBxMHUmVkbW9uZDEeMBwGA1UE
# ChMVTWljcm9zb2Z0IENvcnBvcmF0aW9uMSUwIwYDVQQLExxNaWNyb3NvZnQgQW1l
# cmljYSBPcGVyYXRpb25zMScwJQYDVQQLEx5uU2hpZWxkIFRTUyBFU046MzcwMy0w
# NUUwLUQ5NDcxJTAjBgNVBAMTHE1pY3Jvc29mdCBUaW1lLVN0YW1wIFNlcnZpY2Uw
# ggIiMA0GCSqGSIb3DQEBAQUAA4ICDwAwggIKAoICAQC1C1/xSD8gB9X7Ludoo2rW
# b2ksqaF65QtJkbQpmsc6G4bg5MOv6WP/uJ4XOJvKX/c1t0ej4oWBqdGD6VbjXX4T
# 0KfylTulrzKtgxnxZh7q1uD0Dy/w5G0DJDPb6oxQrz6vMV2Z3y9ZxjfZqBnDfqGo
# n/4VDHnZhdas22svSC5GHywsQ2J90MM7L4ecY8TnLI85kXXTVESb09txL2tHMYrB
# +KHCy08ds36an7IcOGfRmhHbFoPa5om9YGpVKS8xeT7EAwW7WbXL/lo5p9KRRIjA
# lsBBHD1TdGBucrGC3TQXSTp9s7DjkvvNFuUa0BKsz6UiCLxJGQSZhd2iOJTEfJ1f
# xYk2nY6SCKsV+VmtV5aiPzY/sWoFY542+zzrAPr4elrvr9uB6ci/Kci//EOERZEU
# TBPXME/ia+t8jrT2y3ug15MSCVuhOsNrmuZFwaRCrRED0yz4V9wlMTGHIJW55iNM
# 3HPVJJ19vOSvrCP9lsEcEwWZIQ1FCyPOnkM1fs7880dahAa5UmPqMk5WEKxzDPVp
# 081X5RQ6HGVUz6ZdgQ0jcT59EG+CKDPRD6mx8ovzIpS/r/wEHPKt5kOhYrjyQHXc
# 9KHKTWfXpAVj1Syqt5X4nr+Mpeubv+N/PjQEPr0iYJDjSzJrqILhBs5pytb6vyR8
# HUVMp+mAA4rXjOw42vkHfQIDAQABo4IBSTCCAUUwHQYDVR0OBBYEFCuBRSWiUebp
# F0BU1MTIcosFblleMB8GA1UdIwQYMBaAFJ+nFV0AXmJdg/Tl0mWnG1M1GelyMF8G
# A1UdHwRYMFYwVKBSoFCGTmh0dHA6Ly93d3cubWljcm9zb2Z0LmNvbS9wa2lvcHMv
# Y3JsL01pY3Jvc29mdCUyMFRpbWUtU3RhbXAlMjBQQ0ElMjAyMDEwKDEpLmNybDBs
# BggrBgEFBQcBAQRgMF4wXAYIKwYBBQUHMAKGUGh0dHA6Ly93d3cubWljcm9zb2Z0
# LmNvbS9wa2lvcHMvY2VydHMvTWljcm9zb2Z0JTIwVGltZS1TdGFtcCUyMFBDQSUy
# MDIwMTAoMSkuY3J0MAwGA1UdEwEB/wQCMAAwFgYDVR0lAQH/BAwwCgYIKwYBBQUH
# AwgwDgYDVR0PAQH/BAQDAgeAMA0GCSqGSIb3DQEBCwUAA4ICAQAog61WXj9+/nxV
# bX3G37KgvyoNAnuu2w3HoWZj3H0YCeQ3b9KSZThVThW4iFcHrKnhFMBbXJX4uQI5
# 3kOWSaWCaV3xCznpRt3c4/gSn3dvO/1GP3MJkpJfgo56CgS9zLOiP31kfmpUdPqe
# kZb4ivMR6LoPb5HNlq0WbBpzFbtsTjNrTyfqqcqAwc6r99Df2UQTqDa0vzwpA8Cx
# iAg2KlbPyMwBOPcr9hJT8sGpX/ZhLDh11dZcbUAzXHo1RJorSSftVa9hLWnzxGzE
# GafPUwLmoETihOGLqIQlCpvr94Hiak0Gq0wY6lduUQjk/lxZ4EzAw/cGMek8J3Qd
# iNS8u9ujYh1B7NLr6t3IglfScDV3bdVWet1itTUoKVRLIivRDwAT7dRH13Cq32j2
# JG5BYu/XitRE8cdzaJmDVBzYhlPl9QXvC+6qR8I6NIN/9914bTq/S4g6FF4f1dix
# UxE4qlfUPMixGr0Ft4/S0P4fwmhs+WHRn62PB4j3zCHixKJCsRn9IR3ExBQKQdMi
# 5auiqB6xQBADUf+F7hSKZfbA8sFSFreLSqhvj+qUQF84NcxuaxpbJWVpsO18IL4Q
# bt45Cz/QMa7EmMGNn7a8MM3uTQOlQy0u6c/jq111i1JqMjayTceQZNMBMM5EMc5D
# r5m3T4bDj9WTNLgP8SFe3EqTaWVMOTCCB3EwggVZoAMCAQICEzMAAAAVxedrngKb
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
# Y2EgT3BlcmF0aW9uczEnMCUGA1UECxMeblNoaWVsZCBUU1MgRVNOOjM3MDMtMDVF
# MC1EOTQ3MSUwIwYDVQQDExxNaWNyb3NvZnQgVGltZS1TdGFtcCBTZXJ2aWNloiMK
# AQEwBwYFKw4DAhoDFQCJ2x7cQfjpRskJ8UGIctOCkmEkj6CBgzCBgKR+MHwxCzAJ
# BgNVBAYTAlVTMRMwEQYDVQQIEwpXYXNoaW5ndG9uMRAwDgYDVQQHEwdSZWRtb25k
# MR4wHAYDVQQKExVNaWNyb3NvZnQgQ29ycG9yYXRpb24xJjAkBgNVBAMTHU1pY3Jv
# c29mdCBUaW1lLVN0YW1wIFBDQSAyMDEwMA0GCSqGSIb3DQEBCwUAAgUA6q8rVTAi
# GA8yMDI0MTAwODAzNTM1N1oYDzIwMjQxMDA5MDM1MzU3WjB3MD0GCisGAQQBhFkK
# BAExLzAtMAoCBQDqrytVAgEAMAoCAQACAhRhAgH/MAcCAQACAhPAMAoCBQDqsHzV
# AgEAMDYGCisGAQQBhFkKBAIxKDAmMAwGCisGAQQBhFkKAwKgCjAIAgEAAgMHoSCh
# CjAIAgEAAgMBhqAwDQYJKoZIhvcNAQELBQADggEBAGhx9NxpLlrrHRVhUiTBBPHb
# vFOGzuzv6KXtkdKKgTcRpj/SIgoMv9sCkr/SS41akfZp1OLsKBEQpM1xei2jdq94
# vi8vwMVfcVPCtLSkiRVWE9jFC+ZbgTtj4Pf39QXuQKZokERF9lofkRKrWPADFRfe
# YJqgrrzadm2xNalh4a5wTUpzx5xgGLQcjAjJU4mSuASbE3zdEuZzWYDXnAVANRR4
# I688NEhFWDnUpixmy+Z6H7jZM78CwUsDGv9s2JUCFzTRaB4YHEzM4oarcKlW8aoV
# QSY3xZr6Gu8ssWE3Z5cVDQgx/8s3M5FXshkaxgvlNnEGCCv6l9/XRTOhg2V9n54x
# ggQNMIIECQIBATCBkzB8MQswCQYDVQQGEwJVUzETMBEGA1UECBMKV2FzaGluZ3Rv
# bjEQMA4GA1UEBxMHUmVkbW9uZDEeMBwGA1UEChMVTWljcm9zb2Z0IENvcnBvcmF0
# aW9uMSYwJAYDVQQDEx1NaWNyb3NvZnQgVGltZS1TdGFtcCBQQ0EgMjAxMAITMwAA
# AeqaJHLVWT9hYwABAAAB6jANBglghkgBZQMEAgEFAKCCAUowGgYJKoZIhvcNAQkD
# MQ0GCyqGSIb3DQEJEAEEMC8GCSqGSIb3DQEJBDEiBCCmKecwfwa5tiamwHXieZwP
# 6MI5pb9isKPA931/tac67DCB+gYLKoZIhvcNAQkQAi8xgeowgecwgeQwgb0EICmP
# odXjZDR4iwg0ltLANXBh5G1uKqKIvq8sjKekuGZ4MIGYMIGApH4wfDELMAkGA1UE
# BhMCVVMxEzARBgNVBAgTCldhc2hpbmd0b24xEDAOBgNVBAcTB1JlZG1vbmQxHjAc
# BgNVBAoTFU1pY3Jvc29mdCBDb3Jwb3JhdGlvbjEmMCQGA1UEAxMdTWljcm9zb2Z0
# IFRpbWUtU3RhbXAgUENBIDIwMTACEzMAAAHqmiRy1Vk/YWMAAQAAAeowIgQgKV7t
# TvlACC1rIOu8/joIqRoP5Tl2hovxL/HY0MhelhEwDQYJKoZIhvcNAQELBQAEggIA
# fM4GlLwOSk+BdmpqiiQwSfpGkNURV3/VkmxQyOrj62HCr1eYTBCNWFwE6EMWnYLI
# +NH4SArm1M41+aNT4gTO8/FuY4vyFk1fIlgIy5XYYoxAVsxyzp1o8cOWMwGGbvNC
# t+Y91zAFAHqrBpqHtEifo4J3nSOAIBbD22LbssBW/8/Ktwvw0FfAyClaGIeasG/y
# ukSrYLCewlsRxQQHJ1b/zOkFK0yHhMaPhhvGZl2yKSHDz16oWNwmMf3sLWO/1sNa
# HW9uAn1lPbzsRuJHsViVuB2WwBqbgu7k+lyk+Q4+vjwmCyashBVNKTnKh5mRzBp1
# g2xOGECYDs6w2acs8Q8xqmoHaqQFeGD4H/PP+yBPYYxnMkFshWwu7mZeKDyLdGdI
# q+CKm82mzjoQSdrp0sbNdy54j9YlDHVeosNQIE81SyImB221AlPrijNT6H58swll
# FeTmGN5SnSRXr7h6rWUPBm6pccBR/cxPvNaiRz6oDDa9uPyNwSRnqdGuvlMau2pV
# LjBurJI8rGUGgnvWWJONIfRMaR7V7kr3XqQyufbqF4g33FRe1bRVfNSTG1Odp9D7
# IJxOVAHEXejiW0c1hXRwe96zDRFHBveYFXRTuDhV88OPIlN9+4IuLZKGo9aiZiv5
# tbFyrdV7D4ghByz7LbL4wn4yjcTRPn+0xCnsXAylkxA=
# SIG # End signature block
