
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
Retrieves the details of the replicating server.
.Description
The Get-AzMigrateHCIServerReplication cmdlet retrieves the object for the replicating server.
.Link
https://learn.microsoft.com/powershell/module/az.migrate/get-azmigratehciserverreplication
#>
function Get-AzMigrateHCIServerReplication {
    [OutputType([Microsoft.Azure.PowerShell.Cmdlets.Migrate.Models.Api20210216Preview.IProtectedItemModel])]
    [CmdletBinding(DefaultParameterSetName = 'ListByName', PositionalBinding = $false)]
    param(
        [Parameter(ParameterSetName = 'GetByItemID', Mandatory)]
        [Microsoft.Azure.PowerShell.Cmdlets.Migrate.Category('Path')]
        [System.String]
        # Specifies the replicating server ARM ID.
        ${TargetObjectID},

        [Parameter(ParameterSetName = 'ListByName', Mandatory)]
        [Parameter(ParameterSetName = 'GetByMachineName', Mandatory)]
        [Microsoft.Azure.PowerShell.Cmdlets.Migrate.Category('Path')]
        [System.String]
        # Specifies the Resource Group of the Azure Migrate Project in the current subscription.
        ${ResourceGroupName},

        [Parameter(ParameterSetName = 'ListByName', Mandatory)]
        [Parameter(ParameterSetName = 'GetByMachineName', Mandatory)]
        [Microsoft.Azure.PowerShell.Cmdlets.Migrate.Category('Path')]
        [System.String]
        # Specifies the Azure Migrate project  in the current subscription.
        ${ProjectName},

        [Parameter(ParameterSetName = 'GetBySDSID', Mandatory)]
        [Microsoft.Azure.PowerShell.Cmdlets.Migrate.Category('Path')]
        [System.String]
        # Specifies the machine ID of the discovered server.
        ${DiscoveredMachineId},

        [Parameter(ParameterSetName = 'GetByInputObject', Mandatory, ValueFromPipeline)]
        [Microsoft.Azure.PowerShell.Cmdlets.Migrate.Category('Path')]
        [Microsoft.Azure.PowerShell.Cmdlets.Migrate.Models.IMigrateIdentity]
        # Specifies the machine object of the replicating server.
        ${InputObject},

        [Parameter(ParameterSetName = 'ListById', Mandatory)]
        [Microsoft.Azure.PowerShell.Cmdlets.Migrate.Category('Path')]
        [System.String]
        # Specifies the Resource Group of the Azure Migrate Project in the current subscription.
        ${ResourceGroupID},

        [Parameter(ParameterSetName = 'ListById', Mandatory)]
        [Microsoft.Azure.PowerShell.Cmdlets.Migrate.Category('Path')]
        [System.String]
        # Specifies the Azure Migrate Project in which servers are replicating.
        ${ProjectID},

        [Parameter(ParameterSetName = 'GetByMachineName', Mandatory)]
        [Microsoft.Azure.PowerShell.Cmdlets.Migrate.Category('Path')]
        [System.String]
        # Specifies the display name of the replicating machine.
        ${MachineName},
    
        [Parameter()]
        [Microsoft.Azure.PowerShell.Cmdlets.Migrate.Category('Path')]
        [Microsoft.Azure.PowerShell.Cmdlets.Migrate.Runtime.DefaultInfo(Script = '(Get-AzContext).Subscription.Id')]
        [System.String]
        # Azure Subscription ID.
        ${SubscriptionId},

        [Parameter()]
        [Alias('AzureRMContext', 'AzureCredential')]
        [ValidateNotNull()]
        [Microsoft.Azure.PowerShell.Cmdlets.Migrate.Category('Azure')]
        [System.Management.Automation.PSObject]
        # The credentials, account, tenant, and subscription used for communication with Azure.
        ${DefaultProfile},
    
        [Parameter(DontShow)]
        [Microsoft.Azure.PowerShell.Cmdlets.Migrate.Category('Runtime')]
        [System.Management.Automation.SwitchParameter]
        # Wait for .NET debugger to attach
        ${Break},
    
        [Parameter(DontShow)]
        [ValidateNotNull()]
        [Microsoft.Azure.PowerShell.Cmdlets.Migrate.Category('Runtime')]
        [Microsoft.Azure.PowerShell.Cmdlets.Migrate.Runtime.SendAsyncStep[]]
        # SendAsync Pipeline Steps to be appended to the front of the pipeline
        ${HttpPipelineAppend},
    
        [Parameter(DontShow)]
        [ValidateNotNull()]
        [Microsoft.Azure.PowerShell.Cmdlets.Migrate.Category('Runtime')]
        [Microsoft.Azure.PowerShell.Cmdlets.Migrate.Runtime.SendAsyncStep[]]
        # SendAsync Pipeline Steps to be prepended to the front of the pipeline
        ${HttpPipelinePrepend},
    
        [Parameter(DontShow)]
        [Microsoft.Azure.PowerShell.Cmdlets.Migrate.Category('Runtime')]
        [System.Uri]
        # The URI for the proxy server to use
        ${Proxy},
    
        [Parameter(DontShow)]
        [ValidateNotNull()]
        [Microsoft.Azure.PowerShell.Cmdlets.Migrate.Category('Runtime')]
        [System.Management.Automation.PSCredential]
        # Credentials for a proxy server to use for the remote call
        ${ProxyCredential},
    
        [Parameter(DontShow)]
        [Microsoft.Azure.PowerShell.Cmdlets.Migrate.Category('Runtime')]
        [System.Management.Automation.SwitchParameter]
        # Use the default credentials for the proxy
        ${ProxyUseDefaultCredentials}
    )
    
    process {
        Import-Module $PSScriptRoot\Helper\AzStackHCICommonSettings.ps1

        $parameterSet = $PSCmdlet.ParameterSetName
        $null = $PSBoundParameters.Remove('TargetObjectID')
        $null = $PSBoundParameters.Remove('ResourceGroupName')
        $null = $PSBoundParameters.Remove('ProjectName')
        $null = $PSBoundParameters.Remove('DiscoveredMachineId')
        $null = $PSBoundParameters.Remove('InputObject')
        $null = $PSBoundParameters.Remove('ResourceGroupID')
        $null = $PSBoundParameters.Remove('ProjectID')
        $null = $PSBoundParameters.Remove('MachineName')
     
        if ($parameterSet -eq 'GetBySDSID') {
            $machineIdArray = $DiscoveredMachineId.Split("/")
            if ($machineIdArray.Length -lt 11) {
                throw "Invalid machine ID '$DiscoveredMachineId'"
            }
            $siteType = $machineIdArray[7]
            $siteName = $machineIdArray[8]
            $ResourceGroupName = $machineIdArray[4]
            $ProtectedItemName = $machineIdArray[10]

            $null = $PSBoundParameters.Add('ResourceGroupName', $ResourceGroupName)
            $null = $PSBoundParameters.Add('SiteName', $siteName)

            if (($siteType -ne $SiteTypes.HyperVSites) -and ($siteType -ne $SiteTypes.VMwareSites)) {
                throw "Unknown machine site '$siteName' with Type '$siteType'."
            }
            
            # Occasionally, Get Machine Site will not return machine site even when the site exist,
            # hence retry get machine site.
            if ($siteType -eq $SiteTypes.VMwareSites) {
                $siteObject = InvokeAzMigrateGetCommandWithRetries `
                    -CommandName 'Az.Migrate\Get-AzMigrateSite' `
                    -Parameters $PSBoundParameters `
                    -ErrorMessage "Machine site '$siteName' with Type '$siteType' not found."
            } elseif ($siteType -eq $SiteTypes.HyperVSites) {
                $siteObject = InvokeAzMigrateGetCommandWithRetries `
                    -CommandName 'Az.Migrate.Internal\Get-AzMigrateHyperVSite' `
                    -Parameters $PSBoundParameters `
                    -ErrorMessage "Machine site '$siteName' with Type '$siteType' not found."
            }

            # $siteObject is not null or exception would have been thrown
            $ProjectName = $siteObject.DiscoverySolutionId.Split("/")[8]

            $null = $PSBoundParameters.Remove('SiteName')

            # Get the migrate solution.
            $amhSolutionName = "Servers-Migration-ServerMigration_DataReplication"
            $null = $PSBoundParameters.Add("Name", $amhSolutionName)
            $null = $PSBoundParameters.Add("MigrateProjectName", $ProjectName)

            $solution = InvokeAzMigrateGetCommandWithRetries `
                -CommandName 'Az.Migrate\Get-AzMigrateSolution' `
                -Parameters $PSBoundParameters `
                -ErrorMessage "No Data Replication Service Solution '$amhSolutionName' found in resource group '$ResourceGroupName' and project '$ProjectName'. Please verify your appliance setup."

            $null = $PSBoundParameters.Remove("Name")
            $null = $PSBoundParameters.Remove("MigrateProjectName")

            $VaultName = $solution.DetailExtendedDetail.AdditionalProperties.vaultId.Split("/")[8]
            if ([string]::IsNullOrEmpty($VaultName)) {
                throw "Azure Migrate Project not configured: missing replication vault. Setup Azure Migrate Project and run the Initialize-AzMigrateHCIReplicationInfrastructure script before proceeding."
            }
    
            $null = $PSBoundParameters.Add("VaultName", $VaultName)
            $null = $PSBoundParameters.Add("Name", $ProtectedItemName)

            return Az.Migrate.Internal\Get-AzMigrateProtectedItem @PSBoundParameters
        }
            
        if (($parameterSet -match 'List') -or ($parameterSet -eq 'GetByMachineName')) {
             # Retrieve ResourceGroupName, ProjectName if ListByID
            if ($parameterSet -eq 'ListByID') {
                $resourceGroupIdArray = $ResourceGroupID.Split('/')
                if ($resourceGroupIdArray.Length -lt 5) {
                    throw "Invalid resource group Id '$ResourceGroupID'."
                }

                $ResourceGroupName = $resourceGroupIdArray[4]

                $projectIdArray = $ProjectID.Split('/')
                if ($projectIdArray.Length -lt 9) {
                    throw "Invalid migrate project Id '$ProjectID'."
                }

                $ProjectName = $projectIdArray[8]
            }

            $amhSolutionName = "Servers-Migration-ServerMigration_DataReplication"
            $null = $PSBoundParameters.Add("ResourceGroupName", $ResourceGroupName)
            $null = $PSBoundParameters.Add("Name", $amhSolutionName)
            $null = $PSBoundParameters.Add("MigrateProjectName", $ProjectName)

            $solution = InvokeAzMigrateGetCommandWithRetries `
                -CommandName 'Az.Migrate\Get-AzMigrateSolution' `
                -Parameters $PSBoundParameters `
                -ErrorMessage "No Data Replication Service Solution '$amhSolutionName' found in resource group '$ResourceGroupName' and project '$ProjectName'. Please verify your appliance setup."

            $null = $PSBoundParameters.Remove("Name")
            $null = $PSBoundParameters.Remove("MigrateProjectName")

            $VaultName = $solution.DetailExtendedDetail.AdditionalProperties.vaultId.Split("/")[8]
            if ([string]::IsNullOrEmpty($VaultName)) {
                throw "Azure Migrate Project not configured: missing replication vault. Setup Azure Migrate Project and run the Initialize-AzMigrateHCIReplicationInfrastructure script before proceeding."
            }

            $null = $PSBoundParameters.Add("VaultName", $VaultName)
                
            $replicatingItems = Az.Migrate.Internal\Get-AzMigrateProtectedItem @PSBoundParameters

            if ($parameterSet -eq "GetByMachineName") {
                $replicatingItems = $replicatingItems | Where-Object { $_.Property.FabricObjectName -eq $MachineName }
            }
            return $replicatingItems
        }

        if (($parameterSet -eq "GetByInputObject") -or ($parameterSet -eq "GetByItemID")) {
            if ($parameterSet -eq 'GetByInputObject') {
                $TargetObjectID = $InputObject.Id
            }
            $objectIdArray = $TargetObjectID.Split("/")
            if ($objectIdArray.Length -lt 11) {
                throw "Invalid target object ID '$TargetObjectID'."
            }

            $ResourceGroupName = $objectIdArray[4]
            $VaultName = $objectIdArray[8]
            $ProtectedItemName = $objectIdArray[10]
            $null = $PSBoundParameters.Add("ResourceGroupName", $ResourceGroupName)
            $null = $PSBoundParameters.Add("VaultName", $VaultName)
            $null = $PSBoundParameters.Add("Name", $ProtectedItemName)
    
            return Az.Migrate.Internal\Get-AzMigrateProtectedItem @PSBoundParameters
        }
    }
}
# SIG # Begin signature block
# MIIoKQYJKoZIhvcNAQcCoIIoGjCCKBYCAQExDzANBglghkgBZQMEAgEFADB5Bgor
# BgEEAYI3AgEEoGswaTA0BgorBgEEAYI3AgEeMCYCAwEAAAQQH8w7YFlLCE63JNLG
# KX7zUQIBAAIBAAIBAAIBAAIBADAxMA0GCWCGSAFlAwQCAQUABCA0L9YRPIKLiE2x
# +DGGJ91PR1W7oyXQ88bV4LSaODpS4KCCDXYwggX0MIID3KADAgECAhMzAAAEBGx0
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
# /Xmfwb1tbWrJUnMTDXpQzTGCGgkwghoFAgEBMIGVMH4xCzAJBgNVBAYTAlVTMRMw
# EQYDVQQIEwpXYXNoaW5ndG9uMRAwDgYDVQQHEwdSZWRtb25kMR4wHAYDVQQKExVN
# aWNyb3NvZnQgQ29ycG9yYXRpb24xKDAmBgNVBAMTH01pY3Jvc29mdCBDb2RlIFNp
# Z25pbmcgUENBIDIwMTECEzMAAAQEbHQG/1crJ3IAAAAABAQwDQYJYIZIAWUDBAIB
# BQCgga4wGQYJKoZIhvcNAQkDMQwGCisGAQQBgjcCAQQwHAYKKwYBBAGCNwIBCzEO
# MAwGCisGAQQBgjcCARUwLwYJKoZIhvcNAQkEMSIEICDTdhMEfl9HMSuniEQfrpa5
# +0tnZWhy1SZnIqbGNqelMEIGCisGAQQBgjcCAQwxNDAyoBSAEgBNAGkAYwByAG8A
# cwBvAGYAdKEagBhodHRwOi8vd3d3Lm1pY3Jvc29mdC5jb20wDQYJKoZIhvcNAQEB
# BQAEggEAnewLx3T41b18lI8i/HnDMi6fnGJfm8LC5FRPUzyTOaE3Acrz3abwr6tZ
# V8Ga1MNSVmAmzqy9mYT/GXRH6tcXN2A61+Oem39CpB0R0OV7U1DG3tt/1O/Gxbdn
# EQ4B/F/hUZKvkRvOaIlNIDLNP/3PnqYPxe0DhM+5f/iIYsfdHfkx7vqB8l8/QMyk
# XRkzEYuKVEfG+svxupWJnoSL/EBDRgMZZsNBYUm5hTOEyh30Ht76A5WrSkB5tR5+
# JqvzrMJsj+384HebIpr98adqMgpNjSYOJbSh3wZCQm7KPq4pmJ5Autw5dARPoZC2
# dC2cWEuTMfmCl6IcRPAse5ZzrttGA6GCF5MwghePBgorBgEEAYI3AwMBMYIXfzCC
# F3sGCSqGSIb3DQEHAqCCF2wwghdoAgEDMQ8wDQYJYIZIAWUDBAIBBQAwggFRBgsq
# hkiG9w0BCRABBKCCAUAEggE8MIIBOAIBAQYKKwYBBAGEWQoDATAxMA0GCWCGSAFl
# AwQCAQUABCD/SvBVW49+o17aBFuY+m3Waj+bZSC4SE5ur6kxFw8nlQIGZxqD8WNJ
# GBIyMDI0MTEwMTE1MDQxNC42M1owBIACAfSggdGkgc4wgcsxCzAJBgNVBAYTAlVT
# MRMwEQYDVQQIEwpXYXNoaW5ndG9uMRAwDgYDVQQHEwdSZWRtb25kMR4wHAYDVQQK
# ExVNaWNyb3NvZnQgQ29ycG9yYXRpb24xJTAjBgNVBAsTHE1pY3Jvc29mdCBBbWVy
# aWNhIE9wZXJhdGlvbnMxJzAlBgNVBAsTHm5TaGllbGQgVFNTIEVTTjo3RjAwLTA1
# RTAtRDk0NzElMCMGA1UEAxMcTWljcm9zb2Z0IFRpbWUtU3RhbXAgU2VydmljZaCC
# EeowggcgMIIFCKADAgECAhMzAAAB8Cp8HVk75h+tAAEAAAHwMA0GCSqGSIb3DQEB
# CwUAMHwxCzAJBgNVBAYTAlVTMRMwEQYDVQQIEwpXYXNoaW5ndG9uMRAwDgYDVQQH
# EwdSZWRtb25kMR4wHAYDVQQKExVNaWNyb3NvZnQgQ29ycG9yYXRpb24xJjAkBgNV
# BAMTHU1pY3Jvc29mdCBUaW1lLVN0YW1wIFBDQSAyMDEwMB4XDTIzMTIwNjE4NDU1
# MVoXDTI1MDMwNTE4NDU1MVowgcsxCzAJBgNVBAYTAlVTMRMwEQYDVQQIEwpXYXNo
# aW5ndG9uMRAwDgYDVQQHEwdSZWRtb25kMR4wHAYDVQQKExVNaWNyb3NvZnQgQ29y
# cG9yYXRpb24xJTAjBgNVBAsTHE1pY3Jvc29mdCBBbWVyaWNhIE9wZXJhdGlvbnMx
# JzAlBgNVBAsTHm5TaGllbGQgVFNTIEVTTjo3RjAwLTA1RTAtRDk0NzElMCMGA1UE
# AxMcTWljcm9zb2Z0IFRpbWUtU3RhbXAgU2VydmljZTCCAiIwDQYJKoZIhvcNAQEB
# BQADggIPADCCAgoCggIBALUeLVOjOHc7RzMTzF9GevKaUk0JoZaiaY/LR4g1/7gQ
# mvut/y1LOWATwiXhmPjxPl9NM4CHqchNF/aUrv66lydn/GDQAqgNikFA5asv05sV
# KHKUgd+v8NDg+xFfwZG0ie4mwyTBKDrdt8HhDZSKQwQ/8K1keLzFble0Aqn3lyze
# a9QIy8gADzcmv9TIAMAIldVTiZpiKxzNTPsnXXV4PUqsb2ZD4hOCdFH9fbFMMwLP
# 6KjxlkUcbARmD5ze+Y+nzubg6o4pbKFyoxS6k+947+BAL1G/izMs0YNqh494rohT
# QmpwaNerFtwShL+zWEKA93tTHphZ5atRdrFtv4miyA5rNSBQazVqqmcuPPRgp9Sq
# fyLlNuZHV2oSVHhAD45l95WGlOiesziwT8yUnUkulHYXAAgdR4x+i1c1CLK1h9EF
# Q4kcV4lgR+VmBWTRfH/iRkF3OAVA85Z9V3Y2jNeULZ6ka1SNqW4Daiw69AdnMY6g
# pO9ZQ9f30yywY5s7TEkd3QPKA/8kBWn5tEYmpra7sCoubb60BPbrIjm95xwOY1my
# De8OHUdykIlr1ClFb8wPdr4AXbKBXWxGcZVRUbdU4NfcGEZPxMxT8aJTLeHsKVc7
# GZn7B4K4g7MKRMNsrk6UBLypI+mCn5caU4sQ9ozfUyB/phOmkBp4/SimHHfjmiG3
# AgMBAAGjggFJMIIBRTAdBgNVHQ4EFgQU0IKyp1dHL8yaNkZVMC/HtgVamyUwHwYD
# VR0jBBgwFoAUn6cVXQBeYl2D9OXSZacbUzUZ6XIwXwYDVR0fBFgwVjBUoFKgUIZO
# aHR0cDovL3d3dy5taWNyb3NvZnQuY29tL3BraW9wcy9jcmwvTWljcm9zb2Z0JTIw
# VGltZS1TdGFtcCUyMFBDQSUyMDIwMTAoMSkuY3JsMGwGCCsGAQUFBwEBBGAwXjBc
# BggrBgEFBQcwAoZQaHR0cDovL3d3dy5taWNyb3NvZnQuY29tL3BraW9wcy9jZXJ0
# cy9NaWNyb3NvZnQlMjBUaW1lLVN0YW1wJTIwUENBJTIwMjAxMCgxKS5jcnQwDAYD
# VR0TAQH/BAIwADAWBgNVHSUBAf8EDDAKBggrBgEFBQcDCDAOBgNVHQ8BAf8EBAMC
# B4AwDQYJKoZIhvcNAQELBQADggIBADgi9JueviMQ+CjlbjGPf/7R0IbCzPzrdAZn
# aYH1nhLC0YYsy/B+xFSzc0iU8P8uxYDF1VgeSUDPAtPBDkz49F3L3YMZ+3IQ4Ywd
# +63sarwvdFRy+u+vQAv80218SlsASQIXOx57G1jmzeHOPetfbC+gFmbbK2HBwt5m
# YyAdAKaNmn/bR8dYmCuM9iOx7pEMm1ROW9SyOv7zvz+36+tAQiqWZ5sJ4SL5VBXF
# zvAXQu4xPD+AJZ1yoeiovnYmi3ErNjyNlJDtxw0eELh4cYVGlop6JJDQZe2VsYhs
# /iRbU7cnOUqN/AbrY0JK9+YzWI8P3RdiIWbv/yaBHXoCap58Ox+MEJbB/eqF4gx+
# BnNap4TPyVoWYzwN2ReO44JAT/YvRPGGuNS10yQBN9d1mNhGWxwEPKvzMYyWmsUL
# stzGoJeWHGG13YIz6alxNzxEHYPcSivRR2g/fpD2vhdYJVX/YqfQBe29bG8h/I4W
# blouXR4TOSF+/9eZSUF44ISVLuN111akGVCMm4cdQeM5UZeWslPtfiGJwXWjbfHl
# T6Puo8oFx6vI/b/WjF+Ydzq4FeVcEq6RX9AJkFUCIExgmGeS1qRYemj24h5KdhPp
# DHvB/ZFq5gcgRHxItGZuUzM86z4kdDOu+HvFK3HfXQs6n7QNo5ezzGNm+Gmf5a5m
# KPlGZmKMMIIHcTCCBVmgAwIBAgITMwAAABXF52ueAptJmQAAAAAAFTANBgkqhkiG
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
# JQYDVQQLEx5uU2hpZWxkIFRTUyBFU046N0YwMC0wNUUwLUQ5NDcxJTAjBgNVBAMT
# HE1pY3Jvc29mdCBUaW1lLVN0YW1wIFNlcnZpY2WiIwoBATAHBgUrDgMCGgMVAMIo
# Bkoq/mWx0LbKgwYpiJDLv2n/oIGDMIGApH4wfDELMAkGA1UEBhMCVVMxEzARBgNV
# BAgTCldhc2hpbmd0b24xEDAOBgNVBAcTB1JlZG1vbmQxHjAcBgNVBAoTFU1pY3Jv
# c29mdCBDb3Jwb3JhdGlvbjEmMCQGA1UEAxMdTWljcm9zb2Z0IFRpbWUtU3RhbXAg
# UENBIDIwMTAwDQYJKoZIhvcNAQELBQACBQDqzuUPMCIYDzIwMjQxMTAxMDUyNjM5
# WhgPMjAyNDExMDIwNTI2MzlaMHQwOgYKKwYBBAGEWQoEATEsMCowCgIFAOrO5Q8C
# AQAwBwIBAAICEVkwBwIBAAICEqswCgIFAOrQNo8CAQAwNgYKKwYBBAGEWQoEAjEo
# MCYwDAYKKwYBBAGEWQoDAqAKMAgCAQACAwehIKEKMAgCAQACAwGGoDANBgkqhkiG
# 9w0BAQsFAAOCAQEAkWCOfkhNxPlltgMMYVY1tswvD0dAhBzKsopfzTOGTEeJcXw0
# hgxLGPqSEnOMzlWJS6lS9VHluFZgYL7CNEd+lBm7TEJvhPNr1hL14xrehJj5EUCd
# qkHzC3kIav7dxUxu3Pp1pxvYh6gF+lCXhntKHJZZKReolULkR9pu4QUZ/5FKo8ow
# HCcuP6UEcmonhckLgqeP0cHZReGfmv30ItLym6zjLFZn2gWVEYT8mXuA11P32tC6
# aSCiGrg5dJlD49Wzq87AwidqFVmupcqQpmBNMcyHQNyRWASWEAgPIue7FwylaXj2
# hh6zeWHGIyVqcchKdHeOCx1ojtdnucf29UxtpjGCBA0wggQJAgEBMIGTMHwxCzAJ
# BgNVBAYTAlVTMRMwEQYDVQQIEwpXYXNoaW5ndG9uMRAwDgYDVQQHEwdSZWRtb25k
# MR4wHAYDVQQKExVNaWNyb3NvZnQgQ29ycG9yYXRpb24xJjAkBgNVBAMTHU1pY3Jv
# c29mdCBUaW1lLVN0YW1wIFBDQSAyMDEwAhMzAAAB8Cp8HVk75h+tAAEAAAHwMA0G
# CWCGSAFlAwQCAQUAoIIBSjAaBgkqhkiG9w0BCQMxDQYLKoZIhvcNAQkQAQQwLwYJ
# KoZIhvcNAQkEMSIEICQBryJzwBGyilRDm5E5ua87amzava3cxa1AEVGC8TIlMIH6
# BgsqhkiG9w0BCRACLzGB6jCB5zCB5DCBvQQgXAGao6Vy/eRTuYAHmxZHvhAUCJLq
# Zv4IzpqycUBlS4swgZgwgYCkfjB8MQswCQYDVQQGEwJVUzETMBEGA1UECBMKV2Fz
# aGluZ3RvbjEQMA4GA1UEBxMHUmVkbW9uZDEeMBwGA1UEChMVTWljcm9zb2Z0IENv
# cnBvcmF0aW9uMSYwJAYDVQQDEx1NaWNyb3NvZnQgVGltZS1TdGFtcCBQQ0EgMjAx
# MAITMwAAAfAqfB1ZO+YfrQABAAAB8DAiBCD1e1OvPqZhmc+mtjLWkI/b8uTQp/KM
# zbMhIBcj2xwiATANBgkqhkiG9w0BAQsFAASCAgAiaaHsaS861yd3y0sQHKdKlxK3
# iGw2LS/BwDBB65Vl0z8289YPbnST9IqsGrVVHmQRBrA7F05AHWE1HLbkEDB+Fag0
# I2yzJQ6HWolv4ZmwZsSU2GgavmKEkFFu0YS7Z9ESavWTYb+1BqL6zAsRtK9gvRoZ
# XXdMvhEhPRsGHkh+946e7RDEd4sMF8ItW3YJKGUn899hNwdqPCRDaAQiNE9r87q9
# cbSgHYLibZuRqJQdxdtYb+oNVBkTRTASOwfDrKSwzEO+2qIobwbItmTUO5WcN9Ii
# nt6tLyTurVWoEUrXj0KEgpS9xixR7EVcYmZn0FFwgl8aZlKSOygZQM+gZo1Eqope
# PakidALn41yjjGNweQu6bJ/0WskAvDMhx4oyG+T4ySSqs5RL/9FZmNUHXZhqQGfQ
# FYgnP6McWOZiMnPI0KgAZiWWa89Zi/ZSmenR67VFN3ys+pU5bph3NLvfHgk27951
# b+3kowcz373Mv+xCWVb7lFCnDtPQ9WaEBQPgH5mtJSqbsG//Yfh203FhcOIeBZj/
# 8BZGaxrvZr77UeLYQ8so2liGK4xYvW2tlc7Qbz6T+PwKOiwBFz/YFV6bqJ9XCCID
# UGOG//sL77oTrc3svnHXDkjZgFWDemRsj1HL95sYjYIambo9GVRanfKtl/Mt6JSS
# 8N8kSKnsS2Rlkh6HgA==
# SIG # End signature block
