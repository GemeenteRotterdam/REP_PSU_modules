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
Creates an EventHub Namespace
.Description
Creates an EventHub Namespace
#>

function New-AzEventHubNamespace{
    [Alias("New-AzEventHubNamespaceV2")]
    [OutputType([Microsoft.Azure.PowerShell.Cmdlets.EventHub.Models.IEhNamespace])]
    [CmdletBinding(PositionalBinding = $false, SupportsShouldProcess, ConfirmImpact = 'Medium')]
    param(

        [Parameter(Mandatory, HelpMessage = "The name of EventHub namespace.")]
        [Microsoft.Azure.PowerShell.Cmdlets.EventHub.Category('Path')]
        [System.String]
        # The name of EventHub namespace
        ${Name},

        [Parameter(Mandatory, HelpMessage = "The name of the resource group. The name is case insensitive.")]
        [Microsoft.Azure.PowerShell.Cmdlets.EventHub.Category('Path')]
        [System.String]
        # The name of the resource group.
        # The name is case insensitive.
        ${ResourceGroupName},

        [Parameter(HelpMessage = "The ID of the target subscription.")]
        [Microsoft.Azure.PowerShell.Cmdlets.EventHub.Category('Path')]
        [Microsoft.Azure.PowerShell.Cmdlets.EventHub.Runtime.DefaultInfo(Script = '(Get-AzContext).Subscription.Id')]
        [System.String]
        # The ID of the target subscription.
        ${SubscriptionId},

        [Parameter(HelpMessage = "Alternate name specified when alias and namespace names are same")]
        [Microsoft.Azure.PowerShell.Cmdlets.EventHub.Category('Body')]
        [System.String]
        ${AlternateName},

        [Parameter(HelpMessage = "Cluster ARM ID of the Namespace.")]
        [Microsoft.Azure.PowerShell.Cmdlets.EventHub.Category('Body')]
        [System.String]
        ${ClusterArmId},

        [Parameter(HelpMessage = "This property disables SAS authentication for the Event Hubs namespace.")]
        [Microsoft.Azure.PowerShell.Cmdlets.EventHub.Category('Body')]
        [System.Management.Automation.SwitchParameter]
        ${DisableLocalAuth},

        [Parameter(HelpMessage = "Enable Infrastructure Encryption (Double Encryption)")]
        [Microsoft.Azure.PowerShell.Cmdlets.EventHub.Category('Body')]
        [System.Management.Automation.SwitchParameter]
        ${RequireInfrastructureEncryption},

        [Parameter(Mandatory, HelpMessage = "Cluster ARM ID of the Namespace.")]
        [Microsoft.Azure.PowerShell.Cmdlets.EventHub.Category('Body')]
        [System.String]
        ${Location},

        [Parameter(HelpMessage = "Enabling this property creates a Standard Event Hubs Namespace in regions supported availability zones.")]
        [Microsoft.Azure.PowerShell.Cmdlets.EventHub.Category('Body')]
        [System.Management.Automation.SwitchParameter]
        ${ZoneRedundant},

        [Parameter(HelpMessage = "Properties to configure Encryption")]
        [Microsoft.Azure.PowerShell.Cmdlets.EventHub.Category('Body')]
        [Microsoft.Azure.PowerShell.Cmdlets.EventHub.Models.IKeyVaultProperties[]]
        ${KeyVaultProperty},

        [Parameter(HelpMessage = "Type of managed service identity.")]
        [Microsoft.Azure.PowerShell.Cmdlets.EventHub.Category('Body')]
        [System.String]
        ${IdentityType},

        [Parameter(HelpMessage = "Properties for User Assigned Identities")]
        [Microsoft.Azure.PowerShell.Cmdlets.EventHub.Category('Body')]
        [System.String[]]
        # IdentityId
        ${UserAssignedIdentityId},

        [Parameter(HelpMessage = "Value that indicates whether AutoInflate is enabled for eventhub namespace.")]
        [Microsoft.Azure.PowerShell.Cmdlets.EventHub.Category('Body')]
        [System.Management.Automation.SwitchParameter]
        ${EnableAutoInflate},

        [Parameter(HelpMessage = "Upper limit of throughput units when AutoInflate is enabled, value should be within 0 to 20 throughput units. ( '0' if AutoInflateEnabled = true)")]
        [Microsoft.Azure.PowerShell.Cmdlets.EventHub.Category('Body')]
        [System.Int64]
        ${MaximumThroughputUnit},

        [Parameter(HelpMessage = "The minimum TLS version for the cluster to support, e.g. '1.2'")]
        [Microsoft.Azure.PowerShell.Cmdlets.EventHub.Category('Body')]
        [System.String]
        ${MinimumTlsVersion},

        [Parameter(HelpMessage = "The minimum TLS version for the cluster to support, e.g. '1.2'")]
        [Microsoft.Azure.PowerShell.Cmdlets.EventHub.Category('Body')]
        [System.String]
        ${SkuName},

        [Parameter(HelpMessage = "This determines if traffic is allowed over public network. By default it is enabled.")]
        [Microsoft.Azure.PowerShell.Cmdlets.EventHub.Category('Body')]
        [System.String]
        ${PublicNetworkAccess},

        [Parameter(HelpMessage = "The Event Hubs throughput units for Basic or Standard tiers, where value should be 0 to 20 throughput units. The Event Hubs premium units for Premium tier, where value should be 0 to 10 premium units.")]
        [Microsoft.Azure.PowerShell.Cmdlets.EventHub.Category('Body')]
        [System.Int64]
        ${SkuCapacity},

        [Parameter(HelpMessage = "Tag of EventHub Namespace.")]
        [Microsoft.Azure.PowerShell.Cmdlets.EventHub.Category('Body')]
        [System.Collections.Hashtable]
        ${Tag},

        [Parameter(HelpMessage = "The credentials, account, tenant, and subscription used for communication with Azure.")]
        [Alias('AzureRMContext', 'AzureCredential')]
        [ValidateNotNull()]
        [Microsoft.Azure.PowerShell.Cmdlets.EventHub.Category('Azure')]
        [System.Management.Automation.PSObject]
        ${DefaultProfile},

        [Parameter(HelpMessage = "Run the command as a job")]
        [Microsoft.Azure.PowerShell.Cmdlets.EventHub.Category('Runtime')]
        [System.Management.Automation.SwitchParameter]
        # Run the command as a job
        ${AsJob},

        [Parameter(DontShow)]
        [Microsoft.Azure.PowerShell.Cmdlets.EventHub.Category('Runtime')]
        [System.Management.Automation.SwitchParameter]
        # Wait for .NET debugger to attach
        ${Break},

        [Parameter(DontShow)]
        [ValidateNotNull()]
        [Microsoft.Azure.PowerShell.Cmdlets.EventHub.Category('Runtime')]
        [Microsoft.Azure.PowerShell.Cmdlets.EventHub.Runtime.SendAsyncStep[]]
        # SendAsync Pipeline Steps to be appended to the front of the pipeline
        ${HttpPipelineAppend},

        [Parameter(DontShow)]
        [ValidateNotNull()]
        [Microsoft.Azure.PowerShell.Cmdlets.EventHub.Category('Runtime')]
        [Microsoft.Azure.PowerShell.Cmdlets.EventHub.Runtime.SendAsyncStep[]]
        # SendAsync Pipeline Steps to be prepended to the front of the pipeline
        ${HttpPipelinePrepend},

        [Parameter(DontShow)]
        [Microsoft.Azure.PowerShell.Cmdlets.EventHub.Category('Runtime')]
        [System.Management.Automation.SwitchParameter]
        # Run the command asynchronously
        ${NoWait},

        [Parameter(DontShow)]
        [Microsoft.Azure.PowerShell.Cmdlets.EventHub.Category('Runtime')]
        [System.Uri]
        # The URI for the proxy server to use
        ${Proxy},

        [Parameter(DontShow)]
        [ValidateNotNull()]
        [Microsoft.Azure.PowerShell.Cmdlets.EventHub.Category('Runtime')]
        [System.Management.Automation.PSCredential]
        # Credentials for a proxy server to use for the remote call
        ${ProxyCredential},

        [Parameter(DontShow)]
        [Microsoft.Azure.PowerShell.Cmdlets.EventHub.Category('Runtime')]
        [System.Management.Automation.SwitchParameter]
        # Use the default credentials for the proxy
        ${ProxyUseDefaultCredentials}
    )
    process{
        try{
       	    $null = $PSBoundParameters.Remove('WhatIf')
            $null = $PSBoundParameters.Remove('Confirm')
            if($PSBoundParameters.ContainsKey('SkuName')){
                $PSBoundParameters.Add('SkuTier', $SkuName)
            }

            if($PSBoundParameters.ContainsKey('KeyVaultProperty')){
                $PSBoundParameters.Add('KeySource', 'Microsoft.KeyVault')
            }
            
            if($PSBoundParameters.ContainsKey('UserAssignedIdentityId')){
                $identityHashTable = @{}

                foreach ($resourceID in $UserAssignedIdentityId){
                    $identityHashTable.Add($resourceID, [Microsoft.Azure.PowerShell.Cmdlets.EventHub.Models.UserAssignedIdentity]::new())
                }

                $PSBoundParameters.Add("UserAssignedIdentity", $identityHashTable)
                $null = $PSBoundParameters.Remove("UserAssignedIdentityId")
            }
            if ($PSCmdlet.ShouldProcess("EventHub Namespace $($Name)", "Create or update")) {
                Az.EventHub.private\New-AzEventHubNamespace_CreateExpanded @PSBoundParameters
            }
	}
	catch{
	    throw
	}
    }
}

# SIG # Begin signature block
# MIIoRgYJKoZIhvcNAQcCoIIoNzCCKDMCAQExDzANBglghkgBZQMEAgEFADB5Bgor
# BgEEAYI3AgEEoGswaTA0BgorBgEEAYI3AgEeMCYCAwEAAAQQH8w7YFlLCE63JNLG
# KX7zUQIBAAIBAAIBAAIBAAIBADAxMA0GCWCGSAFlAwQCAQUABCBaG1LUm4xI9mvX
# ea8GtXRk2x5wjlFI7uNWFjMaZUy00qCCDXYwggX0MIID3KADAgECAhMzAAAEBGx0
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
# /Xmfwb1tbWrJUnMTDXpQzTGCGiYwghoiAgEBMIGVMH4xCzAJBgNVBAYTAlVTMRMw
# EQYDVQQIEwpXYXNoaW5ndG9uMRAwDgYDVQQHEwdSZWRtb25kMR4wHAYDVQQKExVN
# aWNyb3NvZnQgQ29ycG9yYXRpb24xKDAmBgNVBAMTH01pY3Jvc29mdCBDb2RlIFNp
# Z25pbmcgUENBIDIwMTECEzMAAAQEbHQG/1crJ3IAAAAABAQwDQYJYIZIAWUDBAIB
# BQCgga4wGQYJKoZIhvcNAQkDMQwGCisGAQQBgjcCAQQwHAYKKwYBBAGCNwIBCzEO
# MAwGCisGAQQBgjcCARUwLwYJKoZIhvcNAQkEMSIEIHUP/rAuw1fSxVthg8GI7egJ
# IB/Jt4HFMAW64n8Pb1uDMEIGCisGAQQBgjcCAQwxNDAyoBSAEgBNAGkAYwByAG8A
# cwBvAGYAdKEagBhodHRwOi8vd3d3Lm1pY3Jvc29mdC5jb20wDQYJKoZIhvcNAQEB
# BQAEggEAY5PbMSWNXGdVn0qpnZ1I37kahfT+MuBEg924Mp00L2L21Sus/sQwCuPN
# w9Gmt26FG17sdDujtzXnng+0eyqKpqa5Xq/QyWtqhbVven0U9hhdI3CoiurvYvbC
# Lvpy9UBWEhiAnU9uVHkOFmocUdh0mFsijnIIw3evjG+gHZ/+rZ+N5q5K/AGZ9Q6G
# Td6aJEikZ4mie28fAu7wHo+UL/Jw5rvMJJQ2JI/euxBgHT98+s0A86ouBOB5Z35O
# uFbADHkUQ1YVPyuW0BjUtEIzKOnG+b1TA4vkM4GQfkWs0uxKwZDk1lMlWPRLXYsj
# iWox3uIjrfVGDDPBjC1qz5x8kJKyhqGCF7AwghesBgorBgEEAYI3AwMBMYIXnDCC
# F5gGCSqGSIb3DQEHAqCCF4kwgheFAgEDMQ8wDQYJYIZIAWUDBAIBBQAwggFaBgsq
# hkiG9w0BCRABBKCCAUkEggFFMIIBQQIBAQYKKwYBBAGEWQoDATAxMA0GCWCGSAFl
# AwQCAQUABCDO0rhSYZ6GTcQt+SI80ILBqIqar0AznSKPWeS3OupOOQIGZutLmdoq
# GBMyMDI0MTEwMTE1MDQxNy43OTJaMASAAgH0oIHZpIHWMIHTMQswCQYDVQQGEwJV
# UzETMBEGA1UECBMKV2FzaGluZ3RvbjEQMA4GA1UEBxMHUmVkbW9uZDEeMBwGA1UE
# ChMVTWljcm9zb2Z0IENvcnBvcmF0aW9uMS0wKwYDVQQLEyRNaWNyb3NvZnQgSXJl
# bGFuZCBPcGVyYXRpb25zIExpbWl0ZWQxJzAlBgNVBAsTHm5TaGllbGQgVFNTIEVT
# Tjo0QzFBLTA1RTAtRDk0NzElMCMGA1UEAxMcTWljcm9zb2Z0IFRpbWUtU3RhbXAg
# U2VydmljZaCCEf4wggcoMIIFEKADAgECAhMzAAAB/xI4fPfBZdahAAEAAAH/MA0G
# CSqGSIb3DQEBCwUAMHwxCzAJBgNVBAYTAlVTMRMwEQYDVQQIEwpXYXNoaW5ndG9u
# MRAwDgYDVQQHEwdSZWRtb25kMR4wHAYDVQQKExVNaWNyb3NvZnQgQ29ycG9yYXRp
# b24xJjAkBgNVBAMTHU1pY3Jvc29mdCBUaW1lLVN0YW1wIFBDQSAyMDEwMB4XDTI0
# MDcyNTE4MzExOVoXDTI1MTAyMjE4MzExOVowgdMxCzAJBgNVBAYTAlVTMRMwEQYD
# VQQIEwpXYXNoaW5ndG9uMRAwDgYDVQQHEwdSZWRtb25kMR4wHAYDVQQKExVNaWNy
# b3NvZnQgQ29ycG9yYXRpb24xLTArBgNVBAsTJE1pY3Jvc29mdCBJcmVsYW5kIE9w
# ZXJhdGlvbnMgTGltaXRlZDEnMCUGA1UECxMeblNoaWVsZCBUU1MgRVNOOjRDMUEt
# MDVFMC1EOTQ3MSUwIwYDVQQDExxNaWNyb3NvZnQgVGltZS1TdGFtcCBTZXJ2aWNl
# MIICIjANBgkqhkiG9w0BAQEFAAOCAg8AMIICCgKCAgEAyeiV0pB7bg8/qc/mkiDd
# JXnzJWPYgk9mTGeI3pzQpsyrRJREWcKYHd/9db+g3z4dU4VCkAZEXqvkxP5QNTtB
# G5Ipexpph4PhbiJKwvX+US4KkSFhf1wflDAY1tu9CQqhhxfHFV7vhtmqHLCCmDxh
# ZPmCBh9/XfFJQIUwVZR8RtUkgzmN9bmWiYgfX0R+bDAnncUdtp1xjGmCpdBMygk/
# K0h3bUTUzQHb4kPf2ylkKPoWFYn2GNYgWw8PGBUO0vTMKjYD6pLeBP0hZDh5P3f4
# xhGLm6x98xuIQp/RFnzBbgthySXGl+NT1cZAqGyEhT7L0SdR7qQlv5pwDNerbK3Y
# SEDKk3sDh9S60hLJNqP71iHKkG175HAyg6zmE5p3fONr9/fIEpPAlC8YisxXaGX4
# RpDBYVKpGj0FCZwisiZsxm0X9w6ZSk8OOXf8JxTYWIqfRuWzdUir0Z3jiOOtaDq7
# XdypB4gZrhr90KcPTDRwvy60zrQca/1D1J7PQJAJObbiaboi12usV8axtlT/dCeP
# C4ndcFcar1v+fnClhs9u3Fn6LkHDRZfNzhXgLDEwb6dA4y3s6G+gQ35o90j2i6am
# aa8JsV/cCF+iDSGzAxZY1sQ1mrdMmzxfWzXN6sPJMy49tdsWTIgZWVOSS9uUHhSY
# kbgMxnLeiKXeB5MB9QMcOScCAwEAAaOCAUkwggFFMB0GA1UdDgQWBBTD+pXk/rT/
# d7E/0QE7hH0wz+6UYTAfBgNVHSMEGDAWgBSfpxVdAF5iXYP05dJlpxtTNRnpcjBf
# BgNVHR8EWDBWMFSgUqBQhk5odHRwOi8vd3d3Lm1pY3Jvc29mdC5jb20vcGtpb3Bz
# L2NybC9NaWNyb3NvZnQlMjBUaW1lLVN0YW1wJTIwUENBJTIwMjAxMCgxKS5jcmww
# bAYIKwYBBQUHAQEEYDBeMFwGCCsGAQUFBzAChlBodHRwOi8vd3d3Lm1pY3Jvc29m
# dC5jb20vcGtpb3BzL2NlcnRzL01pY3Jvc29mdCUyMFRpbWUtU3RhbXAlMjBQQ0El
# MjAyMDEwKDEpLmNydDAMBgNVHRMBAf8EAjAAMBYGA1UdJQEB/wQMMAoGCCsGAQUF
# BwMIMA4GA1UdDwEB/wQEAwIHgDANBgkqhkiG9w0BAQsFAAOCAgEAOSNN5MpLiyun
# m866frWIi0hdazKNLgRp3WZPfhYgPC3K/DNMzLliYQUAp6WtgolIrativXjOG1lI
# jayG9r6ew4H1n5XZdDfJ12DLjopap5e1iU/Yk0eutPyfOievfbsIzTk/G51+uiUJ
# k772nVzau6hI2KGyGBJOvAbAVFR0g8ppZwLghT4z3mkGZjq/O4Z/PcmVGtjGps2T
# CtI4rZjPNW8O4c/4aJRmYQ/NdW91JRrOXRpyXrTKUPe3kN8N56jpl9kotLhdvd89
# RbOsJNf2XzqbAV7XjV4caCglA2btzDxcyffwXhLu9HMU3dLYTAI91gTNUF7BA9q1
# EvSlCKKlN8N10Y4iU0nyIkfpRxYyAbRyq5QPYPJHGA0Ty0PD83aCt79Ra0IdDIMS
# uwXlpUnyIyxwrDylgfOGyysWBwQ/js249bqQOYPdpyOdgRe8tXdGrgDoBeuVOK+c
# RClXpimNYwr61oZ2/kPMzVrzRUYMkBXe9WqdSezh8tytuulYYcRK95qihF0irQs6
# /WOQJltQX79lzFXE9FFln9Mix0as+C4HPzd+S0bBN3A3XRROwAv016ICuT8hY1In
# yW7jwVmN+OkQ1zei66LrU5RtAz0nTxx5OePyjnTaItTSY4OGuGU1SXaH49JSP3t8
# yGYA/vorbW4VneeD721FgwaJToHFkOIwggdxMIIFWaADAgECAhMzAAAAFcXna54C
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
# ahC0HVUzWLOhcGbyoYIDWTCCAkECAQEwggEBoYHZpIHWMIHTMQswCQYDVQQGEwJV
# UzETMBEGA1UECBMKV2FzaGluZ3RvbjEQMA4GA1UEBxMHUmVkbW9uZDEeMBwGA1UE
# ChMVTWljcm9zb2Z0IENvcnBvcmF0aW9uMS0wKwYDVQQLEyRNaWNyb3NvZnQgSXJl
# bGFuZCBPcGVyYXRpb25zIExpbWl0ZWQxJzAlBgNVBAsTHm5TaGllbGQgVFNTIEVT
# Tjo0QzFBLTA1RTAtRDk0NzElMCMGA1UEAxMcTWljcm9zb2Z0IFRpbWUtU3RhbXAg
# U2VydmljZaIjCgEBMAcGBSsOAwIaAxUAqROMbMS8JcUlcnPkwRLFRPXFspmggYMw
# gYCkfjB8MQswCQYDVQQGEwJVUzETMBEGA1UECBMKV2FzaGluZ3RvbjEQMA4GA1UE
# BxMHUmVkbW9uZDEeMBwGA1UEChMVTWljcm9zb2Z0IENvcnBvcmF0aW9uMSYwJAYD
# VQQDEx1NaWNyb3NvZnQgVGltZS1TdGFtcCBQQ0EgMjAxMDANBgkqhkiG9w0BAQsF
# AAIFAOrPIGYwIhgPMjAyNDExMDEwOTM5NTBaGA8yMDI0MTEwMjA5Mzk1MFowdzA9
# BgorBgEEAYRZCgQBMS8wLTAKAgUA6s8gZgIBADAKAgEAAgIKgwIB/zAHAgEAAgIT
# 3zAKAgUA6tBx5gIBADA2BgorBgEEAYRZCgQCMSgwJjAMBgorBgEEAYRZCgMCoAow
# CAIBAAIDB6EgoQowCAIBAAIDAYagMA0GCSqGSIb3DQEBCwUAA4IBAQAuYU3H7a33
# ou58AvZ0z4HvLcemQLwxPPn4h6CVfat0kQkHq+yAVTXss74oBO/DZhEeGaObeYD1
# +FZpkpxCkxFdQ+8qonoJojyo7N6Y6U4EmRGs1rhZ5W7O6yX1Q72pzrYMw6v0sK0N
# 6iWS3gM/ORVdf+S1V9I+ff9r0KF6/a6qnUbU99+A4Igx94OPtJdgUM5C4UO3XbUc
# +WcUjkF/nMxspxY4AFDqrRbcrlOg55uSLfFY50Fv4F+4pEFSplgk6sXboUnN8dLO
# Ui3Q2xZyly7glGA+DPtWvuAfRFDuRQT+gwmZo9jTxV0U3TF2QE5gH4B0f+BOPjX+
# +4RzlD/Mr6B9MYIEDTCCBAkCAQEwgZMwfDELMAkGA1UEBhMCVVMxEzARBgNVBAgT
# Cldhc2hpbmd0b24xEDAOBgNVBAcTB1JlZG1vbmQxHjAcBgNVBAoTFU1pY3Jvc29m
# dCBDb3Jwb3JhdGlvbjEmMCQGA1UEAxMdTWljcm9zb2Z0IFRpbWUtU3RhbXAgUENB
# IDIwMTACEzMAAAH/Ejh898Fl1qEAAQAAAf8wDQYJYIZIAWUDBAIBBQCgggFKMBoG
# CSqGSIb3DQEJAzENBgsqhkiG9w0BCRABBDAvBgkqhkiG9w0BCQQxIgQgJ2NObZro
# 4RjUe+x6XouioBs5vT/znwckexfn4VC4YrEwgfoGCyqGSIb3DQEJEAIvMYHqMIHn
# MIHkMIG9BCDkMu++yQJ3aaycIuMT6vA7JNuMaVOI3qDjSEV8upyn/TCBmDCBgKR+
# MHwxCzAJBgNVBAYTAlVTMRMwEQYDVQQIEwpXYXNoaW5ndG9uMRAwDgYDVQQHEwdS
# ZWRtb25kMR4wHAYDVQQKExVNaWNyb3NvZnQgQ29ycG9yYXRpb24xJjAkBgNVBAMT
# HU1pY3Jvc29mdCBUaW1lLVN0YW1wIFBDQSAyMDEwAhMzAAAB/xI4fPfBZdahAAEA
# AAH/MCIEIO99frcwzwzykdioANSJqUY/DIiJLoKUz9B+UIEwjfnKMA0GCSqGSIb3
# DQEBCwUABIICAFL1r+/YsV5yw0BNIocbIbcM/3D/XJw1VdRUJ354FrNw8Flx9e8e
# JzxwymyLE4O5yqOELH3SvnYYYAJCWJHG2roD6AjCPxUiVGcghXQFQT470GScpCTV
# FeE2ftbK+B/I4pNy3LMEAJ7GGttQFEfe9uUzUiyzEcqDrSbj4SMf3sjKIFvJHVDq
# QmFQJdR0HuETUT0MZQRXKBc4XicsR8TlI0EHrWQ+jIUHghkoBgnbtzsdQUfLpeCK
# jl4JAPe69rzOJOAz7w0IHl/u9dHz6Dj/1kyf+cNdv4i6l20XsG1h291JK7A/ql56
# bYkLh65B8rZE+CAJveGNC0VyOpIQxz94gytIdOGsdgFrcVUHpoNriutTdpT4WNG4
# /QMRHVatEstS5nX2DdWJslkmmRa0Y+Dv/T9Pniq3zSrp916EDmyhCPSevY8BcRo0
# Iu/rIBx932w4Z6ghRXhMr3v4I1NKP2YrgA6IG6Pqa82f0Ap16NojPZ9pqJjGHqv0
# yCf3xsuxJKbTYPhMnzxDih2LoayD9ZNF1buc+3HlEO4JdMdp69gdvS6F2IKSBBqs
# DJaudtfRigEyZVzDB2x9Ep2HhZcMaeAlO/w+S7JjUFyVh2aZp1y/l5wOts780ztn
# GQlby1vzUjqNHQtraozCnnUBTcnZKuYRdVwVUh3gC5V/t9Y3fvX8zzpl
# SIG # End signature block
