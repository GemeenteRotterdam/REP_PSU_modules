
# ----------------------------------------------------------------------------------
# Copyright (c) Microsoft Corporation. All rights reserved.
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
# http://www.apache.org/licenses/LICENSE-2.0
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
# Code generated by Microsoft (R) AutoRest Code Generator.Changes may cause incorrect behavior and will be lost if the code
# is regenerated.
# ----------------------------------------------------------------------------------

<#
.Synopsis
Partially updates a Scheduled.
.Description
Partially updates a Scheduled.
.Example
{{ Add code here }}
.Example
{{ Add code here }}

.Inputs
Microsoft.Azure.PowerShell.Cmdlets.DevCenter.Models.IDevCenterIdentity
.Outputs
Microsoft.Azure.PowerShell.Cmdlets.DevCenter.Models.Api20240501Preview.ISchedule
.Notes
COMPLEX PARAMETER PROPERTIES

To create the parameters described below, construct a hash table containing the appropriate properties. For information on hash tables, run Get-Help about_Hash_Tables.

INPUTOBJECT <IDevCenterIdentity>: Identity Parameter
  [AttachedNetworkConnectionName <String>]: The name of the attached NetworkConnection.
  [CatalogName <String>]: The name of the Catalog.
  [DevBoxDefinitionName <String>]: The name of the Dev Box definition.
  [DevCenterName <String>]: The name of the devcenter.
  [EncryptionSetName <String>]: The name of the devcenter encryption set.
  [EnvironmentDefinitionName <String>]: The name of the Environment Definition.
  [EnvironmentTypeName <String>]: The name of the environment type.
  [GalleryName <String>]: The name of the gallery.
  [Id <String>]: Resource identity path
  [ImageName <String>]: The name of the image.
  [Location <String>]: The Azure region
  [MemberName <String>]: The name of a devcenter plan member.
  [NetworkConnectionName <String>]: Name of the Network Connection that can be applied to a Pool.
  [OperationId <String>]: The ID of an ongoing async operation
  [PlanName <String>]: The name of the devcenter plan.
  [PoolName <String>]: Name of the pool.
  [ProjectName <String>]: The name of the project.
  [ResourceGroupName <String>]: The name of the resource group. The name is case insensitive.
  [ScheduleName <String>]: The name of the schedule that uniquely identifies it.
  [SubscriptionId <String>]: The ID of the target subscription.
  [TaskName <String>]: The name of the Task.
  [VersionName <String>]: The version of the image.
.Link
https://learn.microsoft.com/powershell/module/az.devcenter/update-azdevcenteradminschedule
#>
function Update-AzDevCenterAdminSchedule {
  [OutputType([Microsoft.Azure.PowerShell.Cmdlets.DevCenter.Models.Api20240501Preview.ISchedule])]
  [CmdletBinding(DefaultParameterSetName='UpdateExpanded', PositionalBinding=$false, SupportsShouldProcess, ConfirmImpact='Medium')]
  param(
      [Parameter(ParameterSetName='UpdateExpanded', Mandatory)]
      [Microsoft.Azure.PowerShell.Cmdlets.DevCenter.Category('Path')]
      [System.String]
      # Name of the pool.
      ${PoolName},
  
      [Parameter(ParameterSetName='UpdateExpanded', Mandatory)]
      [Microsoft.Azure.PowerShell.Cmdlets.DevCenter.Category('Path')]
      [System.String]
      # The name of the project.
      ${ProjectName},
  
      [Parameter(ParameterSetName='UpdateExpanded', Mandatory)]
      [Microsoft.Azure.PowerShell.Cmdlets.DevCenter.Category('Path')]
      [System.String]
      # The name of the resource group.
      # The name is case insensitive.
      ${ResourceGroupName},
  
      [Parameter(ParameterSetName='UpdateExpanded')]
      [Microsoft.Azure.PowerShell.Cmdlets.DevCenter.Category('Path')]
      [Microsoft.Azure.PowerShell.Cmdlets.DevCenter.Runtime.DefaultInfo(Script='(Get-AzContext).Subscription.Id')]
      [System.String]
      # The ID of the target subscription.
      ${SubscriptionId},
  
      [Parameter(ParameterSetName='UpdateViaIdentityExpanded', Mandatory, ValueFromPipeline)]
      [Microsoft.Azure.PowerShell.Cmdlets.DevCenter.Category('Path')]
      [Microsoft.Azure.PowerShell.Cmdlets.DevCenter.Models.IDevCenterIdentity]
      # Identity Parameter
      # To construct, see NOTES section for INPUTOBJECT properties and create a hash table.
      ${InputObject},

      [Parameter(ParameterSetName = 'UpdateExpanded')]
      [Parameter(ParameterSetName = 'UpdateViaIdentityExpanded')]
      [ArgumentCompleter([Microsoft.Azure.PowerShell.Cmdlets.DevCenter.Support.ScheduleEnableStatus])]
      [Microsoft.Azure.PowerShell.Cmdlets.DevCenter.Category('Body')]
      [Microsoft.Azure.PowerShell.Cmdlets.DevCenter.Support.ScheduleEnableStatus]
      # Indicates whether or not this scheduled task is enabled.
      ${State},
  
      [Parameter(ParameterSetName = 'UpdateExpanded')]
      [Parameter(ParameterSetName = 'UpdateViaIdentityExpanded')]
      [Microsoft.Azure.PowerShell.Cmdlets.DevCenter.Category('Body')]
      [Microsoft.Azure.PowerShell.Cmdlets.DevCenter.Runtime.Info(PossibleTypes=([Microsoft.Azure.PowerShell.Cmdlets.DevCenter.Models.Api20240501Preview.ITags]))]
      [System.Collections.Hashtable]
      # Resource tags.
      ${Tag},
  
      [Parameter(ParameterSetName = 'UpdateExpanded')]
      [Parameter(ParameterSetName = 'UpdateViaIdentityExpanded')]
      [Microsoft.Azure.PowerShell.Cmdlets.DevCenter.Category('Body')]
      [System.String]
      # The target time to trigger the action.
      # The format is HH:MM.
      ${Time},
  
      [Parameter(ParameterSetName = 'UpdateExpanded')]
      [Parameter(ParameterSetName = 'UpdateViaIdentityExpanded')]
      [Microsoft.Azure.PowerShell.Cmdlets.DevCenter.Category('Body')]
      [System.String]
      # The IANA timezone id at which the schedule should execute.
      ${TimeZone},
  
      [Parameter(ParameterSetName = 'UpdateExpanded')]
      [Parameter(ParameterSetName = 'UpdateViaIdentityExpanded')]
      [ArgumentCompleter([Microsoft.Azure.PowerShell.Cmdlets.DevCenter.Support.ScheduledType])]
      [Microsoft.Azure.PowerShell.Cmdlets.DevCenter.Category('Body')]
      [Microsoft.Azure.PowerShell.Cmdlets.DevCenter.Support.ScheduledType]
      # Supported type this scheduled task represents.
      ${Type},
  
      [Parameter()]
      [Alias('AzureRMContext', 'AzureCredential')]
      [ValidateNotNull()]
      [Microsoft.Azure.PowerShell.Cmdlets.DevCenter.Category('Azure')]
      [System.Management.Automation.PSObject]
      # The DefaultProfile parameter is not functional.
      # Use the SubscriptionId parameter when available if executing the cmdlet against a different subscription.
      ${DefaultProfile},
  
      [Parameter()]
      [Microsoft.Azure.PowerShell.Cmdlets.DevCenter.Category('Runtime')]
      [System.Management.Automation.SwitchParameter]
      # Run the command as a job
      ${AsJob},
  
      [Parameter(DontShow)]
      [Microsoft.Azure.PowerShell.Cmdlets.DevCenter.Category('Runtime')]
      [System.Management.Automation.SwitchParameter]
      # Wait for .NET debugger to attach
      ${Break},
  
      [Parameter(DontShow)]
      [ValidateNotNull()]
      [Microsoft.Azure.PowerShell.Cmdlets.DevCenter.Category('Runtime')]
      [Microsoft.Azure.PowerShell.Cmdlets.DevCenter.Runtime.SendAsyncStep[]]
      # SendAsync Pipeline Steps to be appended to the front of the pipeline
      ${HttpPipelineAppend},
  
      [Parameter(DontShow)]
      [ValidateNotNull()]
      [Microsoft.Azure.PowerShell.Cmdlets.DevCenter.Category('Runtime')]
      [Microsoft.Azure.PowerShell.Cmdlets.DevCenter.Runtime.SendAsyncStep[]]
      # SendAsync Pipeline Steps to be prepended to the front of the pipeline
      ${HttpPipelinePrepend},
  
      [Parameter()]
      [Microsoft.Azure.PowerShell.Cmdlets.DevCenter.Category('Runtime')]
      [System.Management.Automation.SwitchParameter]
      # Run the command asynchronously
      ${NoWait},
  
      [Parameter(DontShow)]
      [Microsoft.Azure.PowerShell.Cmdlets.DevCenter.Category('Runtime')]
      [System.Uri]
      # The URI for the proxy server to use
      ${Proxy},
  
      [Parameter(DontShow)]
      [ValidateNotNull()]
      [Microsoft.Azure.PowerShell.Cmdlets.DevCenter.Category('Runtime')]
      [System.Management.Automation.PSCredential]
      # Credentials for a proxy server to use for the remote call
      ${ProxyCredential},
  
      [Parameter(DontShow)]
      [Microsoft.Azure.PowerShell.Cmdlets.DevCenter.Category('Runtime')]
      [System.Management.Automation.SwitchParameter]
      # Use the default credentials for the proxy
      ${ProxyUseDefaultCredentials}
  )

  process {
    if ($PSBoundParameters.ContainsKey('InputObject')) {
      $PSBoundParameters["InputObject"].ScheduleName = "Default"
    }
    
    Az.DevCenter.internal\Update-AzDevCenterAdminSchedule @PSBoundParameters
  }

}

# SIG # Begin signature block
# MIIoQwYJKoZIhvcNAQcCoIIoNDCCKDACAQExDzANBglghkgBZQMEAgEFADB5Bgor
# BgEEAYI3AgEEoGswaTA0BgorBgEEAYI3AgEeMCYCAwEAAAQQH8w7YFlLCE63JNLG
# KX7zUQIBAAIBAAIBAAIBAAIBADAxMA0GCWCGSAFlAwQCAQUABCB21KLnBv6EobAd
# XdTOxCDPr6fY7u27rVtTRe+n3+VKNaCCDXYwggX0MIID3KADAgECAhMzAAAEBGx0
# Bv9XKydyAAAAAAQEMA0GCSqGSIb3DQEBCwUAMH4xCzAJBgNVBAYTAlVTMRMwEQYD
# VQQIEwpXYXNoaW5ndG9uMRAwDgYDVQQHEwdSZWRtb25kMR4wHAYDVQQKExVNaWNy
# b3NvZnQgQ29ycG9yYXRpb24xKDAmBgNVBAMTH01pY3Jvc29mdCBDb2RlIFNpZ25p
# bmcgUENBIDIwMTEwHhcNMjQwOTEyMjAxMTE0WhcNMjUwOTExMjAxMTE0WjB0MQsw
# CQYDVQQGEwJVUzETMBEGA1UECBMKV2FzaGluZ3RvbjEQMA4GA1UEBxMHUmVkbW9u
# ZDEeMBwGA1UEChMVTWljcm9zb2Z0IENvcnBvcmF0aW9uMR4wHAYDVQQDExVNaWNy
# b3NvZnQgQ29ycG9yYXRpb24wggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIB
# AQC0KDfaY50MDqsEGdlIzDHBd6CqIMRQWW9Af1LHDDTuFjfDsvna0nEuDSYJmNyz
# NB10jpbg0lhvkT1AzfX2TLITSXwS8D+mBzGCWMM/wTpciWBV/pbjSazbzoKvRrNo
# DV/u9omOM2Eawyo5JJJdNkM2d8qzkQ0bRuRd4HarmGunSouyb9NY7egWN5E5lUc3
# a2AROzAdHdYpObpCOdeAY2P5XqtJkk79aROpzw16wCjdSn8qMzCBzR7rvH2WVkvF
# HLIxZQET1yhPb6lRmpgBQNnzidHV2Ocxjc8wNiIDzgbDkmlx54QPfw7RwQi8p1fy
# 4byhBrTjv568x8NGv3gwb0RbAgMBAAGjggFzMIIBbzAfBgNVHSUEGDAWBgorBgEE
# AYI3TAgBBggrBgEFBQcDAzAdBgNVHQ4EFgQU8huhNbETDU+ZWllL4DNMPCijEU4w
# RQYDVR0RBD4wPKQ6MDgxHjAcBgNVBAsTFU1pY3Jvc29mdCBDb3Jwb3JhdGlvbjEW
# MBQGA1UEBRMNMjMwMDEyKzUwMjkyMzAfBgNVHSMEGDAWgBRIbmTlUAXTgqoXNzci
# tW2oynUClTBUBgNVHR8ETTBLMEmgR6BFhkNodHRwOi8vd3d3Lm1pY3Jvc29mdC5j
# b20vcGtpb3BzL2NybC9NaWNDb2RTaWdQQ0EyMDExXzIwMTEtMDctMDguY3JsMGEG
# CCsGAQUFBwEBBFUwUzBRBggrBgEFBQcwAoZFaHR0cDovL3d3dy5taWNyb3NvZnQu
# Y29tL3BraW9wcy9jZXJ0cy9NaWNDb2RTaWdQQ0EyMDExXzIwMTEtMDctMDguY3J0
# MAwGA1UdEwEB/wQCMAAwDQYJKoZIhvcNAQELBQADggIBAIjmD9IpQVvfB1QehvpC
# Ge7QeTQkKQ7j3bmDMjwSqFL4ri6ae9IFTdpywn5smmtSIyKYDn3/nHtaEn0X1NBj
# L5oP0BjAy1sqxD+uy35B+V8wv5GrxhMDJP8l2QjLtH/UglSTIhLqyt8bUAqVfyfp
# h4COMRvwwjTvChtCnUXXACuCXYHWalOoc0OU2oGN+mPJIJJxaNQc1sjBsMbGIWv3
# cmgSHkCEmrMv7yaidpePt6V+yPMik+eXw3IfZ5eNOiNgL1rZzgSJfTnvUqiaEQ0X
# dG1HbkDv9fv6CTq6m4Ty3IzLiwGSXYxRIXTxT4TYs5VxHy2uFjFXWVSL0J2ARTYL
# E4Oyl1wXDF1PX4bxg1yDMfKPHcE1Ijic5lx1KdK1SkaEJdto4hd++05J9Bf9TAmi
# u6EK6C9Oe5vRadroJCK26uCUI4zIjL/qG7mswW+qT0CW0gnR9JHkXCWNbo8ccMk1
# sJatmRoSAifbgzaYbUz8+lv+IXy5GFuAmLnNbGjacB3IMGpa+lbFgih57/fIhamq
# 5VhxgaEmn/UjWyr+cPiAFWuTVIpfsOjbEAww75wURNM1Imp9NJKye1O24EspEHmb
# DmqCUcq7NqkOKIG4PVm3hDDED/WQpzJDkvu4FrIbvyTGVU01vKsg4UfcdiZ0fQ+/
# V0hf8yrtq9CkB8iIuk5bBxuPMIIHejCCBWKgAwIBAgIKYQ6Q0gAAAAAAAzANBgkq
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
# /Xmfwb1tbWrJUnMTDXpQzTGCGiMwghofAgEBMIGVMH4xCzAJBgNVBAYTAlVTMRMw
# EQYDVQQIEwpXYXNoaW5ndG9uMRAwDgYDVQQHEwdSZWRtb25kMR4wHAYDVQQKExVN
# aWNyb3NvZnQgQ29ycG9yYXRpb24xKDAmBgNVBAMTH01pY3Jvc29mdCBDb2RlIFNp
# Z25pbmcgUENBIDIwMTECEzMAAAQEbHQG/1crJ3IAAAAABAQwDQYJYIZIAWUDBAIB
# BQCgga4wGQYJKoZIhvcNAQkDMQwGCisGAQQBgjcCAQQwHAYKKwYBBAGCNwIBCzEO
# MAwGCisGAQQBgjcCARUwLwYJKoZIhvcNAQkEMSIEIK5L7eAp2BXeLo7twAxgbC9v
# KRWI/HmjCgVWZEwKiaMvMEIGCisGAQQBgjcCAQwxNDAyoBSAEgBNAGkAYwByAG8A
# cwBvAGYAdKEagBhodHRwOi8vd3d3Lm1pY3Jvc29mdC5jb20wDQYJKoZIhvcNAQEB
# BQAEggEATgysu6dK3HM/G9RMheHocOYmaFtQJ9zx7AKkrMGSZu4FXYLpXdN0/3kn
# Xmp9k9F6NCeOXTeZ+xg8llCAG8BhCV/499ad/W53ckKMHRRQmAaV3uw9SJ1Qg6eX
# eC0xQY7LlXwQImhf0ERnCi8QJwJsemx8kJFQiEd3i5dc9SgjjVNF2Yx2Axvhwaej
# ohWNSLOrFmM6HDXnYIer9ZvixK6qpxYOQGYlFiifcgwydRAqmVtqIlvHgTpnVe/G
# cny9FddAM65D9Xk7Gp596Zaex2HrcAX2IuUZVJJ2TfnUVtrmNiDgtmxkydSW78Np
# u6He3FNYp7NPD5Q1UJW88+xFXiWnWqGCF60wghepBgorBgEEAYI3AwMBMYIXmTCC
# F5UGCSqGSIb3DQEHAqCCF4YwgheCAgEDMQ8wDQYJYIZIAWUDBAIBBQAwggFaBgsq
# hkiG9w0BCRABBKCCAUkEggFFMIIBQQIBAQYKKwYBBAGEWQoDATAxMA0GCWCGSAFl
# AwQCAQUABCAX5bd0KD+0adsHmYK/ag3T6a7odVx8bVpQzgfGvqGs4AIGZzIF2L4g
# GBMyMDI0MTExNTA1NTg1MS4wMDhaMASAAgH0oIHZpIHWMIHTMQswCQYDVQQGEwJV
# UzETMBEGA1UECBMKV2FzaGluZ3RvbjEQMA4GA1UEBxMHUmVkbW9uZDEeMBwGA1UE
# ChMVTWljcm9zb2Z0IENvcnBvcmF0aW9uMS0wKwYDVQQLEyRNaWNyb3NvZnQgSXJl
# bGFuZCBPcGVyYXRpb25zIExpbWl0ZWQxJzAlBgNVBAsTHm5TaGllbGQgVFNTIEVT
# Tjo2QjA1LTA1RTAtRDk0NzElMCMGA1UEAxMcTWljcm9zb2Z0IFRpbWUtU3RhbXAg
# U2VydmljZaCCEfswggcoMIIFEKADAgECAhMzAAAB9oMvJmpUXSLBAAEAAAH2MA0G
# CSqGSIb3DQEBCwUAMHwxCzAJBgNVBAYTAlVTMRMwEQYDVQQIEwpXYXNoaW5ndG9u
# MRAwDgYDVQQHEwdSZWRtb25kMR4wHAYDVQQKExVNaWNyb3NvZnQgQ29ycG9yYXRp
# b24xJjAkBgNVBAMTHU1pY3Jvc29mdCBUaW1lLVN0YW1wIFBDQSAyMDEwMB4XDTI0
# MDcyNTE4MzEwNFoXDTI1MTAyMjE4MzEwNFowgdMxCzAJBgNVBAYTAlVTMRMwEQYD
# VQQIEwpXYXNoaW5ndG9uMRAwDgYDVQQHEwdSZWRtb25kMR4wHAYDVQQKExVNaWNy
# b3NvZnQgQ29ycG9yYXRpb24xLTArBgNVBAsTJE1pY3Jvc29mdCBJcmVsYW5kIE9w
# ZXJhdGlvbnMgTGltaXRlZDEnMCUGA1UECxMeblNoaWVsZCBUU1MgRVNOOjZCMDUt
# MDVFMC1EOTQ3MSUwIwYDVQQDExxNaWNyb3NvZnQgVGltZS1TdGFtcCBTZXJ2aWNl
# MIICIjANBgkqhkiG9w0BAQEFAAOCAg8AMIICCgKCAgEA0UJeLMR/N9WPBZhuKVFF
# +eWJZ68Wujdj4X6JR05cxO5CepNXo17rVazwWLkm5AjaVh19ZVjDChHzimxsoaXx
# Nu8IDggKwpXvpAAItv4Ux50e9S2uVwfKv57p9JKG+Q7VONShujl1NCMkcgSrPdmd
# /8zcsmhzcNobLomrCAIORZ8IwhYy4siVQlf1NKhlyAzmkWJD0N+60IiogFBzg3yI
# SsvroOx0x1xSi2PiRIQlTXE74MggZDIDKqH/hb9FT2kK/nV/aXjuo9LMrrRmn44o
# YYADe/rO95F+SG3uuuhf+H4IriXr0h9ptA6SwHJPS2VmbNWCjQWq5G4YkrcqbPMa
# x7vNXUwu7T65E8fFPd1IuE9RsG4TMAV7XkXBopmPNfvL0hjxg44kpQn384V46o+z
# dQqy5K9dDlWm/J6vZtp5yA1PyD3w+HbGubS0niEQ1L6wGOrPfzIm0FdOn+xFo48E
# Rl+Fxw/3OvXM5CY1EqnzEznPjzJc7OJwhJVR3VQDHjBcEFTOvS9E0diNu1eocw+Z
# Ckz4Pu/oQv+gqU+bfxL8e7PFktfRDlM6FyOzjP4zuI25gD8tO9zJg6g6fRpaZc43
# 9mAbkl3zCVzTLDgchv6SxQajJtvvoQaZxQf0tRiPcbr2HWfMoqqd9uiQ0hTUEhG4
# 4FBSTeUPZeEenRCWadCW4G8CAwEAAaOCAUkwggFFMB0GA1UdDgQWBBRIwZsJuOcJ
# fScPWcXZuBA4B89K8jAfBgNVHSMEGDAWgBSfpxVdAF5iXYP05dJlpxtTNRnpcjBf
# BgNVHR8EWDBWMFSgUqBQhk5odHRwOi8vd3d3Lm1pY3Jvc29mdC5jb20vcGtpb3Bz
# L2NybC9NaWNyb3NvZnQlMjBUaW1lLVN0YW1wJTIwUENBJTIwMjAxMCgxKS5jcmww
# bAYIKwYBBQUHAQEEYDBeMFwGCCsGAQUFBzAChlBodHRwOi8vd3d3Lm1pY3Jvc29m
# dC5jb20vcGtpb3BzL2NlcnRzL01pY3Jvc29mdCUyMFRpbWUtU3RhbXAlMjBQQ0El
# MjAyMDEwKDEpLmNydDAMBgNVHRMBAf8EAjAAMBYGA1UdJQEB/wQMMAoGCCsGAQUF
# BwMIMA4GA1UdDwEB/wQEAwIHgDANBgkqhkiG9w0BAQsFAAOCAgEA13kBirH1cHu1
# WYR1ysj125omGtQ0PaQkEzwGb70xtqSoI+svQihsgdTYxaPfp2IVFdgjaMaBi81w
# B8/nu866FfFKKdhdp3wnMZ91PpP4Ooe7Ncf6qICkgSuwgdIdQvqE0h8VQ5QW5sDV
# 4Q0Jnj4f7KHYx4NiM8C4jTw8SQtsuxWiTH2Hikf3QYB71a7dB9zgHOkW0hgUEeWO
# 9mh2wWqYS/Q48ASjOqYw/ha54oVOff22WaoH+/Hxd9NTEU/4vlvsRIMWT0jsnNI7
# 1jVArT4Q9Bt6VShWzyqraE6SKUoZrEwBpVsI0LMg2X3hOLblC1vxM3+wMyOh97aF
# Os7sFnuemtI2Mfj8qg16BZTJxXlpPurWrG+OBj4BoTDkC9AxXYB3yEtuwMs7pRWL
# yxIxw/wV9THKUGm+x+VE0POLwkrSMgjulSXkpfELHWWiCVslJbFIIB/4Alv+jQJS
# KAJuo9CErbm2qeDk/zjJYlYaVGMyKuYZ+uSRVKB2qkEPcEzG1dO9zIa1Mp32J+zz
# W3P7suJfjw62s3hDOLk+6lMQOR04x+2o17G3LceLkkxJm41ErdiTjAmdClen9yl6
# HgMpGS4okjFCJX+CpOFX7gBA3PVxQWubisAQbL5HgTFBtQNEzcCdh1GYw/6nzzNN
# t+0GQnnobBddfOAiqkzvItqXjvGyK1QwggdxMIIFWaADAgECAhMzAAAAFcXna54C
# m0mZAAAAAAAVMA0GCSqGSIb3DQEBCwUAMIGIMQswCQYDVQQGEwJVUzETMBEGA1UE
# CBMKV2FzaGluZ3RvbjEQMA4GA1UEBxMHUmVkbW9uZDEeMBwGA1UEChMVTWljcm9z
# b2Z0IENvcnBvcmF0aW9uMTIwMAYDVQQDEylNaWNyb3NvZnQgUm9vdCBDZXJ0aWZp
# Y2F0ZSBBdXRob3JpdHkgMjAxMDAeFw0yMTA5MzAxODIyMjVaFw0zMDA5MzAxODMy
# MjVaMHwxCzAJBgNVBAYTAlVTMRMwEQYDVQQIEwpXYXNoaW5ndG9uMRAwDgYDVQQH
# EwdSZWRtb25kMR4wHAYDVQQKExVNaWNyb3NvZnQgQ29ycG9yYXRpb24xJjAkBgNV
# BAMTHU1pY3Jvc29mdCBUaW1lLVN0YW1wIFBDQSAyMDEwMIICIjANBgkqhkiG9w0B
# AQEFAAOCAg8AMIICCgKCAgEA5OGmTOe0ciELeaLL1yR5vQ7VgtP97pwHB9KpbE51
# yMo1V/YBf2xK4OK9uT4XYDP/XE/HZveVU3Fa4n5KWv64NmeFRiMMtY0Tz3cywBAY
# 6GB9alKDRLemjkZrBxTzxXb1hlDcwUTIcVxRMTegCjhuje3XD9gmU3w5YQJ6xKr9
# cmmvHaus9ja+NSZk2pg7uhp7M62AW36MEBydUv626GIl3GoPz130/o5Tz9bshVZN
# 7928jaTjkY+yOSxRnOlwaQ3KNi1wjjHINSi947SHJMPgyY9+tVSP3PoFVZhtaDua
# Rr3tpK56KTesy+uDRedGbsoy1cCGMFxPLOJiss254o2I5JasAUq7vnGpF1tnYN74
# kpEeHT39IM9zfUGaRnXNxF803RKJ1v2lIH1+/NmeRd+2ci/bfV+AutuqfjbsNkz2
# K26oElHovwUDo9Fzpk03dJQcNIIP8BDyt0cY7afomXw/TNuvXsLz1dhzPUNOwTM5
# TI4CvEJoLhDqhFFG4tG9ahhaYQFzymeiXtcodgLiMxhy16cg8ML6EgrXY28MyTZk
# i1ugpoMhXV8wdJGUlNi5UPkLiWHzNgY1GIRH29wb0f2y1BzFa/ZcUlFdEtsluq9Q
# BXpsxREdcu+N+VLEhReTwDwV2xo3xwgVGD94q0W29R6HXtqPnhZyacaue7e3Pmri
# Lq0CAwEAAaOCAd0wggHZMBIGCSsGAQQBgjcVAQQFAgMBAAEwIwYJKwYBBAGCNxUC
# BBYEFCqnUv5kxJq+gpE8RjUpzxD/LwTuMB0GA1UdDgQWBBSfpxVdAF5iXYP05dJl
# pxtTNRnpcjBcBgNVHSAEVTBTMFEGDCsGAQQBgjdMg30BATBBMD8GCCsGAQUFBwIB
# FjNodHRwOi8vd3d3Lm1pY3Jvc29mdC5jb20vcGtpb3BzL0RvY3MvUmVwb3NpdG9y
# eS5odG0wEwYDVR0lBAwwCgYIKwYBBQUHAwgwGQYJKwYBBAGCNxQCBAweCgBTAHUA
# YgBDAEEwCwYDVR0PBAQDAgGGMA8GA1UdEwEB/wQFMAMBAf8wHwYDVR0jBBgwFoAU
# 1fZWy4/oolxiaNE9lJBb186aGMQwVgYDVR0fBE8wTTBLoEmgR4ZFaHR0cDovL2Ny
# bC5taWNyb3NvZnQuY29tL3BraS9jcmwvcHJvZHVjdHMvTWljUm9vQ2VyQXV0XzIw
# MTAtMDYtMjMuY3JsMFoGCCsGAQUFBwEBBE4wTDBKBggrBgEFBQcwAoY+aHR0cDov
# L3d3dy5taWNyb3NvZnQuY29tL3BraS9jZXJ0cy9NaWNSb29DZXJBdXRfMjAxMC0w
# Ni0yMy5jcnQwDQYJKoZIhvcNAQELBQADggIBAJ1VffwqreEsH2cBMSRb4Z5yS/yp
# b+pcFLY+TkdkeLEGk5c9MTO1OdfCcTY/2mRsfNB1OW27DzHkwo/7bNGhlBgi7ulm
# ZzpTTd2YurYeeNg2LpypglYAA7AFvonoaeC6Ce5732pvvinLbtg/SHUB2RjebYIM
# 9W0jVOR4U3UkV7ndn/OOPcbzaN9l9qRWqveVtihVJ9AkvUCgvxm2EhIRXT0n4ECW
# OKz3+SmJw7wXsFSFQrP8DJ6LGYnn8AtqgcKBGUIZUnWKNsIdw2FzLixre24/LAl4
# FOmRsqlb30mjdAy87JGA0j3mSj5mO0+7hvoyGtmW9I/2kQH2zsZ0/fZMcm8Qq3Uw
# xTSwethQ/gpY3UA8x1RtnWN0SCyxTkctwRQEcb9k+SS+c23Kjgm9swFXSVRk2XPX
# fx5bRAGOWhmRaw2fpCjcZxkoJLo4S5pu+yFUa2pFEUep8beuyOiJXk+d0tBMdrVX
# VAmxaQFEfnyhYWxz/gq77EFmPWn9y8FBSX5+k77L+DvktxW/tM4+pTFRhLy/AsGC
# onsXHRWJjXD+57XQKBqJC4822rpM+Zv/Cuk0+CQ1ZyvgDbjmjJnW4SLq8CdCPSWU
# 5nR0W2rRnj7tfqAxM328y+l7vzhwRNGQ8cirOoo6CGJ/2XBjU02N7oJtpQUQwXEG
# ahC0HVUzWLOhcGbyoYIDVjCCAj4CAQEwggEBoYHZpIHWMIHTMQswCQYDVQQGEwJV
# UzETMBEGA1UECBMKV2FzaGluZ3RvbjEQMA4GA1UEBxMHUmVkbW9uZDEeMBwGA1UE
# ChMVTWljcm9zb2Z0IENvcnBvcmF0aW9uMS0wKwYDVQQLEyRNaWNyb3NvZnQgSXJl
# bGFuZCBPcGVyYXRpb25zIExpbWl0ZWQxJzAlBgNVBAsTHm5TaGllbGQgVFNTIEVT
# Tjo2QjA1LTA1RTAtRDk0NzElMCMGA1UEAxMcTWljcm9zb2Z0IFRpbWUtU3RhbXAg
# U2VydmljZaIjCgEBMAcGBSsOAwIaAxUAFU9eSpdxs0a06JFIuGFHIj/I+36ggYMw
# gYCkfjB8MQswCQYDVQQGEwJVUzETMBEGA1UECBMKV2FzaGluZ3RvbjEQMA4GA1UE
# BxMHUmVkbW9uZDEeMBwGA1UEChMVTWljcm9zb2Z0IENvcnBvcmF0aW9uMSYwJAYD
# VQQDEx1NaWNyb3NvZnQgVGltZS1TdGFtcCBQQ0EgMjAxMDANBgkqhkiG9w0BAQsF
# AAIFAOrhIVAwIhgPMjAyNDExMTUwMTI0MzJaGA8yMDI0MTExNjAxMjQzMlowdDA6
# BgorBgEEAYRZCgQBMSwwKjAKAgUA6uEhUAIBADAHAgEAAgIHfzAHAgEAAgISrTAK
# AgUA6uJy0AIBADA2BgorBgEEAYRZCgQCMSgwJjAMBgorBgEEAYRZCgMCoAowCAIB
# AAIDB6EgoQowCAIBAAIDAYagMA0GCSqGSIb3DQEBCwUAA4IBAQBTbkBhFc9MvyFg
# JPQ/gVjXa0sZY9a5hG7w5h4syED1GY+hkA07UER2GOpiBX3wsftspowb/B3xRW3B
# qQ1YAoTXMTCkYabGMAjrqFTrq+mfoa2keg7hpihlisKtXsYEuoKJbGlK7b+GUaFz
# m3nv7SCnH6aj/ySK9pJ0tdz/21JReBv/BTJHaYt1VVOQzWSybOIWlYcvFAu4kzuW
# Ir2YcoYyxoZOBRmYDKAL9wo5jLfqsaLxRsAMa2uRfO+hVtTMkACGeqtz7KbkX5r3
# Q2XPvzFv0fCUdZkTn4vNXgneqy6797WLQ+jHdVfuAwJ0AsP7mqYiAFEh3hS6DsVl
# 1ydMaTpXMYIEDTCCBAkCAQEwgZMwfDELMAkGA1UEBhMCVVMxEzARBgNVBAgTCldh
# c2hpbmd0b24xEDAOBgNVBAcTB1JlZG1vbmQxHjAcBgNVBAoTFU1pY3Jvc29mdCBD
# b3Jwb3JhdGlvbjEmMCQGA1UEAxMdTWljcm9zb2Z0IFRpbWUtU3RhbXAgUENBIDIw
# MTACEzMAAAH2gy8malRdIsEAAQAAAfYwDQYJYIZIAWUDBAIBBQCgggFKMBoGCSqG
# SIb3DQEJAzENBgsqhkiG9w0BCRABBDAvBgkqhkiG9w0BCQQxIgQguFhd17neBVqP
# oWIEe73Q4GWPEQfpY1Yp4ij+WPltjdgwgfoGCyqGSIb3DQEJEAIvMYHqMIHnMIHk
# MIG9BCArYUzxlF6m5USLS4f8NXL/8aoNEVdsCZRmF+LlQjG2ojCBmDCBgKR+MHwx
# CzAJBgNVBAYTAlVTMRMwEQYDVQQIEwpXYXNoaW5ndG9uMRAwDgYDVQQHEwdSZWRt
# b25kMR4wHAYDVQQKExVNaWNyb3NvZnQgQ29ycG9yYXRpb24xJjAkBgNVBAMTHU1p
# Y3Jvc29mdCBUaW1lLVN0YW1wIFBDQSAyMDEwAhMzAAAB9oMvJmpUXSLBAAEAAAH2
# MCIEIN2EggwP5A5HxiX1O+cML9AN+JCfIbv2rMbNiRLWanWqMA0GCSqGSIb3DQEB
# CwUABIICACoj/JV5T3Pg3vkFN0RVaICgBdeZq2xItrIG8bb0GOW2gvi42vsNZpt8
# 1rNlRcPp8jKa9voEL83/Dba2CydlfNqDLG1odCu1eEvj08WeRFGRz8jsoDDf6lMk
# xZlPmaS9YNuRFCYZOZPohCiMtlY/2/NmmmQUwgkueWaBxkdu0hAdRHOhD02SjPye
# HmO86DXoXhX07aFIpyemoD/yWjfBCKiKmYipnlJELaBlhLo6lOGne0jjzGDd7CQT
# H6TbzAI7mkqNNMQxUyLjCeK2FRnuXrrzADizzFk15YgRnLNF75IVgWjML1tzT0En
# JMag3Sm1L/c7FX0hnKRiqSTg3deLKgfyCsKf/hyl5WQeNDrT6kXciQNrIAw6gS95
# ijBuXlxCELKIobs5PVX4AwRoxaWiYhKBw2uM3IpFz+ja/ll3szwthnG9HIhxut0a
# Q5DusFUUZEI1Mz861IOPmZexNpGyDDdI3YwIhKpxElwAK/AkjdNcbnj0oPznBczu
# HVDvK8g7cKsh0Uz4NvDweSNZnkF4o4BPcMQTGWANxeEbDfDTwFnDLlTTUsEvaLjf
# NCYUOHcUw6R702Usoci7/3fcVo4sGNX2orH6xE+4qRZYvRkmiIk712ZGfb2aUQFO
# zvmxgUK2jo5OzszpDyMBh+P0fNY/hd8mQXGjyCFjoNSKQw2yGFol
# SIG # End signature block
