
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
Removes key credentials or password credentials for an application.
.Description
Removes key credentials or password credentials for an application.
.Link
https://learn.microsoft.com/powershell/module/az.resources/Remove-azadappcredential
#>

function Remove-AzADAppCredential {
    [OutputType([System.Boolean])]
    [CmdletBinding(DefaultParameterSetName='ApplicationObjectIdWithKeyIdParameterSet', PositionalBinding=$false, SupportsShouldProcess, ConfirmImpact='Medium')]
    param(
        [Parameter(ParameterSetName='ApplicationObjectIdWithKeyIdParameterSet', Mandatory, HelpMessage = "The object Id of application.")]
        [Alias('Id')]
        [Microsoft.Azure.PowerShell.Cmdlets.Resources.MSGraph.Category('Body')]
        [System.String]
        ${ObjectId},

        [Parameter(ParameterSetName='ApplicationIdWithKeyIdParameterSet', Mandatory, HelpMessage = "The application Id.")]
        [Microsoft.Azure.PowerShell.Cmdlets.Resources.MSGraph.Category('Body')]
        [System.Guid]
        ${ApplicationId},

        [Parameter(ParameterSetName='ApplicationDisplayNameParameterSet', Mandatory, HelpMessage = "The display name of application.")]
        [Microsoft.Azure.PowerShell.Cmdlets.Resources.MSGraph.Category('Body')]
        [System.String]
        ${DisplayName},

        [Parameter(ParameterSetName='ApplicationObjectWithKeyIdParameterSet', Mandatory, ValueFromPipeline, HelpMessage = "The application object, could be used as pipeline input.")]
        [Microsoft.Azure.PowerShell.Cmdlets.Resources.MSGraph.Category('Body')]
        [Microsoft.Azure.PowerShell.Cmdlets.Resources.MSGraph.Models.ApiV10.IMicrosoftGraphApplication]
        ${ApplicationObject},

        [Parameter(HelpMessage = "The key Id of credentials to be removed.")]
        [Microsoft.Azure.PowerShell.Cmdlets.Resources.MSGraph.Category('Body')]
        [System.Guid]
        ${KeyId},

        [Parameter()]
        [Alias("AzContext", "AzureRmContext", "AzureCredential")]
        [ValidateNotNull()]
        [Microsoft.Azure.PowerShell.Cmdlets.Resources.MSGraph.Category('Azure')]
        [System.Management.Automation.PSObject]
        # The credentials, account, tenant, and subscription used for communication with Azure.
        ${DefaultProfile},
    
        [Parameter(DontShow)]
        [Microsoft.Azure.PowerShell.Cmdlets.Resources.MSGraph.Category('Runtime')]
        [System.Management.Automation.SwitchParameter]
        # Wait for .NET debugger to attach
        ${Break},

        [Parameter()]
        [Microsoft.Azure.PowerShell.Cmdlets.Resources.MSGraph.Category('Runtime')]
        [System.Management.Automation.SwitchParameter]
        # Returns true when the command succeeds
        ${PassThru},
    
        [Parameter(DontShow)]
        [ValidateNotNull()]
        [Microsoft.Azure.PowerShell.Cmdlets.Resources.MSGraph.Category('Runtime')]
        [Microsoft.Azure.PowerShell.Cmdlets.Resources.MSGraph.Runtime.SendAsyncStep[]]
        # SendAsync Pipeline Steps to be appended to the front of the pipeline
        ${HttpPipelineAppend},
    
        [Parameter(DontShow)]
        [ValidateNotNull()]
        [Microsoft.Azure.PowerShell.Cmdlets.Resources.MSGraph.Category('Runtime')]
        [Microsoft.Azure.PowerShell.Cmdlets.Resources.MSGraph.Runtime.SendAsyncStep[]]
        # SendAsync Pipeline Steps to be prepended to the front of the pipeline
        ${HttpPipelinePrepend},
    
        [Parameter(DontShow)]
        [Microsoft.Azure.PowerShell.Cmdlets.Resources.MSGraph.Category('Runtime')]
        [System.Uri]
        # The URI for the proxy server to use
        ${Proxy},
    
        [Parameter(DontShow)]
        [ValidateNotNull()]
        [Microsoft.Azure.PowerShell.Cmdlets.Resources.MSGraph.Category('Runtime')]
        [System.Management.Automation.PSCredential]
        # Credentials for a proxy server to use for the remote call
        ${ProxyCredential},
    
        [Parameter(DontShow)]
        [Microsoft.Azure.PowerShell.Cmdlets.Resources.MSGraph.Category('Runtime')]
        [System.Management.Automation.SwitchParameter]
        # Use the default credentials for the proxy
        ${ProxyUseDefaultCredentials}
      )
    
    process {
        if ($PSBoundParameters['PassThru']) {
            $shouldPassThru = $PSBoundParameters['PassThru']
            $null = $PSBoundParameters.Remove('PassThru')
          }

        $param = @{}
        switch ($PSCmdlet.ParameterSetName) {
            'ApplicationObjectIdWithKeyIdParameterSet' {
                $param['ObjectId'] = $PSBoundParameters['ObjectId']
                $null = $PSBoundParameters.Remove('ObjectId')
                break
            }
            'ApplicationIdWithKeyIdParameterSet' {
                $param['ApplicationId'] = $PSBoundParameters['ApplicationId']
                $null = $PSBoundParameters.Remove('ApplicationId')
                break
            }
            'ApplicationDisplayNameParameterSet' {
                $param['DisplayName'] = $PSBoundParameters['DisplayName']
                $null = $PSBoundParameters.Remove('DisplayName')
                break
            }
            'ApplicationObjectWithKeyIdParameterSet' {
                $param['ObjectId'] = $PSBoundParameters['ApplicationObject'].Id
                $null = $PSBoundParameters.Remove('ApplicationObject')
                break
            }
            default {
                break
            }
        }
        $app = Get-AzADApplication @param
        if (!$PSBoundParameters['KeyId']) {
            $PSBoundParameters['Id'] = $app.Id
            $PSBoundParameters['KeyCredentials'] = @()
            Az.MSGraph.internal\Update-AzADApplication @PSBoundParameters
            $null = $PSBoundParameters.Remove('KeyCredentials')
            $null = $PSBoundParameters.Remove('Id')
            $PSBoundParameters['ApplicationId'] = $app.Id
            foreach ($password in $app.PasswordCredentials) {
                $PSBoundParameters['KeyId'] = $password.KeyId
                Az.MSGraph.internal\Remove-AzADApplicationPassword @PSBoundParameters
            }
        } else {
            $list = @()
            foreach ($key in $app.KeyCredentials) {
                if ($PSBoundParameters['KeyId'] -ne $key.KeyId) {
                    $list += $key
                }
            }
            if ($list.Count -ne $app.KeyCredentials.Count) {
                $null = $PSBoundParameters.Remove('KeyId')
                $PSBoundParameters['Id'] = $app.Id
                $PSBoundParameters['KeyCredentials'] = $list
                Az.MSGraph.internal\Update-AzADApplication @PSBoundParameters
                $foundKey = $true
            } else {
                foreach ($password in $app.PasswordCredentials) {
                    if ($PSBoundParameters['KeyId'] -eq $password.KeyId) {
                        $PSBoundParameters['ApplicationId'] = $app.Id
                        Az.MSGraph.internal\Remove-AzADApplicationPassword @PSBoundParameters
                        $foundKey = $true
                        break
                    }
                }
            }
            if (!$foundKey) {
                Write-Error "application '$($app.Id)' does not contains credential with key id: '$($PSBoundParameters['KeyId'])'."
            }
        }
        if ($shouldPassThru) {
            $PSCmdlet.WriteObject($true)
        }
    }
}
# SIG # Begin signature block
# MIIoOgYJKoZIhvcNAQcCoIIoKzCCKCcCAQExDzANBglghkgBZQMEAgEFADB5Bgor
# BgEEAYI3AgEEoGswaTA0BgorBgEEAYI3AgEeMCYCAwEAAAQQH8w7YFlLCE63JNLG
# KX7zUQIBAAIBAAIBAAIBAAIBADAxMA0GCWCGSAFlAwQCAQUABCBdSWje67Txtuph
# gP8yuGGF8MqFVsHrQi5cfoGKqKhEw6CCDYUwggYDMIID66ADAgECAhMzAAAEA73V
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
# cVZOSEXAQsmbdlsKgEhr/Xmfwb1tbWrJUnMTDXpQzTGCGgswghoHAgEBMIGVMH4x
# CzAJBgNVBAYTAlVTMRMwEQYDVQQIEwpXYXNoaW5ndG9uMRAwDgYDVQQHEwdSZWRt
# b25kMR4wHAYDVQQKExVNaWNyb3NvZnQgQ29ycG9yYXRpb24xKDAmBgNVBAMTH01p
# Y3Jvc29mdCBDb2RlIFNpZ25pbmcgUENBIDIwMTECEzMAAAQDvdWVXQ87GK0AAAAA
# BAMwDQYJYIZIAWUDBAIBBQCgga4wGQYJKoZIhvcNAQkDMQwGCisGAQQBgjcCAQQw
# HAYKKwYBBAGCNwIBCzEOMAwGCisGAQQBgjcCARUwLwYJKoZIhvcNAQkEMSIEINN+
# Ay+e/Lese4J5n/BkKCuh65mNA4FbcCxhvDUiPjAwMEIGCisGAQQBgjcCAQwxNDAy
# oBSAEgBNAGkAYwByAG8AcwBvAGYAdKEagBhodHRwOi8vd3d3Lm1pY3Jvc29mdC5j
# b20wDQYJKoZIhvcNAQEBBQAEggEATys5sttbZAiHGY5b7ginpIzzHMCqc4B8uORI
# 8COpCe4jEXwYJda2fQBfzaQ/KjoPSLajjbhFtDkFa8WdUkqYIP6vyW9xgk1oe8Nd
# 2B2kd8PbBhqjCAXS1C/MwhbooMT2Q0G1LUC78ReAeg7ZPDy3vWLmSUAjXG4TROX6
# 9+0KJ1+H6e3WcrSVnyJjlY+zAqufBZ87mxvbrNFg22E50QSR9qD/zd3DgJFEunWQ
# vhWQKYFyJMnO5PxANfVcLWYh9zjeKUe92DdfTTc4WUQqfkQwp95FDbmN15qIig1D
# JeGn9WIss8C8AqjY5XiBmOtI709zknxdEtHqsyxlQZA7ZdODG6GCF5UwgheRBgor
# BgEEAYI3AwMBMYIXgTCCF30GCSqGSIb3DQEHAqCCF24wghdqAgEDMQ8wDQYJYIZI
# AWUDBAIBBQAwggFQBgsqhkiG9w0BCRABBKCCAT8EggE7MIIBNwIBAQYKKwYBBAGE
# WQoDATAxMA0GCWCGSAFlAwQCAQUABCBKw9wF3SKby0H+p1IA4ebgJFJ+dSDlIHI5
# syMOj//tKQIGZzXxQxY5GBEyMDI0MTExNTA1NTg0My41WjAEgAIB9KCB0aSBzjCB
# yzELMAkGA1UEBhMCVVMxEzARBgNVBAgTCldhc2hpbmd0b24xEDAOBgNVBAcTB1Jl
# ZG1vbmQxHjAcBgNVBAoTFU1pY3Jvc29mdCBDb3Jwb3JhdGlvbjElMCMGA1UECxMc
# TWljcm9zb2Z0IEFtZXJpY2EgT3BlcmF0aW9uczEnMCUGA1UECxMeblNoaWVsZCBU
# U1MgRVNOOjkyMDAtMDVFMC1EOTQ3MSUwIwYDVQQDExxNaWNyb3NvZnQgVGltZS1T
# dGFtcCBTZXJ2aWNloIIR7TCCByAwggUIoAMCAQICEzMAAAHnLo8vkwtPG+kAAQAA
# AecwDQYJKoZIhvcNAQELBQAwfDELMAkGA1UEBhMCVVMxEzARBgNVBAgTCldhc2hp
# bmd0b24xEDAOBgNVBAcTB1JlZG1vbmQxHjAcBgNVBAoTFU1pY3Jvc29mdCBDb3Jw
# b3JhdGlvbjEmMCQGA1UEAxMdTWljcm9zb2Z0IFRpbWUtU3RhbXAgUENBIDIwMTAw
# HhcNMjMxMjA2MTg0NTE5WhcNMjUwMzA1MTg0NTE5WjCByzELMAkGA1UEBhMCVVMx
# EzARBgNVBAgTCldhc2hpbmd0b24xEDAOBgNVBAcTB1JlZG1vbmQxHjAcBgNVBAoT
# FU1pY3Jvc29mdCBDb3Jwb3JhdGlvbjElMCMGA1UECxMcTWljcm9zb2Z0IEFtZXJp
# Y2EgT3BlcmF0aW9uczEnMCUGA1UECxMeblNoaWVsZCBUU1MgRVNOOjkyMDAtMDVF
# MC1EOTQ3MSUwIwYDVQQDExxNaWNyb3NvZnQgVGltZS1TdGFtcCBTZXJ2aWNlMIIC
# IjANBgkqhkiG9w0BAQEFAAOCAg8AMIICCgKCAgEAwlefL+CLkOufVzzNQ7WljL/f
# x0VAuZHYhBfPWAT+v0Z+5I6jJGeREnpn+RJYuAi7UFUnn0aRdY+0uSyyorDFjhkW
# i3GlWxk33JiNbzESdbczMAjSKAqv78vFh/EHVdQfwG+bCvkPciL8xsOO031zxPEZ
# a2rsCv3vp1p8DLdOtGpBGYiSc9VYdS4UmCmoj/WdtxGZhhEwlooJCm3LgJ4b4d8q
# zGvPbgX2nh0GRBxkKnbJDOPBAXFklnaYkkgYgMcoR1JG5J5fTz87Qf0lMc0WY1M1
# h4PW39ZqmdHCIgFgtBIyuzjYZUHykkR1SyizT6Zd//lC+F43NGL3anPPIDi1K//O
# E/f8Sua/Nrpb0adgPP2q/XBuFu+udLimgMUQJoC+ISoCF+f9GiALG8qiTmujiBkh
# fWvg315dS6UDzSke/drHBe7Yw+VqsCLon0vWFIhzL0S44ypNEkglf5qVwtAaD5JO
# WrH8a6yWwrCXjx0jhG5aSc0Zs2j+jjF8EXK2+01xUDrE5CrqpFr72CD71cwuvFDP
# jLJCz5XdXqnTjjCu0m239rRkmX9/ojsFkDHFlwfYMOYCtwCGCtPFpCSbssz6n4rY
# Lm3UQpmK/QlbDTrlvsBw2BoXIiQxdi5K45BVI1HF0iCXfX9rLGIrWfQrqxle+AUH
# H68Y75NS/I77Te5rpSMCAwEAAaOCAUkwggFFMB0GA1UdDgQWBBTP/uCYgJ82OHaR
# H/2Za4dSu96PWDAfBgNVHSMEGDAWgBSfpxVdAF5iXYP05dJlpxtTNRnpcjBfBgNV
# HR8EWDBWMFSgUqBQhk5odHRwOi8vd3d3Lm1pY3Jvc29mdC5jb20vcGtpb3BzL2Ny
# bC9NaWNyb3NvZnQlMjBUaW1lLVN0YW1wJTIwUENBJTIwMjAxMCgxKS5jcmwwbAYI
# KwYBBQUHAQEEYDBeMFwGCCsGAQUFBzAChlBodHRwOi8vd3d3Lm1pY3Jvc29mdC5j
# b20vcGtpb3BzL2NlcnRzL01pY3Jvc29mdCUyMFRpbWUtU3RhbXAlMjBQQ0ElMjAy
# MDEwKDEpLmNydDAMBgNVHRMBAf8EAjAAMBYGA1UdJQEB/wQMMAoGCCsGAQUFBwMI
# MA4GA1UdDwEB/wQEAwIHgDANBgkqhkiG9w0BAQsFAAOCAgEAdKHw25PpZVotXAup
# 7H4nuSbadPaOm+gEQqb7Qz6tihT/oYvlDTT+yxnIirnJKlwpgUxSIXwXhksb5Osn
# KJHUK9/NeaRDmmFk5x70NPvISsvOq9ReK3wbuKBweXE8tPE+KIaxvzmBvwf4DZ89
# Dper+7v6hI8+PM12emZcShsmcCpimVmgXdg2BMMyqXS5AcbOgOnp1mUdI2PquRXW
# 1eOYIRkyoEq+RAgDpyw+J4ycH4yKtJkWVsA2UKF7SUmlR0rtpR0C92BxBYpLp21E
# yXzXwQyy+xr/rE5kYg2ZMuTgMaCxtoGk37ohW36Zknz3IJeQjlM3zEJ86Sn1+vhZ
# CNEEDb7j6VrA1PLEfrp4tlZg6O65qia6JuIoYFTXS2jHzVKrwS+WYkitc5mhCwSf
# WvmDoxOaZkmq1ubBm5+4lZBdlvSUCDh+rRlixSUuR7N+s2oZKB4fIg/ety3ho2ap
# BbrCmlFu9sjI/8sU3hhAzqCK9+ZMF8a9VLvs5Lq9svhbjWNKGY6ac6feQFtZXoT9
# MWjvqAVdV372grq/weT1QKdsc66LDBFHAMKSaYqPlWHyLnxo+5nl3BkGFgPFJq/C
# ugLqPiZY/CHhUupUryoakKZnQcwDBqjzkCrdTsN2V8XoSu7wIopt2YgC5TNCueOp
# NLGa8XWT4KZs+zvMPYBy7smQEHswggdxMIIFWaADAgECAhMzAAAAFcXna54Cm0mZ
# AAAAAAAVMA0GCSqGSIb3DQEBCwUAMIGIMQswCQYDVQQGEwJVUzETMBEGA1UECBMK
# V2FzaGluZ3RvbjEQMA4GA1UEBxMHUmVkbW9uZDEeMBwGA1UEChMVTWljcm9zb2Z0
# IENvcnBvcmF0aW9uMTIwMAYDVQQDEylNaWNyb3NvZnQgUm9vdCBDZXJ0aWZpY2F0
# ZSBBdXRob3JpdHkgMjAxMDAeFw0yMTA5MzAxODIyMjVaFw0zMDA5MzAxODMyMjVa
# MHwxCzAJBgNVBAYTAlVTMRMwEQYDVQQIEwpXYXNoaW5ndG9uMRAwDgYDVQQHEwdS
# ZWRtb25kMR4wHAYDVQQKExVNaWNyb3NvZnQgQ29ycG9yYXRpb24xJjAkBgNVBAMT
# HU1pY3Jvc29mdCBUaW1lLVN0YW1wIFBDQSAyMDEwMIICIjANBgkqhkiG9w0BAQEF
# AAOCAg8AMIICCgKCAgEA5OGmTOe0ciELeaLL1yR5vQ7VgtP97pwHB9KpbE51yMo1
# V/YBf2xK4OK9uT4XYDP/XE/HZveVU3Fa4n5KWv64NmeFRiMMtY0Tz3cywBAY6GB9
# alKDRLemjkZrBxTzxXb1hlDcwUTIcVxRMTegCjhuje3XD9gmU3w5YQJ6xKr9cmmv
# Haus9ja+NSZk2pg7uhp7M62AW36MEBydUv626GIl3GoPz130/o5Tz9bshVZN7928
# jaTjkY+yOSxRnOlwaQ3KNi1wjjHINSi947SHJMPgyY9+tVSP3PoFVZhtaDuaRr3t
# pK56KTesy+uDRedGbsoy1cCGMFxPLOJiss254o2I5JasAUq7vnGpF1tnYN74kpEe
# HT39IM9zfUGaRnXNxF803RKJ1v2lIH1+/NmeRd+2ci/bfV+AutuqfjbsNkz2K26o
# ElHovwUDo9Fzpk03dJQcNIIP8BDyt0cY7afomXw/TNuvXsLz1dhzPUNOwTM5TI4C
# vEJoLhDqhFFG4tG9ahhaYQFzymeiXtcodgLiMxhy16cg8ML6EgrXY28MyTZki1ug
# poMhXV8wdJGUlNi5UPkLiWHzNgY1GIRH29wb0f2y1BzFa/ZcUlFdEtsluq9QBXps
# xREdcu+N+VLEhReTwDwV2xo3xwgVGD94q0W29R6HXtqPnhZyacaue7e3PmriLq0C
# AwEAAaOCAd0wggHZMBIGCSsGAQQBgjcVAQQFAgMBAAEwIwYJKwYBBAGCNxUCBBYE
# FCqnUv5kxJq+gpE8RjUpzxD/LwTuMB0GA1UdDgQWBBSfpxVdAF5iXYP05dJlpxtT
# NRnpcjBcBgNVHSAEVTBTMFEGDCsGAQQBgjdMg30BATBBMD8GCCsGAQUFBwIBFjNo
# dHRwOi8vd3d3Lm1pY3Jvc29mdC5jb20vcGtpb3BzL0RvY3MvUmVwb3NpdG9yeS5o
# dG0wEwYDVR0lBAwwCgYIKwYBBQUHAwgwGQYJKwYBBAGCNxQCBAweCgBTAHUAYgBD
# AEEwCwYDVR0PBAQDAgGGMA8GA1UdEwEB/wQFMAMBAf8wHwYDVR0jBBgwFoAU1fZW
# y4/oolxiaNE9lJBb186aGMQwVgYDVR0fBE8wTTBLoEmgR4ZFaHR0cDovL2NybC5t
# aWNyb3NvZnQuY29tL3BraS9jcmwvcHJvZHVjdHMvTWljUm9vQ2VyQXV0XzIwMTAt
# MDYtMjMuY3JsMFoGCCsGAQUFBwEBBE4wTDBKBggrBgEFBQcwAoY+aHR0cDovL3d3
# dy5taWNyb3NvZnQuY29tL3BraS9jZXJ0cy9NaWNSb29DZXJBdXRfMjAxMC0wNi0y
# My5jcnQwDQYJKoZIhvcNAQELBQADggIBAJ1VffwqreEsH2cBMSRb4Z5yS/ypb+pc
# FLY+TkdkeLEGk5c9MTO1OdfCcTY/2mRsfNB1OW27DzHkwo/7bNGhlBgi7ulmZzpT
# Td2YurYeeNg2LpypglYAA7AFvonoaeC6Ce5732pvvinLbtg/SHUB2RjebYIM9W0j
# VOR4U3UkV7ndn/OOPcbzaN9l9qRWqveVtihVJ9AkvUCgvxm2EhIRXT0n4ECWOKz3
# +SmJw7wXsFSFQrP8DJ6LGYnn8AtqgcKBGUIZUnWKNsIdw2FzLixre24/LAl4FOmR
# sqlb30mjdAy87JGA0j3mSj5mO0+7hvoyGtmW9I/2kQH2zsZ0/fZMcm8Qq3UwxTSw
# ethQ/gpY3UA8x1RtnWN0SCyxTkctwRQEcb9k+SS+c23Kjgm9swFXSVRk2XPXfx5b
# RAGOWhmRaw2fpCjcZxkoJLo4S5pu+yFUa2pFEUep8beuyOiJXk+d0tBMdrVXVAmx
# aQFEfnyhYWxz/gq77EFmPWn9y8FBSX5+k77L+DvktxW/tM4+pTFRhLy/AsGConsX
# HRWJjXD+57XQKBqJC4822rpM+Zv/Cuk0+CQ1ZyvgDbjmjJnW4SLq8CdCPSWU5nR0
# W2rRnj7tfqAxM328y+l7vzhwRNGQ8cirOoo6CGJ/2XBjU02N7oJtpQUQwXEGahC0
# HVUzWLOhcGbyoYIDUDCCAjgCAQEwgfmhgdGkgc4wgcsxCzAJBgNVBAYTAlVTMRMw
# EQYDVQQIEwpXYXNoaW5ndG9uMRAwDgYDVQQHEwdSZWRtb25kMR4wHAYDVQQKExVN
# aWNyb3NvZnQgQ29ycG9yYXRpb24xJTAjBgNVBAsTHE1pY3Jvc29mdCBBbWVyaWNh
# IE9wZXJhdGlvbnMxJzAlBgNVBAsTHm5TaGllbGQgVFNTIEVTTjo5MjAwLTA1RTAt
# RDk0NzElMCMGA1UEAxMcTWljcm9zb2Z0IFRpbWUtU3RhbXAgU2VydmljZaIjCgEB
# MAcGBSsOAwIaAxUAs3IE5xmrEsHv3a7vnD3tTRf78EOggYMwgYCkfjB8MQswCQYD
# VQQGEwJVUzETMBEGA1UECBMKV2FzaGluZ3RvbjEQMA4GA1UEBxMHUmVkbW9uZDEe
# MBwGA1UEChMVTWljcm9zb2Z0IENvcnBvcmF0aW9uMSYwJAYDVQQDEx1NaWNyb3Nv
# ZnQgVGltZS1TdGFtcCBQQ0EgMjAxMDANBgkqhkiG9w0BAQsFAAIFAOrhGGowIhgP
# MjAyNDExMTUwMDQ2MzRaGA8yMDI0MTExNjAwNDYzNFowdzA9BgorBgEEAYRZCgQB
# MS8wLTAKAgUA6uEYagIBADAKAgEAAgIHkwIB/zAHAgEAAgIS7TAKAgUA6uJp6gIB
# ADA2BgorBgEEAYRZCgQCMSgwJjAMBgorBgEEAYRZCgMCoAowCAIBAAIDB6EgoQow
# CAIBAAIDAYagMA0GCSqGSIb3DQEBCwUAA4IBAQAMcIDlNbEkB4Gu7P6oYenbnYDG
# gVYWgGZas6uYAlzbJNfGE6B/BKPK9Rz8YIABgjg4y6OepBT3jU0MlDSFWZCpv8Zi
# 80MgZnIqMc5//IpY+l1nkCBjZyAIZBGq/FCKysIa8vnuaUqmfSTowB9n0vHHCxZQ
# uT/11pslMEN9ohsKd/8ksveJwV2HNXZkZT5ldek6iJ7F+MM8yQIRQcmRuNGRRRnm
# 4SdvvLvYIFyKRs6CjinUpt/cNL9awtenuFeBTygHtxPoWezaNORdcg3wXoLsEsxB
# rw8S/X0dFN7EX6VtrY3fyRwCcn0oWOmgFp99y79uMSovRzKpgrs4TcJFeNeDMYIE
# DTCCBAkCAQEwgZMwfDELMAkGA1UEBhMCVVMxEzARBgNVBAgTCldhc2hpbmd0b24x
# EDAOBgNVBAcTB1JlZG1vbmQxHjAcBgNVBAoTFU1pY3Jvc29mdCBDb3Jwb3JhdGlv
# bjEmMCQGA1UEAxMdTWljcm9zb2Z0IFRpbWUtU3RhbXAgUENBIDIwMTACEzMAAAHn
# Lo8vkwtPG+kAAQAAAecwDQYJYIZIAWUDBAIBBQCgggFKMBoGCSqGSIb3DQEJAzEN
# BgsqhkiG9w0BCRABBDAvBgkqhkiG9w0BCQQxIgQgF6iZ/FweqVGMqjWVmGqZQGRV
# NxBkhNggFEPMO0Pj6y8wgfoGCyqGSIb3DQEJEAIvMYHqMIHnMIHkMIG9BCDlNl0N
# dmqG/Q3gxVzPVBR3hF++Bb9AAb0DBu6gudZzrTCBmDCBgKR+MHwxCzAJBgNVBAYT
# AlVTMRMwEQYDVQQIEwpXYXNoaW5ndG9uMRAwDgYDVQQHEwdSZWRtb25kMR4wHAYD
# VQQKExVNaWNyb3NvZnQgQ29ycG9yYXRpb24xJjAkBgNVBAMTHU1pY3Jvc29mdCBU
# aW1lLVN0YW1wIFBDQSAyMDEwAhMzAAAB5y6PL5MLTxvpAAEAAAHnMCIEIKADlx/j
# I55zYwoeS+JRJiZNixmF+PCt78oSOw0GTsxBMA0GCSqGSIb3DQEBCwUABIICAAFC
# LMNKRPPzoUyM3KbvQqHP//xj1lqXph9cuqjiwKLMoEI2/fOnixHJ8/UoF0Sy14iw
# Rz2L8s6k2ZAngfyhLMyrx8ThVIi4D7z9mKDAE+FEm7ru0g8Vru3JsQKZILxnOfLy
# fTdsgiiQ2GVn52NuIvg9ZUjnq3VG8iytTeBx93AzVKZYAobLwDoRGdP7GPsJ34wO
# 7sVa8Bx+83fGwzZ7Te7FXJxJuVzF/HlU0XW9foT03aXxqNb5zfFglcbiWjRkz5Vn
# tU1ZM4ncfnERkyxA1xr0bod7CSwAoGz1YqJabZiOryErgv8iAMvMoc/AbrBXMAru
# wfHAzdRJ+4BSdTm3LGHnEOFA9Nc9fXj0+R4thT9dX9WLO1AlvDMs3jhKIQKM+i3o
# 1eEJUUfnfOK1dHppVPILNgkmLoaxrkc+QiETxtNDLA9bj8VJdmNtLNVRuWr9PSFc
# lsu+FmZYnpDeaZMLBjTai0b9rHat7Vfz1H5QRnF1f7cEoEfU/7J5qhuXxFiVPXYq
# +czXPHONtW+ldfMxiqbDFqA7LqXRlqKdniaI2vHVlQwIPQ3kH5mJWa/8hq2xYG3u
# cD4A5YpIAYn3u/VmG5ctOXDT58hLeeWvA0Wb4w27ZudLVVFc9+ciAJdV4mz1Unih
# FaRWxD3IitNYjwWH4NuE7FS83U2NeFZvPIHBI/R4
# SIG # End signature block
