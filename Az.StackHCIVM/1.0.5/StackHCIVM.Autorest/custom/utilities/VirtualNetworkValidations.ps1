function Confirm-IpPools{
[Microsoft.Azure.PowerShell.Cmdlets.StackHCIVM.DoNotExportAttribute()]
param(
    [Parameter()]
    [System.Collections.Hashtable[]]
    $IpPools
)

    foreach ($IpPool in $IpPools){
        foreach ($Key in $IpPool.Keys){
            if($Key.ToLower() -eq "end"){
                if ($IpPool[$Key] -notmatch $ipv4Regex){
                    Write-Error "Invalid ipaddress provided for IpPoolEnd : $IpPool[$Key]." -ErrorAction Stop
                }
            } elseif ($Key.ToLower() -eq "start"){ 
                if ($IpPool[$Key] -notmatch $ipv4Regex){
                    Write-Error "Invalid ipaddress provided for IpPoolStart : $IpPool[$Key]." -ErrorAction Stop
                }

            } elseif($Key.ToLower() -eq "type"){
                if ($IpPool[$Key] -ne "vm" -and  $IpPool[$Key] -ne "vippool"){
                    Write-Error  "Invalid IpPoolType provided: $IpPool[$Key]. Accepted values are 'vm' and 'vippool'." -ErrorAction Stop
                }

            } else {
                Write-Error "Invalid Key specified in IpPool object. Accpeted values are 'Start', 'End', and 'Type'." -ErrorAction Stop
            }
        }
    }
} 

function Confirm-Routes{
[Microsoft.Azure.PowerShell.Cmdlets.StackHCIVM.DoNotExportAttribute()]
param(
    [Parameter()]
    [System.Collections.Hashtable[]]
    $Routes 
)

    foreach ($Route in $Routes){
       foreach ($Key in $Route.Keys){
            if($Key.ToLower() -eq "addressprefix"){
                if ($Route[$Key] -notmatch $cidrRegex){
                    Write-Error "Invalid ipaddress provided for AddressPrefix for route : $Route[$Key]." -ErrorAction Stop
                }
            } elseif ($Key.ToLower() -eq "name"){ 
                if ($Route[$Key] -notmatch $subnetNameRegex){
                    Write-Error "Invalid subnet name provided for route: $Route[$Key]." -ErrorAction Stop
                }

            } elseif($Key.ToLower() -eq "nexthopipaddress"){
                if ($Route[$Key] -notmatch $ipv4Regex){
                    Write-Error  "Invalid ipaddress provided for NextHopIPAddress for route: $Route[$Key]." -ErrorAction Stop
                }

            } else {
                Write-Error "Invalid Key specified in IpPool object. Accpeted values are 'AddressPrefix', 'Name', and 'NextHopIPAddress'." -ErrorAction Stop
            }
        }
    }
} 

function Confirm-Subnets{
[Microsoft.Azure.PowerShell.Cmdlets.StackHCIVM.DoNotExportAttribute()]
param(
    [Parameter()]
    [System.Collections.Hashtable[]]
    $Subnets
)
    foreach ($Subnet in $Subnets){
        foreach ($Key in $Subnet.Keys){
            if($Key.ToLower() -eq "addressprefix"){
                if ($Subnet[$Key] -notmatch $cidrRegex){
                    Write-Error "Invalid ipaddress provided for AddressPrefix for subnet : $Subnet[$Key]." -ErrorAction Stop
                }
            } elseif ($Key.ToLower() -eq "ipallocationmethod"){
                if ($Subnet[$Key] -ne "Dynamic" -and $Subnet[$Key] -ne "Static"){
                    Write-Error "Invalid Ip Allocation method provided: $IpAllocationMethod. Accepted values are 'Dynamic' or 'Static'" -ErrorAction Stop
                }
            } elseif ($Key.ToLower() -eq "ippool"){
                Confirm-IpPools -IpPools $Subnet[$Key] 
            } elseif ($Key.ToLower() -eq "addressprefixes"){
                foreach ($addressPrefix in $Subnet[$Key]){
                    if ($addressPrefix -notmatch $cidrRegex){
                        Write-Error "Invalid AddressPrefix: $addressPrefix. Please use valid CIDR format." -ErrorAction Stop
                    }
                }
            } elseif ($Key.ToLower() -eq "name"){
                if ($Subnet[$Key] -notmatch $subnetNameRegex){
                    Write-Error "Invalid SubnetName:  $Subnet[$Key]. The name must start with an alphanumeric character, contain all alphanumeric characters or '-' or '_' or '.' and end with an alphanumeric character or '_'. The max length is 80 characters." -ErrorAction Stop
                }
            } elseif ($Key.ToLower() -eq "route"){
                Confirm-Routes -Routes $Subnet[$Key] 
            } elseif ($Key.ToLower() -eq "vlan"){
                if ($Subnet[$Key] -gt 4094 -or $Subnet[$Key] -lt 1){
                    Write-Error "Invalid value for Vlan : $Subnet[$Key]. Valid range is 1-4094"
                }
            } else {
                Write-Error "Invalid Key specified in Subnet object: $Subnet."
            }

        }
    }  
} 
# SIG # Begin signature block
# MIIoPAYJKoZIhvcNAQcCoIIoLTCCKCkCAQExDzANBglghkgBZQMEAgEFADB5Bgor
# BgEEAYI3AgEEoGswaTA0BgorBgEEAYI3AgEeMCYCAwEAAAQQH8w7YFlLCE63JNLG
# KX7zUQIBAAIBAAIBAAIBAAIBADAxMA0GCWCGSAFlAwQCAQUABCDgDyRZ9SEIkhWL
# TzEinyCXVZb6X1vjcV2/IaHFhQ0V7aCCDYUwggYDMIID66ADAgECAhMzAAADri01
# UchTj1UdAAAAAAOuMA0GCSqGSIb3DQEBCwUAMH4xCzAJBgNVBAYTAlVTMRMwEQYD
# VQQIEwpXYXNoaW5ndG9uMRAwDgYDVQQHEwdSZWRtb25kMR4wHAYDVQQKExVNaWNy
# b3NvZnQgQ29ycG9yYXRpb24xKDAmBgNVBAMTH01pY3Jvc29mdCBDb2RlIFNpZ25p
# bmcgUENBIDIwMTEwHhcNMjMxMTE2MTkwODU5WhcNMjQxMTE0MTkwODU5WjB0MQsw
# CQYDVQQGEwJVUzETMBEGA1UECBMKV2FzaGluZ3RvbjEQMA4GA1UEBxMHUmVkbW9u
# ZDEeMBwGA1UEChMVTWljcm9zb2Z0IENvcnBvcmF0aW9uMR4wHAYDVQQDExVNaWNy
# b3NvZnQgQ29ycG9yYXRpb24wggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIB
# AQD0IPymNjfDEKg+YyE6SjDvJwKW1+pieqTjAY0CnOHZ1Nj5irGjNZPMlQ4HfxXG
# yAVCZcEWE4x2sZgam872R1s0+TAelOtbqFmoW4suJHAYoTHhkznNVKpscm5fZ899
# QnReZv5WtWwbD8HAFXbPPStW2JKCqPcZ54Y6wbuWV9bKtKPImqbkMcTejTgEAj82
# 6GQc6/Th66Koka8cUIvz59e/IP04DGrh9wkq2jIFvQ8EDegw1B4KyJTIs76+hmpV
# M5SwBZjRs3liOQrierkNVo11WuujB3kBf2CbPoP9MlOyyezqkMIbTRj4OHeKlamd
# WaSFhwHLJRIQpfc8sLwOSIBBAgMBAAGjggGCMIIBfjAfBgNVHSUEGDAWBgorBgEE
# AYI3TAgBBggrBgEFBQcDAzAdBgNVHQ4EFgQUhx/vdKmXhwc4WiWXbsf0I53h8T8w
# VAYDVR0RBE0wS6RJMEcxLTArBgNVBAsTJE1pY3Jvc29mdCBJcmVsYW5kIE9wZXJh
# dGlvbnMgTGltaXRlZDEWMBQGA1UEBRMNMjMwMDEyKzUwMTgzNjAfBgNVHSMEGDAW
# gBRIbmTlUAXTgqoXNzcitW2oynUClTBUBgNVHR8ETTBLMEmgR6BFhkNodHRwOi8v
# d3d3Lm1pY3Jvc29mdC5jb20vcGtpb3BzL2NybC9NaWNDb2RTaWdQQ0EyMDExXzIw
# MTEtMDctMDguY3JsMGEGCCsGAQUFBwEBBFUwUzBRBggrBgEFBQcwAoZFaHR0cDov
# L3d3dy5taWNyb3NvZnQuY29tL3BraW9wcy9jZXJ0cy9NaWNDb2RTaWdQQ0EyMDEx
# XzIwMTEtMDctMDguY3J0MAwGA1UdEwEB/wQCMAAwDQYJKoZIhvcNAQELBQADggIB
# AGrJYDUS7s8o0yNprGXRXuAnRcHKxSjFmW4wclcUTYsQZkhnbMwthWM6cAYb/h2W
# 5GNKtlmj/y/CThe3y/o0EH2h+jwfU/9eJ0fK1ZO/2WD0xi777qU+a7l8KjMPdwjY
# 0tk9bYEGEZfYPRHy1AGPQVuZlG4i5ymJDsMrcIcqV8pxzsw/yk/O4y/nlOjHz4oV
# APU0br5t9tgD8E08GSDi3I6H57Ftod9w26h0MlQiOr10Xqhr5iPLS7SlQwj8HW37
# ybqsmjQpKhmWul6xiXSNGGm36GarHy4Q1egYlxhlUnk3ZKSr3QtWIo1GGL03hT57
# xzjL25fKiZQX/q+II8nuG5M0Qmjvl6Egltr4hZ3e3FQRzRHfLoNPq3ELpxbWdH8t
# Nuj0j/x9Crnfwbki8n57mJKI5JVWRWTSLmbTcDDLkTZlJLg9V1BIJwXGY3i2kR9i
# 5HsADL8YlW0gMWVSlKB1eiSlK6LmFi0rVH16dde+j5T/EaQtFz6qngN7d1lvO7uk
# 6rtX+MLKG4LDRsQgBTi6sIYiKntMjoYFHMPvI/OMUip5ljtLitVbkFGfagSqmbxK
# 7rJMhC8wiTzHanBg1Rrbff1niBbnFbbV4UDmYumjs1FIpFCazk6AADXxoKCo5TsO
# zSHqr9gHgGYQC2hMyX9MGLIpowYCURx3L7kUiGbOiMwaMIIHejCCBWKgAwIBAgIK
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
# cVZOSEXAQsmbdlsKgEhr/Xmfwb1tbWrJUnMTDXpQzTGCGg0wghoJAgEBMIGVMH4x
# CzAJBgNVBAYTAlVTMRMwEQYDVQQIEwpXYXNoaW5ndG9uMRAwDgYDVQQHEwdSZWRt
# b25kMR4wHAYDVQQKExVNaWNyb3NvZnQgQ29ycG9yYXRpb24xKDAmBgNVBAMTH01p
# Y3Jvc29mdCBDb2RlIFNpZ25pbmcgUENBIDIwMTECEzMAAAOuLTVRyFOPVR0AAAAA
# A64wDQYJYIZIAWUDBAIBBQCgga4wGQYJKoZIhvcNAQkDMQwGCisGAQQBgjcCAQQw
# HAYKKwYBBAGCNwIBCzEOMAwGCisGAQQBgjcCARUwLwYJKoZIhvcNAQkEMSIEIKnf
# 5sF/Ojia51W+fDO8vpcoQs+KaVivD1A8S2Zgdy9MMEIGCisGAQQBgjcCAQwxNDAy
# oBSAEgBNAGkAYwByAG8AcwBvAGYAdKEagBhodHRwOi8vd3d3Lm1pY3Jvc29mdC5j
# b20wDQYJKoZIhvcNAQEBBQAEggEA6GXGUBTNvrEwZAVTmfotR4iX3G38K3JGBdt8
# NDrh4DWxvI9Ie1MZEePEQaeyIWKRsFw43lSiYqAR72eU1aBGLAOFDK5vlDBI0iCg
# nVRTA8wQa3TlFGCbm8nOsV1CdTG6XkffTh7n3QfstiUxASZGnjUn4VAhD4UKAiH8
# IonWpSkDhSiFiSQZW26j32nyjyh74D3WEiRZdt+/U7N660Z12jw8Pmv8J1ddmcD+
# pMp8XYJiBXbPA2t/28ArT03Otr0tPprgMBJVUba1+pOfWeI2jz5TQw9So8xzVm5u
# A2tiCRR7DKx6QG7cjoTnkoQ2k314qOUK2+oeH6UkVW+tMQwMhaGCF5cwgheTBgor
# BgEEAYI3AwMBMYIXgzCCF38GCSqGSIb3DQEHAqCCF3AwghdsAgEDMQ8wDQYJYIZI
# AWUDBAIBBQAwggFSBgsqhkiG9w0BCRABBKCCAUEEggE9MIIBOQIBAQYKKwYBBAGE
# WQoDATAxMA0GCWCGSAFlAwQCAQUABCDan9PJNksNeYr3o9W0UbmK4y/pcEK9TaSo
# NGdtBkf6bwIGZuMCa9g8GBMyMDI0MTAwODA1MDcwMy4xMjhaMASAAgH0oIHRpIHO
# MIHLMQswCQYDVQQGEwJVUzETMBEGA1UECBMKV2FzaGluZ3RvbjEQMA4GA1UEBxMH
# UmVkbW9uZDEeMBwGA1UEChMVTWljcm9zb2Z0IENvcnBvcmF0aW9uMSUwIwYDVQQL
# ExxNaWNyb3NvZnQgQW1lcmljYSBPcGVyYXRpb25zMScwJQYDVQQLEx5uU2hpZWxk
# IFRTUyBFU046N0YwMC0wNUUwLUQ5NDcxJTAjBgNVBAMTHE1pY3Jvc29mdCBUaW1l
# LVN0YW1wIFNlcnZpY2WgghHtMIIHIDCCBQigAwIBAgITMwAAAfAqfB1ZO+YfrQAB
# AAAB8DANBgkqhkiG9w0BAQsFADB8MQswCQYDVQQGEwJVUzETMBEGA1UECBMKV2Fz
# aGluZ3RvbjEQMA4GA1UEBxMHUmVkbW9uZDEeMBwGA1UEChMVTWljcm9zb2Z0IENv
# cnBvcmF0aW9uMSYwJAYDVQQDEx1NaWNyb3NvZnQgVGltZS1TdGFtcCBQQ0EgMjAx
# MDAeFw0yMzEyMDYxODQ1NTFaFw0yNTAzMDUxODQ1NTFaMIHLMQswCQYDVQQGEwJV
# UzETMBEGA1UECBMKV2FzaGluZ3RvbjEQMA4GA1UEBxMHUmVkbW9uZDEeMBwGA1UE
# ChMVTWljcm9zb2Z0IENvcnBvcmF0aW9uMSUwIwYDVQQLExxNaWNyb3NvZnQgQW1l
# cmljYSBPcGVyYXRpb25zMScwJQYDVQQLEx5uU2hpZWxkIFRTUyBFU046N0YwMC0w
# NUUwLUQ5NDcxJTAjBgNVBAMTHE1pY3Jvc29mdCBUaW1lLVN0YW1wIFNlcnZpY2Uw
# ggIiMA0GCSqGSIb3DQEBAQUAA4ICDwAwggIKAoICAQC1Hi1Tozh3O0czE8xfRnry
# mlJNCaGWommPy0eINf+4EJr7rf8tSzlgE8Il4Zj48T5fTTOAh6nITRf2lK7+upcn
# Z/xg0AKoDYpBQOWrL9ObFShylIHfr/DQ4PsRX8GRtInuJsMkwSg63bfB4Q2UikME
# P/CtZHi8xW5XtAKp95cs3mvUCMvIAA83Jr/UyADACJXVU4maYisczUz7J111eD1K
# rG9mQ+ITgnRR/X2xTDMCz+io8ZZFHGwEZg+c3vmPp87m4OqOKWyhcqMUupPveO/g
# QC9Rv4szLNGDaoePeK6IU0JqcGjXqxbcEoS/s1hCgPd7Ux6YWeWrUXaxbb+JosgO
# azUgUGs1aqpnLjz0YKfUqn8i5TbmR1dqElR4QA+OZfeVhpTonrM4sE/MlJ1JLpR2
# FwAIHUeMfotXNQiytYfRBUOJHFeJYEflZgVk0Xx/4kZBdzgFQPOWfVd2NozXlC2e
# pGtUjaluA2osOvQHZzGOoKTvWUPX99MssGObO0xJHd0DygP/JAVp+bRGJqa2u7Aq
# Lm2+tAT26yI5veccDmNZsg3vDh1HcpCJa9QpRW/MD3a+AF2ygV1sRnGVUVG3VODX
# 3BhGT8TMU/GiUy3h7ClXOxmZ+weCuIOzCkTDbK5OlAS8qSPpgp+XGlOLEPaM31Mg
# f6YTppAaeP0ophx345ohtwIDAQABo4IBSTCCAUUwHQYDVR0OBBYEFNCCsqdXRy/M
# mjZGVTAvx7YFWpslMB8GA1UdIwQYMBaAFJ+nFV0AXmJdg/Tl0mWnG1M1GelyMF8G
# A1UdHwRYMFYwVKBSoFCGTmh0dHA6Ly93d3cubWljcm9zb2Z0LmNvbS9wa2lvcHMv
# Y3JsL01pY3Jvc29mdCUyMFRpbWUtU3RhbXAlMjBQQ0ElMjAyMDEwKDEpLmNybDBs
# BggrBgEFBQcBAQRgMF4wXAYIKwYBBQUHMAKGUGh0dHA6Ly93d3cubWljcm9zb2Z0
# LmNvbS9wa2lvcHMvY2VydHMvTWljcm9zb2Z0JTIwVGltZS1TdGFtcCUyMFBDQSUy
# MDIwMTAoMSkuY3J0MAwGA1UdEwEB/wQCMAAwFgYDVR0lAQH/BAwwCgYIKwYBBQUH
# AwgwDgYDVR0PAQH/BAQDAgeAMA0GCSqGSIb3DQEBCwUAA4ICAQA4IvSbnr4jEPgo
# 5W4xj3/+0dCGwsz863QGZ2mB9Z4SwtGGLMvwfsRUs3NIlPD/LsWAxdVYHklAzwLT
# wQ5M+PRdy92DGftyEOGMHfut7Gq8L3RUcvrvr0AL/NNtfEpbAEkCFzseextY5s3h
# zj3rX2wvoBZm2ythwcLeZmMgHQCmjZp/20fHWJgrjPYjse6RDJtUTlvUsjr+878/
# t+vrQEIqlmebCeEi+VQVxc7wF0LuMTw/gCWdcqHoqL52JotxKzY8jZSQ7ccNHhC4
# eHGFRpaKeiSQ0GXtlbGIbP4kW1O3JzlKjfwG62NCSvfmM1iPD90XYiFm7/8mgR16
# AmqefDsfjBCWwf3qheIMfgZzWqeEz8laFmM8DdkXjuOCQE/2L0TxhrjUtdMkATfX
# dZjYRlscBDyr8zGMlprFC7LcxqCXlhxhtd2CM+mpcTc8RB2D3Eor0UdoP36Q9r4X
# WCVV/2Kn0AXtvWxvIfyOFm5aLl0eEzkhfv/XmUlBeOCElS7jdddWpBlQjJuHHUHj
# OVGXlrJT7X4hicF1o23x5U+j7qPKBceryP2/1oxfmHc6uBXlXBKukV/QCZBVAiBM
# YJhnktakWHpo9uIeSnYT6Qx7wf2RauYHIER8SLRmblMzPOs+JHQzrvh7xStx310L
# Op+0DaOXs8xjZvhpn+WuZij5RmZijDCCB3EwggVZoAMCAQICEzMAAAAVxedrngKb
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
# ELQdVTNYs6FwZvKhggNQMIICOAIBATCB+aGB0aSBzjCByzELMAkGA1UEBhMCVVMx
# EzARBgNVBAgTCldhc2hpbmd0b24xEDAOBgNVBAcTB1JlZG1vbmQxHjAcBgNVBAoT
# FU1pY3Jvc29mdCBDb3Jwb3JhdGlvbjElMCMGA1UECxMcTWljcm9zb2Z0IEFtZXJp
# Y2EgT3BlcmF0aW9uczEnMCUGA1UECxMeblNoaWVsZCBUU1MgRVNOOjdGMDAtMDVF
# MC1EOTQ3MSUwIwYDVQQDExxNaWNyb3NvZnQgVGltZS1TdGFtcCBTZXJ2aWNloiMK
# AQEwBwYFKw4DAhoDFQDCKAZKKv5lsdC2yoMGKYiQy79p/6CBgzCBgKR+MHwxCzAJ
# BgNVBAYTAlVTMRMwEQYDVQQIEwpXYXNoaW5ndG9uMRAwDgYDVQQHEwdSZWRtb25k
# MR4wHAYDVQQKExVNaWNyb3NvZnQgQ29ycG9yYXRpb24xJjAkBgNVBAMTHU1pY3Jv
# c29mdCBUaW1lLVN0YW1wIFBDQSAyMDEwMA0GCSqGSIb3DQEBCwUAAgUA6q8cxjAi
# GA8yMDI0MTAwODAyNTE1MFoYDzIwMjQxMDA5MDI1MTUwWjB3MD0GCisGAQQBhFkK
# BAExLzAtMAoCBQDqrxzGAgEAMAoCAQACAgz6AgH/MAcCAQACAhP9MAoCBQDqsG5G
# AgEAMDYGCisGAQQBhFkKBAIxKDAmMAwGCisGAQQBhFkKAwKgCjAIAgEAAgMHoSCh
# CjAIAgEAAgMBhqAwDQYJKoZIhvcNAQELBQADggEBAIXcEJaUkp9LN3Y64qweiKPG
# Rx30rtYWfhGP7+fGG739Xv4vyj+3eLcwGC0bm/el7AHjmtijIrwSx23vwJVrb9yp
# Y5XN7pg/zTl1aECj0JOUOyuOVTTGUpIRDXtxn4B3QSPnqmYtf8DyXhpt/74/KH1c
# DXmnGLlOKUSKeHLuzEoBJSmBcKkopaiGnOIQY4oU9EThlWpb71W/e8WRDmAeE1Dt
# VtHX4wFqaxWdyJSaJYw/ttmjY7geJB4kxQ2UJkoUr47i4QaNysL8PKbO+QH4Lf8i
# h6ye/Za2b8Rk0XDOE4oyFtOvdHX5rM3oK2P7Fd8STFv5pY6BxAQDsipaDgsn5egx
# ggQNMIIECQIBATCBkzB8MQswCQYDVQQGEwJVUzETMBEGA1UECBMKV2FzaGluZ3Rv
# bjEQMA4GA1UEBxMHUmVkbW9uZDEeMBwGA1UEChMVTWljcm9zb2Z0IENvcnBvcmF0
# aW9uMSYwJAYDVQQDEx1NaWNyb3NvZnQgVGltZS1TdGFtcCBQQ0EgMjAxMAITMwAA
# AfAqfB1ZO+YfrQABAAAB8DANBglghkgBZQMEAgEFAKCCAUowGgYJKoZIhvcNAQkD
# MQ0GCyqGSIb3DQEJEAEEMC8GCSqGSIb3DQEJBDEiBCCu/tGp7ObHWYereireHgVV
# K837JFJWrvGQGVwZHX40WTCB+gYLKoZIhvcNAQkQAi8xgeowgecwgeQwgb0EIFwB
# mqOlcv3kU7mAB5sWR74QFAiS6mb+CM6asnFAZUuLMIGYMIGApH4wfDELMAkGA1UE
# BhMCVVMxEzARBgNVBAgTCldhc2hpbmd0b24xEDAOBgNVBAcTB1JlZG1vbmQxHjAc
# BgNVBAoTFU1pY3Jvc29mdCBDb3Jwb3JhdGlvbjEmMCQGA1UEAxMdTWljcm9zb2Z0
# IFRpbWUtU3RhbXAgUENBIDIwMTACEzMAAAHwKnwdWTvmH60AAQAAAfAwIgQgBCLZ
# K6OpyJy4O17PaMSQfQIIQtI2LMoMh0iDR9u2kkMwDQYJKoZIhvcNAQELBQAEggIA
# lcuW/OuYK9dbpd0y1zMjhPnMScZRy7e55Rg4z3iq56skA3YVimpUNWX1uUyyzB8W
# njzhVm6arxv/Ch54Bkt8v5dJPyv+8cy4i6V8UhVSjpO8eNLxgeXdjoDKn+rxrmZY
# xbrsXQ5LDI6ix137zrtJ3YdDTUyTjC2LRJajhxQHpfxD7J2CvMkzryvzTJXKWWcC
# 7xAFi1/IN1h+qhLLXXCxdM303fFedhSwLuZgGi99zXzZRSK3Vjz3CPNZvvKHUe1e
# y7laeJJTloJ7uY4R3ifLx59pp3lGmkdQ1WSqok1udrOW1IkrLLRpHmyaCqkSRXFL
# a8P/Snyso9lz/JRC3NMsmzaVmnB8dpNjGZ0t5wkuq1TRBlSQr2uBcmTE02H8dvpR
# 1vJ4nXK6XwMWWq+JKKN4sDFWAcPMmBJptigxXQRKvZrQsGYrTOxlUJtxS/pfPpiP
# o2JqEN/FSt2ZcsKII/AugmLjagJ1/Ztw06SKfKwiSajRygI54KqL7YT4TSuBDWja
# fkfTNjP87sEEFlrFu6fp6iLFBA2OBOBT3yi/b7mOPTk2jbtvU8PB2toDjCIC5BFc
# cxUQDJL99Ik3ButPJ21U9Kgp6a7ny4SrA69a+0JQYumNbDGiPNw0mpzF/tFoZ0EA
# e9AvCWvOfpMhf8g+e7UEeFB4Wt7XtcbhhRBde/j80/g=
# SIG # End signature block
