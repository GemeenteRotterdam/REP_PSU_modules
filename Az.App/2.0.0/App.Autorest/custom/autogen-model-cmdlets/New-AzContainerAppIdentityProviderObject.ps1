
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
Create an in-memory object for IdentityProviders.
.Description
Create an in-memory object for IdentityProviders.

.Outputs
Microsoft.Azure.PowerShell.Cmdlets.App.Models.IdentityProviders
.Link
https://learn.microsoft.com/powershell/module/Az.App/new-azcontainerappidentityproviderobject
#>
function New-AzContainerAppIdentityProviderObject {
    [OutputType('Microsoft.Azure.PowerShell.Cmdlets.App.Models.IdentityProviders')]
    [CmdletBinding(PositionalBinding=$false)]
    Param(

        [Parameter(HelpMessage="The list of the allowed groups.")]
        [string[]]
        $AllowedPrincipalGroup,
        [Parameter(HelpMessage="The list of the allowed identities.")]
        [string[]]
        $AllowedPrincipalIdentity,
        [Parameter(HelpMessage="<code>false</code> if the Apple provider should not be enabled despite the set registration; otherwise, <code>true</code>.")]
        [bool]
        $AppleEnabled,
        [Parameter(HelpMessage="A list of the scopes that should be requested while authenticating.")]
        [string[]]
        $AppleLoginScope,
        [Parameter(HelpMessage="The Client ID of the app used for login.")]
        [string]
        $AppleRegistrationClientId,
        [Parameter(HelpMessage="The app setting name that contains the client secret.")]
        [string]
        $AppleRegistrationClientSecretSettingName,
        [Parameter(HelpMessage="<code>false</code> if the Azure Active Directory provider should not be enabled despite the set registration; otherwise, <code>true</code>.")]
        [bool]
        $AzureActiveDirectoryEnabled,
        [Parameter(HelpMessage="Gets a value indicating whether the Azure AD configuration was auto-provisioned using 1st party tooling.
        This is an internal flag primarily intended to support the Azure Management Portal. Users should not
        read or write to this property.")]
        [bool]
        $AzureActiveDirectoryIsAutoProvisioned,
        [Parameter(HelpMessage="The Client ID of this relying party application, known as the client_id.
        This setting is required for enabling OpenID Connection authentication with Azure Active Directory or
        other 3rd party OpenID Connect providers.
        More information on OpenID Connect: http://openid.net/specs/openid-connect-core-1_0.html.")]
        [string]
        $AzureActiveDirectoryRegistrationClientId,
        [Parameter(HelpMessage="The app setting name that contains the client secret of the relying party application.")]
        [string]
        $AzureActiveDirectoryRegistrationClientSecretSettingName,
        [Parameter(HelpMessage="The list of audiences that can make successful authentication/authorization requests.")]
        [string[]]
        $AzureActiveDirectoryValidationAllowedAudience,
        [Parameter(HelpMessage="<code>false</code> if the Azure Static Web Apps provider should not be enabled despite the set registration; otherwise, <code>true</code>.")]
        [bool]
        $AzureStaticWebAppEnabled,
        [Parameter(HelpMessage="The Client ID of the app used for login.")]
        [string]
        $AzureStaticWebAppsRegistrationClientId,
        [Parameter(HelpMessage="The map of the name of the alias of each custom Open ID Connect provider to the
        configuration settings of the custom Open ID Connect provider.")]
        [Microsoft.Azure.PowerShell.Cmdlets.App.Models.IIdentityProvidersCustomOpenIdConnectProviders]
        $CustomOpenIdConnectProvider,
        [Parameter(HelpMessage="The configuration settings of the Azure Active Directory allowed applications.")]
        [string[]]
        $DefaultAuthorizationPolicyAllowedApplication,
        [Parameter(HelpMessage="<code>false</code> if the Facebook provider should not be enabled despite the set registration; otherwise, <code>true</code>.")]
        [bool]
        $FacebookEnabled,
        [Parameter(HelpMessage="The version of the Facebook api to be used while logging in.")]
        [string]
        $FacebookGraphApiVersion,
        [Parameter(HelpMessage="A list of the scopes that should be requested while authenticating.")]
        [string[]]
        $FacebookLoginScope,
        [Parameter(HelpMessage="<code>false</code> if the GitHub provider should not be enabled despite the set registration; otherwise, <code>true</code>.")]
        [bool]
        $GitHubEnabled,
        [Parameter(HelpMessage="A list of the scopes that should be requested while authenticating.")]
        [string[]]
        $GitHubLoginScope,
        [Parameter(HelpMessage="The Client ID of the app used for login.")]
        [string]
        $GitHubRegistrationClientId,
        [Parameter(HelpMessage="The app setting name that contains the client secret.")]
        [string]
        $GitHubRegistrationClientSecretSettingName,
        [Parameter(HelpMessage="<code>false</code> if the Google provider should not be enabled despite the set registration; otherwise, <code>true</code>.")]
        [bool]
        $GoogleEnabled,
        [Parameter(HelpMessage="A list of the scopes that should be requested while authenticating.")]
        [string[]]
        $GoogleLoginScope,
        [Parameter(HelpMessage="The Client ID of the app used for login.")]
        [string]
        $GoogleRegistrationClientId,
        [Parameter(HelpMessage="The app setting name that contains the client secret.")]
        [string]
        $GoogleRegistrationClientSecretSettingName,
        [Parameter(HelpMessage="The configuration settings of the allowed list of audiences from which to validate the JWT token.")]
        [string[]]
        $GoogleValidationAllowedAudience,
        [Parameter(HelpMessage="The list of the allowed client applications.")]
        [string[]]
        $JwtClaimCheckAllowedClientApplication,
        [Parameter(HelpMessage="The list of the allowed groups.")]
        [string[]]
        $JwtClaimCheckAllowedGroup,
        [Parameter(HelpMessage="<code>true</code> if the www-authenticate provider should be omitted from the request; otherwise, <code>false</code>.")]
        [bool]
        $LoginDisableWwwAuthenticate,
        [Parameter(HelpMessage="Login parameters to send to the OpenID Connect authorization endpoint when
        a user logs in. Each parameter must be in the form `"key=value`".")]
        [string[]]
        $LoginParameter,
        [Parameter(HelpMessage="The App ID of the app used for login.")]
        [string]
        $RegistrationAppId,
        [Parameter(HelpMessage="The app setting name that contains the app secret.")]
        [string]
        $RegistrationAppSecretSettingName,
        [Parameter(HelpMessage="An alternative to the client secret thumbprint, that is the issuer of a certificate used for signing purposes. This property acts as
        a replacement for the Client Secret Certificate Thumbprint. It is also optional.")]
        [string]
        $RegistrationClientSecretCertificateIssuer,
        [Parameter(HelpMessage="An alternative to the client secret thumbprint, that is the subject alternative name of a certificate used for signing purposes. This property acts as
        a replacement for the Client Secret Certificate Thumbprint. It is also optional.")]
        [string]
        $RegistrationClientSecretCertificateSubjectAlternativeName,
        [Parameter(HelpMessage="An alternative to the client secret, that is the thumbprint of a certificate used for signing purposes. This property acts as
        a replacement for the Client Secret. It is also optional.")]
        [string]
        $RegistrationClientSecretCertificateThumbprint,
        [Parameter(HelpMessage="The OAuth 1.0a consumer key of the Twitter application used for sign-in.
        This setting is required for enabling Twitter Sign-In.
        Twitter Sign-In documentation: https://dev.twitter.com/web/sign-in.")]
        [string]
        $RegistrationConsumerKey,
        [Parameter(HelpMessage="The app setting name that contains the OAuth 1.0a consumer secret of the Twitter
        application used for sign-in.")]
        [string]
        $RegistrationConsumerSecretSettingName,
        [Parameter(HelpMessage="The OpenID Connect Issuer URI that represents the entity which issues access tokens for this application.
        When using Azure Active Directory, this value is the URI of the directory tenant, e.g. https://login.microsoftonline.com/v2.0/{tenant-guid}/.
        This URI is a case-sensitive identifier for the token issuer.
        More information on OpenID Connect Discovery: http://openid.net/specs/openid-connect-discovery-1_0.html.")]
        [string]
        $RegistrationOpenIdIssuer,
        [Parameter(HelpMessage="<code>false</code> if the Twitter provider should not be enabled despite the set registration; otherwise, <code>true</code>.")]
        [bool]
        $TwitterEnabled
    )

    process {
        $Object = [Microsoft.Azure.PowerShell.Cmdlets.App.Models.IdentityProviders]::New()

        if ($PSBoundParameters.ContainsKey('AllowedPrincipalGroup')) {
            $Object.AllowedPrincipalGroup = $AllowedPrincipalGroup
        }
        if ($PSBoundParameters.ContainsKey('AllowedPrincipalIdentity')) {
            $Object.AllowedPrincipalIdentity = $AllowedPrincipalIdentity
        }
        if ($PSBoundParameters.ContainsKey('AppleEnabled')) {
            $Object.AppleEnabled = $AppleEnabled
        }
        if ($PSBoundParameters.ContainsKey('AppleLoginScope')) {
            $Object.AppleLoginScope = $AppleLoginScope
        }
        if ($PSBoundParameters.ContainsKey('AppleRegistrationClientId')) {
            $Object.AppleRegistrationClientId = $AppleRegistrationClientId
        }
        if ($PSBoundParameters.ContainsKey('AppleRegistrationClientSecretSettingName')) {
            $Object.AppleRegistrationClientSecretSettingName = $AppleRegistrationClientSecretSettingName
        }
        if ($PSBoundParameters.ContainsKey('AzureActiveDirectoryEnabled')) {
            $Object.AzureActiveDirectoryEnabled = $AzureActiveDirectoryEnabled
        }
        if ($PSBoundParameters.ContainsKey('AzureActiveDirectoryIsAutoProvisioned')) {
            $Object.AzureActiveDirectoryIsAutoProvisioned = $AzureActiveDirectoryIsAutoProvisioned
        }
        if ($PSBoundParameters.ContainsKey('AzureActiveDirectoryRegistrationClientId')) {
            $Object.AzureActiveDirectoryRegistrationClientId = $AzureActiveDirectoryRegistrationClientId
        }
        if ($PSBoundParameters.ContainsKey('AzureActiveDirectoryRegistrationClientSecretSettingName')) {
            $Object.AzureActiveDirectoryRegistrationClientSecretSettingName = $AzureActiveDirectoryRegistrationClientSecretSettingName
        }
        if ($PSBoundParameters.ContainsKey('AzureActiveDirectoryValidationAllowedAudience')) {
            $Object.AzureActiveDirectoryValidationAllowedAudience = $AzureActiveDirectoryValidationAllowedAudience
        }
        if ($PSBoundParameters.ContainsKey('AzureStaticWebAppEnabled')) {
            $Object.AzureStaticWebAppEnabled = $AzureStaticWebAppEnabled
        }
        if ($PSBoundParameters.ContainsKey('AzureStaticWebAppsRegistrationClientId')) {
            $Object.AzureStaticWebAppsRegistrationClientId = $AzureStaticWebAppsRegistrationClientId
        }
        if ($PSBoundParameters.ContainsKey('CustomOpenIdConnectProvider')) {
            $Object.CustomOpenIdConnectProvider = $CustomOpenIdConnectProvider
        }
        if ($PSBoundParameters.ContainsKey('DefaultAuthorizationPolicyAllowedApplication')) {
            $Object.DefaultAuthorizationPolicyAllowedApplication = $DefaultAuthorizationPolicyAllowedApplication
        }
        if ($PSBoundParameters.ContainsKey('FacebookEnabled')) {
            $Object.FacebookEnabled = $FacebookEnabled
        }
        if ($PSBoundParameters.ContainsKey('FacebookGraphApiVersion')) {
            $Object.FacebookGraphApiVersion = $FacebookGraphApiVersion
        }
        if ($PSBoundParameters.ContainsKey('FacebookLoginScope')) {
            $Object.FacebookLoginScope = $FacebookLoginScope
        }
        if ($PSBoundParameters.ContainsKey('GitHubEnabled')) {
            $Object.GitHubEnabled = $GitHubEnabled
        }
        if ($PSBoundParameters.ContainsKey('GitHubLoginScope')) {
            $Object.GitHubLoginScope = $GitHubLoginScope
        }
        if ($PSBoundParameters.ContainsKey('GitHubRegistrationClientId')) {
            $Object.GitHubRegistrationClientId = $GitHubRegistrationClientId
        }
        if ($PSBoundParameters.ContainsKey('GitHubRegistrationClientSecretSettingName')) {
            $Object.GitHubRegistrationClientSecretSettingName = $GitHubRegistrationClientSecretSettingName
        }
        if ($PSBoundParameters.ContainsKey('GoogleEnabled')) {
            $Object.GoogleEnabled = $GoogleEnabled
        }
        if ($PSBoundParameters.ContainsKey('GoogleLoginScope')) {
            $Object.GoogleLoginScope = $GoogleLoginScope
        }
        if ($PSBoundParameters.ContainsKey('GoogleRegistrationClientId')) {
            $Object.GoogleRegistrationClientId = $GoogleRegistrationClientId
        }
        if ($PSBoundParameters.ContainsKey('GoogleRegistrationClientSecretSettingName')) {
            $Object.GoogleRegistrationClientSecretSettingName = $GoogleRegistrationClientSecretSettingName
        }
        if ($PSBoundParameters.ContainsKey('GoogleValidationAllowedAudience')) {
            $Object.GoogleValidationAllowedAudience = $GoogleValidationAllowedAudience
        }
        if ($PSBoundParameters.ContainsKey('JwtClaimCheckAllowedClientApplication')) {
            $Object.JwtClaimCheckAllowedClientApplication = $JwtClaimCheckAllowedClientApplication
        }
        if ($PSBoundParameters.ContainsKey('JwtClaimCheckAllowedGroup')) {
            $Object.JwtClaimCheckAllowedGroup = $JwtClaimCheckAllowedGroup
        }
        if ($PSBoundParameters.ContainsKey('LoginDisableWwwAuthenticate')) {
            $Object.LoginDisableWwwAuthenticate = $LoginDisableWwwAuthenticate
        }
        if ($PSBoundParameters.ContainsKey('LoginParameter')) {
            $Object.LoginParameter = $LoginParameter
        }
        if ($PSBoundParameters.ContainsKey('RegistrationAppId')) {
            $Object.RegistrationAppId = $RegistrationAppId
        }
        if ($PSBoundParameters.ContainsKey('RegistrationAppSecretSettingName')) {
            $Object.RegistrationAppSecretSettingName = $RegistrationAppSecretSettingName
        }
        if ($PSBoundParameters.ContainsKey('RegistrationClientSecretCertificateIssuer')) {
            $Object.RegistrationClientSecretCertificateIssuer = $RegistrationClientSecretCertificateIssuer
        }
        if ($PSBoundParameters.ContainsKey('RegistrationClientSecretCertificateSubjectAlternativeName')) {
            $Object.RegistrationClientSecretCertificateSubjectAlternativeName = $RegistrationClientSecretCertificateSubjectAlternativeName
        }
        if ($PSBoundParameters.ContainsKey('RegistrationClientSecretCertificateThumbprint')) {
            $Object.RegistrationClientSecretCertificateThumbprint = $RegistrationClientSecretCertificateThumbprint
        }
        if ($PSBoundParameters.ContainsKey('RegistrationConsumerKey')) {
            $Object.RegistrationConsumerKey = $RegistrationConsumerKey
        }
        if ($PSBoundParameters.ContainsKey('RegistrationConsumerSecretSettingName')) {
            $Object.RegistrationConsumerSecretSettingName = $RegistrationConsumerSecretSettingName
        }
        if ($PSBoundParameters.ContainsKey('RegistrationOpenIdIssuer')) {
            $Object.RegistrationOpenIdIssuer = $RegistrationOpenIdIssuer
        }
        if ($PSBoundParameters.ContainsKey('TwitterEnabled')) {
            $Object.TwitterEnabled = $TwitterEnabled
        }
        return $Object
    }
}


# SIG # Begin signature block
# MIIoOQYJKoZIhvcNAQcCoIIoKjCCKCYCAQExDzANBglghkgBZQMEAgEFADB5Bgor
# BgEEAYI3AgEEoGswaTA0BgorBgEEAYI3AgEeMCYCAwEAAAQQH8w7YFlLCE63JNLG
# KX7zUQIBAAIBAAIBAAIBAAIBADAxMA0GCWCGSAFlAwQCAQUABCADkJC1yp37DgVL
# bvAORZJBElZxIdKBwQ+XdIsMdeDXRaCCDYUwggYDMIID66ADAgECAhMzAAAEA73V
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
# HAYKKwYBBAGCNwIBCzEOMAwGCisGAQQBgjcCARUwLwYJKoZIhvcNAQkEMSIEIEyc
# tJo0SjWPWkOVMrvGbngWI1IperjJRUBUvNIgwZP4MEIGCisGAQQBgjcCAQwxNDAy
# oBSAEgBNAGkAYwByAG8AcwBvAGYAdKEagBhodHRwOi8vd3d3Lm1pY3Jvc29mdC5j
# b20wDQYJKoZIhvcNAQEBBQAEggEAm8Sp2iqL9l2zM98O8JuS8+9FcjCM1N0GaD6E
# JXSFG5UPoloNVbXZGQgUUo1mlTbgJR2WQGSbUCN07Oy8Mc95nIN5Hje++uPfoU9q
# RnT8VEAdO7Td8fLw1dGWPAoWLXaiK127nfxpFOAUWl27xyLGzb83iVpoNMHopBxi
# FNExwYzFINZthikeaUTHlRIrPsKAWtsqdMBlJG80xt5qUTH80d4a6yzZ36lwsKwm
# EGka5xe605NHc+AV+4PIW642cdwnnpyUS23DiSVA78onA6/uys+S3xElRy/c/kUU
# wt7PYVOU1d/J6wX8u4hODEuzPiPYQY4cu85xmntMOjfDxwYdv6GCF5QwgheQBgor
# BgEEAYI3AwMBMYIXgDCCF3wGCSqGSIb3DQEHAqCCF20wghdpAgEDMQ8wDQYJYIZI
# AWUDBAIBBQAwggFSBgsqhkiG9w0BCRABBKCCAUEEggE9MIIBOQIBAQYKKwYBBAGE
# WQoDATAxMA0GCWCGSAFlAwQCAQUABCBiqF4V64sQjI8aoOv6DeaVwiZRlFJM6Cis
# BO5KX3/KqQIGZzXkqzXlGBMyMDI0MTExNTA1NTg0MS43ODZaMASAAgH0oIHRpIHO
# MIHLMQswCQYDVQQGEwJVUzETMBEGA1UECBMKV2FzaGluZ3RvbjEQMA4GA1UEBxMH
# UmVkbW9uZDEeMBwGA1UEChMVTWljcm9zb2Z0IENvcnBvcmF0aW9uMSUwIwYDVQQL
# ExxNaWNyb3NvZnQgQW1lcmljYSBPcGVyYXRpb25zMScwJQYDVQQLEx5uU2hpZWxk
# IFRTUyBFU046REMwMC0wNUUwLUQ5NDcxJTAjBgNVBAMTHE1pY3Jvc29mdCBUaW1l
# LVN0YW1wIFNlcnZpY2WgghHqMIIHIDCCBQigAwIBAgITMwAAAehQsIDPK3KZTQAB
# AAAB6DANBgkqhkiG9w0BAQsFADB8MQswCQYDVQQGEwJVUzETMBEGA1UECBMKV2Fz
# aGluZ3RvbjEQMA4GA1UEBxMHUmVkbW9uZDEeMBwGA1UEChMVTWljcm9zb2Z0IENv
# cnBvcmF0aW9uMSYwJAYDVQQDEx1NaWNyb3NvZnQgVGltZS1TdGFtcCBQQ0EgMjAx
# MDAeFw0yMzEyMDYxODQ1MjJaFw0yNTAzMDUxODQ1MjJaMIHLMQswCQYDVQQGEwJV
# UzETMBEGA1UECBMKV2FzaGluZ3RvbjEQMA4GA1UEBxMHUmVkbW9uZDEeMBwGA1UE
# ChMVTWljcm9zb2Z0IENvcnBvcmF0aW9uMSUwIwYDVQQLExxNaWNyb3NvZnQgQW1l
# cmljYSBPcGVyYXRpb25zMScwJQYDVQQLEx5uU2hpZWxkIFRTUyBFU046REMwMC0w
# NUUwLUQ5NDcxJTAjBgNVBAMTHE1pY3Jvc29mdCBUaW1lLVN0YW1wIFNlcnZpY2Uw
# ggIiMA0GCSqGSIb3DQEBAQUAA4ICDwAwggIKAoICAQDhQXdE0WzXG7wzeC9SGdH6
# eVwdGlF6YgpU7weOFBkpW9yuEmJSDE1ADBx/0DTuRBaplSD8CR1QqyQmxRDD/Cdv
# DyeZFAcZ6l2+nlMssmZyC8TPt1GTWAUt3GXUU6g0F0tIrFNLgofCjOvm3G0j482V
# utKS4wZT6bNVnBVsChr2AjmVbGDN/6Qs/EqakL5cwpGel1te7UO13dUwaPjOy0Wi
# 1qYNmR8i7T1luj2JdFdfZhMPyqyq/NDnZuONSbj8FM5xKBoar12ragC8/1CXaL1O
# MXBwGaRoJTYtksi9njuq4wDkcAwitCZ5BtQ2NqPZ0lLiQB7O10Bm9zpHWn9x1/Hm
# dAn4koMWKUDwH5sd/zDu4vi887FWxm54kkWNvk8FeQ7ZZ0Q5gqGKW4g6revV2IdA
# xBobWdorqwvzqL70WdsgDU/P5c0L8vYIskUJZedCGHM2hHIsNRyw9EFoSolDM+yC
# edkz69787s8nIp55icLfDoKw5hak5G6MWF6d71tcNzV9+v9RQKMa6Uwfyquredd5
# sqXWCXv++hek4A15WybIc6ufT0ilazKYZvDvoaswgjP0SeLW7mvmcw0FELzF1/uW
# aXElLHOXIlieKF2i/YzQ6U50K9dbhnMaDcJSsG0hXLRTy/LQbsOD0hw7FuK0nmzo
# tSx/5fo9g7fCzoFjk3tDEwIDAQABo4IBSTCCAUUwHQYDVR0OBBYEFPo5W8o980kM
# fRVQba6T34HwelLaMB8GA1UdIwQYMBaAFJ+nFV0AXmJdg/Tl0mWnG1M1GelyMF8G
# A1UdHwRYMFYwVKBSoFCGTmh0dHA6Ly93d3cubWljcm9zb2Z0LmNvbS9wa2lvcHMv
# Y3JsL01pY3Jvc29mdCUyMFRpbWUtU3RhbXAlMjBQQ0ElMjAyMDEwKDEpLmNybDBs
# BggrBgEFBQcBAQRgMF4wXAYIKwYBBQUHMAKGUGh0dHA6Ly93d3cubWljcm9zb2Z0
# LmNvbS9wa2lvcHMvY2VydHMvTWljcm9zb2Z0JTIwVGltZS1TdGFtcCUyMFBDQSUy
# MDIwMTAoMSkuY3J0MAwGA1UdEwEB/wQCMAAwFgYDVR0lAQH/BAwwCgYIKwYBBQUH
# AwgwDgYDVR0PAQH/BAQDAgeAMA0GCSqGSIb3DQEBCwUAA4ICAQCWfcJm2rwXtPi7
# 4km6PKAkni9+BWotq+QtDGgeT5F3ro7PsIUNKRkUytuGqI8thL3Jcrb03x6DOppY
# JEA+pb6o2qPjFddO1TLqvSXrYm+OgCLL+7+3FmRmfkRu8rHvprab0O19wDbukgO8
# I5Oi1RegMJl8t5k/UtE0Wb3zAlOHnCjLGSzP/Do3ptwhXokk02IvD7SZEBbPboGb
# tw4LCHsT2pFakpGOBh+ISUMXBf835CuVNfddwxmyGvNSzyEyEk5h1Vh7tpwP7z7r
# J+HsiP4sdqBjj6Avopuf4rxUAfrEbV6aj8twFs7WVHNiIgrHNna/55kyrAG9Yt19
# CPvkUwxYK0uZvPl2WC39nfc0jOTjivC7s/IUozE4tfy3JNkyQ1cNtvZftiX3j5Dt
# +eLOeuGDjvhJvYMIEkpkV68XLNH7+ZBfYa+PmfRYaoFFHCJKEoRSZ3PbDJPBiEhZ
# 9yuxMddoMMQ19Tkyftot6Ez0XhSmwjYBq39DvBFWhlyDGBhrU3GteDWiVd9YGSB2
# WnxuFMy5fbAK6o8PWz8QRMiptXHK3HDBr2wWWEcrrgcTuHZIJTqepNoYlx9VRFvj
# /vCXaAFcmkW1nk7VE+owaXr5RJjryDq9ubkyDq1mdrF/geaRALXcNZbfNXIkhXzX
# A6a8CiamcQW/DgmLJpiVQNriZYCHIDCCB3EwggVZoAMCAQICEzMAAAAVxedrngKb
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
# Y2EgT3BlcmF0aW9uczEnMCUGA1UECxMeblNoaWVsZCBUU1MgRVNOOkRDMDAtMDVF
# MC1EOTQ3MSUwIwYDVQQDExxNaWNyb3NvZnQgVGltZS1TdGFtcCBTZXJ2aWNloiMK
# AQEwBwYFKw4DAhoDFQCMJG4vg0juMOVn2BuKACUvP80FuqCBgzCBgKR+MHwxCzAJ
# BgNVBAYTAlVTMRMwEQYDVQQIEwpXYXNoaW5ndG9uMRAwDgYDVQQHEwdSZWRtb25k
# MR4wHAYDVQQKExVNaWNyb3NvZnQgQ29ycG9yYXRpb24xJjAkBgNVBAMTHU1pY3Jv
# c29mdCBUaW1lLVN0YW1wIFBDQSAyMDEwMA0GCSqGSIb3DQEBCwUAAgUA6uELzzAi
# GA8yMDI0MTExNDIzNTI0N1oYDzIwMjQxMTE1MjM1MjQ3WjB0MDoGCisGAQQBhFkK
# BAExLDAqMAoCBQDq4QvPAgEAMAcCAQACAhRMMAcCAQACAhKGMAoCBQDq4l1PAgEA
# MDYGCisGAQQBhFkKBAIxKDAmMAwGCisGAQQBhFkKAwKgCjAIAgEAAgMHoSChCjAI
# AgEAAgMBhqAwDQYJKoZIhvcNAQELBQADggEBAE90GJeeqQZlDlLgtPu/OfZd8VU2
# Idr5cx+JiHE0mQ4hALnYcT4p9jwznv98OzXNXAhDndEdMBL04wX3WsqeJ4WwTolQ
# IBoS6yRq3pOeX6z/0ujogN4Tj9Tu4tuYrzz4X16xOuRx0zEjq5aCWTnaHW1V+AOB
# AAXQEgMZpvl91w2ycMBfdO9GEUNdM1LqB/ivJufWMV7wIs3SOqSFZGEl9Sldf1Vf
# KeJIkSOfhhku5LJvqUe4WiRrwRPQGWUuZmA4ppeVOVdfoIwvOG/x7+O5Z77zLsoy
# Xmgjhg1JyujAm+AlmBd56ECqpjNoJ5vt2I6Yl4hmKuBwkdojQJHqPP8c/g8xggQN
# MIIECQIBATCBkzB8MQswCQYDVQQGEwJVUzETMBEGA1UECBMKV2FzaGluZ3RvbjEQ
# MA4GA1UEBxMHUmVkbW9uZDEeMBwGA1UEChMVTWljcm9zb2Z0IENvcnBvcmF0aW9u
# MSYwJAYDVQQDEx1NaWNyb3NvZnQgVGltZS1TdGFtcCBQQ0EgMjAxMAITMwAAAehQ
# sIDPK3KZTQABAAAB6DANBglghkgBZQMEAgEFAKCCAUowGgYJKoZIhvcNAQkDMQ0G
# CyqGSIb3DQEJEAEEMC8GCSqGSIb3DQEJBDEiBCCltfONiaJwMVgFUfi0EPaPaViC
# jiqEdRLe7Vrdy6qN0zCB+gYLKoZIhvcNAQkQAi8xgeowgecwgeQwgb0EICrS2sTV
# AoQggkHR59pNqige0xfJT2J3U8W1Sc8H+OsdMIGYMIGApH4wfDELMAkGA1UEBhMC
# VVMxEzARBgNVBAgTCldhc2hpbmd0b24xEDAOBgNVBAcTB1JlZG1vbmQxHjAcBgNV
# BAoTFU1pY3Jvc29mdCBDb3Jwb3JhdGlvbjEmMCQGA1UEAxMdTWljcm9zb2Z0IFRp
# bWUtU3RhbXAgUENBIDIwMTACEzMAAAHoULCAzytymU0AAQAAAegwIgQgcX/t95+6
# /jkWka2lReS0HD1+//zP3z5AKrDdvnux824wDQYJKoZIhvcNAQELBQAEggIAPZd3
# pHU31tpzi/fM4zsbmImTvhgbJ/v/Z6QprG4Tcoro5q3ZAyk3ZCYJSDJvV33X2tAZ
# LBGqLzoSDUtImIXVJBEkIt+KlnOIwVzSkcUFum0vtzyKOZqcMnBGECi4FERpE44f
# CdXjgZhggTKGkl7F7cbvuSjLCgg0JAAVDBp2I0frdk7BYacbhYoXmsjNvSATzPcN
# E/IbyWxbFDeqF8bJ5azQ/uRp2PI1JkxPl/H++9etQiSTFQnQ7uv+Ooth4Tj0hAY+
# MZp+Dq90vCK7T2U1KOSXZTvFcTFFEIou7GkLrMrMnX+a3AN0a6TV6lnGZsI3wcJE
# A/KSUzQlRvAeK2EIgNHeuH3uuqquU8Yf8hjkqxlR9eTGOrrNhs+ztOYZYzl4Prx9
# acMsVp+1oy9Xt3nVe90e7gRhj1it6G7I0nJzckTRZqL6xjtT1lb104hv8TxJNA7Z
# SPObtIbYHlNRQIqGorfd4ljulqXHdnE4X1Uvq2S5onHe47Ed94itb7Wxsa+DtqEJ
# bT2uAVKn/a8mMST/JTELYo5P30PYovwBUGWw0rLeUEx4rlhqkWz27XogFNSaRi4n
# RRpVD+uk9h82+vllNzTCTr86wyZTPQgCN5VklsFYKZvWevKO81ZjKfQqdoDzI4Dp
# dxZNBJctoly5vFsKCS6/ZnnQjcf2NrFHAWPXPlU=
# SIG # End signature block
