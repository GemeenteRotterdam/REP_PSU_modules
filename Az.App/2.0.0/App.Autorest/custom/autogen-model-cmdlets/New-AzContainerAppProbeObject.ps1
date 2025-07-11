
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
Create an in-memory object for ContainerAppProbe.
.Description
Create an in-memory object for ContainerAppProbe.

.Outputs
Microsoft.Azure.PowerShell.Cmdlets.App.Models.ContainerAppProbe
.Link
https://learn.microsoft.com/powershell/module/Az.App/new-azcontainerappprobeobject
#>
function New-AzContainerAppProbeObject {
    [OutputType('Microsoft.Azure.PowerShell.Cmdlets.App.Models.ContainerAppProbe')]
    [CmdletBinding(PositionalBinding=$false)]
    Param(

        [Parameter(HelpMessage="Minimum consecutive failures for the probe to be considered failed after having succeeded. Defaults to 3. Minimum value is 1. Maximum value is 10.")]
        [int]
        $FailureThreshold,
        [Parameter(HelpMessage="Host name to connect to, defaults to the pod IP. You probably want to set `"Host`" in httpHeaders instead.")]
        [string]
        $HttpGetHost,
        [Parameter(HelpMessage="Custom headers to set in the request. HTTP allows repeated headers.")]
        [Microsoft.Azure.PowerShell.Cmdlets.App.Models.IContainerAppProbeHttpGetHttpHeadersItem[]]
        $HttpGetHttpHeader,
        [Parameter(HelpMessage="Path to access on the HTTP server.")]
        [string]
        $HttpGetPath,
        [Parameter(HelpMessage="Name or number of the port to access on the container. Number must be in the range 1 to 65535. Name must be an IANA_SVC_NAME.")]
        [int]
        $HttpGetPort,
        [Parameter(HelpMessage="Scheme to use for connecting to the host. Defaults to HTTP.")]
        [Microsoft.Azure.PowerShell.Cmdlets.App.PSArgumentCompleterAttribute("HTTP", "HTTPS")]
        [string]
        $HttpGetScheme,
        [Parameter(HelpMessage="Number of seconds after the container has started before liveness probes are initiated. Minimum value is 1. Maximum value is 60.")]
        [int]
        $InitialDelaySecond,
        [Parameter(HelpMessage="How often (in seconds) to perform the probe. Default to 10 seconds. Minimum value is 1. Maximum value is 240.")]
        [int]
        $PeriodSecond,
        [Parameter(HelpMessage="Minimum consecutive successes for the probe to be considered successful after having failed. Defaults to 1. Must be 1 for liveness and startup. Minimum value is 1. Maximum value is 10.")]
        [int]
        $SuccessThreshold,
        [Parameter(HelpMessage="Optional: Host name to connect to, defaults to the pod IP.")]
        [string]
        $TcpSocketHost,
        [Parameter(HelpMessage="Number or name of the port to access on the container. Number must be in the range 1 to 65535. Name must be an IANA_SVC_NAME.")]
        [int]
        $TcpSocketPort,
        [Parameter(HelpMessage="Optional duration in seconds the pod needs to terminate gracefully upon probe failure. The grace period is the duration in seconds after the processes running in the pod are sent a termination signal and the time when the processes are forcibly halted with a kill signal. Set this value longer than the expected cleanup time for your process. If this value is nil, the pod's terminationGracePeriodSeconds will be used. Otherwise, this value overrides the value provided by the pod spec. Value must be non-negative integer. The value zero indicates stop immediately via the kill signal (no opportunity to shut down). This is an alpha field and requires enabling ProbeTerminationGracePeriod feature gate. Maximum value is 3600 seconds (1 hour).")]
        [long]
        $TerminationGracePeriodSecond,
        [Parameter(HelpMessage="Number of seconds after which the probe times out. Defaults to 1 second. Minimum value is 1. Maximum value is 240.")]
        [int]
        $TimeoutSecond,
        [Parameter(HelpMessage="The type of probe.")]
        [Microsoft.Azure.PowerShell.Cmdlets.App.PSArgumentCompleterAttribute("Liveness", "Readiness", "Startup")]
        [string]
        $Type
    )

    process {
        $Object = [Microsoft.Azure.PowerShell.Cmdlets.App.Models.ContainerAppProbe]::New()

        if ($PSBoundParameters.ContainsKey('FailureThreshold')) {
            $Object.FailureThreshold = $FailureThreshold
        }
        if ($PSBoundParameters.ContainsKey('HttpGetHost')) {
            $Object.HttpGetHost = $HttpGetHost
        }
        if ($PSBoundParameters.ContainsKey('HttpGetHttpHeader')) {
            $Object.HttpGetHttpHeader = $HttpGetHttpHeader
        }
        if ($PSBoundParameters.ContainsKey('HttpGetPath')) {
            $Object.HttpGetPath = $HttpGetPath
        }
        if ($PSBoundParameters.ContainsKey('HttpGetPort')) {
            $Object.HttpGetPort = $HttpGetPort
        }
        if ($PSBoundParameters.ContainsKey('HttpGetScheme')) {
            $Object.HttpGetScheme = $HttpGetScheme
        }
        if ($PSBoundParameters.ContainsKey('InitialDelaySecond')) {
            $Object.InitialDelaySecond = $InitialDelaySecond
        }
        if ($PSBoundParameters.ContainsKey('PeriodSecond')) {
            $Object.PeriodSecond = $PeriodSecond
        }
        if ($PSBoundParameters.ContainsKey('SuccessThreshold')) {
            $Object.SuccessThreshold = $SuccessThreshold
        }
        if ($PSBoundParameters.ContainsKey('TcpSocketHost')) {
            $Object.TcpSocketHost = $TcpSocketHost
        }
        if ($PSBoundParameters.ContainsKey('TcpSocketPort')) {
            $Object.TcpSocketPort = $TcpSocketPort
        }
        if ($PSBoundParameters.ContainsKey('TerminationGracePeriodSecond')) {
            $Object.TerminationGracePeriodSecond = $TerminationGracePeriodSecond
        }
        if ($PSBoundParameters.ContainsKey('TimeoutSecond')) {
            $Object.TimeoutSecond = $TimeoutSecond
        }
        if ($PSBoundParameters.ContainsKey('Type')) {
            $Object.Type = $Type
        }
        return $Object
    }
}


# SIG # Begin signature block
# MIIoQgYJKoZIhvcNAQcCoIIoMzCCKC8CAQExDzANBglghkgBZQMEAgEFADB5Bgor
# BgEEAYI3AgEEoGswaTA0BgorBgEEAYI3AgEeMCYCAwEAAAQQH8w7YFlLCE63JNLG
# KX7zUQIBAAIBAAIBAAIBAAIBADAxMA0GCWCGSAFlAwQCAQUABCAU3SDIMojrMwCL
# BmoK1C/RlLS8GGP5uclDwcWbaRFlraCCDXYwggX0MIID3KADAgECAhMzAAAEBGx0
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
# /Xmfwb1tbWrJUnMTDXpQzTGCGiIwghoeAgEBMIGVMH4xCzAJBgNVBAYTAlVTMRMw
# EQYDVQQIEwpXYXNoaW5ndG9uMRAwDgYDVQQHEwdSZWRtb25kMR4wHAYDVQQKExVN
# aWNyb3NvZnQgQ29ycG9yYXRpb24xKDAmBgNVBAMTH01pY3Jvc29mdCBDb2RlIFNp
# Z25pbmcgUENBIDIwMTECEzMAAAQEbHQG/1crJ3IAAAAABAQwDQYJYIZIAWUDBAIB
# BQCgga4wGQYJKoZIhvcNAQkDMQwGCisGAQQBgjcCAQQwHAYKKwYBBAGCNwIBCzEO
# MAwGCisGAQQBgjcCARUwLwYJKoZIhvcNAQkEMSIEIDKdqEAkkAxyc2TiF1uJu/eZ
# YmcbB4Mnlk6ul8uUt1ZGMEIGCisGAQQBgjcCAQwxNDAyoBSAEgBNAGkAYwByAG8A
# cwBvAGYAdKEagBhodHRwOi8vd3d3Lm1pY3Jvc29mdC5jb20wDQYJKoZIhvcNAQEB
# BQAEggEAdxETE6LQgt7vV6Tl5ZLZhs1AGkTvl3BXGvxB1UgMulSDC0lbQFS/Z/n4
# M01VEMEXmAzKke+iQbNlxXFjsWRYlHO6BPuIIy1Znf8djFzhFqPc+6FK/lzcROxn
# PP2Mz0Pek5h/RFUyHCIYscQIiQY/j1Dbn8zZcayQysq939dUy9aqDZcQkrgXzikA
# odMmfdJAljM359C/pRkY9z6Df+Tw2zvtY/aAnw1iDtSdwff0lxIA1EQ7HTeRuvmH
# lpq/J0OrceBZT7iwjjS4CiPIsDAt9lIuNc5Y+cWkh5CZuW3D7Tqs8q0eelGa4avt
# 7LW6lIPGtlGtLocM13M39ozbIQY5aKGCF6wwgheoBgorBgEEAYI3AwMBMYIXmDCC
# F5QGCSqGSIb3DQEHAqCCF4UwgheBAgEDMQ8wDQYJYIZIAWUDBAIBBQAwggFZBgsq
# hkiG9w0BCRABBKCCAUgEggFEMIIBQAIBAQYKKwYBBAGEWQoDATAxMA0GCWCGSAFl
# AwQCAQUABCBwVf/XFhFycxb1eC8BqDihq9a9LcAA6rhoBN4RfBbergIGZus7r/k7
# GBIyMDI0MTExNTA1NTg1MC4wM1owBIACAfSggdmkgdYwgdMxCzAJBgNVBAYTAlVT
# MRMwEQYDVQQIEwpXYXNoaW5ndG9uMRAwDgYDVQQHEwdSZWRtb25kMR4wHAYDVQQK
# ExVNaWNyb3NvZnQgQ29ycG9yYXRpb24xLTArBgNVBAsTJE1pY3Jvc29mdCBJcmVs
# YW5kIE9wZXJhdGlvbnMgTGltaXRlZDEnMCUGA1UECxMeblNoaWVsZCBUU1MgRVNO
# OjJBMUEtMDVFMC1EOTQ3MSUwIwYDVQQDExxNaWNyb3NvZnQgVGltZS1TdGFtcCBT
# ZXJ2aWNloIIR+zCCBygwggUQoAMCAQICEzMAAAH5H2eNdauk8bEAAQAAAfkwDQYJ
# KoZIhvcNAQELBQAwfDELMAkGA1UEBhMCVVMxEzARBgNVBAgTCldhc2hpbmd0b24x
# EDAOBgNVBAcTB1JlZG1vbmQxHjAcBgNVBAoTFU1pY3Jvc29mdCBDb3Jwb3JhdGlv
# bjEmMCQGA1UEAxMdTWljcm9zb2Z0IFRpbWUtU3RhbXAgUENBIDIwMTAwHhcNMjQw
# NzI1MTgzMTA5WhcNMjUxMDIyMTgzMTA5WjCB0zELMAkGA1UEBhMCVVMxEzARBgNV
# BAgTCldhc2hpbmd0b24xEDAOBgNVBAcTB1JlZG1vbmQxHjAcBgNVBAoTFU1pY3Jv
# c29mdCBDb3Jwb3JhdGlvbjEtMCsGA1UECxMkTWljcm9zb2Z0IElyZWxhbmQgT3Bl
# cmF0aW9ucyBMaW1pdGVkMScwJQYDVQQLEx5uU2hpZWxkIFRTUyBFU046MkExQS0w
# NUUwLUQ5NDcxJTAjBgNVBAMTHE1pY3Jvc29mdCBUaW1lLVN0YW1wIFNlcnZpY2Uw
# ggIiMA0GCSqGSIb3DQEBAQUAA4ICDwAwggIKAoICAQC0PUwffIAdYc1WyUL4IFOP
# 8yl3nksM+1CuE3tZ6oWFF4L3EpdKOhtbVkfMdTxXYE4lSJiDt8MnYDEZUbKi9S2A
# ZmDb4Zq4UqTdmOOwtKyp6FgixRCuBf6v9UBNpbz841bLqU7IZnBmnF9XYRfioCHq
# ZvaFp0C691tGXVArW18GVHd914IFAb7JvP0kVnjks3amzw1zXGvjU3xCLcpUkthf
# SJsRsCSSxHhtuzMLO9j691KuNbIoCNHpiBiFoFoPETYoMnaxBEUUX96ALEqCiB0X
# dUgmgIT9a7L0y4SDKl5rUd6LuUUa90tBkfkmjZBHm43yGIxzxnjtFEm4hYI57Ign
# VidGKKJulRnvb7Cm/wtOi/TIfoLkdH8Pz4BPi+q0/nshNewP0M86hvy2O2x589xA
# l5tQ2KrJ/JMvmPn8n7Z34Y8JxcRih5Zn6euxlJ+t3kMczii8KYPeWJ+BifOM6vLi
# CFBP9y+Z0fAWvrIkamFb8cbwZB35wHjDvAak6EdUlvLjiQZUrwzNj2zfYPLVMecm
# DynvLWwQbP8DXLzhm3qAiwhNhpxweEEqnhw5U2t+hFVTHYb/ROvsOTd+kJTy77mi
# Wo8/AqBmznuOX6U6tFWxfUBgSYCfILIaupEDOkZfKTUe80gGlI025MFCTsUG+75i
# mLoDtLZXZOPqXNhZUG+4YQIDAQABo4IBSTCCAUUwHQYDVR0OBBYEFInto7qclckj
# 16KPNLlCRHZGWeAAMB8GA1UdIwQYMBaAFJ+nFV0AXmJdg/Tl0mWnG1M1GelyMF8G
# A1UdHwRYMFYwVKBSoFCGTmh0dHA6Ly93d3cubWljcm9zb2Z0LmNvbS9wa2lvcHMv
# Y3JsL01pY3Jvc29mdCUyMFRpbWUtU3RhbXAlMjBQQ0ElMjAyMDEwKDEpLmNybDBs
# BggrBgEFBQcBAQRgMF4wXAYIKwYBBQUHMAKGUGh0dHA6Ly93d3cubWljcm9zb2Z0
# LmNvbS9wa2lvcHMvY2VydHMvTWljcm9zb2Z0JTIwVGltZS1TdGFtcCUyMFBDQSUy
# MDIwMTAoMSkuY3J0MAwGA1UdEwEB/wQCMAAwFgYDVR0lAQH/BAwwCgYIKwYBBQUH
# AwgwDgYDVR0PAQH/BAQDAgeAMA0GCSqGSIb3DQEBCwUAA4ICAQBmIAmAVuR/uN+H
# H+aZmWcZmulp74canFbGzwjv29RvwZCi7nQzWezuLAbYJx2hdqrtWClWQ1/W68iG
# sZikoIFdD5JonY7QG/C4lHtSyBNoo3SP/J/d+kcPSS0f4SQS4Zez0MEvK3vWK61W
# TCjD2JCZKTiggrxLwCs0alI7N6671N0mMGOxqya4n7arlOOauAQrI97dMCkCKjxx
# 3D9vVwECaO0ju2k1hXk/JEjcrU2G4OB8SPmTKcYX+6LM/U24dLEX9XWSz/a0ISiu
# KJwziTU8lNMDRMKM1uSmYFywAyXFPMGdayqcEK3135R31VrcjD0GzhxyuSAGMu2D
# e9gZhqvrXmh9i1T526n4u5TR3bAEMQbWeFJYdo767bLpKLcBo0g23+k4wpTqXgBb
# S4NZQff04cfcSoUe1OyxldoM6O3JGBuowaaR/wojeohUFknZdCmeES5FuH4CCmZG
# f9rjXQOTtW0+Da4LjbZYsLwfwhWT8V6iJJLi8Wh2GdwV60nRkrfrDEBrcWI+AF5t
# FbJW1nvreoMPPENvSYHocv0cR9Ns37igcKRlrUcqXwHSzxGIUEx/9bv47sQ9n7Aw
# fzB2SNntJux1211GBEBGpHwgU9a6tD6yft+0SJ9qiPO4IRqFIByrzrKPBB5M831g
# b1vfhFO6ueSkP7A8ZMHVZxwymwuUzTCCB3EwggVZoAMCAQICEzMAAAAVxedrngKb
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
# ELQdVTNYs6FwZvKhggNWMIICPgIBATCCAQGhgdmkgdYwgdMxCzAJBgNVBAYTAlVT
# MRMwEQYDVQQIEwpXYXNoaW5ndG9uMRAwDgYDVQQHEwdSZWRtb25kMR4wHAYDVQQK
# ExVNaWNyb3NvZnQgQ29ycG9yYXRpb24xLTArBgNVBAsTJE1pY3Jvc29mdCBJcmVs
# YW5kIE9wZXJhdGlvbnMgTGltaXRlZDEnMCUGA1UECxMeblNoaWVsZCBUU1MgRVNO
# OjJBMUEtMDVFMC1EOTQ3MSUwIwYDVQQDExxNaWNyb3NvZnQgVGltZS1TdGFtcCBT
# ZXJ2aWNloiMKAQEwBwYFKw4DAhoDFQCqzlaNY7vNUAqYhx3CGqBm/KnpRqCBgzCB
# gKR+MHwxCzAJBgNVBAYTAlVTMRMwEQYDVQQIEwpXYXNoaW5ndG9uMRAwDgYDVQQH
# EwdSZWRtb25kMR4wHAYDVQQKExVNaWNyb3NvZnQgQ29ycG9yYXRpb24xJjAkBgNV
# BAMTHU1pY3Jvc29mdCBUaW1lLVN0YW1wIFBDQSAyMDEwMA0GCSqGSIb3DQEBCwUA
# AgUA6uDb1zAiGA8yMDI0MTExNDIwMjgwN1oYDzIwMjQxMTE1MjAyODA3WjB0MDoG
# CisGAQQBhFkKBAExLDAqMAoCBQDq4NvXAgEAMAcCAQACAhgkMAcCAQACAhL2MAoC
# BQDq4i1XAgEAMDYGCisGAQQBhFkKBAIxKDAmMAwGCisGAQQBhFkKAwKgCjAIAgEA
# AgMHoSChCjAIAgEAAgMBhqAwDQYJKoZIhvcNAQELBQADggEBAG/OOtRgtSfvzcNB
# 8yTA6mbTMcxd7+rLcOI1IGPrd2cL9+N+04EM8Ub88n2qZ9jXVr1YQaXhfUrjYiX6
# CMpA56Uq4vc3bDZcF09g+c86diK0bpBNXJ8GZ6U/3PvnjlYtaSNYHbjVvlURT0jM
# MqCffwv9XHMqcgOTgqJbIOFGCXcNUs3GDcJXvbtpUMUjip1v06Q8n6EWKLP44bBx
# l6ueD+jZPJXUr57BYGkj7WC5ZRJnmpovlJ5Ez2jXIOXMgsLKg3R+wpC7ijHVvfDt
# h6NwBQUKQtpugFsBWxAsQx+sibbkQuamnAUun8BseOrxI+iqopsXxYkclLG/qbUE
# 2ok6dKkxggQNMIIECQIBATCBkzB8MQswCQYDVQQGEwJVUzETMBEGA1UECBMKV2Fz
# aGluZ3RvbjEQMA4GA1UEBxMHUmVkbW9uZDEeMBwGA1UEChMVTWljcm9zb2Z0IENv
# cnBvcmF0aW9uMSYwJAYDVQQDEx1NaWNyb3NvZnQgVGltZS1TdGFtcCBQQ0EgMjAx
# MAITMwAAAfkfZ411q6TxsQABAAAB+TANBglghkgBZQMEAgEFAKCCAUowGgYJKoZI
# hvcNAQkDMQ0GCyqGSIb3DQEJEAEEMC8GCSqGSIb3DQEJBDEiBCDDe5XzdyJel1xD
# mY5EPq2Vha2SG8tDSMl/q0tHvB0bdzCB+gYLKoZIhvcNAQkQAi8xgeowgecwgeQw
# gb0EIDkjjMge8I37ZPrpFQ4sJmtQRV2gqUqXxV4I7lJsYtgQMIGYMIGApH4wfDEL
# MAkGA1UEBhMCVVMxEzARBgNVBAgTCldhc2hpbmd0b24xEDAOBgNVBAcTB1JlZG1v
# bmQxHjAcBgNVBAoTFU1pY3Jvc29mdCBDb3Jwb3JhdGlvbjEmMCQGA1UEAxMdTWlj
# cm9zb2Z0IFRpbWUtU3RhbXAgUENBIDIwMTACEzMAAAH5H2eNdauk8bEAAQAAAfkw
# IgQgZIiNq/VJ9id8+bmWuf0lSBzKTRcKzXlaYTU6kAyLNegwDQYJKoZIhvcNAQEL
# BQAEggIAEqU+ta4kXmahvmDbda5aHWzl6/Ge/IoQlPYFAewQS/41kxV9xI+sRsK+
# YJaFhx+IOjfKiUUl9AA3f+iCgVtxNbcsqW2mngqaOowJt4rEDRNet7CdIqk0IRVJ
# sQcEA18+GVeY80BN4HNLoOf1I5hYdwlCVuJdg2zA3iSWF0bj3ESZ4BoCvaXwyxb9
# InKA1XM1BIXBLKFbMDEGFA8wh1ozG1hoA58Jfo+/owH3Pf2Mg+rmMI///B8kFeHd
# /kSO0JgiFYP7DYOMwekbVQPjCGWy5bFClvoCe5q4nKOVyCfj/tFkpIqM1f5SUQgN
# EyrXNVk75ItC4qbxJtnBlckmBj1X2tKSOhm3gQLjMZXPlO+avYqecXdsGgoUzL0H
# rUa4bpgtc7JCjBI8kF1F9GljQgxy/3bccrZZ0g8ftBP9EwbI3F21LNtfkuzAXZ76
# H2ud+CInimsM+vOFqE/8fsUt6jVC0LuhbXzY9SJStOgIIHzZLdjgyww5IDDjWPp9
# pFx7QFRXrK678SArxJJv/SRgMpaz44yKtdF5k9Cy4LCCun14+ScytSPL/MS9gOex
# EVv3E9/SNxot44M4DJASw+AFVWkOKYm2RRwPeFxSJBFeds/rJG6+DNG35m+vK2W1
# YIYZzQd2QF+/i1Q/Q6ZkLzAmDTFjBwZD6g/2JrIuwq6EeHdRPws=
# SIG # End signature block
