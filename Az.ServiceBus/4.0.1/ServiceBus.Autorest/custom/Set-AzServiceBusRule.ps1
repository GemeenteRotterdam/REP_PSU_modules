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
Updates a ServiceBus Rule
.Description
Updates a ServiceBus Rule
#>

function Set-AzServiceBusRule{
	[OutputType([Microsoft.Azure.PowerShell.Cmdlets.ServiceBus.Models.IRule])]
    [CmdletBinding(DefaultParameterSetName = 'SetExpanded', PositionalBinding = $false, SupportsShouldProcess, ConfirmImpact = 'Medium')]
	param(
		[Parameter(ParameterSetName = 'SetExpanded', Mandatory, HelpMessage = "The name of the Rule.")]
        [Alias('RuleName')]
        [Microsoft.Azure.PowerShell.Cmdlets.ServiceBus.Category('Path')]
        [System.String]
        # The name of the Rule.
        ${Name},

        [Parameter(ParameterSetName = 'SetExpanded', Mandatory, HelpMessage = "The name of the Topic.")]
        [Microsoft.Azure.PowerShell.Cmdlets.ServiceBus.Category('Path')]
        [System.String]
        # The name of the Topic.
        ${TopicName},

        [Parameter(ParameterSetName = 'SetExpanded', Mandatory, HelpMessage = "The name of the SubscriptionName.")]
        [Microsoft.Azure.PowerShell.Cmdlets.ServiceBus.Category('Path')]
        [System.String]
        # The name of the SubscriptionName.
        ${SubscriptionName},

        [Parameter(ParameterSetName = 'SetExpanded', Mandatory, HelpMessage = "The name of ServiceBus namespace")]
        [Microsoft.Azure.PowerShell.Cmdlets.ServiceBus.Category('Path')]
        [System.String]
        # The name of ServiceBus namespace
        ${NamespaceName},

        [Parameter(ParameterSetName = 'SetExpanded', Mandatory, HelpMessage = "The name of the resource group. The name is case insensitive.")]
        [Microsoft.Azure.PowerShell.Cmdlets.ServiceBus.Category('Path')]
        [System.String]
        # The name of the resource group.
        # The name is case insensitive.
        ${ResourceGroupName},

        [Parameter(ParameterSetName = 'SetExpanded', HelpMessage = "The ID of the target subscription.")]
        [Microsoft.Azure.PowerShell.Cmdlets.ServiceBus.Category('Path')]
        [Microsoft.Azure.PowerShell.Cmdlets.ServiceBus.Runtime.DefaultInfo(Script = '(Get-AzContext).Subscription.Id')]
        [System.String]
        # The ID of the target subscription.
        ${SubscriptionId},

        [Parameter(ParameterSetName = 'SetViaIdentityExpanded', Mandatory, ValueFromPipeline, HelpMessage = "Identity parameter. To construct, see NOTES section for INPUTOBJECT properties and create a hash table.")]
        [Microsoft.Azure.PowerShell.Cmdlets.ServiceBus.Category('Path')]
        [Microsoft.Azure.PowerShell.Cmdlets.ServiceBus.Models.IServiceBusIdentity]
        # Identity Parameter
        # To construct, see NOTES section for INPUTOBJECT properties and create a hash table.
        ${InputObject},

        [Parameter(HelpMessage = "SQL expression. e.g. MyProperty='ABC'")]
		[Microsoft.Azure.PowerShell.Cmdlets.ServiceBus.Category('Body')]
		[System.String]
		# SQL expression. e.g. MyProperty='ABC'
		${SqlExpression},

        [Parameter(HelpMessage = "Value that indicates whether the rule action requires preprocessing.")]
        [Microsoft.Azure.PowerShell.Cmdlets.ServiceBus.Category('Body')]
        [System.Management.Automation.SwitchParameter]
        # Value that indicates whether the rule action requires preprocessing.
        ${SqlFilterRequiresPreprocessing},

        [Parameter(HelpMessage = "Content type of the message.")]
		[Microsoft.Azure.PowerShell.Cmdlets.ServiceBus.Category('Body')]
		[System.String]
		# Content type of the message.
		${ContentType},

        [Parameter(HelpMessage = "Identifier of the correlation.")]
		[Microsoft.Azure.PowerShell.Cmdlets.ServiceBus.Category('Body')]
		[System.String]
		# Identifier of the correlation.
		${CorrelationId},

        [Parameter(HelpMessage = "Application specific label.")]
		[Microsoft.Azure.PowerShell.Cmdlets.ServiceBus.Category('Body')]
		[System.String]
		# Application specific label.
		${Label},

        [Parameter(HelpMessage = "Identifier of the message.")]
		[Microsoft.Azure.PowerShell.Cmdlets.ServiceBus.Category('Body')]
		[System.String]
		# Identifier of the message.
		${MessageId},

        [Parameter(HelpMessage = "dictionary object for custom filters")]
		[Microsoft.Azure.PowerShell.Cmdlets.ServiceBus.Category('Body')]
		[System.Collections.Hashtable]
		# dictionary object for custom filters
		${CorrelationFilterProperty},

        [Parameter(HelpMessage = "Address of the queue to reply to.")]
		[Microsoft.Azure.PowerShell.Cmdlets.ServiceBus.Category('Body')]
		[System.String]
		# Address of the queue to reply to.
		${ReplyTo},

        [Parameter(HelpMessage = "Session identifier to reply to.")]
		[Microsoft.Azure.PowerShell.Cmdlets.ServiceBus.Category('Body')]
		[System.String]
		# Session identifier to reply to.
		${ReplyToSessionId},

        [Parameter(HelpMessage = "Value that indicates whether the rule action requires preprocessing.")]
        [Microsoft.Azure.PowerShell.Cmdlets.ServiceBus.Category('Body')]
        [System.Management.Automation.SwitchParameter]
        # Value that indicates whether the rule action requires preprocessing.
        ${CorrelationFilterRequiresPreprocessing},

        [Parameter(HelpMessage = "Session identifier.")]
		[Microsoft.Azure.PowerShell.Cmdlets.ServiceBus.Category('Body')]
		[System.String]
		# Session identifier.
		${SessionId},

        [Parameter(HelpMessage = "Address to send to.")]
        [Microsoft.Azure.PowerShell.Cmdlets.ServiceBus.Category('Body')]
        [System.String]
        # Address to send to.
        ${To},

        [Parameter(HelpMessage = "Filter type that is evaluated against a BrokeredMessage.")]
        [Microsoft.Azure.PowerShell.Cmdlets.ServiceBus.Category('Body')]
        [System.String]
        # Filter type that is evaluated against a BrokeredMessage.
        ${FilterType},

        [Parameter(HelpMessage = "Value that indicates whether the rule action requires preprocessing.")]
        [Microsoft.Azure.PowerShell.Cmdlets.ServiceBus.Category('Body')]
        [System.Management.Automation.SwitchParameter]
        # Value that indicates whether the rule action requires preprocessing. 
        ${ActionRequiresPreprocessing},

        [Parameter(HelpMessage = "SQL expression. e.g. MyProperty='ABC'")]
		[Microsoft.Azure.PowerShell.Cmdlets.ServiceBus.Category('Body')]
		[System.String]
		# SQL expression. e.g. MyProperty='ABC'
		${ActionSqlExpression},

        [Parameter(HelpMessage = "The credentials, account, tenant, and subscription used for communication with Azure.")]
        [Alias('AzureRMContext', 'AzureCredential')]
        [ValidateNotNull()]
        [Microsoft.Azure.PowerShell.Cmdlets.ServiceBus.Category('Azure')]
        [System.Management.Automation.PSObject]
        # The credentials, account, tenant, and subscription used for communication with Azure.
        ${DefaultProfile},

        [Parameter(HelpMessage = "Run the command as a job")]
        [Microsoft.Azure.PowerShell.Cmdlets.ServiceBus.Category('Runtime')]
        [System.Management.Automation.SwitchParameter]
        # Run the command as a job
        ${AsJob},

        [Parameter(DontShow)]
        [Microsoft.Azure.PowerShell.Cmdlets.ServiceBus.Category('Runtime')]
        [System.Management.Automation.SwitchParameter]
        # Wait for .NET debugger to attach
        ${Break},

        [Parameter(DontShow)]
        [ValidateNotNull()]
        [Microsoft.Azure.PowerShell.Cmdlets.ServiceBus.Category('Runtime')]
        [Microsoft.Azure.PowerShell.Cmdlets.ServiceBus.Runtime.SendAsyncStep[]]
        # SendAsync Pipeline Steps to be appended to the front of the pipeline
        ${HttpPipelineAppend},

        [Parameter(DontShow)]
        [ValidateNotNull()]
        [Microsoft.Azure.PowerShell.Cmdlets.ServiceBus.Category('Runtime')]
        [Microsoft.Azure.PowerShell.Cmdlets.ServiceBus.Runtime.SendAsyncStep[]]
        # SendAsync Pipeline Steps to be prepended to the front of the pipeline
        ${HttpPipelinePrepend},

        [Parameter(HelpMessage = "Run the command asynchronously")]
        [Microsoft.Azure.PowerShell.Cmdlets.ServiceBus.Category('Runtime')]
        [System.Management.Automation.SwitchParameter]
        # Run the command asynchronously
        ${NoWait},

        [Parameter(DontShow)]
        [Microsoft.Azure.PowerShell.Cmdlets.ServiceBus.Category('Runtime')]
        [System.Uri]
        # The URI for the proxy server to use
        ${Proxy},

        [Parameter(DontShow)]
        [ValidateNotNull()]
        [Microsoft.Azure.PowerShell.Cmdlets.ServiceBus.Category('Runtime')]
        [System.Management.Automation.PSCredential]
        # Credentials for a proxy server to use for the remote call
        ${ProxyCredential},

        [Parameter(DontShow)]
        [Microsoft.Azure.PowerShell.Cmdlets.ServiceBus.Category('Runtime')]
        [System.Management.Automation.SwitchParameter]
        # Use the default credentials for the proxy
        ${ProxyUseDefaultCredentials}
	)
	process{
		try{
            $hasSqlExpression = $PSBoundParameters.Remove('SqlExpression')
            $hasSqlFilterRequiresPreprocessing = $PSBoundParameters.Remove('SqlFilterRequiresPreprocessing')
            $hasContentType = $PSBoundParameters.Remove('ContentType')
            $hasCorrelationId = $PSBoundParameters.Remove('CorrelationId')
            $hasLabel = $PSBoundParameters.Remove('Label')
            $hasMessageId = $PSBoundParameters.Remove('MessageId')
            $hasCorrelationFilterProperty = $PSBoundParameters.Remove('CorrelationFilterProperty')
            $hasReplyTo = $PSBoundParameters.Remove('ReplyTo')
            $hasReplyToSessionId = $PSBoundParameters.Remove('ReplyToSessionId')
            $hasCorrelationFilterRequiresPreprocessing = $PSBoundParameters.Remove('CorrelationFilterRequiresPreprocessing')
            $hasSessionId = $PSBoundParameters.Remove('SessionId')
            $hasTo = $PSBoundParameters.Remove('To')
            $hasFilterType = $PSBoundParameters.Remove('FilterType')
            $hasActionSqlExpression = $PSBoundParameters.Remove('ActionSqlExpression')
            $hasActionRequiresPreprocessing = $PSBoundParameters.Remove('ActionRequiresPreprocessing')

            $rule = Get-AzServiceBusRule @PSBoundParameters

            # 2. PUT
            $null = $PSBoundParameters.Remove('InputObject')
            $null = $PSBoundParameters.Remove('ResourceGroupName')
            $null = $PSBoundParameters.Remove('NamespaceName')
            $null = $PSBoundParameters.Remove('TopicName')
            $null = $PSBoundParameters.Remove('SubscriptionName')
            $null = $PSBoundParameters.Remove('Name')
            $null = $PSBoundParameters.Remove('SubscriptionId')

            $hasProperty = $false

            if ($hasSqlExpression) {
                $rule.SqlExpression = $SqlExpression
                $hasProperty = $true
            }
            if ($hasSqlFilterRequiresPreprocessing) {
                $rule.SqlFilterRequiresPreprocessing = $SqlFilterRequiresPreprocessing
                $hasProperty = $true
            }
            if ($hasContentType) {
                $rule.ContentType = $ContentType
                $hasProperty = $true
            }
            if ($hasCorrelationId) {
                $rule.CorrelationId = $CorrelationId
                $hasProperty = $true
            }
            if ($hasLabel) {
                $rule.Label = $Label
                $hasProperty = $true
            }
            if ($hasMessageId) {
                $rule.MessageId = $MessageId
                $hasProperty = $true
            }
            if ($hasCorrelationFilterProperty) {
                $rule.CorrelationFilterProperty = $CorrelationFilterProperty
                $hasProperty = $true
            }
            if ($hasReplyTo) {
                $rule.ReplyTo = $ReplyTo
                $hasProperty = $true
            }
            if ($hasReplyToSessionId) {
                $rule.ReplyToSessionId = $ReplyToSessionId
                $hasProperty = $true
            }
            if ($hasCorrelationFilterRequiresPreprocessing) {
                $rule.CorrelationFilterRequiresPreprocessing = $CorrelationFilterRequiresPreprocessing
                $hasProperty = $true
            }
            if ($hasSessionId) {
                $rule.SessionId = $SessionId
                $hasProperty = $true
            }
            if ($hasTo) {
                $rule.To = $To
                $hasProperty = $true
            }
            if ($hasFilterType) {
                $rule.FilterType = $FilterType
                $hasProperty = $true
            }
            if ($hasActionSqlExpression) {
                $rule.ActionSqlExpression = $ActionSqlExpression
                $hasProperty = $true
            }
            if ($hasActionRequiresPreprocessing) {
                $rule.ActionRequiresPreprocessing = $ActionRequiresPreprocessing
                $hasProperty = $true
            }

            if (($hasProperty -eq $false) -and ($PSCmdlet.ParameterSetName -eq 'SetViaIdentityExpanded')){
                throw 'Please specify the property you want to update on the -InputObject. Refer https://go.microsoft.com/fwlink/?linkid=2204584#behavior-of--inputobject for example.'
            }

            if ($hasAsJob) {
                $PSBoundParameters.Add('AsJob', $true)
            }

            if ($PSCmdlet.ShouldProcess("ServiceBus Rule $($rule.Name)", "Create or update")) {
                Az.ServiceBus.private\New-AzServiceBusRule_CreateViaIdentity -InputObject $rule -Parameter $rule @PSBoundParameters
            }
		}
		catch{
			throw
		}
	}
}
# SIG # Begin signature block
# MIIoKgYJKoZIhvcNAQcCoIIoGzCCKBcCAQExDzANBglghkgBZQMEAgEFADB5Bgor
# BgEEAYI3AgEEoGswaTA0BgorBgEEAYI3AgEeMCYCAwEAAAQQH8w7YFlLCE63JNLG
# KX7zUQIBAAIBAAIBAAIBAAIBADAxMA0GCWCGSAFlAwQCAQUABCC+4gvofWN4UMSz
# a4LOrM7f2KN3/bq9HofxN38r9Av6fqCCDXYwggX0MIID3KADAgECAhMzAAAEBGx0
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
# /Xmfwb1tbWrJUnMTDXpQzTGCGgowghoGAgEBMIGVMH4xCzAJBgNVBAYTAlVTMRMw
# EQYDVQQIEwpXYXNoaW5ndG9uMRAwDgYDVQQHEwdSZWRtb25kMR4wHAYDVQQKExVN
# aWNyb3NvZnQgQ29ycG9yYXRpb24xKDAmBgNVBAMTH01pY3Jvc29mdCBDb2RlIFNp
# Z25pbmcgUENBIDIwMTECEzMAAAQEbHQG/1crJ3IAAAAABAQwDQYJYIZIAWUDBAIB
# BQCgga4wGQYJKoZIhvcNAQkDMQwGCisGAQQBgjcCAQQwHAYKKwYBBAGCNwIBCzEO
# MAwGCisGAQQBgjcCARUwLwYJKoZIhvcNAQkEMSIEIHBixlhIpz4CbKpoQTU+PZ5Z
# W9+poY7Cc6JN90UM75WfMEIGCisGAQQBgjcCAQwxNDAyoBSAEgBNAGkAYwByAG8A
# cwBvAGYAdKEagBhodHRwOi8vd3d3Lm1pY3Jvc29mdC5jb20wDQYJKoZIhvcNAQEB
# BQAEggEAhxZ3CljE9zO7HlhMNs8dKuCXwzyTGSC6z2jw5hri5C0LfTxrML1uK0IR
# LmqgJqXdnazvFqP66sFZI5MN/JMGQ/LeKmuWYUnyLnOiLDh9vkSu8CccpLqVpPeb
# k8ZhygZV0Vo+nmE4SHSW7+LxEs9sU1xK4hQIH/UC+2Fzw3QOjmejOxmV8F0Ssxi7
# NjFfPf0AAH6vCHLT4K513suN9M7QIrBSD/rPhdB+NZ9gXeG6zr1r4ctKDBvh8d7+
# 8c6KGuVRkdUaGZFyON6Mkra4aqInzl7ldDpJuoqMcjx7eH30b2BsaF0752smDePz
# hp4lfemIXuhSNAB+9iyaiTDgQVpelKGCF5QwgheQBgorBgEEAYI3AwMBMYIXgDCC
# F3wGCSqGSIb3DQEHAqCCF20wghdpAgEDMQ8wDQYJYIZIAWUDBAIBBQAwggFSBgsq
# hkiG9w0BCRABBKCCAUEEggE9MIIBOQIBAQYKKwYBBAGEWQoDATAxMA0GCWCGSAFl
# AwQCAQUABCAWbjqaoi60a/URI796df63TEfQdn7Ab9LQMFTtJsu2IgIGZxqP99zY
# GBMyMDI0MTEwMTE1MDQxNC4zMDdaMASAAgH0oIHRpIHOMIHLMQswCQYDVQQGEwJV
# UzETMBEGA1UECBMKV2FzaGluZ3RvbjEQMA4GA1UEBxMHUmVkbW9uZDEeMBwGA1UE
# ChMVTWljcm9zb2Z0IENvcnBvcmF0aW9uMSUwIwYDVQQLExxNaWNyb3NvZnQgQW1l
# cmljYSBPcGVyYXRpb25zMScwJQYDVQQLEx5uU2hpZWxkIFRTUyBFU046RTAwMi0w
# NUUwLUQ5NDcxJTAjBgNVBAMTHE1pY3Jvc29mdCBUaW1lLVN0YW1wIFNlcnZpY2Wg
# ghHqMIIHIDCCBQigAwIBAgITMwAAAe4F0wIwspqdpwABAAAB7jANBgkqhkiG9w0B
# AQsFADB8MQswCQYDVQQGEwJVUzETMBEGA1UECBMKV2FzaGluZ3RvbjEQMA4GA1UE
# BxMHUmVkbW9uZDEeMBwGA1UEChMVTWljcm9zb2Z0IENvcnBvcmF0aW9uMSYwJAYD
# VQQDEx1NaWNyb3NvZnQgVGltZS1TdGFtcCBQQ0EgMjAxMDAeFw0yMzEyMDYxODQ1
# NDRaFw0yNTAzMDUxODQ1NDRaMIHLMQswCQYDVQQGEwJVUzETMBEGA1UECBMKV2Fz
# aGluZ3RvbjEQMA4GA1UEBxMHUmVkbW9uZDEeMBwGA1UEChMVTWljcm9zb2Z0IENv
# cnBvcmF0aW9uMSUwIwYDVQQLExxNaWNyb3NvZnQgQW1lcmljYSBPcGVyYXRpb25z
# MScwJQYDVQQLEx5uU2hpZWxkIFRTUyBFU046RTAwMi0wNUUwLUQ5NDcxJTAjBgNV
# BAMTHE1pY3Jvc29mdCBUaW1lLVN0YW1wIFNlcnZpY2UwggIiMA0GCSqGSIb3DQEB
# AQUAA4ICDwAwggIKAoICAQC+8byl16KEia8xKS4vVL7REOOR7LzYCLXEtWgeqyOV
# lrzuEz+AoCa4tBGESjbHTXECeMOwP9TPeKaKalfTU5XSGjpJhpGx59fxMJoTYWPz
# zD0O2RAlyBmOBBmiLDXRDQJL1RtuAjvCiLulVQeiPI8V7+HhTR391TbC1beSxwXf
# dKJqY1onjDawqDJAmtwsA/gmqXgHwF9fZWcwKSuXiZBTbU5fcm3bhhlRNw5d04Ld
# 15ZWzVl/VDp/iRerGo2Is/0Wwn/a3eGOdHrvfwIbfk6lVqwbNQE11Oedn2uvRjKW
# EwerXL70OuDZ8vLzxry0yEdvQ8ky+Vfq8mfEXS907Y7rN/HYX6cCsC2soyXG3OwC
# tLA7o0/+kKJZuOrD5HUrSz3kfqgDlmWy67z8ZZPjkiDC1dYW1jN77t5iSl5Wp1HK
# Bp7JU8RiRI+vY2i1cb5X2REkw3WrNW/jbofXEs9t4bgd+yU8sgKn9MtVnQ65s6QG
# 72M/yaUZG2HMI31tm9mooH29vPBO9jDMOIu0LwzUTkIWflgd/vEWfTNcPWEQj7fs
# WuSoVuJ3uBqwNmRSpmQDzSfMaIzuys0pvV1jFWqtqwwCcaY/WXsb/axkxB/zCTdH
# SBUJ8Tm3i4PM9skiunXY+cSqH58jWkpHbbLA3Ofss7e+JbMjKmTdcjmSkb5oN8qU
# 1wIDAQABo4IBSTCCAUUwHQYDVR0OBBYEFBCIzT8a2dwgnr37xd+2v1/cdqYIMB8G
# A1UdIwQYMBaAFJ+nFV0AXmJdg/Tl0mWnG1M1GelyMF8GA1UdHwRYMFYwVKBSoFCG
# Tmh0dHA6Ly93d3cubWljcm9zb2Z0LmNvbS9wa2lvcHMvY3JsL01pY3Jvc29mdCUy
# MFRpbWUtU3RhbXAlMjBQQ0ElMjAyMDEwKDEpLmNybDBsBggrBgEFBQcBAQRgMF4w
# XAYIKwYBBQUHMAKGUGh0dHA6Ly93d3cubWljcm9zb2Z0LmNvbS9wa2lvcHMvY2Vy
# dHMvTWljcm9zb2Z0JTIwVGltZS1TdGFtcCUyMFBDQSUyMDIwMTAoMSkuY3J0MAwG
# A1UdEwEB/wQCMAAwFgYDVR0lAQH/BAwwCgYIKwYBBQUHAwgwDgYDVR0PAQH/BAQD
# AgeAMA0GCSqGSIb3DQEBCwUAA4ICAQB3ZyAva2EKOWSVpBnYkzX8f8GZjaOs577F
# 9o14Anh9lKy6tS34wXoPXEyQp1v1iI7rJzZVG7rpUznay2n9csfn3p6y7kYkHqtS
# ugCGmTiiBkwhFfSByKPI08MklgvJvKTZb673yGfpFwPjQwZeI6EPj/OAtpYkT7IU
# XqMki1CRMJKgeY4wURCccIujdWRkoVv4J3q/87KE0qPQmAR9fqMNxjI3ZClVxA4w
# iM3tNVlRbF9SgpOnjVo3P/I5p8Jd41hNSVCx/8j3qM7aLSKtDzOEUNs+ZtjhznmZ
# gUd7/AWHDhwBHdL57TI9h7niZkfOZOXncYsKxG4gryTshU6G6sAYpbqdME/+/g1u
# er7VGIHUtLq3W0Anm8lAfS9PqthskZt54JF28CHdsFq/7XVBtFlxL/KgcQylJNni
# a+anixUG60yUDt3FMGSJI34xG9NHsz3BpqSWueGtJhQ5ZN0K8ju0vNVgF+Dv05si
# rPg0ftSKf9FVECp93o8ogF48jh8CT/B32lz1D6Truk4Ezcw7E1OhtOMf7DHgPMWf
# 6WOdYnf+HaSJx7ZTXCJsW5oOkM0sLitxBpSpGcj2YjnNznCpsEPZat0h+6d7ulRa
# WR5RHAUyFFQ9jRa7KWaNGdELTs+nHSlYjYeQpK5QSXjigdKlLQPBlX+9zOoGAJho
# Zfrpjq4nQDCCB3EwggVZoAMCAQICEzMAAAAVxedrngKbSZkAAAAAABUwDQYJKoZI
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
# MCUGA1UECxMeblNoaWVsZCBUU1MgRVNOOkUwMDItMDVFMC1EOTQ3MSUwIwYDVQQD
# ExxNaWNyb3NvZnQgVGltZS1TdGFtcCBTZXJ2aWNloiMKAQEwBwYFKw4DAhoDFQCI
# o6bVNvflFxbUWCDQ3YYKy6O+k6CBgzCBgKR+MHwxCzAJBgNVBAYTAlVTMRMwEQYD
# VQQIEwpXYXNoaW5ndG9uMRAwDgYDVQQHEwdSZWRtb25kMR4wHAYDVQQKExVNaWNy
# b3NvZnQgQ29ycG9yYXRpb24xJjAkBgNVBAMTHU1pY3Jvc29mdCBUaW1lLVN0YW1w
# IFBDQSAyMDEwMA0GCSqGSIb3DQEBCwUAAgUA6s7xGDAiGA8yMDI0MTEwMTA2MTgw
# MFoYDzIwMjQxMTAyMDYxODAwWjB0MDoGCisGAQQBhFkKBAExLDAqMAoCBQDqzvEY
# AgEAMAcCAQACAg5iMAcCAQACAhLhMAoCBQDq0EKYAgEAMDYGCisGAQQBhFkKBAIx
# KDAmMAwGCisGAQQBhFkKAwKgCjAIAgEAAgMHoSChCjAIAgEAAgMBhqAwDQYJKoZI
# hvcNAQELBQADggEBAI1eoQSvGEVcKFFmU57SwTIfLsx2oD8C+Q5nexSEWiHxvdRt
# D5iDYlybOAQlJvF2JJv9ffDR1Zh7eTqI9PIoTg4RdXycQw453kmIXqWT5PL0kwWH
# eZRPatVxkKbqiVweLRHmPT6ZXjb2OlC+oemEcj2VaGlsp078T0N7HTVmtxzRNVqc
# eNB2EvgKd+e9jFx9w518NW0LRheRKR8yYYQo1tuZ9j15t9QNy094dGPAB0g9g1tz
# egH6b1MkMyCT/WG21ZN4rX1tXfdb7OnBigws3sSmPr+WDo7xtgu0+SKYisWClJT9
# Db7ctk1kf2T5+MtbQRhSCX2uGmuA9w3Wcd63tvMxggQNMIIECQIBATCBkzB8MQsw
# CQYDVQQGEwJVUzETMBEGA1UECBMKV2FzaGluZ3RvbjEQMA4GA1UEBxMHUmVkbW9u
# ZDEeMBwGA1UEChMVTWljcm9zb2Z0IENvcnBvcmF0aW9uMSYwJAYDVQQDEx1NaWNy
# b3NvZnQgVGltZS1TdGFtcCBQQ0EgMjAxMAITMwAAAe4F0wIwspqdpwABAAAB7jAN
# BglghkgBZQMEAgEFAKCCAUowGgYJKoZIhvcNAQkDMQ0GCyqGSIb3DQEJEAEEMC8G
# CSqGSIb3DQEJBDEiBCDaLsIe1a+ZUdoKw6Jn+lSBx4BwjpHOFLuv5FvCcHihzzCB
# +gYLKoZIhvcNAQkQAi8xgeowgecwgeQwgb0EIE9QdxSVhfq+Vdf+DPs+5EIkBz9o
# CS/OQflHkVRhfjAhMIGYMIGApH4wfDELMAkGA1UEBhMCVVMxEzARBgNVBAgTCldh
# c2hpbmd0b24xEDAOBgNVBAcTB1JlZG1vbmQxHjAcBgNVBAoTFU1pY3Jvc29mdCBD
# b3Jwb3JhdGlvbjEmMCQGA1UEAxMdTWljcm9zb2Z0IFRpbWUtU3RhbXAgUENBIDIw
# MTACEzMAAAHuBdMCMLKanacAAQAAAe4wIgQgE0C5pSYNwbwkrRg6H+Km1xTq0tR7
# 3gLdlXcPhx6Ygx0wDQYJKoZIhvcNAQELBQAEggIAU777Iad9YW5xFojHb50Vjspv
# 9BIEAeJ9S+pK54LnwUbLrG/JvmPSwnmsw8LXPsqIqcdeEeTVPQ7da4O2wtqCb+s6
# TCu/qWhpVjchYBaJ+A2QW+AIOkcvvHHOKaxBQs3kd99pLKTdzew98/M/9zqQlb31
# 8tR0mzyoteTUpT7myrgqlD9MZ3GkORi68GZWc5oEjzQ9AT2SI57AkY2h8JEVvk4I
# rw+ipBQdj23I2ekR+/ifs8Ptk88uVyz1C6AYrxypQEUKlZl7PsLdLByXmL4l89EI
# q4BZlDlU59clbBP+Tc/MzFDZOf0aErUMNR2taRaDQ59nXSleoAL9GbZ7emrwvZNu
# qjA/3uXHs0SC5PXB0UERSvZ8Kg0YUpkU9nf0YrNqZPsRUR57NB1TWmQqfG4sIZPd
# 2V8YD5bLRSzjIKriveJQMnvdGE+6XnVrFpSa2FUXFBua0dKQFD3bl8mypumz1rpW
# 7URkX89csZePJcK4dHQASDnd6armJ+WOiWmOkJZNsrSmAxLjrDr/CJ7xsLwYjUzn
# 8+qZMs+Zajo1BIc+bzVdxu03AXyqm0pQy4kvyCY3KgIKMSnFwWxjCGmYNDEOfq7l
# 0rZ3uhp0jdAD1FsMKeYOMttRzB6Gewj/KlAct7NV65GGRQ8MVpEb8wYhYrgYDPap
# Ragagd7/pVqCywpyzBs=
# SIG # End signature block
