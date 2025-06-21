function AddFilterToQuery {
    [Microsoft.Azure.PowerShell.Cmdlets.DataProtection.DoNotExportAttribute()]
    param(
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [System.String]
        $Query,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [System.String]
        $FilterKey,

        [Parameter(Mandatory = $true)]
        [System.String[]]
        $FilterValues
    )
	
    process {

        if (($FilterValues -ne $null) -and ($FilterValues.Length -ne 0)) {
            $updatedQuery = $Query
            $filterValueJoin = [System.String]::Join("','", $FilterValues)
            $updatedQuery += " | where " + $FilterKey + " in~ ('" + $filterValueJoin + "')"
            return $updatedQuery
        }

        return $Query
    }
}

function GetResourceGroupIdFromArmId {
    [Microsoft.Azure.PowerShell.Cmdlets.DataProtection.DoNotExportAttribute()]
    param(
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [System.String]
        $Id
    )
	
    process {

        $ResourceArray = $Id.Split("/")
        $ResourceRG = "/subscriptions/" + $ResourceArray[2] + "/resourceGroups/" + $ResourceArray[4]

        return $ResourceRG
    }
}

function GetSubscriptionNameFromArmId {
    [Microsoft.Azure.PowerShell.Cmdlets.DataProtection.DoNotExportAttribute()]
    param(
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [System.String]
        $Id
    )
	
    process {

        $ResourceArray = $Id.Split("/")
        $SubscriptionName = "/subscriptions/" + $ResourceArray[2]
        
        return $SubscriptionName
    }
}


function GetResourceNameFromArmId {
    [Microsoft.Azure.PowerShell.Cmdlets.DataProtection.DoNotExportAttribute()]
    param(
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [System.String]
        $Id
    )
	
    process {

        $ResourceArray = $Id.Split("/")
        $ResourceName = $ResourceArray[8]
        
        return $ResourceName
    }
}

function GetResourceGroupNameFromArmId {
    [Microsoft.Azure.PowerShell.Cmdlets.DataProtection.DoNotExportAttribute()]
    param(
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [System.String]
        $Id
    )
	
    process {

        $ResourceArray = $Id.Split("/")
        $ResourceRG = $ResourceArray[4]
        
        return $ResourceRG
    }
}

function CheckResourceGraphModuleDependency {
    [Microsoft.Azure.PowerShell.Cmdlets.DataProtection.DoNotExportAttribute()]
    param() 

    process {
        $module = Get-Module -ListAvailable | Where-Object { $_.Name -eq "Az.ResourceGraph" }
        if ($module -eq $null) {
            $message = "Az.ResourceGraph Module must be installed to run this command. Please run 'Install-Module -Name Az.ResourceGraph' to install and continue."
            throw $message
        }
    }
}

function CheckResourcesModuleDependency {
    [Microsoft.Azure.PowerShell.Cmdlets.DataProtection.DoNotExportAttribute()]
    param() 

    process {
        $module = Get-Module -ListAvailable | Where-Object { $_.Name -eq "Az.Resources" }
        if ($module -eq $null) {
            $message = "Az.Resources Module must be installed to run this command. Please run 'Install-Module -Name Az.Resources' to install and continue."
            throw $message
        }
    }
}

function CheckPostgreSqlModuleDependency {
    [Microsoft.Azure.PowerShell.Cmdlets.DataProtection.DoNotExportAttribute()]
    param() 

    process {
        $module = Get-Module -ListAvailable | Where-Object { $_.Name -eq "Az.PostgreSql" }
        if ($module -eq $null) {
            $message = "Az.PostgreSql Module must be installed to run this command. Please run 'Install-Module -Name Az.PostgreSql' to install and continue."
            throw $message
        }
    }
}

function CheckKeyVaultModuleDependency {
    [Microsoft.Azure.PowerShell.Cmdlets.DataProtection.DoNotExportAttribute()]
    param() 

    process {
        $module = Get-Module -ListAvailable | Where-Object { $_.Name -eq "Az.KeyVault" }
        if ($module -eq $null) {
            $message = "Az.KeyVault Module must be installed to run this command. Please run 'Install-Module -Name Az.KeyVault' to install and continue."
            throw $message
        }
    }
}

function CheckAksModuleDependency {
    [Microsoft.Azure.PowerShell.Cmdlets.DataProtection.DoNotExportAttribute()]
    param() 

    process {
        $module = Get-Module -ListAvailable | Where-Object { $_.Name -eq "Az.Aks" }
        if ($module -eq $null) {
            $message = "Az.Aks Module must be installed to run this command. Please run 'Install-Module -Name Az.Aks' to install and continue."
            throw $message
        }
    }
}

function CheckStorageModuleDependency {
    [Microsoft.Azure.PowerShell.Cmdlets.DataProtection.DoNotExportAttribute()]
    param() 

    process {
        $module = Get-Module -ListAvailable | Where-Object { $_.Name -eq "Az.Storage" }
        if ($module -eq $null) {
            $message = "Az.Storage Module must be installed to run this command. Please run 'Install-Module -Name Az.Storage' to install and continue."
            throw $message
        }
    }
}

function AssignMissingRolesHelper {
    [Microsoft.Azure.PowerShell.Cmdlets.DataProtection.DoNotExportAttribute()]
    param(
        [Parameter(Mandatory)]
        [System.String]
        ${ObjectId},

        [Parameter(Mandatory)]
        [System.String]
        ${Permission},

        [Parameter(Mandatory)]
        [System.String]
        ${ResourceScope}
    )

    process {
        Write-Debug "Assigning new role for ObjectId, RoleDefinitionName, Scope: "
        Write-Debug $ObjectId
        Write-Debug $Permission
        Write-Debug $ResourceGroup        

        try { 
            New-AzRoleAssignment -ObjectId $ObjectId -RoleDefinitionName $Permission -Scope $ResourceScope | Out-Null 
        }
         
        catch {
            $err = $_
            if ($err.Exception.Message -eq "Operation returned an invalid status code 'Forbidden'") {
                $err = "User doesn't have sufficient privileges for performing Grant permissions."
            }
            throw $err 
        }
    }
}

function AssignMissingRoles {
    [Microsoft.Azure.PowerShell.Cmdlets.DataProtection.DoNotExportAttribute()]
    param(
        [Parameter(Mandatory)]
        [System.String]
        ${ObjectId},

        [Parameter(Mandatory)]
        [System.String]
        ${Permission},

        [Parameter(Mandatory)]
        [System.String]
        ${PermissionsScope},

        [Parameter(Mandatory)]
        [System.String]
        ${Resource},

        [Parameter(Mandatory)]
        [System.String]
        ${ResourceGroup},

        [Parameter(Mandatory)]
        [System.String]
        ${Subscription}
    )

    process {

        if ($PermissionsScope -eq "Resource") {
            AssignMissingRolesHelper -ObjectId $ObjectId -Permission $Permission -ResourceScope $Resource
        }

        elseif ($PermissionsScope -eq "ResourceGroup") {
            AssignMissingRolesHelper -ObjectId $ObjectId -Permission $Permission -ResourceScope $ResourceGroup
        }

        else {
            AssignMissingRolesHelper -ObjectId $ObjectId -Permission $Permission -ResourceScope $Subscription
        }
    }
}

function GetBackupInstanceARGQuery {
    [Microsoft.Azure.PowerShell.Cmdlets.DataProtection.DoNotExportAttribute()]
    param()

    process {
        $query = "RecoveryServicesResources | where type =~ 'microsoft.dataprotection/backupvaults/backupinstances'"
        $query += "| extend vaultName = split(split(id, '/Microsoft.DataProtection/backupVaults/')[1],'/')[0]"
        $query += "| extend protectionState = properties.currentProtectionState"

        return $query
    }
}

function GetBackupJobARGQuery {
    [Microsoft.Azure.PowerShell.Cmdlets.DataProtection.DoNotExportAttribute()]
    param()

    process {
        $query = "RecoveryServicesResources | where type =~ 'microsoft.dataprotection/backupvaults/backupjobs'"
        $query += "| extend vaultName = properties.vaultName"
        $query += "| extend status = properties.status"
        $query += "| extend operation = case( tolower(properties.operationCategory) startswith 'backup' and properties.isUserTriggered == 'true', strcat('OnDemand',properties.operationCategory)"
        $query += ", tolower(properties.operationCategory) startswith 'backup' and properties.isUserTriggered == 'false', strcat('Scheduled', properties.operationCategory)"
        $query += ", type =~ 'microsoft.dataprotection/backupVaults/backupJobs', properties.operationCategory, 'Invalid')"

        return $query
    }
}

function GetBackupVaultARGQuery {
    [Microsoft.Azure.PowerShell.Cmdlets.DataProtection.DoNotExportAttribute()]
    param()

    process {
        $query = "Resources | where type =~ 'microsoft.dataprotection/backupvaults'"

        return $query
    }
}
# SIG # Begin signature block
# MIIoVAYJKoZIhvcNAQcCoIIoRTCCKEECAQExDzANBglghkgBZQMEAgEFADB5Bgor
# BgEEAYI3AgEEoGswaTA0BgorBgEEAYI3AgEeMCYCAwEAAAQQH8w7YFlLCE63JNLG
# KX7zUQIBAAIBAAIBAAIBAAIBADAxMA0GCWCGSAFlAwQCAQUABCCFo6rqn8zoSWpK
# GIlvn6W9WmTRrJzOL/TYcq6SBQeiG6CCDYUwggYDMIID66ADAgECAhMzAAAEA73V
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
# cVZOSEXAQsmbdlsKgEhr/Xmfwb1tbWrJUnMTDXpQzTGCGiUwghohAgEBMIGVMH4x
# CzAJBgNVBAYTAlVTMRMwEQYDVQQIEwpXYXNoaW5ndG9uMRAwDgYDVQQHEwdSZWRt
# b25kMR4wHAYDVQQKExVNaWNyb3NvZnQgQ29ycG9yYXRpb24xKDAmBgNVBAMTH01p
# Y3Jvc29mdCBDb2RlIFNpZ25pbmcgUENBIDIwMTECEzMAAAQDvdWVXQ87GK0AAAAA
# BAMwDQYJYIZIAWUDBAIBBQCgga4wGQYJKoZIhvcNAQkDMQwGCisGAQQBgjcCAQQw
# HAYKKwYBBAGCNwIBCzEOMAwGCisGAQQBgjcCARUwLwYJKoZIhvcNAQkEMSIEID97
# Enp3aiEEjEPlTtNIZHgTEhbRUbScMr9/jN3z1PlLMEIGCisGAQQBgjcCAQwxNDAy
# oBSAEgBNAGkAYwByAG8AcwBvAGYAdKEagBhodHRwOi8vd3d3Lm1pY3Jvc29mdC5j
# b20wDQYJKoZIhvcNAQEBBQAEggEAauqBuLKDL5jJWWZwVqh0SSe2tTxj4uXMgshs
# 7QBJTtqwHVia+aFur2kpghHrSV4mBx7YbLbLqEYJhnO8OQCH/7hrofPTNvZmtQLA
# mHM06GPz401ECaNnhMEHNXbbs2vFIdcfF+kS7RZdOiWfJRrxkInaMAIQ9NEM9GiA
# /o++47mGQVOlnZyMX5WlhvdMf9FtSd25KSk/Kdqnj8OiT/cyzrHuWvxb3OZf6dsP
# UrIaXZh/scA4ZA5beSt0kShFCszJ7sDu5eftlTJwZuJuCbXRQs4SkMuECZVhMEFo
# dK0lp1u4abpjbQKtVugBXs+NX2RAsTUa23RUuSWzVQBJBGrPBKGCF68wgherBgor
# BgEEAYI3AwMBMYIXmzCCF5cGCSqGSIb3DQEHAqCCF4gwgheEAgEDMQ8wDQYJYIZI
# AWUDBAIBBQAwggFZBgsqhkiG9w0BCRABBKCCAUgEggFEMIIBQAIBAQYKKwYBBAGE
# WQoDATAxMA0GCWCGSAFlAwQCAQUABCCReajk96ub+mrNLqMrXe31Gm5YWGvrF1Nb
# vFAq4c8QQgIGZusylWRxGBIyMDI0MTEwMTE1MDQxNC40NlowBIACAfSggdmkgdYw
# gdMxCzAJBgNVBAYTAlVTMRMwEQYDVQQIEwpXYXNoaW5ndG9uMRAwDgYDVQQHEwdS
# ZWRtb25kMR4wHAYDVQQKExVNaWNyb3NvZnQgQ29ycG9yYXRpb24xLTArBgNVBAsT
# JE1pY3Jvc29mdCBJcmVsYW5kIE9wZXJhdGlvbnMgTGltaXRlZDEnMCUGA1UECxMe
# blNoaWVsZCBUU1MgRVNOOjJEMUEtMDVFMC1EOTQ3MSUwIwYDVQQDExxNaWNyb3Nv
# ZnQgVGltZS1TdGFtcCBTZXJ2aWNloIIR/jCCBygwggUQoAMCAQICEzMAAAH9c/lo
# Ws0MYe0AAQAAAf0wDQYJKoZIhvcNAQELBQAwfDELMAkGA1UEBhMCVVMxEzARBgNV
# BAgTCldhc2hpbmd0b24xEDAOBgNVBAcTB1JlZG1vbmQxHjAcBgNVBAoTFU1pY3Jv
# c29mdCBDb3Jwb3JhdGlvbjEmMCQGA1UEAxMdTWljcm9zb2Z0IFRpbWUtU3RhbXAg
# UENBIDIwMTAwHhcNMjQwNzI1MTgzMTE2WhcNMjUxMDIyMTgzMTE2WjCB0zELMAkG
# A1UEBhMCVVMxEzARBgNVBAgTCldhc2hpbmd0b24xEDAOBgNVBAcTB1JlZG1vbmQx
# HjAcBgNVBAoTFU1pY3Jvc29mdCBDb3Jwb3JhdGlvbjEtMCsGA1UECxMkTWljcm9z
# b2Z0IElyZWxhbmQgT3BlcmF0aW9ucyBMaW1pdGVkMScwJQYDVQQLEx5uU2hpZWxk
# IFRTUyBFU046MkQxQS0wNUUwLUQ5NDcxJTAjBgNVBAMTHE1pY3Jvc29mdCBUaW1l
# LVN0YW1wIFNlcnZpY2UwggIiMA0GCSqGSIb3DQEBAQUAA4ICDwAwggIKAoICAQCh
# Zaz4P467gmNidEdF527QxMVjM0kRU+cgvNzTZHepue6O+FmCSGn6n+XKZgvORDIb
# bOnFhx5OMgXseJBZu3oVbcBGQGu2ElTPTlmcqlwXfWWlQRvyBReIPbEimjxgz5IP
# RL6FM/VMID/B7fzJncES2Zm1xWdotGn8C+yqD7kojQrDpMMmkrBMuXRVbT/bewqK
# R5YNKcdB5Oms7TMib9u1qBJibdX/zNeV/HLuz8RUV1KCUcaxSrwRm6lQ7xdsfPPu
# 1RHKIPeQ7E2fDmjHV5lf9z9eZbgfpvjI2ZkXTBNm7DfvIDU8ko7JJKtetYSH4fr7
# 5Zvr7WW0wI+gwkdS08/cKfQI1w2+s/Im0NpyqOchOsvOuwd04uqOwfbb1mS+d2TQ
# irEENmAyhj4R/t98VE/ak+SsXUX0hwGRjPyEv5CNf67jLhSqrhS1PtVGeyq9H/H/
# 5AsTSlxISH9cTXDV9ynomarxGccReKTJwws39r8pjGlI/cV8Vstm5/6oivIUvSAQ
# PK1qkafU42NWSIqlU/a6pUhiPhWIKPLmktRx4x6qIqBiqGmZQcITZaywsuF1AEd2
# mXbz6T5ljqbh08WcSgZwke4xwhmfDhw7CLGiNE6v42rvVwmPtDgvRfA++5MdC3Sg
# ftEoxCCazLsJUPu/nl06F0dd1izI7r10B0r6daXJhwIDAQABo4IBSTCCAUUwHQYD
# VR0OBBYEFOkMxcDhlbz7Ivb7e8DpGZTugQqkMB8GA1UdIwQYMBaAFJ+nFV0AXmJd
# g/Tl0mWnG1M1GelyMF8GA1UdHwRYMFYwVKBSoFCGTmh0dHA6Ly93d3cubWljcm9z
# b2Z0LmNvbS9wa2lvcHMvY3JsL01pY3Jvc29mdCUyMFRpbWUtU3RhbXAlMjBQQ0El
# MjAyMDEwKDEpLmNybDBsBggrBgEFBQcBAQRgMF4wXAYIKwYBBQUHMAKGUGh0dHA6
# Ly93d3cubWljcm9zb2Z0LmNvbS9wa2lvcHMvY2VydHMvTWljcm9zb2Z0JTIwVGlt
# ZS1TdGFtcCUyMFBDQSUyMDIwMTAoMSkuY3J0MAwGA1UdEwEB/wQCMAAwFgYDVR0l
# AQH/BAwwCgYIKwYBBQUHAwgwDgYDVR0PAQH/BAQDAgeAMA0GCSqGSIb3DQEBCwUA
# A4ICAQBj2Fhf5PkCYKtgZof3pN1HlPnb8804bvJJh6im/h+WcNZAuEGWtq8CD6mO
# U2/ldJdmsoa/x7izl0nlZ2F8L3LAVCrhOZedR689e2W5tmT7TYFcrr/beEzRNIqz
# YqWFiKrNtF7xBsx8pcQO28ygdJlPuv7AjYiCNhDCRr7c/1VeARHC7jr9zPPwhH9m
# r687nnbcmV3qyxW7Oz27AismF9xgGPnSZdZEFwyHNqMuNYOByKHQO7KQ9wGmhMuU
# 4vwuleiiqev5AtgTgGlR6ncnJIxh8/PaF84veDTZYR+w7GnwA1tx2KozfV2be9KF
# 4SSaMcDbO4z5OCfiPmf4CfLsg4NhCQis1WEt0wvT167V0g+GnbiUW2dZNg1oVM58
# yoVrcBvwoMqJyanQC2FE1lWDQE8Avnz4HRRygEYrNL2OxzA5O7UmY2WKw4qRVRWR
# InkWj9y18NI90JNVohdcXuXjSTVwz9fY7Ql0BL3tPvyViO3D8/Ju7NfmyHEGH9Gp
# M+8LICEjEFUp83+F+zgIigVqpYnSv/xIHUIazLIhw98SAyjxx6rXDlmjQl+fIWLo
# a6j7Pcs8WX97FBpG5sSuwBRN/IFjn/mWLK+MCDINicQHy8c7tzsWDa0Z3mEaBiz4
# A6hbHbj5dzLGlSQBqMOGTL0OX7wllOO2zoFxP2xhOY6h2T9KAjCCB3EwggVZoAMC
# AQICEzMAAAAVxedrngKbSZkAAAAAABUwDQYJKoZIhvcNAQELBQAwgYgxCzAJBgNV
# BAYTAlVTMRMwEQYDVQQIEwpXYXNoaW5ndG9uMRAwDgYDVQQHEwdSZWRtb25kMR4w
# HAYDVQQKExVNaWNyb3NvZnQgQ29ycG9yYXRpb24xMjAwBgNVBAMTKU1pY3Jvc29m
# dCBSb290IENlcnRpZmljYXRlIEF1dGhvcml0eSAyMDEwMB4XDTIxMDkzMDE4MjIy
# NVoXDTMwMDkzMDE4MzIyNVowfDELMAkGA1UEBhMCVVMxEzARBgNVBAgTCldhc2hp
# bmd0b24xEDAOBgNVBAcTB1JlZG1vbmQxHjAcBgNVBAoTFU1pY3Jvc29mdCBDb3Jw
# b3JhdGlvbjEmMCQGA1UEAxMdTWljcm9zb2Z0IFRpbWUtU3RhbXAgUENBIDIwMTAw
# ggIiMA0GCSqGSIb3DQEBAQUAA4ICDwAwggIKAoICAQDk4aZM57RyIQt5osvXJHm9
# DtWC0/3unAcH0qlsTnXIyjVX9gF/bErg4r25PhdgM/9cT8dm95VTcVrifkpa/rg2
# Z4VGIwy1jRPPdzLAEBjoYH1qUoNEt6aORmsHFPPFdvWGUNzBRMhxXFExN6AKOG6N
# 7dcP2CZTfDlhAnrEqv1yaa8dq6z2Nr41JmTamDu6GnszrYBbfowQHJ1S/rboYiXc
# ag/PXfT+jlPP1uyFVk3v3byNpOORj7I5LFGc6XBpDco2LXCOMcg1KL3jtIckw+DJ
# j361VI/c+gVVmG1oO5pGve2krnopN6zL64NF50ZuyjLVwIYwXE8s4mKyzbnijYjk
# lqwBSru+cakXW2dg3viSkR4dPf0gz3N9QZpGdc3EXzTdEonW/aUgfX782Z5F37Zy
# L9t9X4C626p+Nuw2TPYrbqgSUei/BQOj0XOmTTd0lBw0gg/wEPK3Rxjtp+iZfD9M
# 269ewvPV2HM9Q07BMzlMjgK8QmguEOqEUUbi0b1qGFphAXPKZ6Je1yh2AuIzGHLX
# pyDwwvoSCtdjbwzJNmSLW6CmgyFdXzB0kZSU2LlQ+QuJYfM2BjUYhEfb3BvR/bLU
# HMVr9lxSUV0S2yW6r1AFemzFER1y7435UsSFF5PAPBXbGjfHCBUYP3irRbb1Hode
# 2o+eFnJpxq57t7c+auIurQIDAQABo4IB3TCCAdkwEgYJKwYBBAGCNxUBBAUCAwEA
# ATAjBgkrBgEEAYI3FQIEFgQUKqdS/mTEmr6CkTxGNSnPEP8vBO4wHQYDVR0OBBYE
# FJ+nFV0AXmJdg/Tl0mWnG1M1GelyMFwGA1UdIARVMFMwUQYMKwYBBAGCN0yDfQEB
# MEEwPwYIKwYBBQUHAgEWM2h0dHA6Ly93d3cubWljcm9zb2Z0LmNvbS9wa2lvcHMv
# RG9jcy9SZXBvc2l0b3J5Lmh0bTATBgNVHSUEDDAKBggrBgEFBQcDCDAZBgkrBgEE
# AYI3FAIEDB4KAFMAdQBiAEMAQTALBgNVHQ8EBAMCAYYwDwYDVR0TAQH/BAUwAwEB
# /zAfBgNVHSMEGDAWgBTV9lbLj+iiXGJo0T2UkFvXzpoYxDBWBgNVHR8ETzBNMEug
# SaBHhkVodHRwOi8vY3JsLm1pY3Jvc29mdC5jb20vcGtpL2NybC9wcm9kdWN0cy9N
# aWNSb29DZXJBdXRfMjAxMC0wNi0yMy5jcmwwWgYIKwYBBQUHAQEETjBMMEoGCCsG
# AQUFBzAChj5odHRwOi8vd3d3Lm1pY3Jvc29mdC5jb20vcGtpL2NlcnRzL01pY1Jv
# b0NlckF1dF8yMDEwLTA2LTIzLmNydDANBgkqhkiG9w0BAQsFAAOCAgEAnVV9/Cqt
# 4SwfZwExJFvhnnJL/Klv6lwUtj5OR2R4sQaTlz0xM7U518JxNj/aZGx80HU5bbsP
# MeTCj/ts0aGUGCLu6WZnOlNN3Zi6th542DYunKmCVgADsAW+iehp4LoJ7nvfam++
# Kctu2D9IdQHZGN5tggz1bSNU5HhTdSRXud2f8449xvNo32X2pFaq95W2KFUn0CS9
# QKC/GbYSEhFdPSfgQJY4rPf5KYnDvBewVIVCs/wMnosZiefwC2qBwoEZQhlSdYo2
# wh3DYXMuLGt7bj8sCXgU6ZGyqVvfSaN0DLzskYDSPeZKPmY7T7uG+jIa2Zb0j/aR
# AfbOxnT99kxybxCrdTDFNLB62FD+CljdQDzHVG2dY3RILLFORy3BFARxv2T5JL5z
# bcqOCb2zAVdJVGTZc9d/HltEAY5aGZFrDZ+kKNxnGSgkujhLmm77IVRrakURR6nx
# t67I6IleT53S0Ex2tVdUCbFpAUR+fKFhbHP+CrvsQWY9af3LwUFJfn6Tvsv4O+S3
# Fb+0zj6lMVGEvL8CwYKiexcdFYmNcP7ntdAoGokLjzbaukz5m/8K6TT4JDVnK+AN
# uOaMmdbhIurwJ0I9JZTmdHRbatGePu1+oDEzfbzL6Xu/OHBE0ZDxyKs6ijoIYn/Z
# cGNTTY3ugm2lBRDBcQZqELQdVTNYs6FwZvKhggNZMIICQQIBATCCAQGhgdmkgdYw
# gdMxCzAJBgNVBAYTAlVTMRMwEQYDVQQIEwpXYXNoaW5ndG9uMRAwDgYDVQQHEwdS
# ZWRtb25kMR4wHAYDVQQKExVNaWNyb3NvZnQgQ29ycG9yYXRpb24xLTArBgNVBAsT
# JE1pY3Jvc29mdCBJcmVsYW5kIE9wZXJhdGlvbnMgTGltaXRlZDEnMCUGA1UECxMe
# blNoaWVsZCBUU1MgRVNOOjJEMUEtMDVFMC1EOTQ3MSUwIwYDVQQDExxNaWNyb3Nv
# ZnQgVGltZS1TdGFtcCBTZXJ2aWNloiMKAQEwBwYFKw4DAhoDFQCiPRa1VVBQ1Iqi
# q2uOKdECwFR2g6CBgzCBgKR+MHwxCzAJBgNVBAYTAlVTMRMwEQYDVQQIEwpXYXNo
# aW5ndG9uMRAwDgYDVQQHEwdSZWRtb25kMR4wHAYDVQQKExVNaWNyb3NvZnQgQ29y
# cG9yYXRpb24xJjAkBgNVBAMTHU1pY3Jvc29mdCBUaW1lLVN0YW1wIFBDQSAyMDEw
# MA0GCSqGSIb3DQEBCwUAAgUA6s8HXzAiGA8yMDI0MTEwMTA3NTMwM1oYDzIwMjQx
# MTAyMDc1MzAzWjB3MD0GCisGAQQBhFkKBAExLzAtMAoCBQDqzwdfAgEAMAoCAQAC
# AgOpAgH/MAcCAQACAhMSMAoCBQDq0FjfAgEAMDYGCisGAQQBhFkKBAIxKDAmMAwG
# CisGAQQBhFkKAwKgCjAIAgEAAgMHoSChCjAIAgEAAgMBhqAwDQYJKoZIhvcNAQEL
# BQADggEBAELGa/6Wnp7x7djmWm35CawSD1D5zDnpOequVIyz4uJ7y5YAlXHhESQ2
# Zabdit9ywEaqAhsS/cIrVD1NmQgO0yBRE11HyRgZeauFaBvchDLKsDSHSbTwK+rQ
# zaQhVdpBhsjSPR4fH7jcq9zh6VrPbkdR+xloizi52sPnLj+jtsFnIXNTCQUlMS5j
# jRJviPdBFcP0h48RAw5YcIyhsUoHgiYP9Bj5zrNOEXZ3gf13E0XntnKeRl2SWMjm
# 6KclN+VrAn3RmErhohWVVaifyxj2CZd20WCSG9RcyjLT5FQe2PC5tNZ0Foh/joRs
# 39yiYSWl6wGyLCKTb+mocFOG2F6+JrYxggQNMIIECQIBATCBkzB8MQswCQYDVQQG
# EwJVUzETMBEGA1UECBMKV2FzaGluZ3RvbjEQMA4GA1UEBxMHUmVkbW9uZDEeMBwG
# A1UEChMVTWljcm9zb2Z0IENvcnBvcmF0aW9uMSYwJAYDVQQDEx1NaWNyb3NvZnQg
# VGltZS1TdGFtcCBQQ0EgMjAxMAITMwAAAf1z+WhazQxh7QABAAAB/TANBglghkgB
# ZQMEAgEFAKCCAUowGgYJKoZIhvcNAQkDMQ0GCyqGSIb3DQEJEAEEMC8GCSqGSIb3
# DQEJBDEiBCCaPQ6xEBILHbhb7ah5Ibg6q21EkYpBQaZ9EIFE51Bp+jCB+gYLKoZI
# hvcNAQkQAi8xgeowgecwgeQwgb0EIIAoSA3JSjC8h/H94N9hK6keR4XWnoYXCMoG
# zyVEHg1HMIGYMIGApH4wfDELMAkGA1UEBhMCVVMxEzARBgNVBAgTCldhc2hpbmd0
# b24xEDAOBgNVBAcTB1JlZG1vbmQxHjAcBgNVBAoTFU1pY3Jvc29mdCBDb3Jwb3Jh
# dGlvbjEmMCQGA1UEAxMdTWljcm9zb2Z0IFRpbWUtU3RhbXAgUENBIDIwMTACEzMA
# AAH9c/loWs0MYe0AAQAAAf0wIgQgwiOuHVK/XXWrAFa+Stltgn3e0DyLHYVLVWNL
# sDU0AL0wDQYJKoZIhvcNAQELBQAEggIALBk7l1Q3HbYZa3A05RJ50iNLZzMC5nK+
# V9rWMYiZbTKzNJAz3mcxovLeumX6Nrld29+0D7n14leSr0vR8wSBcHy5eAKh49FT
# ZyxOGcVPuUMxkub84wWu0NGSEgK0ByH7Nbtxp/OwFmu9EuLxTzKCUsLJpRmrCYMd
# Mm0hvgPNrrOyWNc6RUEtwx0jI+Fbyw6ZMzi2EgnXSs54j2QnAmX9aspB2coPGMvu
# +m0vJmhtzOdmmpS26d3f8WtEuEZRv2SulwrfkhKp2j4dIOEaI6d6QcUTbH2d1Ocm
# LIk3xkpf9demXKcqAqr/hudth4EgT/Hp20xtEV4bweHlUY/tHG/i8yotu0Hg81jO
# R8IwbbF5SSQa2XkBBVS2nJunmhgot1HOZlJKmpfqnaWPkELSUhSqyk6sf9bimBBK
# 9azcyOESt/8JJqr0FN+ghbI5AicF1UobF8WmtXflvmpOcXk+m5gTJwhXirpIFHyv
# tfEyyAJJJGsWUXC7Y5E3FHX3xmTl1hH0Dwaj+xuTsp8tMDlYdNpYSSnO58IUGv7a
# vjpWCJnRejGwBtu9AsGz/WbYfTj22TyjFtSUZkaKXhXCumK+fA3CUtO8mR+WF+w3
# roJ4M4bvfDUj9/tJ9eCmYIBLF8Ox0CKHnAhC++Jy43X5uSIMGMmszVRuF5icZRbm
# +cBDaUiPsTs=
# SIG # End signature block
