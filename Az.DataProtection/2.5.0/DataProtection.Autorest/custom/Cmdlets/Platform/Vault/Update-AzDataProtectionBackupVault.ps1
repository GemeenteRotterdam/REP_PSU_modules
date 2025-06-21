function Update-AzDataProtectionBackupVault
{
	[OutputType('Microsoft.Azure.PowerShell.Cmdlets.DataProtection.Models.Api20240401.IBackupVaultResource')]
    [CmdletBinding(DefaultParameterSetName="UpdateExpanded", PositionalBinding=$false, SupportsShouldProcess)]
    [Microsoft.Azure.PowerShell.Cmdlets.DataProtection.Description('Updates a BackupVault resource belonging to a resource group. For example updating tags for a resource.')]

    param(
        [Parameter(ParameterSetName="UpdateExpanded",Mandatory=$false, HelpMessage='The ID of the target subscription. The value must be an UUID.')]
        [System.String]
        ${SubscriptionId},

        [Parameter(ParameterSetName="UpdateExpanded",Mandatory, HelpMessage='The name of the resource group. The name is case insensitive.')]
        [System.String]
        ${ResourceGroupName},

        [Parameter(ParameterSetName="UpdateExpanded",Mandatory, HelpMessage='The name of the backup vault.')]
        [System.String]
        ${VaultName},

        [Parameter(ParameterSetName="UpdateExpanded",HelpMessage='The identityType which can take values: "SystemAssigned", "UserAssigned", "SystemAssigned,UserAssigned", "None"')]
        [System.String]
        ${IdentityType},

        [Parameter(ParameterSetName="UpdateExpanded",Mandatory=$false, HelpMessage='Parameter to Enable or Disable built-in azure monitor alerts for job failures. Security alerts cannot be disabled.')]
        [Microsoft.Azure.PowerShell.Cmdlets.DataProtection.Support.AlertsState]
        [ValidateSet('Enabled','Disabled')]
        ${AzureMonitorAlertsForAllJobFailure},

        [Parameter(ParameterSetName="UpdateExpanded",Mandatory=$false, HelpMessage='Immutability state of the vault. Allowed values are Disabled, Unlocked, Locked.')]
        [Microsoft.Azure.PowerShell.Cmdlets.DataProtection.Support.ImmutabilityState]
        [ValidateSet('Disabled','Unlocked', 'Locked')]
        ${ImmutabilityState},

        [Parameter(ParameterSetName="UpdateExpanded",Mandatory=$false, HelpMessage='Cross region restore state of the vault. Allowed values are Disabled, Enabled.')]
        [Microsoft.Azure.PowerShell.Cmdlets.DataProtection.Support.CrossRegionRestoreState]
        [ValidateSet('Disabled','Enabled')]
        ${CrossRegionRestoreState},
        
        [Parameter(ParameterSetName="UpdateExpanded",Mandatory=$false, HelpMessage='Cross subscription restore state of the vault. Allowed values are Disabled, Enabled, PermanentlyDisabled.')]
        [Microsoft.Azure.PowerShell.Cmdlets.DataProtection.Support.CrossSubscriptionRestoreState]
        [ValidateSet('Disabled','Enabled', 'PermanentlyDisabled')]
        ${CrossSubscriptionRestoreState},
        
        [Parameter(ParameterSetName="UpdateExpanded",Mandatory=$false, HelpMessage='Soft delete retention duration in days')]
        [System.Double]
        ${SoftDeleteRetentionDurationInDay},

        [Parameter(ParameterSetName="UpdateExpanded",Mandatory=$false, HelpMessage='Soft delete state of the vault. Allowed values are Off, On, AlwaysOn')]
        [Microsoft.Azure.PowerShell.Cmdlets.DataProtection.Support.SoftDeleteState]
        [ValidateSet('Off','On', 'AlwaysOn')]  
        ${SoftDeleteState},

        [Parameter(ParameterSetName="UpdateExpanded",HelpMessage='Resource tags.')]
        [System.Collections.Hashtable]
        ${Tag},

        [Parameter(ParameterSetName="UpdateExpanded",Mandatory=$false, HelpMessage='Gets or sets the user assigned identities.')]
        [Alias('UserAssignedIdentity')]
        [System.Collections.Hashtable]
        ${IdentityUserAssignedIdentity},

        [Parameter(ParameterSetName="UpdateExpanded",Mandatory=$false, HelpMessage='Enable CMK encryption state for a Backup Vault.')]
        [Microsoft.Azure.PowerShell.Cmdlets.DataProtection.Support.EncryptionState]
        ${CmkEncryptionState},

        [Parameter(ParameterSetName="UpdateExpanded",Mandatory=$false, HelpMessage='The identity type to be used for CMK encryption - SystemAssigned or UserAssigned Identity.')]
        [Microsoft.Azure.PowerShell.Cmdlets.DataProtection.Support.IdentityType]
        ${CmkIdentityType},

        [Parameter(ParameterSetName="UpdateExpanded",Mandatory=$false, HelpMessage='This parameter is required if the identity type is UserAssigned. Add the user assigned managed identity id to be used which has access permissions to the Key Vault.')]
        [System.String]
        ${CmkUserAssignedIdentityId},

        [Parameter(ParameterSetName="UpdateExpanded",Mandatory=$false, HelpMessage='The Key URI of the CMK key to be used for encryption. To enable auto-rotation of keys, exclude the version component from the Key URI. ')]
        [System.String]
        ${CmkEncryptionKeyUri},
        
        [Parameter(ParameterSetName="UpdateExpanded", Mandatory=$false, HelpMessage='Resource guard operation request in the format similar to <ResourceGuard-ARMID>/operationName/default. Here operationName can be any of dppReduceImmutabilityStateRequests, dppReduceSoftDeleteSecurityRequests, dppModifyEncryptionSettingsRequests. Use this parameter when the operation is MUA protected.')]
        [System.String[]]
        ${ResourceGuardOperationRequest},

        [Parameter(Mandatory=$false, HelpMessage='Parameter to authorize operations protected by cross tenant resource guard. Use command (Get-AzAccessToken -TenantId "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx -AsSecureString").Token to fetch secure authorization token for different tenant and then convert to string using ConvertFrom-SecureString cmdlet.')]
        [System.String]
        ${Token},

        [Parameter(Mandatory=$false, HelpMessage='Parameter to authorize operations protected by cross tenant resource guard. Use command (Get-AzAccessToken -TenantId "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx -AsSecureString").Token to fetch authorization token for different tenant.')]
        [System.Security.SecureString]
        ${SecureToken},

        [Parameter(HelpMessage='The DefaultProfile parameter is not functional. Use the SubscriptionId parameter when available if executing the cmdlet against a different subscription.')]
        [Alias('AzureRMContext', 'AzureCredential')]
        [ValidateNotNull()]
        [System.Management.Automation.PSObject]
        # The credentials, account, tenant, and subscription used for communication with Azure.
        ${DefaultProfile},
            
        [Parameter(HelpMessage='Run the command as a job')]
        [System.Management.Automation.SwitchParameter]
        # Run the command as a job
        ${AsJob},
    
        [Parameter(DontShow)]
        [System.Management.Automation.SwitchParameter]
        # Wait for .NET debugger to attach
        ${Break},
    
        [Parameter(DontShow)]
        [ValidateNotNull()]
        [Microsoft.Azure.PowerShell.Cmdlets.DataProtection.Runtime.SendAsyncStep[]]
        # SendAsync Pipeline Steps to be appended to the front of the pipeline
        ${HttpPipelineAppend},
    
        [Parameter(DontShow)]
        [ValidateNotNull()]
        [Microsoft.Azure.PowerShell.Cmdlets.DataProtection.Runtime.SendAsyncStep[]]
        # SendAsync Pipeline Steps to be prepended to the front of the pipeline
        ${HttpPipelinePrepend},
    
        [Parameter(DontShow)]
        [System.Uri]
        # The URI for the proxy server to use
        ${Proxy},

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        # Run the command asynchronously
        ${NoWait},
    
        [Parameter(DontShow)]
        [ValidateNotNull()]
        [System.Management.Automation.PSCredential]
        # Credentials for a proxy server to use for the remote call
        ${ProxyCredential},
    
        [Parameter(DontShow)]
        [System.Management.Automation.SwitchParameter]
        # Use the default credentials for the proxy
        ${ProxyUseDefaultCredentials}

    )

    process
    {
        $hasToken = $PSBoundParameters.Remove("Token")
        $hasSecureToken = $PSBoundParameters.Remove("SecureToken")
        if($hasToken -or $hasSecureToken)
        {   
            if($hasSecureToken -and $hasToken){
                throw "Both Token and SecureToken parameters cannot be provided together"
            }
            elseif($hasToken){
                Write-Warning -Message 'The Token parameter is deprecated and will be removed in future versions. Please use SecureToken instead.'
                $null = $PSBoundParameters.Add("Token", "Bearer $Token")
            }
            else{
                $plainToken = UnprotectSecureString -SecureString $SecureToken
                $null = $PSBoundParameters.Add("Token", "Bearer $plainToken")
            }
        }

        $hasCmkEncryptionState = $PSBoundParameters.Remove("CmkEncryptionState")
        $hasCmkIdentityType = $PSBoundParameters.Remove("CmkIdentityType")
        $hasCmkUserAssignedIdentityId = $PSBoundParameters.Remove("CmkUserAssignedIdentityId")
        $hasCmkEncryptionKeyUri = $PSBoundParameters.Remove("CmkEncryptionKeyUri")

        if (-not $hasCmkEncryptionState -and -not $hasCmkIdentityType -and -not $hasCmkUserAssignedIdentityId -and -not $hasCmkEncryptionKeyUri) {
            Az.DataProtection.Internal\Update-AzDataProtectionBackupVault @PSBoundParameters
            return
        }

        $hasIdentityType = $PSBoundParameters.Remove("IdentityType")
        $hasAzureMonitorAlertsForAllJobFailure = $PSBoundParameters.Remove("AzureMonitorAlertsForAllJobFailure")
        $hasImmutabilityState = $PSBoundParameters.Remove("ImmutabilityState")
        $hasCrossRegionRestoreState = $PSBoundParameters.Remove("CrossRegionRestoreState")
        $hasCrossSubscriptionRestoreState = $PSBoundParameters.Remove("CrossSubscriptionRestoreState")
        $hasSoftDeleteRetentionDurationInDay = $PSBoundParameters.Remove("SoftDeleteRetentionDurationInDay")
        $hasSoftDeleteState = $PSBoundParameters.Remove("SoftDeleteState")
        $hasTag = $PSBoundParameters.Remove("Tag")
        $hasUserAssignedIdentity = $PSBoundParameters.Remove("UserAssignedIdentity")

        $vault = Az.DataProtection\Get-AzDataProtectionBackupVault @PSBoundParameters

        $encryptionSettings = $null

        if ($vault.EncryptionSetting -ne $null) { $encryptionSettings = $vault.EncryptionSetting }
        else { 
            $encryptionSettings = [Microsoft.Azure.PowerShell.Cmdlets.DataProtection.Models.Api20240401.EncryptionSettings]::new()
            $encryptionSettings.CmkIdentity = [Microsoft.Azure.PowerShell.Cmdlets.DataProtection.Models.Api20240401.CmkKekIdentity]::new()
            $encryptionSettings.CmkKeyVaultProperty = [Microsoft.Azure.PowerShell.Cmdlets.DataProtection.Models.Api20240401.CmkKeyVaultProperties]::new()
        }

        if ($hasCmkEncryptionState) { $encryptionSettings.State = $CmkEncryptionState }
        if ($hasCmkIdentityType) { 
            $encryptionSettings.CmkIdentity.IdentityType = $CmkIdentityType 
            if ( $CmkIdentityType -eq "SystemAssigned" ) {
                $encryptionSettings.CmkIdentity.IdentityId = $null
            }
        }
        if ($hasCmkUserAssignedIdentityId) { $encryptionSettings.CmkIdentity.IdentityId = $CmkUserAssignedIdentityId }
        if ($hasCmkEncryptionKeyUri) { $encryptionSettings.CmkKeyVaultProperty.KeyUri = $CmkEncryptionKeyUri }

        $PSBoundParameters.Add("EncryptionSetting", $encryptionSettings)

        if ($hasIdentityType) { $PSBoundParameters.Add("IdentityType", $IdentityType) }
        if ($hasAzureMonitorAlertsForAllJobFailure) { $PSBoundParameters.Add("AzureMonitorAlertsForAllJobFailure", $AzureMonitorAlertsForAllJobFailure) }
        if ($hasImmutabilityState) { $PSBoundParameters.Add("ImmutabilityState", $ImmutabilityState) }
        if ($hasCrossRegionRestoreState) { $PSBoundParameters.Add("CrossRegionRestoreState", $CrossRegionRestoreState) }
        if ($hasCrossSubscriptionRestoreState) { $PSBoundParameters.Add("CrossSubscriptionRestoreState", $CrossSubscriptionRestoreState) }
        if ($hasSoftDeleteRetentionDurationInDay) { $PSBoundParameters.Add("SoftDeleteRetentionDurationInDay", $SoftDeleteRetentionDurationInDay) }
        if ($hasSoftDeleteState) { $PSBoundParameters.Add("SoftDeleteState", $SoftDeleteState) }
        if ($hasTag) { $PSBoundParameters.Add("Tag", $Tag) }
        if ($hasUserAssignedIdentity) { $PSBoundParameters.Add("UserAssignedIdentity", $UserAssignedIdentity) }

        Az.DataProtection.Internal\Update-AzDataProtectionBackupVault @PSBoundParameters
    }
}
# SIG # Begin signature block
# MIIoLAYJKoZIhvcNAQcCoIIoHTCCKBkCAQExDzANBglghkgBZQMEAgEFADB5Bgor
# BgEEAYI3AgEEoGswaTA0BgorBgEEAYI3AgEeMCYCAwEAAAQQH8w7YFlLCE63JNLG
# KX7zUQIBAAIBAAIBAAIBAAIBADAxMA0GCWCGSAFlAwQCAQUABCAV91FNftDIvtR1
# jF4qHm33B/P94jh0K2YL+9rNro/JKqCCDXYwggX0MIID3KADAgECAhMzAAAEBGx0
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
# /Xmfwb1tbWrJUnMTDXpQzTGCGgwwghoIAgEBMIGVMH4xCzAJBgNVBAYTAlVTMRMw
# EQYDVQQIEwpXYXNoaW5ndG9uMRAwDgYDVQQHEwdSZWRtb25kMR4wHAYDVQQKExVN
# aWNyb3NvZnQgQ29ycG9yYXRpb24xKDAmBgNVBAMTH01pY3Jvc29mdCBDb2RlIFNp
# Z25pbmcgUENBIDIwMTECEzMAAAQEbHQG/1crJ3IAAAAABAQwDQYJYIZIAWUDBAIB
# BQCgga4wGQYJKoZIhvcNAQkDMQwGCisGAQQBgjcCAQQwHAYKKwYBBAGCNwIBCzEO
# MAwGCisGAQQBgjcCARUwLwYJKoZIhvcNAQkEMSIEIIR/j1X5F4E3k0nWB90OMJuH
# eV/TvByUqhGEqb66BjOhMEIGCisGAQQBgjcCAQwxNDAyoBSAEgBNAGkAYwByAG8A
# cwBvAGYAdKEagBhodHRwOi8vd3d3Lm1pY3Jvc29mdC5jb20wDQYJKoZIhvcNAQEB
# BQAEggEAOso7uoOtiN3eoIIShVu61Pjovd5MW85wu8p8LXc1HatlTMWU2SCqYrUW
# 5PPwvfWT6CVmwS9zFToyfxWy9qQJntIcUMT2yixUdCUATI0MlSQF6WIqZDG2tPxS
# XonYPOm5DYXGQIjtUQosNAaX/BLmB5i/Ze941ihSbuhwEY+2ftB9KMA/SN1Lco14
# kniYnKF4T6QaP/gjUhNWDD00yNUzynI/1Ia47C9CyhF3zJajhmH6tsaq+zTxsPhM
# 0lwclrJ3KTjyNBxXIO/XfbC7meC+SPFq12UOKJ0VSY4adwRgZ3S3X8t/aNoxtWwb
# gCAhemVdeFW+00O+LI0yOM03BnLUGqGCF5YwgheSBgorBgEEAYI3AwMBMYIXgjCC
# F34GCSqGSIb3DQEHAqCCF28wghdrAgEDMQ8wDQYJYIZIAWUDBAIBBQAwggFRBgsq
# hkiG9w0BCRABBKCCAUAEggE8MIIBOAIBAQYKKwYBBAGEWQoDATAxMA0GCWCGSAFl
# AwQCAQUABCB6KZBmWXUd/Qap2zmU4ld9UtdkgEmCtyumwk+Emc/cGQIGZxqHAhu3
# GBIyMDI0MTEwMTE1MDQxMi43M1owBIACAfSggdGkgc4wgcsxCzAJBgNVBAYTAlVT
# MRMwEQYDVQQIEwpXYXNoaW5ndG9uMRAwDgYDVQQHEwdSZWRtb25kMR4wHAYDVQQK
# ExVNaWNyb3NvZnQgQ29ycG9yYXRpb24xJTAjBgNVBAsTHE1pY3Jvc29mdCBBbWVy
# aWNhIE9wZXJhdGlvbnMxJzAlBgNVBAsTHm5TaGllbGQgVFNTIEVTTjo4OTAwLTA1
# RTAtRDk0NzElMCMGA1UEAxMcTWljcm9zb2Z0IFRpbWUtU3RhbXAgU2VydmljZaCC
# Ee0wggcgMIIFCKADAgECAhMzAAAB7eFfy9X3pV1zAAEAAAHtMA0GCSqGSIb3DQEB
# CwUAMHwxCzAJBgNVBAYTAlVTMRMwEQYDVQQIEwpXYXNoaW5ndG9uMRAwDgYDVQQH
# EwdSZWRtb25kMR4wHAYDVQQKExVNaWNyb3NvZnQgQ29ycG9yYXRpb24xJjAkBgNV
# BAMTHU1pY3Jvc29mdCBUaW1lLVN0YW1wIFBDQSAyMDEwMB4XDTIzMTIwNjE4NDU0
# MVoXDTI1MDMwNTE4NDU0MVowgcsxCzAJBgNVBAYTAlVTMRMwEQYDVQQIEwpXYXNo
# aW5ndG9uMRAwDgYDVQQHEwdSZWRtb25kMR4wHAYDVQQKExVNaWNyb3NvZnQgQ29y
# cG9yYXRpb24xJTAjBgNVBAsTHE1pY3Jvc29mdCBBbWVyaWNhIE9wZXJhdGlvbnMx
# JzAlBgNVBAsTHm5TaGllbGQgVFNTIEVTTjo4OTAwLTA1RTAtRDk0NzElMCMGA1UE
# AxMcTWljcm9zb2Z0IFRpbWUtU3RhbXAgU2VydmljZTCCAiIwDQYJKoZIhvcNAQEB
# BQADggIPADCCAgoCggIBAKgwwmySuupqnJwvE8LUfvMPuDzw2lsRpDpKNxMhFvMJ
# XJhA2zPxNovWmoVMQA8vVfuiMvj8RoRb5SM2pmz9rIzJbhgikU9k/bHgUExUJ12x
# 4XaL5owyMMeLQtxNBnEzazeYUysJkBZJ8thdgMiKYUHPyPSgtYbLdWAuYFMozjEu
# q/sNlTPwHZKgCZsS2nraeBKXSE6g3vdIXAT5jbhK8ZAxaHKSkb69cPByla/AN75O
# CestHsBNEVc3klLbp2bbLLpJgUxFicwTd0wcJD9RAhBA0LycuYi90qQChYQxe0mw
# YSjdCszZLZIG/g+kdHNG6TNO0/5QBx4bEz0nKvBRA/k4ISZbphyETJENLA/iFT1/
# sHQDKHXg/D28mjuN7A2N4w8iSad7ItKLSu6/ajH/FEa1wn3IE0LkFpGS2PPuy09q
# iNH48MDZ+4G0KjzEqWS3neZRvsBj4JkceqEubvql0wXoEe/ZO/CVUF5BE3bZeNpV
# VHAKCOAmc17C3s96NyulSfSocuAur7UE3UPNi6RaROvvBPTOXSJev422pSRZI6dZ
# F97w3bW0Hq6/dWRbycV0KG1ttlnPbil4u0kRm42s3xd/09M8zNlcMkEjURyJH/3V
# BwahkWZVsVVvatQgCzTX5mR7C9uGYZUN59f2hkbj8riAZSxO9Nb6vUlkzFRPYzCp
# AgMBAAGjggFJMIIBRTAdBgNVHQ4EFgQUzhvw7PfeECoER8qUBl/Q0qHgIhkwHwYD
# VR0jBBgwFoAUn6cVXQBeYl2D9OXSZacbUzUZ6XIwXwYDVR0fBFgwVjBUoFKgUIZO
# aHR0cDovL3d3dy5taWNyb3NvZnQuY29tL3BraW9wcy9jcmwvTWljcm9zb2Z0JTIw
# VGltZS1TdGFtcCUyMFBDQSUyMDIwMTAoMSkuY3JsMGwGCCsGAQUFBwEBBGAwXjBc
# BggrBgEFBQcwAoZQaHR0cDovL3d3dy5taWNyb3NvZnQuY29tL3BraW9wcy9jZXJ0
# cy9NaWNyb3NvZnQlMjBUaW1lLVN0YW1wJTIwUENBJTIwMjAxMCgxKS5jcnQwDAYD
# VR0TAQH/BAIwADAWBgNVHSUBAf8EDDAKBggrBgEFBQcDCDAOBgNVHQ8BAf8EBAMC
# B4AwDQYJKoZIhvcNAQELBQADggIBAJ3WArZF354YvR4eL6ITr+oNjyxtuw7h6Zqd
# ynoo837GrlkBq2IFHiOZFGGb71WKTQWjQMtaL83bxsUjt1djDT2ne8KKluPLgSiJ
# +bQ253v/hTfSL37tG9btc5DevHfv5Tu+r2WTrJikYI2nSOUnXzz8K5E+Comd+rkR
# 15p8fYCgbjqEpZN4HsO5dqwa3qykk56cZ51Kt7fgxZmp5MhDSto4i1mcW4YPLj7G
# gPWpHPZBb67aAIdobwBCOFhQzi5OL23qS22PpztdqavbOta5x4OHPuwou20tMnvC
# zlisDYjxxOVswB/YpbQZWMptgZ34tkZ24Qrv/t+zgZSQypznUWw10bWf7OBzvMe7
# agYZ4IGDizxlHRkXLHuOyCb2xIUIpDkKxsC+Wv/rQ12TlN4xHwmzaQ1SJy7YKpnT
# fzfdOy9OCTuIPUouB9LXocS+M3qbhUokqCMns4knNpu1LglCBScmshl/KiyTgPXy
# tmeL2lTA3TdaBOZ3XRZPCJk67iDxSfqIpw8xj+IWpO7ie2TMVTEEGlsUbqTUIg1m
# aiKsRaYK0beXJnYh12aO0h59OQi8ZZvgnHPPuXab8TaQY6LEMkexqFlWbCyg2+HL
# mS7+KdT751cfPD6GW+pNIVPz2sgVWFyaxY8Mk81FJKkyGgnfdXZlr+WQpxuRQzRJ
# tCBL2qx3MIIHcTCCBVmgAwIBAgITMwAAABXF52ueAptJmQAAAAAAFTANBgkqhkiG
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
# e784cETRkPHIqzqKOghif9lwY1NNje6CbaUFEMFxBmoQtB1VM1izoXBm8qGCA1Aw
# ggI4AgEBMIH5oYHRpIHOMIHLMQswCQYDVQQGEwJVUzETMBEGA1UECBMKV2FzaGlu
# Z3RvbjEQMA4GA1UEBxMHUmVkbW9uZDEeMBwGA1UEChMVTWljcm9zb2Z0IENvcnBv
# cmF0aW9uMSUwIwYDVQQLExxNaWNyb3NvZnQgQW1lcmljYSBPcGVyYXRpb25zMScw
# JQYDVQQLEx5uU2hpZWxkIFRTUyBFU046ODkwMC0wNUUwLUQ5NDcxJTAjBgNVBAMT
# HE1pY3Jvc29mdCBUaW1lLVN0YW1wIFNlcnZpY2WiIwoBATAHBgUrDgMCGgMVAO4d
# rIpMJpixjEmH6hZPHq5U8XD5oIGDMIGApH4wfDELMAkGA1UEBhMCVVMxEzARBgNV
# BAgTCldhc2hpbmd0b24xEDAOBgNVBAcTB1JlZG1vbmQxHjAcBgNVBAoTFU1pY3Jv
# c29mdCBDb3Jwb3JhdGlvbjEmMCQGA1UEAxMdTWljcm9zb2Z0IFRpbWUtU3RhbXAg
# UENBIDIwMTAwDQYJKoZIhvcNAQELBQACBQDqzuggMCIYDzIwMjQxMTAxMDUzOTQ0
# WhgPMjAyNDExMDIwNTM5NDRaMHcwPQYKKwYBBAGEWQoEATEvMC0wCgIFAOrO6CAC
# AQAwCgIBAAICI1wCAf8wBwIBAAICE0MwCgIFAOrQOaACAQAwNgYKKwYBBAGEWQoE
# AjEoMCYwDAYKKwYBBAGEWQoDAqAKMAgCAQACAwehIKEKMAgCAQACAwGGoDANBgkq
# hkiG9w0BAQsFAAOCAQEAuxOFR9bHOPkoVcWu8xLkvww/dl8yP5e3/o0wIfz0RRcQ
# 5CO7ghDa8D3jzn0lQf5JDbZ2gb4L/6Of1IV+uZIrGuZzrYz8H0JJspw1mVuHg0iB
# 5BeR+FAiLG3t3nSt0NfKhBzvX6ZRrGogKBs88U8slYNdvMvlCtEAfymQ9Q1wc1dz
# uQBOgC4CVf5VZAKtPbSngCb/tfOPtOT1+yHJOwUxiF+Nr7LlwYBt1C2VfZukToWL
# uKmr4IhR3U7cYq21kf/7vvKVHKAZ2wVguH66Nv2aCr5Kq4PY6zPama/UXSenRws5
# AbqujkqaQg4miNRR3vh04A9hy0YF2jG/K7rKKlmMjTGCBA0wggQJAgEBMIGTMHwx
# CzAJBgNVBAYTAlVTMRMwEQYDVQQIEwpXYXNoaW5ndG9uMRAwDgYDVQQHEwdSZWRt
# b25kMR4wHAYDVQQKExVNaWNyb3NvZnQgQ29ycG9yYXRpb24xJjAkBgNVBAMTHU1p
# Y3Jvc29mdCBUaW1lLVN0YW1wIFBDQSAyMDEwAhMzAAAB7eFfy9X3pV1zAAEAAAHt
# MA0GCWCGSAFlAwQCAQUAoIIBSjAaBgkqhkiG9w0BCQMxDQYLKoZIhvcNAQkQAQQw
# LwYJKoZIhvcNAQkEMSIEIL31ZhZU534YkgYDASENFbJ+SOQSyc8bt0BZJSvpVgXN
# MIH6BgsqhkiG9w0BCRACLzGB6jCB5zCB5DCBvQQgjS4NaDQIWx4rErcDXqXXCsjC
# uxIOtdnrFJ/QXjFsyjkwgZgwgYCkfjB8MQswCQYDVQQGEwJVUzETMBEGA1UECBMK
# V2FzaGluZ3RvbjEQMA4GA1UEBxMHUmVkbW9uZDEeMBwGA1UEChMVTWljcm9zb2Z0
# IENvcnBvcmF0aW9uMSYwJAYDVQQDEx1NaWNyb3NvZnQgVGltZS1TdGFtcCBQQ0Eg
# MjAxMAITMwAAAe3hX8vV96VdcwABAAAB7TAiBCBROF0LbKhjD+8ahMSxJbo1tgBb
# UKeDPuuAD17qoEKEIjANBgkqhkiG9w0BAQsFAASCAgCKgf8tITTHHZKYpTO2+sai
# PT69pRHSkKs3O5ti5sOcnJH6zpCMGsGna9JtDOqdOkelih8VGbFWhgSxClrsBxy7
# 2a0L+DJX6hDEhlGFulcws+L0Ne/mLN5HapUVxkW4ALaS0NWQg8BlCah3ZxTkxctR
# skLBBlsKS0OJTa4EItxFmZ6DU6xboG95XHS+hEXL7aSlI1BI5D2NeAlY7KY2Byjk
# 7dlrSlRa7YPmuByINk0Xif6OHSp0yd9MQuOKrkYXeu2T9lWOyd4/qmYXS8tvby5q
# hT8QN2LPzs9oNaPgzWd+metE7BW5zwNu/0SJFXUs4dCGzVsN0ljmbeIw9uP+5Jyc
# HQTN1AatcVvARi7ClCuXKwbhGlCGLMR2EXJE3u2KF+VE7NXqVwWw6gjy2BcpvfCJ
# mOOrXWl52QRqYCNQ1IdHkO4LiIRiCTrQ0w8CK4zv+8O9OzU2fapgqedrhMJaAekV
# W0HYvzW2UVLgVAU59a2ev1j3/ZrvJpuIWvqmrE4zYciMtel12HeygFc+t4huMAPW
# q76Lg8aDhfchhh4lrsOc9XaBHpl1/McA7QLOZ628zujepbwdaVIJrruZ1Fhijful
# NqU3p3O2fae4L+y9tbWov2LDZsMh96d7vND1NKHvw8HJey5VfErYDB9OZU0/l9+g
# 5W5QH6EXNoajldmmlaI+xg==
# SIG # End signature block
