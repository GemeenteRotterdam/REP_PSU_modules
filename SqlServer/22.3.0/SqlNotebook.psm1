# Copyright (c) Microsoft Corporation.
# Licensed under the MIT license.

Set-StrictMode -Version Latest

function Invoke-SqlNotebook {

    [CmdletBinding(DefaultParameterSetName="ByConnectionParameters")]

    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUsePSCredentialType", "Username", Justification="Intentionally allowing User/Password, in addition to a PSCredential parameter.")]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSAvoidUsingPlainTextForPassword", "Password", Justification="Intentionally allowing User/Password, in addition to a PSCredential parameter.")]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSAvoidUsingUsernameAndPasswordParams", "", Justification="Intentionally allowing User/Password, in addition to a PSCredential parameter.")]

    # Parameters
    param(
        [Parameter(Mandatory = $false, ParameterSetName = 'ByConnectionParameters')]$ServerInstance,
        [Parameter(Mandatory = $false, ParameterSetName = 'ByConnectionParameters')]$Database,
        [Parameter(Mandatory = $false, ParameterSetName = 'ByConnectionParameters')][ValidateNotNullorEmpty()]$Username,
        [Parameter(Mandatory = $false, ParameterSetName = 'ByConnectionParameters')][ValidateNotNullorEmpty()]$Password,

        [Parameter(Mandatory = $false, ParameterSetName = 'ByConnectionString')][ValidateNotNullorEmpty()]$ConnectionString,
        [Parameter(Mandatory = $false, ParameterSetName = 'ByConnectionParameters')][ValidateNotNullorEmpty()][PSCredential]$Credential,
        [Parameter(Mandatory = $true, ParameterSetName='ByInputFile')]
        [Parameter(ParameterSetName = 'ByConnectionParameters')]
        [Parameter(ParameterSetName = 'ByConnectionString')]$InputFile,
        [Parameter(Mandatory = $true, ParameterSetName='ByInputObject')]
        [Parameter(ParameterSetName = 'ByConnectionParameters')]
        [Parameter(ParameterSetName = 'ByConnectionString')]$InputObject,
        [Parameter(Mandatory = $false)][ValidateNotNullorEmpty()]$OutputFile,

        [Parameter(Mandatory = $false, ParameterSetName = 'ByConnectionParameters')][ValidateNotNullorEmpty()][PSObject]$AccessToken,
        [Parameter(Mandatory = $false, ParameterSetName = 'ByConnectionParameters')][Switch]$TrustServerCertificate,
        [Parameter(Mandatory = $false, ParameterSetName = 'ByConnectionParameters')][ValidateSet("Mandatory", "Optional", "Strict")][string]$Encrypt,
        [Parameter(Mandatory = $false, ParameterSetName = 'ByConnectionParameters')][ValidateNotNull()][string]$HostNameInCertificate,

        [Switch]$Force
    )

    #Checks to see if OutputFile is given
    #If it is, checks to see if extension is there
    function getOutputFile($inputFile,$outputFile) {
        if($outputFile) {
            $extn = [IO.Path]::GetExtension($outputFile)
            if ($extn.Length -eq 0) {
                $outputFile = ($outputFile + ".ipynb")
            }
            $outputFile
        }
        else {
            #If User does not define Output it will use the inputFile file location
            $fileinfo = Get-Item $inputFile

            # Create an output file based on the file path of input and name
            Join-Path $fileinfo.DirectoryName ($fileinfo.BaseName + "_out" + $fileinfo.Extension)
        }
    }

    #Validates InputFile and Converts InputFile to Json Object
    function getFileContents($inputfile) {

        if (-not (Test-Path -Path $inputfile)) {
            Throw New-Object System.IO.FileNotFoundException ($inputfile + " does not exist")
        }

        $fileItem = Get-Item $inputfile

        #Checking if file is a python notebook
        if ($fileItem.Extension -ne ".ipynb") {
            Throw New-Object System.FormatException "Only ipynb files are supported"
        }

        $fileContent = Get-Content $inputfile
        try {
            $fileContentJson = ($fileContent | ConvertFrom-Json)
        }
        catch {
            Throw New-Object System.FormatException "Malformed Json file"
        }
        $fileContentJson
    }

    #Validate SQL Kernel Notebook
    function validateKernelType($fileContentJson) {
        if ($fileContentJson.metadata.kernelspec.name -ne "SQL") {
            Throw New-Object System.NotSupportedException "Kernel type '$($fileContentJson.metadata.kernelspec.name)' not supported."
        }
    }

    #Validate non-existing output file
    #If file exists and $throwifexists, an exception is thrown.
    function validateExistingOutputFile($outputfile, $throwifexists) {
        if ($outputfile -and (Test-Path $outputfile) -and $throwifexists) {
            Throw New-Object System.IO.IOException "The file '$($outputfile)' already exists. Please, specify -Force to overwrite it."
        }
    }

    #Parsing Notebook Data to Notebook Output
    function ParseTableToNotebookOutput {
        param (
            [System.Data.DataTable]
            $DataTable,

            [int]
            $CellExecutionCount
        )
        $TableHTMLText = "<table>"
        $TableSchemaFeilds = @()
        $TableHTMLText += "<tr>"
        foreach ($ColumnName in $DataTable.Columns) {
            $TableSchemaFeilds += @(@{name = $ColumnName.toString() })
            $TableHTMLText += "<th>" + $ColumnName.toString() + "</th>"
        }
        $TableHTMLText += "</tr>"
        $TableSchema = @{ }
        $TableSchema["fields"] = $TableSchemaFeilds

        $TableDataRows = @()
        foreach ($Row in $DataTable) {
            $TableDataRow = [ordered]@{ }
            $TableHTMLText += "<tr>"
            $i = 0
            foreach ($Cell in $Row.ItemArray) {
                $TableDataRow[$i.ToString()] = $Cell.toString()
                $TableHTMLText += "<td>" + $Cell.toString() + "</td>"
                $i++
            }
            $TableHTMLText += "</tr>"
            $TableDataRows += $TableDataRow
        }

        $TableDataResource = @{ }
        $TableDataResource["schema"] = $TableSchema
        $TableDataResource["data"] = $TableDataRows
        $TableData = @{ }
        $TableData["application/vnd.dataresource+json"] = $TableDataResource
        $TableData["text/html"] = $TableHTMLText
        $TableOutput = @{ }
        $TableOutput["output_type"] = "execute_result"
        $TableOutput["data"] = $TableData
        $TableOutput["metadata"] = @{ }
        $TableOutput["execution_count"] = $CellExecutionCount
        return $TableOutput
    }

    #Parsing the Error Messages to Notebook Output
    function ParseQueryErrorToNotebookOutput {
        param (
            $QueryError
        )
        <#
        Following the current syntax of errors in T-SQL notebooks from ADS
        #>
        $ErrorString = "Msg " + $QueryError.Exception.InnerException.Number +
        ", Level " + $QueryError.Exception.InnerException.Class +
        ", State " + $QueryError.Exception.InnerException.State +
        ", Line " + $QueryError.Exception.InnerException.LineNumber +
        "`r`n" + $QueryError.Exception.Message

        $ErrorOutput = @{ }
        $ErrorOutput["output_type"] = "error"
        $ErrorOutput["traceback"] = @()
        $ErrorOutput["evalue"] = $ErrorString
        return $ErrorOutput
    }

    #Parsing Messages to Notebook Output
    function ParseStringToNotebookOutput {
        param (
            [System.String]
            $InputString
        )
        <#
        Parsing the string to notebook cell output.
        It's the standard Jupyter Syntax
        #>
        $StringOutputData = @{ }
        $StringOutputData["text/html"] = $InputString
        $StringOutput = @{ }
        $StringOutput["output_type"] = "display_data"
        $StringOutput["data"] = $StringOutputData
        $StringOutput["metadata"] = @{ }
        return $StringOutput
    }

    #Start of Script
    #Checks to see if InputFile or InputObject was entered

    #Checks to InputFile Type and initializes OutputFile
    if ($InputFile -is [System.String]) {
        $fileInformation = getFileContents($InputFile)
        $fileContent = $fileInformation[0]
        $OutputFile = getOutputFile $InputFile $OutputFile
    } elseif ($InputFile -is [System.IO.FileInfo]) {
        $fileInformation = getFileContents($InputFile.FullName)
        $fileContent = $fileInformation[0]
        $OutputFile = getOutputFile $InputFile $OutputFile
    } else {
        $fileContent = $InputObject
    }

    #Checks InputObject and converts that to appropriate Json object
    if ($InputObject -is [System.String]) {
        $fileContentJson = ($InputObject | ConvertFrom-Json)
        $fileContent = $fileContentJson[0]
    }

    #Validates only SQL Notebooks
    validateKernelType $fileContent

    #Validate that $OutputFile does not exist, or, if it exists a -Force was passed in.
    validateExistingOutputFile $OutputFile (-not $Force)

    #Setting params for Invoke-Sqlcmd
    $DatabaseQueryHashTable = @{ }

    #Checks to see if User entered ConnectionString or individual parameters
    if ($ConnectionString) {
        $DatabaseQueryHashTable["ConnectionString"] = $ConnectionString
    } else {
        if ($ServerInstance) {
            $DatabaseQueryHashTable["ServerInstance"] = $ServerInstance
        }
        if ($Database) {
            $DatabaseQueryHashTable["Database"] = $Database
        }
        #Checks to see if User entered AccessToken, Credential, or individual parameters
        if ($AccessToken) {
            # Currently, Invoke-Sqlcmd only supports an -AccessToken of type [string]
            if ($AccessToken -is [string]) {
                $DatabaseQueryHashTable["AccessToken"] = $AccessToken
            } else {
                # Assume $AccessToken has a 'Token' member that is a string
                $DatabaseQueryHashTable["AccessToken"] = $AccessToken.Token
            }
        } else {
            if ($Credential) {
                $DatabaseQueryHashTable["Credential"] = $Credential
            } else {
                if ($Username) {
                    $DatabaseQueryHashTable["Username"] = $Username
                }
                if ($Password) {
                    $DatabaseQueryHashTable["Password"] = $Password
                }
            }
        }
        if ($Encrypt) {
            $DatabaseQueryHashTable["Encrypt"] = $Encrypt
        }
        if ($TrustServerCertificate) {
            $DatabaseQueryHashTable["TrustServerCertificate"] = $TrustServerCertificate
        }
        if ($HostNameInCertificate) {
            $DatabaseQueryHashTable["HostNameInCertificate"] = $HostNameInCertificate
        }
    }

    #Setting additional parameters for Invoke-SQLCMD to get
    #all the information from Notebook execution to output
    $DatabaseQueryHashTable["Verbose"] = $true
    $DatabaseQueryHashTable["ErrorVariable"] = "SqlQueryError"
    $DatabaseQueryHashTable["OutputAs"] = "DataTables"

    #The first code cell number
    $cellExecutionCount = 1
    #Iterate through Notebook Cells
    $fileContent.cells | Where-Object {
        # Ignoring Markdown or raw cells
        $_.cell_type -ne "markdown" -and $_.cell_type -ne "raw" -and $_.source -ne ""
    } | ForEach-Object {
        $NotebookCellOutputs = @()

        # Getting the source T-SQL from the cell
        # Note that the cell's source field can be
        # an array (or strings) or a scalar (string).
        # If an array, elements are properly terminated with CR/LF.
        $DatabaseQueryHashTable["Query"] = $_.source -join ''

        # Executing the T-SQL Query and storing the result and the time taken to execute
        $SqlQueryExecutionTime = Measure-Command {
            [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseDeclaredVarsMoreThanAssignments", "SqlQueryResult", Justification="Suppressing false warning.")]
            $SqlQueryResult = @( Invoke-Sqlcmd @DatabaseQueryHashTable -ErrorAction SilentlyContinue 4>&1)
        }

        # Setting the Notebook Cell Execution Count to increase count of each code cell
        # Note: handle the case where the 'execution_count' property is missing.
        if (-not ($_ | Get-Member execution_count)) {
            $_ | Add-Member -Name execution_count -Value $null -MemberType NoteProperty
        }
        $_.execution_count = $cellExecutionCount++

        $NotebookCellTableOutputs = @()

        <#
        Iterating over the results by Invoke-Sqlcmd
        There are 2 types of errors:
        1. Verbose Output: Print Statements:
            These needs to be added to the beginning of the cell outputs
        2. Datatables from the database
            These needs to be added to the end of cell outputs
        #>
        $SqlQueryResult | ForEach-Object {
            if ($_ -is [System.Management.Automation.VerboseRecord]) {
                # Adding the print statments to the cell outputs
                $NotebookCellOutputs += $(ParseStringToNotebookOutput($_.Message))
            } elseif ($_ -is [System.Data.DataTable]) {
                # Storing the print Tables into an array to be added later to the cell output
                $NotebookCellTableOutputs += $(ParseTableToNotebookOutput $_  $CellExecutionCount)
            } elseif ($_ -is [System.Data.DataRow]) {
                # Storing the print row into an array to be added later to the cell output
                $NotebookCellTableOutputs += $(ParseTableToNotebookOutput $_.Table  $CellExecutionCount)
            }
        }

        if ($SqlQueryError) {
            # Adding the parsed query error from Invoke-Sqlcmd
            $NotebookCellOutputs += $(ParseQueryErrorToNotebookOutput($SqlQueryError))
        }

        if ($SqlQueryExecutionTime) {
            # Adding the parsed execution time from Measure-Command
            $NotebookCellExcutionTimeString = "Total execution time: " + $SqlQueryExecutionTime.ToString()
            $NotebookCellOutputs += $(ParseStringToNotebookOutput($NotebookCellExcutionTimeString))
        }

        # Adding the data tables
        $NotebookCellOutputs += $NotebookCellTableOutputs

        # In the unlikely case the 'outputs' property is missing from the JSON
        # object, we add it.
        if (-not ($_ | Get-Member outputs)) {
            $_ | Add-Member -Name outputs -Value $null -MemberType NoteProperty
        }
        $_.outputs = $NotebookCellOutputs
    }

    # This will update the Output file according to the executed output of the notebook
    if ($OutputFile) {
        ($fileContent | ConvertTo-Json -Depth 100 ) | Out-File  -Encoding Ascii -FilePath $OutputFile
        Get-Item $OutputFile
    }
    else {
        $fileContent | ConvertTo-Json -Depth 100
    }
}

# SIG # Begin signature block
# MIInwgYJKoZIhvcNAQcCoIInszCCJ68CAQExDzANBglghkgBZQMEAgEFADB5Bgor
# BgEEAYI3AgEEoGswaTA0BgorBgEEAYI3AgEeMCYCAwEAAAQQH8w7YFlLCE63JNLG
# KX7zUQIBAAIBAAIBAAIBAAIBADAxMA0GCWCGSAFlAwQCAQUABCBC3/MSmZTxjb3A
# KquEOsvHtRhftHrIWp5otqM4/z7NCKCCDXYwggX0MIID3KADAgECAhMzAAADrzBA
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
# /Xmfwb1tbWrJUnMTDXpQzTGCGaIwghmeAgEBMIGVMH4xCzAJBgNVBAYTAlVTMRMw
# EQYDVQQIEwpXYXNoaW5ndG9uMRAwDgYDVQQHEwdSZWRtb25kMR4wHAYDVQQKExVN
# aWNyb3NvZnQgQ29ycG9yYXRpb24xKDAmBgNVBAMTH01pY3Jvc29mdCBDb2RlIFNp
# Z25pbmcgUENBIDIwMTECEzMAAAOvMEAOTKNNBUEAAAAAA68wDQYJYIZIAWUDBAIB
# BQCgga4wGQYJKoZIhvcNAQkDMQwGCisGAQQBgjcCAQQwHAYKKwYBBAGCNwIBCzEO
# MAwGCisGAQQBgjcCARUwLwYJKoZIhvcNAQkEMSIEIKJG5a8oeLOPZi+GILEm1EY9
# HX1cjHZiM86Ltf777lMkMEIGCisGAQQBgjcCAQwxNDAyoBSAEgBNAGkAYwByAG8A
# cwBvAGYAdKEagBhodHRwOi8vd3d3Lm1pY3Jvc29mdC5jb20wDQYJKoZIhvcNAQEB
# BQAEggEAe+n2AMjprb40lyfcbrKmeKmPZkdpW2BmMxYjyQkmaWZkyN8/6CtXsvEH
# x9cYiPBc6UmRvygaR5jdAskACglRcAMsp8k/HZEEcvMCHeLdBZ77Tt/bDpoUtChX
# KGk8guttHWqM95mNBWfO3UISa6QLAz39ZSCLW6aBLVK7FUB2/FY4/4NB3SQ0eCBb
# aCZW2arNOBOj1/EKi7Nok6iuM/Dx2wk/ntngD/2YwK4s6oBGJtfL9nIrIjNP4zlA
# 3dJ+PKsF1+Ky0OCMxsytSOIDhmHzziQm3QqaE3Zojl/lPBlvO2mMtnyJ6iH6+pxm
# K4h4pDgw1I1TiloWv14+mP5C93gT/KGCFywwghcoBgorBgEEAYI3AwMBMYIXGDCC
# FxQGCSqGSIb3DQEHAqCCFwUwghcBAgEDMQ8wDQYJYIZIAWUDBAIBBQAwggFZBgsq
# hkiG9w0BCRABBKCCAUgEggFEMIIBQAIBAQYKKwYBBAGEWQoDATAxMA0GCWCGSAFl
# AwQCAQUABCDMJTNqO8oA/BZKJv3paJApYU7zI+rFf4UCh/OrXFMuIAIGZnLCPrOn
# GBMyMDI0MDcwNDE4NDQxNi4yODJaMASAAgH0oIHYpIHVMIHSMQswCQYDVQQGEwJV
# UzETMBEGA1UECBMKV2FzaGluZ3RvbjEQMA4GA1UEBxMHUmVkbW9uZDEeMBwGA1UE
# ChMVTWljcm9zb2Z0IENvcnBvcmF0aW9uMS0wKwYDVQQLEyRNaWNyb3NvZnQgSXJl
# bGFuZCBPcGVyYXRpb25zIExpbWl0ZWQxJjAkBgNVBAsTHVRoYWxlcyBUU1MgRVNO
# OjJBRDQtNEI5Mi1GQTAxMSUwIwYDVQQDExxNaWNyb3NvZnQgVGltZS1TdGFtcCBT
# ZXJ2aWNloIIRezCCBycwggUPoAMCAQICEzMAAAHenkielp8oRD0AAQAAAd4wDQYJ
# KoZIhvcNAQELBQAwfDELMAkGA1UEBhMCVVMxEzARBgNVBAgTCldhc2hpbmd0b24x
# EDAOBgNVBAcTB1JlZG1vbmQxHjAcBgNVBAoTFU1pY3Jvc29mdCBDb3Jwb3JhdGlv
# bjEmMCQGA1UEAxMdTWljcm9zb2Z0IFRpbWUtU3RhbXAgUENBIDIwMTAwHhcNMjMx
# MDEyMTkwNzEyWhcNMjUwMTEwMTkwNzEyWjCB0jELMAkGA1UEBhMCVVMxEzARBgNV
# BAgTCldhc2hpbmd0b24xEDAOBgNVBAcTB1JlZG1vbmQxHjAcBgNVBAoTFU1pY3Jv
# c29mdCBDb3Jwb3JhdGlvbjEtMCsGA1UECxMkTWljcm9zb2Z0IElyZWxhbmQgT3Bl
# cmF0aW9ucyBMaW1pdGVkMSYwJAYDVQQLEx1UaGFsZXMgVFNTIEVTTjoyQUQ0LTRC
# OTItRkEwMTElMCMGA1UEAxMcTWljcm9zb2Z0IFRpbWUtU3RhbXAgU2VydmljZTCC
# AiIwDQYJKoZIhvcNAQEBBQADggIPADCCAgoCggIBALSB9ByF9UIDhA6xFrOniw/x
# sDl8sSi9rOCOXSSO4VMQjnNGAo5VHx0iijMEMH9LY2SUIBkVQS0Ml6kR+TagkUPb
# aEpwjhQ1mprhRgJT/jlSnic42VDAo0en4JI6xnXoAoWoKySY8/ROIKdpphgI7OJb
# 4XHk1P3sX2pNZ32LDY1ktchK1/hWyPlblaXAHRu0E3ynvwrS8/bcorANO6Djuysy
# S9zUmr+w3H3AEvSgs2ReuLj2pkBcfW1UPCFudLd7IPZ2RC4odQcEPnY12jypYPnS
# 6yZAs0pLpq0KRFUyB1x6x6OU73sudiHON16mE0l6LLT9OmGo0S94Bxg3N/3aE6fU
# bnVoemVc7FkFLum8KkZcbQ7cOHSAWGJxdCvo5OtUtRdSqf85FklCXIIkg4sm7nM9
# TktUVfO0kp6kx7mysgD0Qrxx6/5oaqnwOTWLNzK+BCi1G7nUD1pteuXvQp8fE1Kp
# TjnG/1OJeehwKNNPjGt98V0BmogZTe3SxBkOeOQyLA++5Hyg/L68pe+DrZoZPXJa
# GU/iBiFmL+ul/Oi3d83zLAHlHQmH/VGNBfRwP+ixvqhyk/EebwuXVJY+rTyfbRfu
# h9n0AaMhhNxxg6tGKyZS4EAEiDxrF9mAZEy8e8rf6dlKIX5d3aQLo9fDda1ZTOw+
# XAcAvj2/N3DLVGZlHnHlAgMBAAGjggFJMIIBRTAdBgNVHQ4EFgQUazAmbxseaapg
# dxzK8Os+naPQEsgwHwYDVR0jBBgwFoAUn6cVXQBeYl2D9OXSZacbUzUZ6XIwXwYD
# VR0fBFgwVjBUoFKgUIZOaHR0cDovL3d3dy5taWNyb3NvZnQuY29tL3BraW9wcy9j
# cmwvTWljcm9zb2Z0JTIwVGltZS1TdGFtcCUyMFBDQSUyMDIwMTAoMSkuY3JsMGwG
# CCsGAQUFBwEBBGAwXjBcBggrBgEFBQcwAoZQaHR0cDovL3d3dy5taWNyb3NvZnQu
# Y29tL3BraW9wcy9jZXJ0cy9NaWNyb3NvZnQlMjBUaW1lLVN0YW1wJTIwUENBJTIw
# MjAxMCgxKS5jcnQwDAYDVR0TAQH/BAIwADAWBgNVHSUBAf8EDDAKBggrBgEFBQcD
# CDAOBgNVHQ8BAf8EBAMCB4AwDQYJKoZIhvcNAQELBQADggIBAOKUwHsXDacGOvUI
# gs5HDgPs0LZ1qyHS6C6wfKlLaD36tZfbWt1x+GMiazSuy+GsxiVHzkhMW+FqK8gr
# uLQWN/sOCX+fGUgT9LT21cRIpcZj4/ZFIvwtkBcsCz1XEUsXYOSJUPitY7E8bbld
# mmhYZ29p+XQpIcsG/q+YjkqBW9mw0ru1MfxMTQs9MTDiD28gAVGrPA3NykiSChvd
# qS7VX+/LcEz9Ubzto/w28WA8HOCHqBTbDRHmiP7MIj+SQmI9VIayYsIGRjvelmNa
# 0OvbU9CJSz/NfMEgf2NHMZUYW8KqWEjIjPfHIKxWlNMYhuWfWRSHZCKyIANA0aJL
# 4soHQtzzZ2MnNfjYY851wHYjGgwUj/hlLRgQO5S30Zx78GqBKfylp25aOWJ/qPhC
# +DXM2gXajIXbl+jpGcVANwtFFujCJRdZbeH1R+Q41FjgBg4m3OTFDGot5DSuVkQg
# jku7pOVPtldE46QlDg/2WhPpTQxXH64sP1GfkAwUtt6rrZM/PCwRG6girYmnTRLL
# sicBhoYLh+EEFjVviXAGTk6pnu8jx/4WPWu0jsz7yFzg82/FMqCk9wK3LvyLAyDH
# N+FxbHAxtgwad7oLQPM0WGERdB1umPCIiYsSf/j79EqHdoNwQYROVm+ZX10RX3n6
# bRmAnskeNhi0wnVaeVogLMdGD+nqMIIHcTCCBVmgAwIBAgITMwAAABXF52ueAptJ
# mQAAAAAAFTANBgkqhkiG9w0BAQsFADCBiDELMAkGA1UEBhMCVVMxEzARBgNVBAgT
# Cldhc2hpbmd0b24xEDAOBgNVBAcTB1JlZG1vbmQxHjAcBgNVBAoTFU1pY3Jvc29m
# dCBDb3Jwb3JhdGlvbjEyMDAGA1UEAxMpTWljcm9zb2Z0IFJvb3QgQ2VydGlmaWNh
# dGUgQXV0aG9yaXR5IDIwMTAwHhcNMjEwOTMwMTgyMjI1WhcNMzAwOTMwMTgzMjI1
# WjB8MQswCQYDVQQGEwJVUzETMBEGA1UECBMKV2FzaGluZ3RvbjEQMA4GA1UEBxMH
# UmVkbW9uZDEeMBwGA1UEChMVTWljcm9zb2Z0IENvcnBvcmF0aW9uMSYwJAYDVQQD
# Ex1NaWNyb3NvZnQgVGltZS1TdGFtcCBQQ0EgMjAxMDCCAiIwDQYJKoZIhvcNAQEB
# BQADggIPADCCAgoCggIBAOThpkzntHIhC3miy9ckeb0O1YLT/e6cBwfSqWxOdcjK
# NVf2AX9sSuDivbk+F2Az/1xPx2b3lVNxWuJ+Slr+uDZnhUYjDLWNE893MsAQGOhg
# fWpSg0S3po5GawcU88V29YZQ3MFEyHFcUTE3oAo4bo3t1w/YJlN8OWECesSq/XJp
# rx2rrPY2vjUmZNqYO7oaezOtgFt+jBAcnVL+tuhiJdxqD89d9P6OU8/W7IVWTe/d
# vI2k45GPsjksUZzpcGkNyjYtcI4xyDUoveO0hyTD4MmPfrVUj9z6BVWYbWg7mka9
# 7aSueik3rMvrg0XnRm7KMtXAhjBcTyziYrLNueKNiOSWrAFKu75xqRdbZ2De+JKR
# Hh09/SDPc31BmkZ1zcRfNN0Sidb9pSB9fvzZnkXftnIv231fgLrbqn427DZM9itu
# qBJR6L8FA6PRc6ZNN3SUHDSCD/AQ8rdHGO2n6Jl8P0zbr17C89XYcz1DTsEzOUyO
# ArxCaC4Q6oRRRuLRvWoYWmEBc8pnol7XKHYC4jMYctenIPDC+hIK12NvDMk2ZItb
# oKaDIV1fMHSRlJTYuVD5C4lh8zYGNRiER9vcG9H9stQcxWv2XFJRXRLbJbqvUAV6
# bMURHXLvjflSxIUXk8A8FdsaN8cIFRg/eKtFtvUeh17aj54WcmnGrnu3tz5q4i6t
# AgMBAAGjggHdMIIB2TASBgkrBgEEAYI3FQEEBQIDAQABMCMGCSsGAQQBgjcVAgQW
# BBQqp1L+ZMSavoKRPEY1Kc8Q/y8E7jAdBgNVHQ4EFgQUn6cVXQBeYl2D9OXSZacb
# UzUZ6XIwXAYDVR0gBFUwUzBRBgwrBgEEAYI3TIN9AQEwQTA/BggrBgEFBQcCARYz
# aHR0cDovL3d3dy5taWNyb3NvZnQuY29tL3BraW9wcy9Eb2NzL1JlcG9zaXRvcnku
# aHRtMBMGA1UdJQQMMAoGCCsGAQUFBwMIMBkGCSsGAQQBgjcUAgQMHgoAUwB1AGIA
# QwBBMAsGA1UdDwQEAwIBhjAPBgNVHRMBAf8EBTADAQH/MB8GA1UdIwQYMBaAFNX2
# VsuP6KJcYmjRPZSQW9fOmhjEMFYGA1UdHwRPME0wS6BJoEeGRWh0dHA6Ly9jcmwu
# bWljcm9zb2Z0LmNvbS9wa2kvY3JsL3Byb2R1Y3RzL01pY1Jvb0NlckF1dF8yMDEw
# LTA2LTIzLmNybDBaBggrBgEFBQcBAQROMEwwSgYIKwYBBQUHMAKGPmh0dHA6Ly93
# d3cubWljcm9zb2Z0LmNvbS9wa2kvY2VydHMvTWljUm9vQ2VyQXV0XzIwMTAtMDYt
# MjMuY3J0MA0GCSqGSIb3DQEBCwUAA4ICAQCdVX38Kq3hLB9nATEkW+Geckv8qW/q
# XBS2Pk5HZHixBpOXPTEztTnXwnE2P9pkbHzQdTltuw8x5MKP+2zRoZQYIu7pZmc6
# U03dmLq2HnjYNi6cqYJWAAOwBb6J6Gngugnue99qb74py27YP0h1AdkY3m2CDPVt
# I1TkeFN1JFe53Z/zjj3G82jfZfakVqr3lbYoVSfQJL1AoL8ZthISEV09J+BAljis
# 9/kpicO8F7BUhUKz/AyeixmJ5/ALaoHCgRlCGVJ1ijbCHcNhcy4sa3tuPywJeBTp
# kbKpW99Jo3QMvOyRgNI95ko+ZjtPu4b6MhrZlvSP9pEB9s7GdP32THJvEKt1MMU0
# sHrYUP4KWN1APMdUbZ1jdEgssU5HLcEUBHG/ZPkkvnNtyo4JvbMBV0lUZNlz138e
# W0QBjloZkWsNn6Qo3GcZKCS6OEuabvshVGtqRRFHqfG3rsjoiV5PndLQTHa1V1QJ
# sWkBRH58oWFsc/4Ku+xBZj1p/cvBQUl+fpO+y/g75LcVv7TOPqUxUYS8vwLBgqJ7
# Fx0ViY1w/ue10CgaiQuPNtq6TPmb/wrpNPgkNWcr4A245oyZ1uEi6vAnQj0llOZ0
# dFtq0Z4+7X6gMTN9vMvpe784cETRkPHIqzqKOghif9lwY1NNje6CbaUFEMFxBmoQ
# tB1VM1izoXBm8qGCAtcwggJAAgEBMIIBAKGB2KSB1TCB0jELMAkGA1UEBhMCVVMx
# EzARBgNVBAgTCldhc2hpbmd0b24xEDAOBgNVBAcTB1JlZG1vbmQxHjAcBgNVBAoT
# FU1pY3Jvc29mdCBDb3Jwb3JhdGlvbjEtMCsGA1UECxMkTWljcm9zb2Z0IElyZWxh
# bmQgT3BlcmF0aW9ucyBMaW1pdGVkMSYwJAYDVQQLEx1UaGFsZXMgVFNTIEVTTjoy
# QUQ0LTRCOTItRkEwMTElMCMGA1UEAxMcTWljcm9zb2Z0IFRpbWUtU3RhbXAgU2Vy
# dmljZaIjCgEBMAcGBSsOAwIaAxUAaKBSisy4y86pl8Xy22CJZExE2vOggYMwgYCk
# fjB8MQswCQYDVQQGEwJVUzETMBEGA1UECBMKV2FzaGluZ3RvbjEQMA4GA1UEBxMH
# UmVkbW9uZDEeMBwGA1UEChMVTWljcm9zb2Z0IENvcnBvcmF0aW9uMSYwJAYDVQQD
# Ex1NaWNyb3NvZnQgVGltZS1TdGFtcCBQQ0EgMjAxMDANBgkqhkiG9w0BAQUFAAIF
# AOoxBacwIhgPMjAyNDA3MDQxOTI3MzVaGA8yMDI0MDcwNTE5MjczNVowdzA9Bgor
# BgEEAYRZCgQBMS8wLTAKAgUA6jEFpwIBADAKAgEAAgIioQIB/zAHAgEAAgIStzAK
# AgUA6jJXJwIBADA2BgorBgEEAYRZCgQCMSgwJjAMBgorBgEEAYRZCgMCoAowCAIB
# AAIDB6EgoQowCAIBAAIDAYagMA0GCSqGSIb3DQEBBQUAA4GBABgOQt7RwfKZNIa1
# GqbJz9gNNkFRtsCScqQXcfOXrY530ReVbcaE68MRdSasfBakUIL3eQS2vxLDYwqc
# qy2cgPj0B4F3kqnfyyqYxJMMnFec3Aab7ObytQM/vSj1RtzrB9APowDGmwNUfrUd
# Lwvt81FqS53qDUBpIeUWvuHiXSftMYIEDTCCBAkCAQEwgZMwfDELMAkGA1UEBhMC
# VVMxEzARBgNVBAgTCldhc2hpbmd0b24xEDAOBgNVBAcTB1JlZG1vbmQxHjAcBgNV
# BAoTFU1pY3Jvc29mdCBDb3Jwb3JhdGlvbjEmMCQGA1UEAxMdTWljcm9zb2Z0IFRp
# bWUtU3RhbXAgUENBIDIwMTACEzMAAAHenkielp8oRD0AAQAAAd4wDQYJYIZIAWUD
# BAIBBQCgggFKMBoGCSqGSIb3DQEJAzENBgsqhkiG9w0BCRABBDAvBgkqhkiG9w0B
# CQQxIgQgLCCXg5v364COEtvFs25OnY6qbrQuSHzreBrzEeMmm9gwgfoGCyqGSIb3
# DQEJEAIvMYHqMIHnMIHkMIG9BCCOPiOfDcFeEBBJAn/mC3MgrT5w/U2z81LYD44H
# c34dezCBmDCBgKR+MHwxCzAJBgNVBAYTAlVTMRMwEQYDVQQIEwpXYXNoaW5ndG9u
# MRAwDgYDVQQHEwdSZWRtb25kMR4wHAYDVQQKExVNaWNyb3NvZnQgQ29ycG9yYXRp
# b24xJjAkBgNVBAMTHU1pY3Jvc29mdCBUaW1lLVN0YW1wIFBDQSAyMDEwAhMzAAAB
# 3p5InpafKEQ9AAEAAAHeMCIEIM9b4Y/gfYaAclqeQjzgauECfBZyMBgPX0GHwi+m
# jh6UMA0GCSqGSIb3DQEBCwUABIICACcX2ck2AFQlDxMziZOZwNQNyoUhjksQWG7m
# rHxCkS4v/eyfNK3DTugujTHN71uuP2Jlv4FU2rUPz1hcvGqaj6SMHmGz7SMNyHWk
# 35WLJ1ik+UMRsQwQTAQI5RGlTZo9PIGeIOFs0I/lQEP8S0swC7dvfYrGtc295gh2
# RNWSbio2hwntbluK/RvbrmZ4XAuInx1s/wFEKEeXfECqvZuI4Eo9VarJngZ5ZeOP
# O/PbQl6tYLdhOCCaf2FAyMvhI4zx17wgxiNsvKvGQ5yLHD3dcBA2LkVr7fXVj5bY
# 7yze1LWJVdNpTrgFfg0i/wBM1LxCoOHKmpdd7T/9GQDC1qPhmyjcyBlHemChxr8r
# eTZbKgAMcz3iK0cMY87XcYjTGrZGwXMtHoeQ0tRQiqMm1nCMWNiD7AAb3l432I4z
# UMZbDxsgkAGLaGZuMOVgh7/WzRNQruh2iJvPfqDj4flhwAEzb7osX68y7RJbxIy+
# /WNUw2HsTu85ZFI7uUrinJJEGDLm4r/OKk3bE/S9K6g3iIEjuL8LbiCbqvakmzIq
# JIebC1KZbubkqrgiLjBLhXSNr/HEY+OPYuEpeN5A1tpS6lhLw6yebxUtGPNddqRL
# y/mwGgZvqkcQevzANeGRW5szx1QbipQ40XVb9m2IA/HXK1m+9yTS0cEaTOvG+Qnl
# 47RjOJHe
# SIG # End signature block
