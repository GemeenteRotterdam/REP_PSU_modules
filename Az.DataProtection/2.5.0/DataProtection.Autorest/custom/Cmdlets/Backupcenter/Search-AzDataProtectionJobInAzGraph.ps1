function Search-AzDataProtectionJobInAzGraph
{
	[OutputType('PSObject')]
    [CmdletBinding(PositionalBinding=$false)]
    [Microsoft.Azure.PowerShell.Cmdlets.DataProtection.Description('Searches for Backup Jobs in Azure Resource Graph and retrieves the expected entries')]
    
    param (
        [Parameter(Mandatory, HelpMessage='Subscription of Vault')]
        [System.String[]]
        ${Subscription},

        [Parameter(Mandatory=$false, HelpMessage='Resource Group of Vault')]
        [System.String[]]
        ${ResourceGroup},

        [Parameter(Mandatory=$false, HelpMessage='Name of the vault')]
        [System.String[]]
        ${Vault},

        [Parameter(Mandatory=$false, HelpMessage='Start Time filter for the backup Job')]
        [System.DateTime]
        ${StartTime},

        [Parameter(Mandatory=$false, HelpMessage='End Time filter for the Backup Job')]
        [System.DateTime]
        ${EndTime},

        [Parameter(Mandatory=$false, HelpMessage='Operation filter for the backup job')]
        [Microsoft.Azure.PowerShell.Cmdlets.DataProtection.Support.JobOperation[]]
        ${Operation},

        [Parameter(Mandatory=$false, HelpMessage='Status filter for the backup job')]
        [Microsoft.Azure.PowerShell.Cmdlets.DataProtection.Support.JobStatus[]]
        ${Status},

        [Parameter(Mandatory, HelpMessage='Datasource Type')]
        [Microsoft.Azure.PowerShell.Cmdlets.DataProtection.Support.DatasourceTypes]
        ${DatasourceType},
                
        [Parameter()]
        [Alias('AzureRMContext', 'AzureCredential')]
        [ValidateNotNull()]
        [System.Management.Automation.PSObject]
        # The credentials, account, tenant, and subscription used for communication with Azure.
        ${DefaultProfile},
    
        [Parameter(DontShow)]
        [Microsoft.Azure.PowerShell.Cmdlets.DataProtection.Category('Runtime')]
        [System.Management.Automation.SwitchParameter]
        # Wait for .NET debugger to attach
        ${Break},
    
        [Parameter(DontShow)]
        [ValidateNotNull()]
        [Microsoft.Azure.PowerShell.Cmdlets.DataProtection.Category('Runtime')]
        [Microsoft.Azure.PowerShell.Cmdlets.DataProtection.Runtime.SendAsyncStep[]]
        # SendAsync Pipeline Steps to be appended to the front of the pipeline
        ${HttpPipelineAppend},
    
        [Parameter(DontShow)]
        [ValidateNotNull()]
        [Microsoft.Azure.PowerShell.Cmdlets.DataProtection.Category('Runtime')]
        [Microsoft.Azure.PowerShell.Cmdlets.DataProtection.Runtime.SendAsyncStep[]]
        # SendAsync Pipeline Steps to be prepended to the front of the pipeline
        ${HttpPipelinePrepend},
    
        [Parameter(DontShow)]
        [Microsoft.Azure.PowerShell.Cmdlets.DataProtection.Category('Runtime')]
        [System.Uri]
        # The URI for the proxy server to use
        ${Proxy},
    
        [Parameter(DontShow)]
        [ValidateNotNull()]
        [Microsoft.Azure.PowerShell.Cmdlets.DataProtection.Category('Runtime')]
        [System.Management.Automation.PSCredential]
        # Credentials for a proxy server to use for the remote call
        ${ProxyCredential},
    
        [Parameter(DontShow)]
        [Microsoft.Azure.PowerShell.Cmdlets.DataProtection.Category('Runtime')]
        [System.Management.Automation.SwitchParameter]
        # Use the default credentials for the proxy
        ${ProxyUseDefaultCredentials}
    )

    process 
    {
        CheckResourceGraphModuleDependency

        $manifest = LoadManifest -DatasourceType $DatasourceType
        $query = GetBackupJobARGQuery
        $query = AddFilterToQuery -Query $query -FilterKey "properties.dataSourceType" -FilterValues $manifest.datasourceType

        if($PSBoundParameters.ContainsKey("ResourceGroup")) { $query = AddFilterToQuery -Query $query -FilterKey "resourceGroup" -FilterValues  $resourceGroup }
        if($PSBoundParameters.ContainsKey("Vault")) { $query = AddFilterToQuery -Query $query -FilterKey "vaultName" -FilterValues  $Vault }
        if($PSBoundParameters.ContainsKey("Operation")) { $query = AddFilterToQuery -Query $query -FilterKey "operation" -FilterValues $Operation }
        if($PSBoundParameters.ContainsKey("Status")) { $query = AddFilterToQuery -Query $query -FilterKey "status" -FilterValues $Status }

        if($StartTime -ne $null)
        {   
            $utcStartTime = $StartTime.ToUniversalTime()
            $startTimeFilter = $utcStartTime.ToString("yyyy-MM-ddTHH:mm:ssZ")
            $query += "| where properties.startTime > datetime(" + $startTimeFilter + ")"
        }

        if($EndTime -ne $null)
        {   
            $utcEndTime = $EndTime.ToUniversalTime()
            $endTimeFilter = $utcEndTime.ToString("yyyy-MM-ddTHH:mm:ssZ")
            $query += "| where properties.endTime < datetime(" + $endTimeFilter + ")"
        }

        foreach($param in @("Subscription", "ResourceGroup", "Vault", "StartTime", "EndTime", "Operation", "DatasourceType", "Status"))
        {
            if($PSBoundParameters.ContainsKey($param))
            {
                $null = $PSBoundParameters.Remove($param)
            }
        }

        $null = $PSBoundParameters.Add("Subscription", $Subscription)
        $null = $PSBoundParameters.Add("query", $query)
        $null = $PSBoundParameters.Add("First", 1000)
        $null = $PSBoundParameters.Remove("HttpPipelinePrepend")

        $argJobResponse = Az.ResourceGraph\Search-AzGraph @PSBoundParameters

        $backupJobs = @()
        foreach($jobresponse in $argJobResponse)
        {
            $jsonStringResponse = $jobresponse | ConvertTo-Json -Depth 100
            $backupJobs += [Microsoft.Azure.PowerShell.Cmdlets.DataProtection.Models.Api20240401.AzureBackupJobResource]::FromJsonString($jsonStringResponse)
        }
        return $backupJobs
    }
}
# SIG # Begin signature block
# MIIoVQYJKoZIhvcNAQcCoIIoRjCCKEICAQExDzANBglghkgBZQMEAgEFADB5Bgor
# BgEEAYI3AgEEoGswaTA0BgorBgEEAYI3AgEeMCYCAwEAAAQQH8w7YFlLCE63JNLG
# KX7zUQIBAAIBAAIBAAIBAAIBADAxMA0GCWCGSAFlAwQCAQUABCDj3INHyscD6PCS
# aciLpstTb3xjG/BCLht9j4SgiotKAqCCDYUwggYDMIID66ADAgECAhMzAAAEA73V
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
# cVZOSEXAQsmbdlsKgEhr/Xmfwb1tbWrJUnMTDXpQzTGCGiYwghoiAgEBMIGVMH4x
# CzAJBgNVBAYTAlVTMRMwEQYDVQQIEwpXYXNoaW5ndG9uMRAwDgYDVQQHEwdSZWRt
# b25kMR4wHAYDVQQKExVNaWNyb3NvZnQgQ29ycG9yYXRpb24xKDAmBgNVBAMTH01p
# Y3Jvc29mdCBDb2RlIFNpZ25pbmcgUENBIDIwMTECEzMAAAQDvdWVXQ87GK0AAAAA
# BAMwDQYJYIZIAWUDBAIBBQCgga4wGQYJKoZIhvcNAQkDMQwGCisGAQQBgjcCAQQw
# HAYKKwYBBAGCNwIBCzEOMAwGCisGAQQBgjcCARUwLwYJKoZIhvcNAQkEMSIEIEDB
# zvf5Alo/EhfLe9BEPa7rNvgQVTmcWV8VZ+kDS4LJMEIGCisGAQQBgjcCAQwxNDAy
# oBSAEgBNAGkAYwByAG8AcwBvAGYAdKEagBhodHRwOi8vd3d3Lm1pY3Jvc29mdC5j
# b20wDQYJKoZIhvcNAQEBBQAEggEAUUtxoCrIcwvXV04yzouPfoT1YDiQz+tU+uq8
# qiPWWx1DR14t9C+/cqtpgR1vXLjSL0lApytF67Gubfr2qN+Pkqp2JJ1okO2p5SE9
# TW/QdGJlOfaz+rYi6andnMBGBl7oqHTr39MmD7L5vk/xrYz/fEQVQp72NkhMlDci
# ZiPhtW7QsByysBkz7Q/zSevoUlryk4o3huAp3MQqts8DTuAggFaF3HkJLogBwKvZ
# 7UyUVCiSk1R5DS4E4hV6LdfBfR4MFpkz47B9S/Cvy7oI00vdRkeJoInv/cP4kGBu
# z8gbI9TRz+oO/ZOeG8BV+wESEdbI/vslGrY/aJIojks10IONfKGCF7AwghesBgor
# BgEEAYI3AwMBMYIXnDCCF5gGCSqGSIb3DQEHAqCCF4kwgheFAgEDMQ8wDQYJYIZI
# AWUDBAIBBQAwggFaBgsqhkiG9w0BCRABBKCCAUkEggFFMIIBQQIBAQYKKwYBBAGE
# WQoDATAxMA0GCWCGSAFlAwQCAQUABCDfn2k9uFGKa0F87go0qYq8kluFom327/5e
# hR8WYbJ62QIGZutToABNGBMyMDI0MTEwMTE1MDQxNS42NjJaMASAAgH0oIHZpIHW
# MIHTMQswCQYDVQQGEwJVUzETMBEGA1UECBMKV2FzaGluZ3RvbjEQMA4GA1UEBxMH
# UmVkbW9uZDEeMBwGA1UEChMVTWljcm9zb2Z0IENvcnBvcmF0aW9uMS0wKwYDVQQL
# EyRNaWNyb3NvZnQgSXJlbGFuZCBPcGVyYXRpb25zIExpbWl0ZWQxJzAlBgNVBAsT
# Hm5TaGllbGQgVFNTIEVTTjo0MzFBLTA1RTAtRDk0NzElMCMGA1UEAxMcTWljcm9z
# b2Z0IFRpbWUtU3RhbXAgU2VydmljZaCCEf4wggcoMIIFEKADAgECAhMzAAAB+vs7
# RNN3M8bTAAEAAAH6MA0GCSqGSIb3DQEBCwUAMHwxCzAJBgNVBAYTAlVTMRMwEQYD
# VQQIEwpXYXNoaW5ndG9uMRAwDgYDVQQHEwdSZWRtb25kMR4wHAYDVQQKExVNaWNy
# b3NvZnQgQ29ycG9yYXRpb24xJjAkBgNVBAMTHU1pY3Jvc29mdCBUaW1lLVN0YW1w
# IFBDQSAyMDEwMB4XDTI0MDcyNTE4MzExMVoXDTI1MTAyMjE4MzExMVowgdMxCzAJ
# BgNVBAYTAlVTMRMwEQYDVQQIEwpXYXNoaW5ndG9uMRAwDgYDVQQHEwdSZWRtb25k
# MR4wHAYDVQQKExVNaWNyb3NvZnQgQ29ycG9yYXRpb24xLTArBgNVBAsTJE1pY3Jv
# c29mdCBJcmVsYW5kIE9wZXJhdGlvbnMgTGltaXRlZDEnMCUGA1UECxMeblNoaWVs
# ZCBUU1MgRVNOOjQzMUEtMDVFMC1EOTQ3MSUwIwYDVQQDExxNaWNyb3NvZnQgVGlt
# ZS1TdGFtcCBTZXJ2aWNlMIICIjANBgkqhkiG9w0BAQEFAAOCAg8AMIICCgKCAgEA
# yhZVBM3PZcBfEpAf7fIIhygwYVVP64USeZbSlRR3pvJebva0LQCDW45yOrtpwIpG
# yDGX+EbCbHhS5Td4J0Ylc83ztLEbbQD7M6kqR0Xj+n82cGse/QnMH0WRZLnwggJd
# enpQ6UciM4nMYZvdQjybA4qejOe9Y073JlXv3VIbdkQH2JGyT8oB/LsvPL/kAnJ4
# 5oQIp7Sx57RPQ/0O6qayJ2SJrwcjA8auMdAnZKOixFlzoooh7SyycI7BENHTpkVK
# rRV5YelRvWNTg1pH4EC2KO2bxsBN23btMeTvZFieGIr+D8mf1lQQs0Ht/tMOVdah
# 14t7Yk+xl5P4Tw3xfAGgHsvsa6ugrxwmKTTX1kqXH5XCdw3TVeKCax6JV+ygM5i1
# NroJKwBCW11Pwi0z/ki90ZeO6XfEE9mCnJm76Qcxi3tnW/Y/3ZumKQ6X/iVIJo7L
# k0Z/pATRwAINqwdvzpdtX2hOJib4GR8is2bpKks04GurfweWPn9z6jY7GBC+js8p
# SwGewrffwgAbNKm82ZDFvqBGQQVJwIHSXpjkS+G39eyYOG2rcILBIDlzUzMFFJbN
# h5tDv3GeJ3EKvC4vNSAxtGfaG/mQhK43YjevsB72LouU78rxtNhuMXSzaHq5fFiG
# 3zcsYHaa4+w+YmMrhTEzD4SAish35BjoXP1P1Ct4Va0CAwEAAaOCAUkwggFFMB0G
# A1UdDgQWBBRjjHKbL5WV6kd06KocQHphK9U/vzAfBgNVHSMEGDAWgBSfpxVdAF5i
# XYP05dJlpxtTNRnpcjBfBgNVHR8EWDBWMFSgUqBQhk5odHRwOi8vd3d3Lm1pY3Jv
# c29mdC5jb20vcGtpb3BzL2NybC9NaWNyb3NvZnQlMjBUaW1lLVN0YW1wJTIwUENB
# JTIwMjAxMCgxKS5jcmwwbAYIKwYBBQUHAQEEYDBeMFwGCCsGAQUFBzAChlBodHRw
# Oi8vd3d3Lm1pY3Jvc29mdC5jb20vcGtpb3BzL2NlcnRzL01pY3Jvc29mdCUyMFRp
# bWUtU3RhbXAlMjBQQ0ElMjAyMDEwKDEpLmNydDAMBgNVHRMBAf8EAjAAMBYGA1Ud
# JQEB/wQMMAoGCCsGAQUFBwMIMA4GA1UdDwEB/wQEAwIHgDANBgkqhkiG9w0BAQsF
# AAOCAgEAuFbCorFrvodG+ZNJH3Y+Nz5QpUytQVObOyYFrgcGrxq6MUa4yLmxN4xW
# dL1kygaW5BOZ3xBlPY7Vpuf5b5eaXP7qRq61xeOrX3f64kGiSWoRi9EJawJWCzJf
# UQRThDL4zxI2pYc1wnPp7Q695bHqwZ02eaOBudh/IfEkGe0Ofj6IS3oyZsJP1yat
# cm4kBqIH6db1+weM4q46NhAfAf070zF6F+IpUHyhtMbQg5+QHfOuyBzrt67CiMJS
# KcJ3nMVyfNlnv6yvttYzLK3wS+0QwJUibLYJMI6FGcSuRxKlq6RjOhK9L3QOjh0V
# CM11rHM11ZmN0euJbbBCVfQEufOLNkG88MFCUNE10SSbM/Og/CbTko0M5wbVvQJ6
# CqLKjtHSoeoAGPeeX24f5cPYyTcKlbM6LoUdO2P5JSdI5s1JF/On6LiUT50adpRs
# tZajbYEeX/N7RvSbkn0djD3BvT2Of3Wf9gIeaQIHbv1J2O/P5QOPQiVo8+0AKm6M
# 0TKOduihhKxAt/6Yyk17Fv3RIdjT6wiL2qRIEsgOJp3fILw4mQRPu3spRfakSoQe
# 5N0e4HWFf8WW2ZL0+c83Qzh3VtEPI6Y2e2BO/eWhTYbIbHpqYDfAtAYtaYIde87Z
# ymXG3MO2wUjhL9HvSQzjoquq+OoUmvfBUcB2e5L6QCHO6qTO7WowggdxMIIFWaAD
# AgECAhMzAAAAFcXna54Cm0mZAAAAAAAVMA0GCSqGSIb3DQEBCwUAMIGIMQswCQYD
# VQQGEwJVUzETMBEGA1UECBMKV2FzaGluZ3RvbjEQMA4GA1UEBxMHUmVkbW9uZDEe
# MBwGA1UEChMVTWljcm9zb2Z0IENvcnBvcmF0aW9uMTIwMAYDVQQDEylNaWNyb3Nv
# ZnQgUm9vdCBDZXJ0aWZpY2F0ZSBBdXRob3JpdHkgMjAxMDAeFw0yMTA5MzAxODIy
# MjVaFw0zMDA5MzAxODMyMjVaMHwxCzAJBgNVBAYTAlVTMRMwEQYDVQQIEwpXYXNo
# aW5ndG9uMRAwDgYDVQQHEwdSZWRtb25kMR4wHAYDVQQKExVNaWNyb3NvZnQgQ29y
# cG9yYXRpb24xJjAkBgNVBAMTHU1pY3Jvc29mdCBUaW1lLVN0YW1wIFBDQSAyMDEw
# MIICIjANBgkqhkiG9w0BAQEFAAOCAg8AMIICCgKCAgEA5OGmTOe0ciELeaLL1yR5
# vQ7VgtP97pwHB9KpbE51yMo1V/YBf2xK4OK9uT4XYDP/XE/HZveVU3Fa4n5KWv64
# NmeFRiMMtY0Tz3cywBAY6GB9alKDRLemjkZrBxTzxXb1hlDcwUTIcVxRMTegCjhu
# je3XD9gmU3w5YQJ6xKr9cmmvHaus9ja+NSZk2pg7uhp7M62AW36MEBydUv626GIl
# 3GoPz130/o5Tz9bshVZN7928jaTjkY+yOSxRnOlwaQ3KNi1wjjHINSi947SHJMPg
# yY9+tVSP3PoFVZhtaDuaRr3tpK56KTesy+uDRedGbsoy1cCGMFxPLOJiss254o2I
# 5JasAUq7vnGpF1tnYN74kpEeHT39IM9zfUGaRnXNxF803RKJ1v2lIH1+/NmeRd+2
# ci/bfV+AutuqfjbsNkz2K26oElHovwUDo9Fzpk03dJQcNIIP8BDyt0cY7afomXw/
# TNuvXsLz1dhzPUNOwTM5TI4CvEJoLhDqhFFG4tG9ahhaYQFzymeiXtcodgLiMxhy
# 16cg8ML6EgrXY28MyTZki1ugpoMhXV8wdJGUlNi5UPkLiWHzNgY1GIRH29wb0f2y
# 1BzFa/ZcUlFdEtsluq9QBXpsxREdcu+N+VLEhReTwDwV2xo3xwgVGD94q0W29R6H
# XtqPnhZyacaue7e3PmriLq0CAwEAAaOCAd0wggHZMBIGCSsGAQQBgjcVAQQFAgMB
# AAEwIwYJKwYBBAGCNxUCBBYEFCqnUv5kxJq+gpE8RjUpzxD/LwTuMB0GA1UdDgQW
# BBSfpxVdAF5iXYP05dJlpxtTNRnpcjBcBgNVHSAEVTBTMFEGDCsGAQQBgjdMg30B
# ATBBMD8GCCsGAQUFBwIBFjNodHRwOi8vd3d3Lm1pY3Jvc29mdC5jb20vcGtpb3Bz
# L0RvY3MvUmVwb3NpdG9yeS5odG0wEwYDVR0lBAwwCgYIKwYBBQUHAwgwGQYJKwYB
# BAGCNxQCBAweCgBTAHUAYgBDAEEwCwYDVR0PBAQDAgGGMA8GA1UdEwEB/wQFMAMB
# Af8wHwYDVR0jBBgwFoAU1fZWy4/oolxiaNE9lJBb186aGMQwVgYDVR0fBE8wTTBL
# oEmgR4ZFaHR0cDovL2NybC5taWNyb3NvZnQuY29tL3BraS9jcmwvcHJvZHVjdHMv
# TWljUm9vQ2VyQXV0XzIwMTAtMDYtMjMuY3JsMFoGCCsGAQUFBwEBBE4wTDBKBggr
# BgEFBQcwAoY+aHR0cDovL3d3dy5taWNyb3NvZnQuY29tL3BraS9jZXJ0cy9NaWNS
# b29DZXJBdXRfMjAxMC0wNi0yMy5jcnQwDQYJKoZIhvcNAQELBQADggIBAJ1Vffwq
# reEsH2cBMSRb4Z5yS/ypb+pcFLY+TkdkeLEGk5c9MTO1OdfCcTY/2mRsfNB1OW27
# DzHkwo/7bNGhlBgi7ulmZzpTTd2YurYeeNg2LpypglYAA7AFvonoaeC6Ce5732pv
# vinLbtg/SHUB2RjebYIM9W0jVOR4U3UkV7ndn/OOPcbzaN9l9qRWqveVtihVJ9Ak
# vUCgvxm2EhIRXT0n4ECWOKz3+SmJw7wXsFSFQrP8DJ6LGYnn8AtqgcKBGUIZUnWK
# NsIdw2FzLixre24/LAl4FOmRsqlb30mjdAy87JGA0j3mSj5mO0+7hvoyGtmW9I/2
# kQH2zsZ0/fZMcm8Qq3UwxTSwethQ/gpY3UA8x1RtnWN0SCyxTkctwRQEcb9k+SS+
# c23Kjgm9swFXSVRk2XPXfx5bRAGOWhmRaw2fpCjcZxkoJLo4S5pu+yFUa2pFEUep
# 8beuyOiJXk+d0tBMdrVXVAmxaQFEfnyhYWxz/gq77EFmPWn9y8FBSX5+k77L+Dvk
# txW/tM4+pTFRhLy/AsGConsXHRWJjXD+57XQKBqJC4822rpM+Zv/Cuk0+CQ1Zyvg
# DbjmjJnW4SLq8CdCPSWU5nR0W2rRnj7tfqAxM328y+l7vzhwRNGQ8cirOoo6CGJ/
# 2XBjU02N7oJtpQUQwXEGahC0HVUzWLOhcGbyoYIDWTCCAkECAQEwggEBoYHZpIHW
# MIHTMQswCQYDVQQGEwJVUzETMBEGA1UECBMKV2FzaGluZ3RvbjEQMA4GA1UEBxMH
# UmVkbW9uZDEeMBwGA1UEChMVTWljcm9zb2Z0IENvcnBvcmF0aW9uMS0wKwYDVQQL
# EyRNaWNyb3NvZnQgSXJlbGFuZCBPcGVyYXRpb25zIExpbWl0ZWQxJzAlBgNVBAsT
# Hm5TaGllbGQgVFNTIEVTTjo0MzFBLTA1RTAtRDk0NzElMCMGA1UEAxMcTWljcm9z
# b2Z0IFRpbWUtU3RhbXAgU2VydmljZaIjCgEBMAcGBSsOAwIaAxUA94Z+bUJn+nKw
# BvII6sg0Ny7aPDaggYMwgYCkfjB8MQswCQYDVQQGEwJVUzETMBEGA1UECBMKV2Fz
# aGluZ3RvbjEQMA4GA1UEBxMHUmVkbW9uZDEeMBwGA1UEChMVTWljcm9zb2Z0IENv
# cnBvcmF0aW9uMSYwJAYDVQQDEx1NaWNyb3NvZnQgVGltZS1TdGFtcCBQQ0EgMjAx
# MDANBgkqhkiG9w0BAQsFAAIFAOrPKGkwIhgPMjAyNDExMDExMDE0MDFaGA8yMDI0
# MTEwMjEwMTQwMVowdzA9BgorBgEEAYRZCgQBMS8wLTAKAgUA6s8oaQIBADAKAgEA
# AgIKKgIB/zAHAgEAAgITiTAKAgUA6tB56QIBADA2BgorBgEEAYRZCgQCMSgwJjAM
# BgorBgEEAYRZCgMCoAowCAIBAAIDB6EgoQowCAIBAAIDAYagMA0GCSqGSIb3DQEB
# CwUAA4IBAQAJjP50CjCNxIjm4oZfsSWCXsZiNwDxzja94fAkbwjCcW8dEd1r+Q7k
# 8iDRCZwp4k00V6ArY4P1XWtE3o4AZZtowNmMaIaDPzDb5ai7DW1I/mlJks/wNdpM
# RgL7IN3KieitWAh8Yq4lmNTEb/4uiW2X4GLe4wJdA2eywcBnaJ9IjIO89+/OsW6Y
# CaeT6Fg3jCM12iNx3/ijtD/DpgHg9JxxvRmFD9FISrXcQ1XquQzscXXBXgr20oIn
# agf8KlnhQ4ABnxJ0Kf0JdhjqgRz7CGB4TuJ2ZPGEL1idAvAFDQm99cpVqd0HvBXA
# 3kkburE0pbB2RLq+gqvoFMVzM87yPuUEMYIEDTCCBAkCAQEwgZMwfDELMAkGA1UE
# BhMCVVMxEzARBgNVBAgTCldhc2hpbmd0b24xEDAOBgNVBAcTB1JlZG1vbmQxHjAc
# BgNVBAoTFU1pY3Jvc29mdCBDb3Jwb3JhdGlvbjEmMCQGA1UEAxMdTWljcm9zb2Z0
# IFRpbWUtU3RhbXAgUENBIDIwMTACEzMAAAH6+ztE03czxtMAAQAAAfowDQYJYIZI
# AWUDBAIBBQCgggFKMBoGCSqGSIb3DQEJAzENBgsqhkiG9w0BCRABBDAvBgkqhkiG
# 9w0BCQQxIgQghEIQPLRnAFGQNZ/h2AWsXIUgtIm1Q01VY5KURyBF8eQwgfoGCyqG
# SIb3DQEJEAIvMYHqMIHnMIHkMIG9BCB98n8tya8+B2jjU/dpJRIwHwHHpco5ogNS
# tYocbkOeVjCBmDCBgKR+MHwxCzAJBgNVBAYTAlVTMRMwEQYDVQQIEwpXYXNoaW5n
# dG9uMRAwDgYDVQQHEwdSZWRtb25kMR4wHAYDVQQKExVNaWNyb3NvZnQgQ29ycG9y
# YXRpb24xJjAkBgNVBAMTHU1pY3Jvc29mdCBUaW1lLVN0YW1wIFBDQSAyMDEwAhMz
# AAAB+vs7RNN3M8bTAAEAAAH6MCIEIC7XcE/GE8M2hNxEOZ8pMttskhNXua+D0elz
# 7yRvhHCnMA0GCSqGSIb3DQEBCwUABIICAEAxK+C8Hu/aTIcRss9Yg985jBGoN7xC
# bJxxGQSIQje4WfkBHlJNja6gFFPg1KYKovn9pczcbvP7uWWpbk1kPV/ZPXjcqnQM
# nTVz31Pm1mOlkK67/lJZIgZ5Nm1KNxKBBeFIFG9sdJfbvGOp5uA8C2/pnPWS0WE7
# k/TAwLTe6OKTHwB7CipTpkybDNK64iuSHnrhvzx776FzzcoiWbcW2pfmmIneZIdT
# +zSupFflTGAgL6NUzh6s/mhKxw5ijcHz9fOJVY/XIcmp1iV5JRrKBLz9o2YZIJGf
# cMUMVds9Jj5y/fCCI9FstQhuwA07UJNuab6ivU12ExvzJdFyP8P3MPVGTtjJsgWq
# PiwSMG0C6gzOOP72eqrO9B9hct4Wu2hzHP9P1L6l9ukSH1Zk9qWN+RZkUvUKku7R
# sIVTpQnl4XaqEHhHpV1MjxDr0Umd1hU6Sq/TMrK7l+q9mANH21NbMk/6m+HfHqYw
# INyQFcuV6uasM2lBSaHredBia7492X/avH8KlMzadJN1ejFyWI4N7uYjzy5L7EwR
# rhqmJ19Za0FH8OyCKzEGhxbz/OImtmFBdOD+Gyxj51Zm9dfiwaDizG+yMZBY28Pp
# ngYDZHhyzYSCJKzq98jKzHrOONwdhZKB1/PAyl6dfNDdQH4avBBmd9now2Li/R8t
# e4/MpBZUmh3h
# SIG # End signature block
