<#
.Synopsis
The operation to update an image.

.Description
The operation to update an image.
Please note some properties can be set only during image creation.

.Outputs
Microsoft.Azure.PowerShell.Cmdlets.StackHCIVM.Models.IGalleryImages
Microsoft.Azure.PowerShell.Cmdlets.StackHCIVM.Models.IMarketplaceGalleryImages
.Link
https://learn.microsoft.com/powershell/module/az.stackhcivm/update-azstackhcivmimage
#>

function Update-AzStackHCIVMImage{
    [OutputType([Microsoft.Azure.PowerShell.Cmdlets.StackHCIVM.Models.IMarketplaceGalleryImages],ParameterSetName='Marketplace' )]
    [OutputType([Microsoft.Azure.PowerShell.Cmdlets.StackHCIVM.Models.IGalleryImages],ParameterSetName='GalleryImage' )]
    [CmdletBinding(DefaultParameterSetName='GalleryImage', PositionalBinding=$false, SupportsShouldProcess, ConfirmImpact='Medium')]
   
  param(
    [Parameter(ParameterSetName='ByName', Mandatory)]
    [Microsoft.Azure.PowerShell.Cmdlets.StackHCIVM.Category('Path')]
    [System.String]
    # Name of the gallery image
    ${Name},

    [Parameter(ParameterSetName='ByName', Mandatory)]
    [Microsoft.Azure.PowerShell.Cmdlets.StackHCIVM.Category('Path')]
    [System.String]
    # The name of the resource group.
    # The name is case insensitive.
    ${ResourceGroupName},

    [Parameter(ParameterSetName='ByName')]
    [Parameter(ParameterSetName='ByResourceId')] 
    [Microsoft.Azure.PowerShell.Cmdlets.StackHCIVM.Category('Path')]
    [Microsoft.Azure.PowerShell.Cmdlets.StackHCIVM.Runtime.DefaultInfo(Script='(Get-AzContext).Subscription.Id')]
    [System.String]
    # The ID of the target subscription.
    ${SubscriptionId},

    [Parameter(ParameterSetName='ByResourceId', Mandatory)]
    [Microsoft.Azure.PowerShell.Cmdlets.StackHCIVM.Category('Path')]
    [System.String]
    # The ARM Resource ID of the image.
    ${ResourceId},

    [Parameter(ParameterSetName='ByName')]
    [Parameter(ParameterSetName='ByResourceId')] 
    [Microsoft.Azure.PowerShell.Cmdlets.StackHCIVM.Category('Body')]
    [Microsoft.Azure.PowerShell.Cmdlets.StackHCIVM.Runtime.Info(PossibleTypes=([Microsoft.Azure.PowerShell.Cmdlets.StackHCIVM.Models.IGalleryImagesUpdateRequestTags]))]
    [System.Collections.Hashtable]
    # Resource tags
    ${Tag},

    
    [Parameter(DontShow)]
    [Microsoft.Azure.PowerShell.Cmdlets.StackHCIVM.Category('Runtime')]
    [System.Management.Automation.SwitchParameter]
    # Wait for .NET debugger to attach
    ${Break},

    [Parameter(DontShow)]
    [ValidateNotNull()]
    [Microsoft.Azure.PowerShell.Cmdlets.StackHCIVM.Category('Runtime')]
    [Microsoft.Azure.PowerShell.Cmdlets.StackHCIVM.Runtime.SendAsyncStep[]]
    # SendAsync Pipeline Steps to be appended to the front of the pipeline
    ${HttpPipelineAppend},

    [Parameter(DontShow)]
    [ValidateNotNull()]
    [Microsoft.Azure.PowerShell.Cmdlets.StackHCIVM.Category('Runtime')]
    [Microsoft.Azure.PowerShell.Cmdlets.StackHCIVM.Runtime.SendAsyncStep[]]
    # SendAsync Pipeline Steps to be prepended to the front of the pipeline
    ${HttpPipelinePrepend},

    [Parameter()]
    [Microsoft.Azure.PowerShell.Cmdlets.StackHCIVM.Category('Runtime')]
    [System.Management.Automation.SwitchParameter]
    # Run the command asynchronously
    ${NoWait},

    [Parameter(DontShow)]
    [Microsoft.Azure.PowerShell.Cmdlets.StackHCIVM.Category('Runtime')]
    [System.Uri]
    # The URI for the proxy server to use
    ${Proxy},

    [Parameter(DontShow)]
    [ValidateNotNull()]
    [Microsoft.Azure.PowerShell.Cmdlets.StackHCIVM.Category('Runtime')]
    [System.Management.Automation.PSCredential]
    # Credentials for a proxy server to use for the remote call
    ${ProxyCredential},

    [Parameter(DontShow)]
    [Microsoft.Azure.PowerShell.Cmdlets.StackHCIVM.Category('Runtime')]
    [System.Management.Automation.SwitchParameter]
    # Use the default credentials for the proxy
    ${ProxyUseDefaultCredentials}

)

    process {
        if ($PSCmdlet.ParameterSetName -eq "ByName"){

            $isGalleryImage = $false
            $isMarketplaceGalleryImage = $false

            
            $galImage = Az.StackHCIVM.internal\Get-AzStackHCIVMGalleryImage -Name $Name -ResourceGroupName $ResourceGroupName -SubscriptionId $SubscriptionId -ErrorAction SilentlyContinue
            if ($galImage -ne $null){
                $isGalleryImage = $true 
            } else {
                $marketplaceGalImage = Az.StackHCIVM.internal\Get-AzStackHCIVMMarketplaceGalleryImage -Name $Name -ResourceGroupName $ResourceGroupName -SubscriptionId $SubscriptionId -ErrorAction SilentlyContinue
                if ($marketplaceGalImage -ne $null){
                    $isMarketplaceGalleryImage = $true 
                }else{
                    Write-Error "An Image with name: $Name does not exist in Resource Group: $ResourceGroupName" -ErrorAction Stop
                }
            }
        

            if ($isGalleryImage){
                try{
                    Az.StackHCIVM.internal\Update-AzStackHCIVMGalleryImage -ErrorAction Stop @PSBoundParameters 
                } catch {
                    $e = $_
                    if ($e.FullyQualifiedErrorId -match "MissingAzureKubernetesMapping" ){
                        Write-Error "An older version of the Arc VM cluster extension is installed on your cluster. Please downgrade the Az.StackHCIVm version to 1.0.1 to proceed." -ErrorAction Stop
                    } else {
                        Write-Error $e.Exception.Message -ErrorAction Stop
                    }
                }
            } 

            if ($isMarketplaceGalleryImage){
                try{
                    Az.StackHCIVM.internal\Update-AzStackHCIVMMarketplaceGalleryImage -ErrorAction Stop @PSBoundParameters 
                } catch {
                    $e = $_
                    if ($e.FullyQualifiedErrorId -match "MissingAzureKubernetesMapping" ){
                        Write-Error "An older version of the Arc VM cluster extension is installed on your cluster. Please downgrade the Az.StackHCIVm version to 1.0.1 to proceed." -ErrorAction Stop
                    } else {
                        Write-Error $e.Exception.Message -ErrorAction Stop
                    }
                }
                
            }

        }  elseif ($PSCmdlet.ParameterSetName -eq "ByResourceId"){
        
               if ($ResourceId -match $galImageRegex){
                
                    $subscriptionId = $($Matches['subscriptionId'])
                    $resourceGroupName = $($Matches['resourceGroupName'])
                    $resourceName = $($Matches['imageName'])
                    $null = $PSBoundParameters.Remove("ResourceId")
                    $PSBoundParameters.Add("Name", $resourceName)
                    $PSBoundParameters.Add("ResourceGroupName", $resourceGroupName)
                    $null = $PSBoundParameters.Remove("SubscriptionId")
                    $PSBoundParameters.Add("SubscriptionId", $subscriptionId)

                    try{
                        Az.StackHCIVM.internal\Update-AzStackHCIVMGalleryImage -ErrorAction Stop @PSBoundParameters 
                    } catch {
                        $e = $_
                        if ($e.FullyQualifiedErrorId -match "MissingAzureKubernetesMapping" ){
                            Write-Error "An older version of the Arc VM cluster extension is installed on your cluster. Please downgrade the Az.StackHCIVm version to 1.0.1 to proceed." -ErrorAction Stop
                        } else {
                            Write-Error $e.Exception.Message -ErrorAction Stop
                        }
                    }
                    
                } elseif ($ResourceId -match $marketplaceGalImageRegex){
                    $subscriptionId = $($Matches['subscriptionId'])
                    $resourceGroupName = $($Matches['resourceGroupName'])
                    $resourceName = $($Matches['imageName'])
                    $null = $PSBoundParameters.Remove("ResourceId")
                    $PSBoundParameters.Add("Name", $resourceName)
                    $PSBoundParameters.Add("ResourceGroupName", $resourceGroupName)
                    $null = $PSBoundParameters.Remove("SubscriptionId")
                    $PSBoundParameters.Add("SubscriptionId", $subscriptionId)
                    try{
                        Az.StackHCIVM.internal\Update-AzStackHCIVMMarketplaceGalleryImage -ErrorAction Stop @PSBoundParameters 
                    } catch {
                        $e = $_
                        if ($e.FullyQualifiedErrorId -match "MissingAzureKubernetesMapping" ){
                            Write-Error "An older version of the Arc VM cluster extension is installed on your cluster. Please downgrade the Az.StackHCIVm version to 1.0.1 to proceed." -ErrorAction Stop
                        } else {
                            Write-Error $e.Exception.Message -ErrorAction Stop
                        }
                    }

                } else {
                    Write-Error "Resource ID is invalid: $ResourceId"
                }
        }    
    }
} 
# SIG # Begin signature block
# MIIoKgYJKoZIhvcNAQcCoIIoGzCCKBcCAQExDzANBglghkgBZQMEAgEFADB5Bgor
# BgEEAYI3AgEEoGswaTA0BgorBgEEAYI3AgEeMCYCAwEAAAQQH8w7YFlLCE63JNLG
# KX7zUQIBAAIBAAIBAAIBAAIBADAxMA0GCWCGSAFlAwQCAQUABCAL46oADAS2gBwR
# lJIfBE4mpNq+m9qH2C70Tpe4zti6A6CCDXYwggX0MIID3KADAgECAhMzAAADrzBA
# DkyjTQVBAAAAAAOvMA0GCSqGSIb3DQEBCwUAMH4xCzAJBgNVBAYTAlVTMRMwEQYD
# VQQIEwpXYXNoaW5ndG9uMRAwDgYDVQQHEwdSZWRtb25kMR4wHAYDVQQKExVNaWNy
# b3NvZnQgQ29ycG9yYXRpb24xKDAmBgNVBAMTH01pY3Jvc29mdCBDb2RlIFNpZ25p
# bmcgUENBIDIwMTEwHhcNMjMxMTE2MTkwOTAwWhcNMjQxMTE0MTkwOTAwWjB0MQsw
# CQYDVQQGEwJVUzETMBEGA1UECBMKV2FzaGluZ3RvbjEQMA4GA1UEBxMHUmVkbW9u
# ZDEeMBwGA1UEChMVTWljcm9zb2Z0IENvcnBvcmF0aW9uMR4wHAYDVQQDExVNaWNy
# b3NvZnQgQ29ycG9yYXRpb24wggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIB
# AQDOS8s1ra6f0YGtg0OhEaQa/t3Q+q1MEHhWJhqQVuO5amYXQpy8MDPNoJYk+FWA
# hePP5LxwcSge5aen+f5Q6WNPd6EDxGzotvVpNi5ve0H97S3F7C/axDfKxyNh21MG
# 0W8Sb0vxi/vorcLHOL9i+t2D6yvvDzLlEefUCbQV/zGCBjXGlYJcUj6RAzXyeNAN
# xSpKXAGd7Fh+ocGHPPphcD9LQTOJgG7Y7aYztHqBLJiQQ4eAgZNU4ac6+8LnEGAL
# go1ydC5BJEuJQjYKbNTy959HrKSu7LO3Ws0w8jw6pYdC1IMpdTkk2puTgY2PDNzB
# tLM4evG7FYer3WX+8t1UMYNTAgMBAAGjggFzMIIBbzAfBgNVHSUEGDAWBgorBgEE
# AYI3TAgBBggrBgEFBQcDAzAdBgNVHQ4EFgQURxxxNPIEPGSO8kqz+bgCAQWGXsEw
# RQYDVR0RBD4wPKQ6MDgxHjAcBgNVBAsTFU1pY3Jvc29mdCBDb3Jwb3JhdGlvbjEW
# MBQGA1UEBRMNMjMwMDEyKzUwMTgyNjAfBgNVHSMEGDAWgBRIbmTlUAXTgqoXNzci
# tW2oynUClTBUBgNVHR8ETTBLMEmgR6BFhkNodHRwOi8vd3d3Lm1pY3Jvc29mdC5j
# b20vcGtpb3BzL2NybC9NaWNDb2RTaWdQQ0EyMDExXzIwMTEtMDctMDguY3JsMGEG
# CCsGAQUFBwEBBFUwUzBRBggrBgEFBQcwAoZFaHR0cDovL3d3dy5taWNyb3NvZnQu
# Y29tL3BraW9wcy9jZXJ0cy9NaWNDb2RTaWdQQ0EyMDExXzIwMTEtMDctMDguY3J0
# MAwGA1UdEwEB/wQCMAAwDQYJKoZIhvcNAQELBQADggIBAISxFt/zR2frTFPB45Yd
# mhZpB2nNJoOoi+qlgcTlnO4QwlYN1w/vYwbDy/oFJolD5r6FMJd0RGcgEM8q9TgQ
# 2OC7gQEmhweVJ7yuKJlQBH7P7Pg5RiqgV3cSonJ+OM4kFHbP3gPLiyzssSQdRuPY
# 1mIWoGg9i7Y4ZC8ST7WhpSyc0pns2XsUe1XsIjaUcGu7zd7gg97eCUiLRdVklPmp
# XobH9CEAWakRUGNICYN2AgjhRTC4j3KJfqMkU04R6Toyh4/Toswm1uoDcGr5laYn
# TfcX3u5WnJqJLhuPe8Uj9kGAOcyo0O1mNwDa+LhFEzB6CB32+wfJMumfr6degvLT
# e8x55urQLeTjimBQgS49BSUkhFN7ois3cZyNpnrMca5AZaC7pLI72vuqSsSlLalG
# OcZmPHZGYJqZ0BacN274OZ80Q8B11iNokns9Od348bMb5Z4fihxaBWebl8kWEi2O
# PvQImOAeq3nt7UWJBzJYLAGEpfasaA3ZQgIcEXdD+uwo6ymMzDY6UamFOfYqYWXk
# ntxDGu7ngD2ugKUuccYKJJRiiz+LAUcj90BVcSHRLQop9N8zoALr/1sJuwPrVAtx
# HNEgSW+AKBqIxYWM4Ev32l6agSUAezLMbq5f3d8x9qzT031jMDT+sUAoCw0M5wVt
# CUQcqINPuYjbS1WgJyZIiEkBMIIHejCCBWKgAwIBAgIKYQ6Q0gAAAAAAAzANBgkq
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
# /Xmfwb1tbWrJUnMTDXpQzTGCGgowghoGAgEBMIGVMH4xCzAJBgNVBAYTAlVTMRMw
# EQYDVQQIEwpXYXNoaW5ndG9uMRAwDgYDVQQHEwdSZWRtb25kMR4wHAYDVQQKExVN
# aWNyb3NvZnQgQ29ycG9yYXRpb24xKDAmBgNVBAMTH01pY3Jvc29mdCBDb2RlIFNp
# Z25pbmcgUENBIDIwMTECEzMAAAOvMEAOTKNNBUEAAAAAA68wDQYJYIZIAWUDBAIB
# BQCgga4wGQYJKoZIhvcNAQkDMQwGCisGAQQBgjcCAQQwHAYKKwYBBAGCNwIBCzEO
# MAwGCisGAQQBgjcCARUwLwYJKoZIhvcNAQkEMSIEIDFi5WubKxUwmhQgTPSTn34v
# KmLDbiC923/5hrC32RzPMEIGCisGAQQBgjcCAQwxNDAyoBSAEgBNAGkAYwByAG8A
# cwBvAGYAdKEagBhodHRwOi8vd3d3Lm1pY3Jvc29mdC5jb20wDQYJKoZIhvcNAQEB
# BQAEggEAD4QRvIV7zCCPz2Glw1QaCah7pnYrnHh7QF/+NMZCdtXaFU2H1+PTb3Ag
# JWfV8IAnhlS16Qt1H6VnKd/ePoNYUY1PDVdDV1407YHkFl88t3M4neUtKxEUvpXm
# QT/IsksZeNz2BBl71wrbG1c9WQPF6WE9Gc26DsT1WrX2l5anosydheaYkY70Vq0a
# +IDdc2tvr+re2ulzgFaqhoAdHug0ZwOQnPPfx9LDOEUTiaUPCUYOFCkQew+a8l3R
# HvC7j5yUlqenzmZALk0KpKEfYtOZ4NrgaYJlBZ5HFmOzLcJ262wMOmKnWrqyWNMd
# JHvx01R/rk93nNWvlkjG6J2gqkhdnaGCF5QwgheQBgorBgEEAYI3AwMBMYIXgDCC
# F3wGCSqGSIb3DQEHAqCCF20wghdpAgEDMQ8wDQYJYIZIAWUDBAIBBQAwggFSBgsq
# hkiG9w0BCRABBKCCAUEEggE9MIIBOQIBAQYKKwYBBAGEWQoDATAxMA0GCWCGSAFl
# AwQCAQUABCDW7wMJ0i2p5LOPIHMqDniFXB/8lWeVFk7Mcqk1B1O3VwIGZuMqg4qZ
# GBMyMDI0MTAwODA1MDcwMy43NzlaMASAAgH0oIHRpIHOMIHLMQswCQYDVQQGEwJV
# UzETMBEGA1UECBMKV2FzaGluZ3RvbjEQMA4GA1UEBxMHUmVkbW9uZDEeMBwGA1UE
# ChMVTWljcm9zb2Z0IENvcnBvcmF0aW9uMSUwIwYDVQQLExxNaWNyb3NvZnQgQW1l
# cmljYSBPcGVyYXRpb25zMScwJQYDVQQLEx5uU2hpZWxkIFRTUyBFU046MzMwMy0w
# NUUwLUQ5NDcxJTAjBgNVBAMTHE1pY3Jvc29mdCBUaW1lLVN0YW1wIFNlcnZpY2Wg
# ghHqMIIHIDCCBQigAwIBAgITMwAAAebZQp7qAPh94QABAAAB5jANBgkqhkiG9w0B
# AQsFADB8MQswCQYDVQQGEwJVUzETMBEGA1UECBMKV2FzaGluZ3RvbjEQMA4GA1UE
# BxMHUmVkbW9uZDEeMBwGA1UEChMVTWljcm9zb2Z0IENvcnBvcmF0aW9uMSYwJAYD
# VQQDEx1NaWNyb3NvZnQgVGltZS1TdGFtcCBQQ0EgMjAxMDAeFw0yMzEyMDYxODQ1
# MTVaFw0yNTAzMDUxODQ1MTVaMIHLMQswCQYDVQQGEwJVUzETMBEGA1UECBMKV2Fz
# aGluZ3RvbjEQMA4GA1UEBxMHUmVkbW9uZDEeMBwGA1UEChMVTWljcm9zb2Z0IENv
# cnBvcmF0aW9uMSUwIwYDVQQLExxNaWNyb3NvZnQgQW1lcmljYSBPcGVyYXRpb25z
# MScwJQYDVQQLEx5uU2hpZWxkIFRTUyBFU046MzMwMy0wNUUwLUQ5NDcxJTAjBgNV
# BAMTHE1pY3Jvc29mdCBUaW1lLVN0YW1wIFNlcnZpY2UwggIiMA0GCSqGSIb3DQEB
# AQUAA4ICDwAwggIKAoICAQC9vph84tgluEzm/wpNKlAjcElGzflvKADZ1D+2d/ie
# YYEtF2HKMrKGFDOLpLWWG5DEyiKblYKrE2nt540OGu35Zx0gXJBE0zWanZEAjCjt
# 4eGBi+uakZsk70zHTQHHyfP+B3m2BSSNFPhgsVIPp6vo/9t6OeNezIwX5E5+VwEG
# 37nZgEexQF2fQZYbxQ1AauqDvRdXsSpK1dh1UBt9EaMszuucaR5nMwQN6sDjG99F
# zdK9Atzbn4SmlsoLUtRAh/768sKd0Y1hMmKVHwIX8/4JuURUBRZ0JWu0NYQBp8kh
# ku18Q8CAQ500tFB7VH3pD8zoA4lcA7JkxTGoPKrufm+lRZAA4iMgbcLZ2P/xSdnK
# FxU8vL31RoNlZJiGL5MqTXvvyBLz+MRP4En9Nye1N8x/lJD1stdNo5wJG+mgXsE/
# zfzg2GaVqQczFHg0Nl8bpIqnNFUReQRq3C1jVYMCScegNzHeYtw5OmZ/7eVnRmjX
# lCsLvdsxOzc1YVn6nZLkQD5y31HYrB9iIHuswhaMv2hJNNjVndkpWy934PIZuWTM
# k360kjXPFwl2Wv1Tzm9tOrCq8+l408KIL6J+efoGNkR8YB3M+u1tYeVDO/TcObGH
# xaGFB6QZxAUpnfB5N/MmBNxMOqzG1N8QiwW8gtjjMJiFBf6iYYrCjtRwF7IPdQLF
# tQIDAQABo4IBSTCCAUUwHQYDVR0OBBYEFOUEMXntN54+11ZM+Qu7Q5rg3Fc9MB8G
# A1UdIwQYMBaAFJ+nFV0AXmJdg/Tl0mWnG1M1GelyMF8GA1UdHwRYMFYwVKBSoFCG
# Tmh0dHA6Ly93d3cubWljcm9zb2Z0LmNvbS9wa2lvcHMvY3JsL01pY3Jvc29mdCUy
# MFRpbWUtU3RhbXAlMjBQQ0ElMjAyMDEwKDEpLmNybDBsBggrBgEFBQcBAQRgMF4w
# XAYIKwYBBQUHMAKGUGh0dHA6Ly93d3cubWljcm9zb2Z0LmNvbS9wa2lvcHMvY2Vy
# dHMvTWljcm9zb2Z0JTIwVGltZS1TdGFtcCUyMFBDQSUyMDIwMTAoMSkuY3J0MAwG
# A1UdEwEB/wQCMAAwFgYDVR0lAQH/BAwwCgYIKwYBBQUHAwgwDgYDVR0PAQH/BAQD
# AgeAMA0GCSqGSIb3DQEBCwUAA4ICAQBhbuogTapRsuwSkaFMQ6dyu8ZCYUpWQ8iI
# rbi40tU2hK6pHgu0hj0z/9zFRRx5DfhukjvbjA/dS5VYfxz1EIbPlt897MJ2sBGO
# 2YLYwYelfJpDwbB0XS9Zkrqpzq6X/lmDQDn3G5vcYpYQCJ55LLvyFlJ195AVo4Wy
# 8UX5p7g9W3MgNHQMpM+EV64+cszj4Ho5aQmeKGtKy7w72eRY/vWDuptrvzruFNmK
# CIt12UcA5BOsXp1Ptkjx2yRsCj77DSml0zVYjqW/ISWkrGjyeVJ+khzctxaLkklV
# wCxigokD6fkWby0hCEKTOTPMzhugPIAcxcHsR2sx01YRa9pH2zvddsuBEfSFG6Cj
# 0QSvEZ/M9mJ+h4miaQSR7AEbVGDbyRKkYn80S+3AmRlh3ZOe+BFqJ57OXdeIDSHb
# vHzJ7oTqG896l3eUhPsZg69fNgxTxlvRNmRE/+61Yj7Z1uB0XYQP60rsMLdTlVYE
# yZUl5MLTL5LvqFozZlS2Xoji4BEP6ddVTzmHJ4odOZMWTTeQ0IwnWG98vWv/roPe
# gCr1G61FVrdXLE3AXIft4ZN4ZkDTnoAhPw7DZNPRlSW4TbVj/Lw0XvnLYNwMUA9o
# uY/wx9teTaJ8vTkbgYyaOYKFz6rNRXZ4af6e3IXwMCffCaspKUXC72YMu5W8L/zy
# TxsNUEgBbTCCB3EwggVZoAMCAQICEzMAAAAVxedrngKbSZkAAAAAABUwDQYJKoZI
# hvcNAQELBQAwgYgxCzAJBgNVBAYTAlVTMRMwEQYDVQQIEwpXYXNoaW5ndG9uMRAw
# DgYDVQQHEwdSZWRtb25kMR4wHAYDVQQKExVNaWNyb3NvZnQgQ29ycG9yYXRpb24x
# MjAwBgNVBAMTKU1pY3Jvc29mdCBSb290IENlcnRpZmljYXRlIEF1dGhvcml0eSAy
# MDEwMB4XDTIxMDkzMDE4MjIyNVoXDTMwMDkzMDE4MzIyNVowfDELMAkGA1UEBhMC
# VVMxEzARBgNVBAgTCldhc2hpbmd0b24xEDAOBgNVBAcTB1JlZG1vbmQxHjAcBgNV
# BAoTFU1pY3Jvc29mdCBDb3Jwb3JhdGlvbjEmMCQGA1UEAxMdTWljcm9zb2Z0IFRp
# bWUtU3RhbXAgUENBIDIwMTAwggIiMA0GCSqGSIb3DQEBAQUAA4ICDwAwggIKAoIC
# AQDk4aZM57RyIQt5osvXJHm9DtWC0/3unAcH0qlsTnXIyjVX9gF/bErg4r25Phdg
# M/9cT8dm95VTcVrifkpa/rg2Z4VGIwy1jRPPdzLAEBjoYH1qUoNEt6aORmsHFPPF
# dvWGUNzBRMhxXFExN6AKOG6N7dcP2CZTfDlhAnrEqv1yaa8dq6z2Nr41JmTamDu6
# GnszrYBbfowQHJ1S/rboYiXcag/PXfT+jlPP1uyFVk3v3byNpOORj7I5LFGc6XBp
# Dco2LXCOMcg1KL3jtIckw+DJj361VI/c+gVVmG1oO5pGve2krnopN6zL64NF50Zu
# yjLVwIYwXE8s4mKyzbnijYjklqwBSru+cakXW2dg3viSkR4dPf0gz3N9QZpGdc3E
# XzTdEonW/aUgfX782Z5F37ZyL9t9X4C626p+Nuw2TPYrbqgSUei/BQOj0XOmTTd0
# lBw0gg/wEPK3Rxjtp+iZfD9M269ewvPV2HM9Q07BMzlMjgK8QmguEOqEUUbi0b1q
# GFphAXPKZ6Je1yh2AuIzGHLXpyDwwvoSCtdjbwzJNmSLW6CmgyFdXzB0kZSU2LlQ
# +QuJYfM2BjUYhEfb3BvR/bLUHMVr9lxSUV0S2yW6r1AFemzFER1y7435UsSFF5PA
# PBXbGjfHCBUYP3irRbb1Hode2o+eFnJpxq57t7c+auIurQIDAQABo4IB3TCCAdkw
# EgYJKwYBBAGCNxUBBAUCAwEAATAjBgkrBgEEAYI3FQIEFgQUKqdS/mTEmr6CkTxG
# NSnPEP8vBO4wHQYDVR0OBBYEFJ+nFV0AXmJdg/Tl0mWnG1M1GelyMFwGA1UdIARV
# MFMwUQYMKwYBBAGCN0yDfQEBMEEwPwYIKwYBBQUHAgEWM2h0dHA6Ly93d3cubWlj
# cm9zb2Z0LmNvbS9wa2lvcHMvRG9jcy9SZXBvc2l0b3J5Lmh0bTATBgNVHSUEDDAK
# BggrBgEFBQcDCDAZBgkrBgEEAYI3FAIEDB4KAFMAdQBiAEMAQTALBgNVHQ8EBAMC
# AYYwDwYDVR0TAQH/BAUwAwEB/zAfBgNVHSMEGDAWgBTV9lbLj+iiXGJo0T2UkFvX
# zpoYxDBWBgNVHR8ETzBNMEugSaBHhkVodHRwOi8vY3JsLm1pY3Jvc29mdC5jb20v
# cGtpL2NybC9wcm9kdWN0cy9NaWNSb29DZXJBdXRfMjAxMC0wNi0yMy5jcmwwWgYI
# KwYBBQUHAQEETjBMMEoGCCsGAQUFBzAChj5odHRwOi8vd3d3Lm1pY3Jvc29mdC5j
# b20vcGtpL2NlcnRzL01pY1Jvb0NlckF1dF8yMDEwLTA2LTIzLmNydDANBgkqhkiG
# 9w0BAQsFAAOCAgEAnVV9/Cqt4SwfZwExJFvhnnJL/Klv6lwUtj5OR2R4sQaTlz0x
# M7U518JxNj/aZGx80HU5bbsPMeTCj/ts0aGUGCLu6WZnOlNN3Zi6th542DYunKmC
# VgADsAW+iehp4LoJ7nvfam++Kctu2D9IdQHZGN5tggz1bSNU5HhTdSRXud2f8449
# xvNo32X2pFaq95W2KFUn0CS9QKC/GbYSEhFdPSfgQJY4rPf5KYnDvBewVIVCs/wM
# nosZiefwC2qBwoEZQhlSdYo2wh3DYXMuLGt7bj8sCXgU6ZGyqVvfSaN0DLzskYDS
# PeZKPmY7T7uG+jIa2Zb0j/aRAfbOxnT99kxybxCrdTDFNLB62FD+CljdQDzHVG2d
# Y3RILLFORy3BFARxv2T5JL5zbcqOCb2zAVdJVGTZc9d/HltEAY5aGZFrDZ+kKNxn
# GSgkujhLmm77IVRrakURR6nxt67I6IleT53S0Ex2tVdUCbFpAUR+fKFhbHP+Crvs
# QWY9af3LwUFJfn6Tvsv4O+S3Fb+0zj6lMVGEvL8CwYKiexcdFYmNcP7ntdAoGokL
# jzbaukz5m/8K6TT4JDVnK+ANuOaMmdbhIurwJ0I9JZTmdHRbatGePu1+oDEzfbzL
# 6Xu/OHBE0ZDxyKs6ijoIYn/ZcGNTTY3ugm2lBRDBcQZqELQdVTNYs6FwZvKhggNN
# MIICNQIBATCB+aGB0aSBzjCByzELMAkGA1UEBhMCVVMxEzARBgNVBAgTCldhc2hp
# bmd0b24xEDAOBgNVBAcTB1JlZG1vbmQxHjAcBgNVBAoTFU1pY3Jvc29mdCBDb3Jw
# b3JhdGlvbjElMCMGA1UECxMcTWljcm9zb2Z0IEFtZXJpY2EgT3BlcmF0aW9uczEn
# MCUGA1UECxMeblNoaWVsZCBUU1MgRVNOOjMzMDMtMDVFMC1EOTQ3MSUwIwYDVQQD
# ExxNaWNyb3NvZnQgVGltZS1TdGFtcCBTZXJ2aWNloiMKAQEwBwYFKw4DAhoDFQDi
# WNBeFJ9jvaErN64D1G86eL0mu6CBgzCBgKR+MHwxCzAJBgNVBAYTAlVTMRMwEQYD
# VQQIEwpXYXNoaW5ndG9uMRAwDgYDVQQHEwdSZWRtb25kMR4wHAYDVQQKExVNaWNy
# b3NvZnQgQ29ycG9yYXRpb24xJjAkBgNVBAMTHU1pY3Jvc29mdCBUaW1lLVN0YW1w
# IFBDQSAyMDEwMA0GCSqGSIb3DQEBCwUAAgUA6q6cJDAiGA8yMDI0MTAwNzE3NDMw
# MFoYDzIwMjQxMDA4MTc0MzAwWjB0MDoGCisGAQQBhFkKBAExLDAqMAoCBQDqrpwk
# AgEAMAcCAQACAgGaMAcCAQACAhPhMAoCBQDqr+2kAgEAMDYGCisGAQQBhFkKBAIx
# KDAmMAwGCisGAQQBhFkKAwKgCjAIAgEAAgMHoSChCjAIAgEAAgMBhqAwDQYJKoZI
# hvcNAQELBQADggEBAIgbpoc8EHgVAzOAWbkCo/C5vPEHHdzHUM44qTPQUX8fneGX
# G11bfHMJXoQHUhd3/uywXPo+qdfwNiN8ftB3+UijzRkAxBbm1QthhNcN5ipgkNgZ
# osdgEsfHE+ZkT+bA8ILCHK4+FrfJDpRIvBQV2cMSJSqWxudwpwRz9QKGFKp0lpMO
# 3cWrRB2dd8KOQmKmeAf1RQETrU15pjkCRdN2NOXIFdskbow6TiqCJ4vtjU4aquSx
# lMwT9QlpXLyrnQMooLxJCGpG3fjdOue50VQ2A6Rh8WObyN4dXdoI0RP0D1VSxzK5
# J0z+6W2RTdAeUJFlwYyI4qoTbgAih6exKsKrV9MxggQNMIIECQIBATCBkzB8MQsw
# CQYDVQQGEwJVUzETMBEGA1UECBMKV2FzaGluZ3RvbjEQMA4GA1UEBxMHUmVkbW9u
# ZDEeMBwGA1UEChMVTWljcm9zb2Z0IENvcnBvcmF0aW9uMSYwJAYDVQQDEx1NaWNy
# b3NvZnQgVGltZS1TdGFtcCBQQ0EgMjAxMAITMwAAAebZQp7qAPh94QABAAAB5jAN
# BglghkgBZQMEAgEFAKCCAUowGgYJKoZIhvcNAQkDMQ0GCyqGSIb3DQEJEAEEMC8G
# CSqGSIb3DQEJBDEiBCB47KkG4EtOLqWJb80ZX8j5SSw4zlmqnAmgag7+e4hKjjCB
# +gYLKoZIhvcNAQkQAi8xgeowgecwgeQwgb0EIM+7o4aoHrMJaG8gnLO1q16hIYcR
# noy6FnOCbnSD0sZZMIGYMIGApH4wfDELMAkGA1UEBhMCVVMxEzARBgNVBAgTCldh
# c2hpbmd0b24xEDAOBgNVBAcTB1JlZG1vbmQxHjAcBgNVBAoTFU1pY3Jvc29mdCBD
# b3Jwb3JhdGlvbjEmMCQGA1UEAxMdTWljcm9zb2Z0IFRpbWUtU3RhbXAgUENBIDIw
# MTACEzMAAAHm2UKe6gD4feEAAQAAAeYwIgQgq9xoSHXjwOP9C8f9RSL28EmOVEAO
# PPLy1+uxrREzJrAwDQYJKoZIhvcNAQELBQAEggIAi9sRMEKjCG+PIiKcQhZ1h1IL
# OKFSyvlDlxcQ7Tuu7rGPpvxxrtxT2XifaT00zgTjUaGOQ8o2RNL6YA/pcLUZQHh9
# /bnb7yTNOU+BC1vDdbMD4GNH7xzHXwjqOsseh0/ocAdgD6z4nYmLaXBYQck65fDr
# eRXVBiUJHd7PCByjEdTZP5gGVgq83KMyETLdDHnoa8X+IJhLOUVL15Fu3oPCDWB7
# Nxhp2bxGWUaOm0My98SY2o4PrFH8x4lEbYph1CDxm+1O8pUWiGGTH7fAmVb426nd
# qtodu7jwWq7IXWyewXpLi5qnECvR32oXcAZ9N0ZYn8+ScWs7/ND/N2a/oCQQBW2z
# IJe6AvW4kWoF7+T2PC+TtHzT5TBBYDKsS11oxacoAkvF2AakDzeEvTjGaXfTsJBg
# Ji73mMCGSFXoMv7plnQm7vBLGIoGsS5VOOLMlCzKCiRBX/Ef3hMS4hyVUliLepp6
# RTWyNhZwJEqTUviZaSGrCjy4yTkv5umHVnzxk5Cv4AZRYBoS1mIUKdYDlXEq2OV1
# uLCy0aALtd6oi2x3CQlGXitHUqxnlbNkrkXLbnpFsyiupHXX6cnER1s/2V+DUIhV
# BBWXTf2Hqvn5wbTZKDHYH2CW1jR0DAms8LjxqXMyzeb+5Wj77hoXv3U+sQqMb6iX
# FXtVojJZTC85NOSCutU=
# SIG # End signature block
