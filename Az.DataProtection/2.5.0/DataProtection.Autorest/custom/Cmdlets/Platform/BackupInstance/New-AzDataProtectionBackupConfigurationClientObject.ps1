
function New-AzDataProtectionBackupConfigurationClientObject{
	[OutputType('PSObject')]
    [CmdletBinding(PositionalBinding=$false)]
    [Microsoft.Azure.PowerShell.Cmdlets.DataProtection.Description('Creates new backup configuration object')]

    param(
        [Parameter(Mandatory, HelpMessage='Datasource Type')]
        [Microsoft.Azure.PowerShell.Cmdlets.DataProtection.Support.DatasourceTypes]
        [ValidateSet('AzureKubernetesService', 'AzureBlob')]
        ${DatasourceType},
        
        [Parameter(Mandatory=$false, HelpMessage='List of resource types to be excluded from backup')]
        [System.String[]]
        ${ExcludedResourceType},

        [Parameter(Mandatory=$false, HelpMessage='List of resource types to be included for backup')]
        [System.String[]]
        ${IncludedResourceType},

        [Parameter(Mandatory=$false, HelpMessage='List of namespaces to be excluded from backup')]
        [System.String[]]
        ${ExcludedNamespace},

        [Parameter(Mandatory=$false, HelpMessage='List of namespaces to be included for backup')]
        [System.String[]]
        ${IncludedNamespace},

        [Parameter(Mandatory=$false, HelpMessage='List of labels for internal filtering for backup')]
        [System.String[]]
        ${LabelSelector},

        [Parameter(Mandatory=$false, HelpMessage='Boolean parameter to decide whether snapshot volumes are included for backup. By default this is taken as true.')]        
        [Nullable[System.Boolean]]
        ${SnapshotVolume},

        [Parameter(Mandatory=$false, HelpMessage='Boolean parameter to decide whether cluster scope resources are included for backup. By default this is taken as true.')]        
        [Nullable[System.Boolean]]
        ${IncludeClusterScopeResource},

        [Parameter(Mandatory=$false, HelpMessage='Hook reference to be executed during backup.')]
        [Microsoft.Azure.PowerShell.Cmdlets.DataProtection.Models.Api20240401.NamespacedNameResource[]]
        ${BackupHookReference},
        
        [Parameter(Mandatory=$false, HelpMessage='List of containers to be backed up inside the VaultStore. Use this parameter for DatasourceType AzureBlob.')]
        [System.String[]]
        ${VaultedBackupContainer},
        
        [Parameter(Mandatory=$false, HelpMessage='Switch parameter to include all containers to be backed up inside the VaultStore. Use this parameter for DatasourceType AzureBlob.')]
        [Switch]
        ${IncludeAllContainer},
        
        [Parameter(Mandatory=$false, HelpMessage='Storage account where the Datasource is present. Use this parameter for DatasourceType AzureBlob.')]
        [System.String]
        ${StorageAccountName},
        
        [Parameter(Mandatory=$false, HelpMessage='Storage account resource group name where the Datasource is present. Use this parameter for DatasourceType AzureBlob.')]
        [System.String]
        ${StorageAccountResourceGroupName}
    )

    process {        
        # need to have parameter validation when this command supports another DatasourceType           
        $dataSourceParam = $null

        if($DatasourceType.ToString() -eq "AzureKubernetesService"){

            # parameter validation
            if($VaultedBackupContainer -ne $null -or $IncludeAllContainer){
                $message = "Invalid parameter VaultedBackupContainer or IncludeAllContainer for given DatasourceType."
                throw $message
            }

            $dataSourceParam = [Microsoft.Azure.PowerShell.Cmdlets.DataProtection.Models.Api20240401.KubernetesClusterBackupDatasourceParameters]::new()
            $dataSourceParam.ObjectType = "KubernetesClusterBackupDatasourceParameters"
        
            $dataSourceParam.ExcludedResourceType = $ExcludedResourceType
            $dataSourceParam.IncludedResourceType = $IncludedResourceType
            $dataSourceParam.ExcludedNamespace = $ExcludedNamespace
            $dataSourceParam.IncludedNamespace = $IncludedNamespace
            $dataSourceParam.LabelSelector = $LabelSelector
            $dataSourceParam.BackupHookReference = $BackupHookReference

            if ($SnapshotVolume -ne $null) {
                $dataSourceParam.SnapshotVolume = $SnapshotVolume
            }
            else{
                $dataSourceParam.SnapshotVolume = $true
            }

            if($IncludeClusterScopeResource -ne $null){
                $dataSourceParam.IncludeClusterScopeResource = $IncludeClusterScopeResource
            }
            else{
                $dataSourceParam.IncludeClusterScopeResource = $true        
            }
        }

        if($DatasourceType.ToString() -eq "AzureBlob"){
            $dataSourceParam = [Microsoft.Azure.PowerShell.Cmdlets.DataProtection.Models.Api20240401.BlobBackupDatasourceParameters]::new()
            $dataSourceParam.ObjectType = "BlobBackupDatasourceParameters"
            
            if($VaultedBackupContainer -ne $null){

                # exclude containers which start with $ except $web, $root
                $unsupportedContainers = $VaultedBackupContainer | Where-Object { $_ -like '$*' -and $_ -ne "`$root" -and $_ -ne "`$web"}
                if($unsupportedContainers.Count -gt 0){
                    $message = "Following containers are not allowed for configure protection with AzureBlob - $unsupportedContainers. Please remove them and proceed."
                    throw $message
                }

                $dataSourceParam.ContainersList = $VaultedBackupContainer
            }
            elseif($IncludeAllContainer){
                if($StorageAccountName -eq $null -or $StorageAccountResourceGroupName -eq $null){
                    $message = "Please input StorageAccountName and StorageAccountResourceGroupName parameters for fetching all vaulted containers."
                    throw $message
                }

                CheckStorageModuleDependency
                $storageAccount = Get-AzStorageAccount -ResourceGroupName $StorageAccountResourceGroupName -Name $StorageAccountName 
                $containers = Get-AzStorageContainer -Context $storageAccount.Context

                # exclude containers which start with $ except $web, $root
                $allContainers = $containers.Name | Where-Object { -not($_ -like '$*' -and $_ -ne "`$root" -and $_ -ne "`$web")}
                $dataSourceParam.ContainersList = $allContainers
            }
            elseif($ExcludedResourceType -ne $null -or $IncludedResourceType -ne $null -or $ExcludedNamespace -ne $null -or $IncludedNamespace -ne $null -or $LabelSelector -ne $null -or $SnapshotVolume -ne $null -or $IncludeClusterScopeResource -ne $null){
                $message = "Invalid parameters ExcludedResourceType, IncludedResourceType, ExcludedNamespace, IncludedNamespace, LabelSelector, SnapshotVolume, IncludeClusterScopeResource for given DatasourceType."
                throw $message
            }
            else {
                 $message = "Please input VaultedBackupContainer or IncludeAllContainer parameters for given workload type."
                 throw $message
            }
        }

        $dataSourceParam
    }
}
# SIG # Begin signature block
# MIIoOQYJKoZIhvcNAQcCoIIoKjCCKCYCAQExDzANBglghkgBZQMEAgEFADB5Bgor
# BgEEAYI3AgEEoGswaTA0BgorBgEEAYI3AgEeMCYCAwEAAAQQH8w7YFlLCE63JNLG
# KX7zUQIBAAIBAAIBAAIBAAIBADAxMA0GCWCGSAFlAwQCAQUABCCAz/vljNVQhaoz
# aLHT5bE//TAeDCvs9GYq3dOi/9E3VKCCDYUwggYDMIID66ADAgECAhMzAAAEA73V
# lV0POxitAAAAAAQDMA0GCSqGSIb3DQEBCwUAMH4xCzAJBgNVBAYTAlVTMRMwEQYD
# VQQIEwpXYXNoaW5ndG9uMRAwDgYDVQQHEwdSZWRtb25kMR4wHAYDVQQKExVNaWNy
# b3NvZnQgQ29ycG9yYXRpb24xKDAmBgNVBAMTH01pY3Jvc29mdCBDb2RlIFNpZ25p
# bmcgUENBIDIwMTEwHhcNMjQwOTEyMjAxMTEzWhcNMjUwOTExMjAxMTEzWjB0MQsw
# CQYDVQQGEwJVUzETMBEGA1UECBMKV2FzaGluZ3RvbjEQMA4GA1UEBxMHUmVkbW9u
# ZDEeMBwGA1UEChMVTWljcm9zb2Z0IENvcnBvcmF0aW9uMR4wHAYDVQQDExVNaWNy
# b3NvZnQgQ29ycG9yYXRpb24wggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIB
# AQCfdGddwIOnbRYUyg03O3iz19XXZPmuhEmW/5uyEN+8mgxl+HJGeLGBR8YButGV
# LVK38RxcVcPYyFGQXcKcxgih4w4y4zJi3GvawLYHlsNExQwz+v0jgY/aejBS2EJY
# oUhLVE+UzRihV8ooxoftsmKLb2xb7BoFS6UAo3Zz4afnOdqI7FGoi7g4vx/0MIdi
# kwTn5N56TdIv3mwfkZCFmrsKpN0zR8HD8WYsvH3xKkG7u/xdqmhPPqMmnI2jOFw/
# /n2aL8W7i1Pasja8PnRXH/QaVH0M1nanL+LI9TsMb/enWfXOW65Gne5cqMN9Uofv
# ENtdwwEmJ3bZrcI9u4LZAkujAgMBAAGjggGCMIIBfjAfBgNVHSUEGDAWBgorBgEE
# AYI3TAgBBggrBgEFBQcDAzAdBgNVHQ4EFgQU6m4qAkpz4641iK2irF8eWsSBcBkw
# VAYDVR0RBE0wS6RJMEcxLTArBgNVBAsTJE1pY3Jvc29mdCBJcmVsYW5kIE9wZXJh
# dGlvbnMgTGltaXRlZDEWMBQGA1UEBRMNMjMwMDEyKzUwMjkyNjAfBgNVHSMEGDAW
# gBRIbmTlUAXTgqoXNzcitW2oynUClTBUBgNVHR8ETTBLMEmgR6BFhkNodHRwOi8v
# d3d3Lm1pY3Jvc29mdC5jb20vcGtpb3BzL2NybC9NaWNDb2RTaWdQQ0EyMDExXzIw
# MTEtMDctMDguY3JsMGEGCCsGAQUFBwEBBFUwUzBRBggrBgEFBQcwAoZFaHR0cDov
# L3d3dy5taWNyb3NvZnQuY29tL3BraW9wcy9jZXJ0cy9NaWNDb2RTaWdQQ0EyMDEx
# XzIwMTEtMDctMDguY3J0MAwGA1UdEwEB/wQCMAAwDQYJKoZIhvcNAQELBQADggIB
# AFFo/6E4LX51IqFuoKvUsi80QytGI5ASQ9zsPpBa0z78hutiJd6w154JkcIx/f7r
# EBK4NhD4DIFNfRiVdI7EacEs7OAS6QHF7Nt+eFRNOTtgHb9PExRy4EI/jnMwzQJV
# NokTxu2WgHr/fBsWs6G9AcIgvHjWNN3qRSrhsgEdqHc0bRDUf8UILAdEZOMBvKLC
# rmf+kJPEvPldgK7hFO/L9kmcVe67BnKejDKO73Sa56AJOhM7CkeATrJFxO9GLXos
# oKvrwBvynxAg18W+pagTAkJefzneuWSmniTurPCUE2JnvW7DalvONDOtG01sIVAB
# +ahO2wcUPa2Zm9AiDVBWTMz9XUoKMcvngi2oqbsDLhbK+pYrRUgRpNt0y1sxZsXO
# raGRF8lM2cWvtEkV5UL+TQM1ppv5unDHkW8JS+QnfPbB8dZVRyRmMQ4aY/tx5x5+
# sX6semJ//FbiclSMxSI+zINu1jYerdUwuCi+P6p7SmQmClhDM+6Q+btE2FtpsU0W
# +r6RdYFf/P+nK6j2otl9Nvr3tWLu+WXmz8MGM+18ynJ+lYbSmFWcAj7SYziAfT0s
# IwlQRFkyC71tsIZUhBHtxPliGUu362lIO0Lpe0DOrg8lspnEWOkHnCT5JEnWCbzu
# iVt8RX1IV07uIveNZuOBWLVCzWJjEGa+HhaEtavjy6i7MIIHejCCBWKgAwIBAgIK
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
# cVZOSEXAQsmbdlsKgEhr/Xmfwb1tbWrJUnMTDXpQzTGCGgowghoGAgEBMIGVMH4x
# CzAJBgNVBAYTAlVTMRMwEQYDVQQIEwpXYXNoaW5ndG9uMRAwDgYDVQQHEwdSZWRt
# b25kMR4wHAYDVQQKExVNaWNyb3NvZnQgQ29ycG9yYXRpb24xKDAmBgNVBAMTH01p
# Y3Jvc29mdCBDb2RlIFNpZ25pbmcgUENBIDIwMTECEzMAAAQDvdWVXQ87GK0AAAAA
# BAMwDQYJYIZIAWUDBAIBBQCgga4wGQYJKoZIhvcNAQkDMQwGCisGAQQBgjcCAQQw
# HAYKKwYBBAGCNwIBCzEOMAwGCisGAQQBgjcCARUwLwYJKoZIhvcNAQkEMSIEIMn7
# retBgpZSYacJ8yjJdUOpRQoKcyPa+tVY8NLuVlcOMEIGCisGAQQBgjcCAQwxNDAy
# oBSAEgBNAGkAYwByAG8AcwBvAGYAdKEagBhodHRwOi8vd3d3Lm1pY3Jvc29mdC5j
# b20wDQYJKoZIhvcNAQEBBQAEggEAOyiUf9ey89rb+BXuARw1tx5ZbIYCdxorfFad
# JV9BjPoBEKWgs0yicOlRdyTufB7F6Pi4mI9qUEQHoWjncM6jFjEm4UFdc0Ksb+fc
# orOXQ0N/8DHukZI5apZ/ctBl1De3G5yWBFcuRT9s0FkAltbQqBCQF60/rzCoK57u
# FWepToHRBy4W7l9GUiEBk9E4/U95KX5tYxmCOOSDJ9PXo6nXfXi2RqsuG8wxIlpQ
# p1aEG6sAu2UMJcpOtVfVDrORF4s7Bxra6SiMc8CMRH/NVJj+bya7pmTtjpq8+apL
# +8fCSwoo6TLhvkFFkoZrCSTPwsLjISS+buzCITzN47wHoicnQaGCF5QwgheQBgor
# BgEEAYI3AwMBMYIXgDCCF3wGCSqGSIb3DQEHAqCCF20wghdpAgEDMQ8wDQYJYIZI
# AWUDBAIBBQAwggFSBgsqhkiG9w0BCRABBKCCAUEEggE9MIIBOQIBAQYKKwYBBAGE
# WQoDATAxMA0GCWCGSAFlAwQCAQUABCAONlYP3XHRTijSa4qmitrdAkgqcWKGbcHw
# G08xjF+xpAIGZxqP99z4GBMyMDI0MTEwMTE1MDQxNi4wMTFaMASAAgH0oIHRpIHO
# MIHLMQswCQYDVQQGEwJVUzETMBEGA1UECBMKV2FzaGluZ3RvbjEQMA4GA1UEBxMH
# UmVkbW9uZDEeMBwGA1UEChMVTWljcm9zb2Z0IENvcnBvcmF0aW9uMSUwIwYDVQQL
# ExxNaWNyb3NvZnQgQW1lcmljYSBPcGVyYXRpb25zMScwJQYDVQQLEx5uU2hpZWxk
# IFRTUyBFU046RTAwMi0wNUUwLUQ5NDcxJTAjBgNVBAMTHE1pY3Jvc29mdCBUaW1l
# LVN0YW1wIFNlcnZpY2WgghHqMIIHIDCCBQigAwIBAgITMwAAAe4F0wIwspqdpwAB
# AAAB7jANBgkqhkiG9w0BAQsFADB8MQswCQYDVQQGEwJVUzETMBEGA1UECBMKV2Fz
# aGluZ3RvbjEQMA4GA1UEBxMHUmVkbW9uZDEeMBwGA1UEChMVTWljcm9zb2Z0IENv
# cnBvcmF0aW9uMSYwJAYDVQQDEx1NaWNyb3NvZnQgVGltZS1TdGFtcCBQQ0EgMjAx
# MDAeFw0yMzEyMDYxODQ1NDRaFw0yNTAzMDUxODQ1NDRaMIHLMQswCQYDVQQGEwJV
# UzETMBEGA1UECBMKV2FzaGluZ3RvbjEQMA4GA1UEBxMHUmVkbW9uZDEeMBwGA1UE
# ChMVTWljcm9zb2Z0IENvcnBvcmF0aW9uMSUwIwYDVQQLExxNaWNyb3NvZnQgQW1l
# cmljYSBPcGVyYXRpb25zMScwJQYDVQQLEx5uU2hpZWxkIFRTUyBFU046RTAwMi0w
# NUUwLUQ5NDcxJTAjBgNVBAMTHE1pY3Jvc29mdCBUaW1lLVN0YW1wIFNlcnZpY2Uw
# ggIiMA0GCSqGSIb3DQEBAQUAA4ICDwAwggIKAoICAQC+8byl16KEia8xKS4vVL7R
# EOOR7LzYCLXEtWgeqyOVlrzuEz+AoCa4tBGESjbHTXECeMOwP9TPeKaKalfTU5XS
# GjpJhpGx59fxMJoTYWPzzD0O2RAlyBmOBBmiLDXRDQJL1RtuAjvCiLulVQeiPI8V
# 7+HhTR391TbC1beSxwXfdKJqY1onjDawqDJAmtwsA/gmqXgHwF9fZWcwKSuXiZBT
# bU5fcm3bhhlRNw5d04Ld15ZWzVl/VDp/iRerGo2Is/0Wwn/a3eGOdHrvfwIbfk6l
# VqwbNQE11Oedn2uvRjKWEwerXL70OuDZ8vLzxry0yEdvQ8ky+Vfq8mfEXS907Y7r
# N/HYX6cCsC2soyXG3OwCtLA7o0/+kKJZuOrD5HUrSz3kfqgDlmWy67z8ZZPjkiDC
# 1dYW1jN77t5iSl5Wp1HKBp7JU8RiRI+vY2i1cb5X2REkw3WrNW/jbofXEs9t4bgd
# +yU8sgKn9MtVnQ65s6QG72M/yaUZG2HMI31tm9mooH29vPBO9jDMOIu0LwzUTkIW
# flgd/vEWfTNcPWEQj7fsWuSoVuJ3uBqwNmRSpmQDzSfMaIzuys0pvV1jFWqtqwwC
# caY/WXsb/axkxB/zCTdHSBUJ8Tm3i4PM9skiunXY+cSqH58jWkpHbbLA3Ofss7e+
# JbMjKmTdcjmSkb5oN8qU1wIDAQABo4IBSTCCAUUwHQYDVR0OBBYEFBCIzT8a2dwg
# nr37xd+2v1/cdqYIMB8GA1UdIwQYMBaAFJ+nFV0AXmJdg/Tl0mWnG1M1GelyMF8G
# A1UdHwRYMFYwVKBSoFCGTmh0dHA6Ly93d3cubWljcm9zb2Z0LmNvbS9wa2lvcHMv
# Y3JsL01pY3Jvc29mdCUyMFRpbWUtU3RhbXAlMjBQQ0ElMjAyMDEwKDEpLmNybDBs
# BggrBgEFBQcBAQRgMF4wXAYIKwYBBQUHMAKGUGh0dHA6Ly93d3cubWljcm9zb2Z0
# LmNvbS9wa2lvcHMvY2VydHMvTWljcm9zb2Z0JTIwVGltZS1TdGFtcCUyMFBDQSUy
# MDIwMTAoMSkuY3J0MAwGA1UdEwEB/wQCMAAwFgYDVR0lAQH/BAwwCgYIKwYBBQUH
# AwgwDgYDVR0PAQH/BAQDAgeAMA0GCSqGSIb3DQEBCwUAA4ICAQB3ZyAva2EKOWSV
# pBnYkzX8f8GZjaOs577F9o14Anh9lKy6tS34wXoPXEyQp1v1iI7rJzZVG7rpUzna
# y2n9csfn3p6y7kYkHqtSugCGmTiiBkwhFfSByKPI08MklgvJvKTZb673yGfpFwPj
# QwZeI6EPj/OAtpYkT7IUXqMki1CRMJKgeY4wURCccIujdWRkoVv4J3q/87KE0qPQ
# mAR9fqMNxjI3ZClVxA4wiM3tNVlRbF9SgpOnjVo3P/I5p8Jd41hNSVCx/8j3qM7a
# LSKtDzOEUNs+ZtjhznmZgUd7/AWHDhwBHdL57TI9h7niZkfOZOXncYsKxG4gryTs
# hU6G6sAYpbqdME/+/g1uer7VGIHUtLq3W0Anm8lAfS9PqthskZt54JF28CHdsFq/
# 7XVBtFlxL/KgcQylJNnia+anixUG60yUDt3FMGSJI34xG9NHsz3BpqSWueGtJhQ5
# ZN0K8ju0vNVgF+Dv05sirPg0ftSKf9FVECp93o8ogF48jh8CT/B32lz1D6Truk4E
# zcw7E1OhtOMf7DHgPMWf6WOdYnf+HaSJx7ZTXCJsW5oOkM0sLitxBpSpGcj2YjnN
# znCpsEPZat0h+6d7ulRaWR5RHAUyFFQ9jRa7KWaNGdELTs+nHSlYjYeQpK5QSXji
# gdKlLQPBlX+9zOoGAJhoZfrpjq4nQDCCB3EwggVZoAMCAQICEzMAAAAVxedrngKb
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
# ELQdVTNYs6FwZvKhggNNMIICNQIBATCB+aGB0aSBzjCByzELMAkGA1UEBhMCVVMx
# EzARBgNVBAgTCldhc2hpbmd0b24xEDAOBgNVBAcTB1JlZG1vbmQxHjAcBgNVBAoT
# FU1pY3Jvc29mdCBDb3Jwb3JhdGlvbjElMCMGA1UECxMcTWljcm9zb2Z0IEFtZXJp
# Y2EgT3BlcmF0aW9uczEnMCUGA1UECxMeblNoaWVsZCBUU1MgRVNOOkUwMDItMDVF
# MC1EOTQ3MSUwIwYDVQQDExxNaWNyb3NvZnQgVGltZS1TdGFtcCBTZXJ2aWNloiMK
# AQEwBwYFKw4DAhoDFQCIo6bVNvflFxbUWCDQ3YYKy6O+k6CBgzCBgKR+MHwxCzAJ
# BgNVBAYTAlVTMRMwEQYDVQQIEwpXYXNoaW5ndG9uMRAwDgYDVQQHEwdSZWRtb25k
# MR4wHAYDVQQKExVNaWNyb3NvZnQgQ29ycG9yYXRpb24xJjAkBgNVBAMTHU1pY3Jv
# c29mdCBUaW1lLVN0YW1wIFBDQSAyMDEwMA0GCSqGSIb3DQEBCwUAAgUA6s7xGDAi
# GA8yMDI0MTEwMTA2MTgwMFoYDzIwMjQxMTAyMDYxODAwWjB0MDoGCisGAQQBhFkK
# BAExLDAqMAoCBQDqzvEYAgEAMAcCAQACAg5iMAcCAQACAhLhMAoCBQDq0EKYAgEA
# MDYGCisGAQQBhFkKBAIxKDAmMAwGCisGAQQBhFkKAwKgCjAIAgEAAgMHoSChCjAI
# AgEAAgMBhqAwDQYJKoZIhvcNAQELBQADggEBAI1eoQSvGEVcKFFmU57SwTIfLsx2
# oD8C+Q5nexSEWiHxvdRtD5iDYlybOAQlJvF2JJv9ffDR1Zh7eTqI9PIoTg4RdXyc
# Qw453kmIXqWT5PL0kwWHeZRPatVxkKbqiVweLRHmPT6ZXjb2OlC+oemEcj2VaGls
# p078T0N7HTVmtxzRNVqceNB2EvgKd+e9jFx9w518NW0LRheRKR8yYYQo1tuZ9j15
# t9QNy094dGPAB0g9g1tzegH6b1MkMyCT/WG21ZN4rX1tXfdb7OnBigws3sSmPr+W
# Do7xtgu0+SKYisWClJT9Db7ctk1kf2T5+MtbQRhSCX2uGmuA9w3Wcd63tvMxggQN
# MIIECQIBATCBkzB8MQswCQYDVQQGEwJVUzETMBEGA1UECBMKV2FzaGluZ3RvbjEQ
# MA4GA1UEBxMHUmVkbW9uZDEeMBwGA1UEChMVTWljcm9zb2Z0IENvcnBvcmF0aW9u
# MSYwJAYDVQQDEx1NaWNyb3NvZnQgVGltZS1TdGFtcCBQQ0EgMjAxMAITMwAAAe4F
# 0wIwspqdpwABAAAB7jANBglghkgBZQMEAgEFAKCCAUowGgYJKoZIhvcNAQkDMQ0G
# CyqGSIb3DQEJEAEEMC8GCSqGSIb3DQEJBDEiBCCIpXJupay+WfsEAQTVgiki3Ksl
# 4SStCIj/wRZxvr7dGTCB+gYLKoZIhvcNAQkQAi8xgeowgecwgeQwgb0EIE9QdxSV
# hfq+Vdf+DPs+5EIkBz9oCS/OQflHkVRhfjAhMIGYMIGApH4wfDELMAkGA1UEBhMC
# VVMxEzARBgNVBAgTCldhc2hpbmd0b24xEDAOBgNVBAcTB1JlZG1vbmQxHjAcBgNV
# BAoTFU1pY3Jvc29mdCBDb3Jwb3JhdGlvbjEmMCQGA1UEAxMdTWljcm9zb2Z0IFRp
# bWUtU3RhbXAgUENBIDIwMTACEzMAAAHuBdMCMLKanacAAQAAAe4wIgQgE0C5pSYN
# wbwkrRg6H+Km1xTq0tR73gLdlXcPhx6Ygx0wDQYJKoZIhvcNAQELBQAEggIAt+k9
# V85FIJVi8Ut6bCiElCT0SXkhXVfbY7N8aoRqXCgDSwnvqE1+Z9ZXkhDMmBy7ifF4
# IGS6ousZrxrRGgU6tGPWTEnePcbMBRkwZiElmsDJdrLq3UZW9cw3HSmWtWEwvgOz
# rnwRwyTvqXfrV8cku7lm9YJU4VkQ96AY9vtRKroyGosGrmRTckvbM8D5CIbBb+6V
# jFTAXF2X/BtygnAydfHHBVQlirh5G2MQitYgIwTcIdRD1hsdBWu+CXzuinvSbX/g
# 9bU+5tgFMtPiIwupsId8fWAdqi95m/3dEayYB55PaC2B4OTXsbM8FfccJd9FYxep
# VIlTHsn1k3Rza4oSiYodgSxfHPRykTivfCLDz0y10ik06BRo1AbodUupIB1SUwxJ
# ZsPbYJxTGcC1TNbcd2FeX44PxC48eYIVEoJcjxQnuhqvLHNmDvqSAuJRt4M6Xkl5
# S/trmef/Lvy63yYrkfoNHAHAr5v27e+kejaJlEZtNt8WprOdlPphU8+0ROSLNRlB
# bxXrJZhwbr7uo4uq6Cj42cwVApslvYn94kMXnV9IGs+E6aWQsgF5z4j1B7+Hhz2L
# 4ZAZPHUoKByTgCA/uzROxU8Sxh7UMnU19gtYhhw7j/jQvw+I8gGBCcm0l4JSCQ6N
# v2+M+TV64ljfZB2JgcA87MK7/YR/ssIuB8aNG1E=
# SIG # End signature block
