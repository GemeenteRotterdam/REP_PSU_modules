
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
Updates the target properties for the replicating server.
.Description
The Set-AzMigrateServerReplication cmdlet updates the target properties for the replicating server.
.Link
https://learn.microsoft.com/powershell/module/az.migrate/set-azmigrateserverreplication
#>
function Set-AzMigrateServerReplication {
    [OutputType([Microsoft.Azure.PowerShell.Cmdlets.Migrate.Models.Api202401.IJob])]
    [CmdletBinding(DefaultParameterSetName = 'ByIDVMwareCbt', PositionalBinding = $false)]
    param(
        [Parameter(ParameterSetName = 'ByIDVMwareCbt', Mandatory)]
        [Microsoft.Azure.PowerShell.Cmdlets.Migrate.Category('Path')]
        [System.String]
        # Specifies the replcating server for which the properties need to be updated. The ID should be retrieved using the Get-AzMigrateServerReplication cmdlet.
        ${TargetObjectID},

        [Parameter(ParameterSetName = 'ByInputObjectVMwareCbt', Mandatory)]
        [Microsoft.Azure.PowerShell.Cmdlets.Migrate.Category('Path')]
        [Microsoft.Azure.PowerShell.Cmdlets.Migrate.Models.Api202401.IMigrationItem]
        # Specifies the replicating server for which the properties need to be updated. The server object can be retrieved using the Get-AzMigrateServerReplication cmdlet.
        ${InputObject},

        [Parameter()]
        [Microsoft.Azure.PowerShell.Cmdlets.Migrate.Category('Path')]
        [System.String]
        # Specifies the replcating server for which the properties need to be updated. The ID should be retrieved using the Get-AzMigrateServerReplication cmdlet.
        ${TargetVMName},

        [Parameter()]
        [Microsoft.Azure.PowerShell.Cmdlets.Migrate.Category('Path')]
        [System.String]
        # Specifies the name of the Azure VM to be created.
        ${TargetDiskName},

        [Parameter()]
        [Microsoft.Azure.PowerShell.Cmdlets.Migrate.Category('Path')]
        [System.String]
        # Updates the SKU of the Azure VM to be created.
        ${TargetVMSize},

        [Parameter()]
        [Microsoft.Azure.PowerShell.Cmdlets.Migrate.Category('Path')]
        [System.String]
        # Updates the Virtual Network id within the destination Azure subscription to which the server needs to be migrated.
        ${TargetNetworkId},

        [Parameter()]
        [Microsoft.Azure.PowerShell.Cmdlets.Migrate.Category('Path')]
        [System.String]
        # Updates the Virtual Network id within the destination Azure subscription to which the server needs to be test migrated.
        ${TestNetworkId},

        [Parameter()]
        [Microsoft.Azure.PowerShell.Cmdlets.Migrate.Category('Path')]
        [System.String]
        # Updates the Resource Group id within the destination Azure subscription to which the server needs to be migrated.
        ${TargetResourceGroupID},

        [Parameter()]
        [Microsoft.Azure.PowerShell.Cmdlets.Migrate.Category('Path')]
        [Microsoft.Azure.PowerShell.Cmdlets.Migrate.Models.Api202401.IVMwareCbtNicInput[]]
        # Updates the NIC for the Azure VM to be created.
        ${NicToUpdate},

        [Parameter()]
        [Microsoft.Azure.PowerShell.Cmdlets.Migrate.Category('Path')]
        [Microsoft.Azure.PowerShell.Cmdlets.Migrate.Models.Api202401.IVMwareCbtUpdateDiskInput[]]
        # Updates the disk for the Azure VM to be created.
        ${DiskToUpdate},

        [Parameter()]
        [Microsoft.Azure.PowerShell.Cmdlets.Migrate.Category('Path')]
        [System.String]
        # Specifies the Availability Set to be used for VM creation.
        ${TargetAvailabilitySet},
        
        [Parameter()]
        [Microsoft.Azure.PowerShell.Cmdlets.Migrate.Category('Path')]
        [System.String]
        # Specifies the Availability Zone to be used for VM creation.
        ${TargetAvailabilityZone},

        [Parameter()]
        [ValidateSet("NoLicenseType" , "PAYG" , "AHUB")]
        [ArgumentCompleter( { "NoLicenseType" , "PAYG" , "AHUB" })]
        [Microsoft.Azure.PowerShell.Cmdlets.Migrate.Category('Path')]
        [System.String]
        # Specifies if Azure Hybrid benefit for SQL Server is applicable for the server to be migrated.
        ${SqlServerLicenseType},

        [Parameter()]
        [ValidateSet( "NotSpecified", "NoLicenseType", "LinuxServer")]
        [ArgumentCompleter( { "NotSpecified", "NoLicenseType", "LinuxServer" })]
        [Microsoft.Azure.PowerShell.Cmdlets.Migrate.Category('Path')]
        [System.String]
        # Specifies if Azure Hybrid benefit is applicable for the source linux server to be migrated.
        ${LinuxLicenseType},

        [Parameter()]
        [Microsoft.Azure.PowerShell.Cmdlets.Migrate.Category('Path')]
        [System.Collections.Hashtable]
        # Specifies the tag to be used for Resource creation.
        ${UpdateTag},

        [Parameter()]
        [ValidateSet("Merge" , "Replace" , "Delete")]
        [ArgumentCompleter( { "Merge" , "Replace" , "Delete" })]
        [Microsoft.Azure.PowerShell.Cmdlets.Migrate.Category('Path')]
        [System.String]
        # Specifies update tag operation.
        ${UpdateTagOperation},

        [Parameter()]
        [Microsoft.Azure.PowerShell.Cmdlets.Migrate.Category('Path')]
        [Microsoft.Azure.PowerShell.Cmdlets.Migrate.Models.Api202401.IVMwareCbtEnableMigrationInputTargetVmtags]
        # Specifies the tag to be used for VM creation.
        ${UpdateVMTag},

        [Parameter()]
        [ValidateSet("Merge" , "Replace" , "Delete")]
        [ArgumentCompleter( { "Merge" , "Replace" , "Delete" })]
        [Microsoft.Azure.PowerShell.Cmdlets.Migrate.Category('Path')]
        [System.String]
        # Specifies update VM tag operation.
        ${UpdateVMTagOperation},

        [Parameter()]
        [Microsoft.Azure.PowerShell.Cmdlets.Migrate.Category('Path')]
        [Microsoft.Azure.PowerShell.Cmdlets.Migrate.Models.Api202401.IVMwareCbtEnableMigrationInputTargetNicTags]
        # Specifies the tag to be used for NIC creation.
        ${UpdateNicTag},

        [Parameter()]
        [ValidateSet("Merge" , "Replace" , "Delete")]
        [ArgumentCompleter( { "Merge" , "Replace" , "Delete" })]
        [Microsoft.Azure.PowerShell.Cmdlets.Migrate.Category('Path')]
        [System.String]
        # Specifies update NIC tag operation.
        ${UpdateNicTagOperation},

        [Parameter()]
        [Microsoft.Azure.PowerShell.Cmdlets.Migrate.Category('Path')]
        [Microsoft.Azure.PowerShell.Cmdlets.Migrate.Models.Api202401.IVMwareCbtEnableMigrationInputTargetDiskTags]
        # Specifies the tag to be used for disk creation.
        ${UpdateDiskTag},

        [Parameter()]
        [ValidateSet("Merge" , "Replace" , "Delete")]
        [ArgumentCompleter( { "Merge" , "Replace" , "Delete" })]
        [Microsoft.Azure.PowerShell.Cmdlets.Migrate.Category('Path')]
        [System.String]
        # Specifies update disk tag operation.
        ${UpdateDiskTagOperation},

        [Parameter()]
        [Microsoft.Azure.PowerShell.Cmdlets.Migrate.Category('Path')]
        [System.String]
        # Specifies the storage account to be used for boot diagnostics.
        ${TargetBootDiagnosticsStorageAccount},

        [Parameter()]
        [Microsoft.Azure.PowerShell.Cmdlets.Migrate.Category('Path')]
        [Microsoft.Azure.PowerShell.Cmdlets.Migrate.Runtime.DefaultInfo(Script = '(Get-AzContext).Subscription.Id')]
        [System.String]
        # The subscription Id.
        ${SubscriptionId},

        [Parameter()]
        [Alias('AzureRMContext', 'AzureCredential')]
        [ValidateNotNull()]
        [Microsoft.Azure.PowerShell.Cmdlets.Migrate.Category('Azure')]
        [System.Management.Automation.PSObject]
        # The credentials, account, tenant, and subscription used for communication with Azure.
        ${DefaultProfile},

        [Parameter(DontShow)]
        [Microsoft.Azure.PowerShell.Cmdlets.Migrate.Category('Runtime')]
        [System.Management.Automation.SwitchParameter]
        # Wait for .NET debugger to attach
        ${Break},

        [Parameter(DontShow)]
        [ValidateNotNull()]
        [Microsoft.Azure.PowerShell.Cmdlets.Migrate.Category('Runtime')]
        [Microsoft.Azure.PowerShell.Cmdlets.Migrate.Runtime.SendAsyncStep[]]
        # SendAsync Pipeline Steps to be appended to the front of the pipeline
        ${HttpPipelineAppend},

        [Parameter(DontShow)]
        [ValidateNotNull()]
        [Microsoft.Azure.PowerShell.Cmdlets.Migrate.Category('Runtime')]
        [Microsoft.Azure.PowerShell.Cmdlets.Migrate.Runtime.SendAsyncStep[]]
        # SendAsync Pipeline Steps to be prepended to the front of the pipeline
        ${HttpPipelinePrepend},

        [Parameter(DontShow)]
        [Microsoft.Azure.PowerShell.Cmdlets.Migrate.Category('Runtime')]
        [System.Uri]
        # The URI for the proxy server to use
        ${Proxy},

        [Parameter(DontShow)]
        [ValidateNotNull()]
        [Microsoft.Azure.PowerShell.Cmdlets.Migrate.Category('Runtime')]
        [System.Management.Automation.PSCredential]
        # Credentials for a proxy server to use for the remote call
        ${ProxyCredential},

        [Parameter(DontShow)]
        [Microsoft.Azure.PowerShell.Cmdlets.Migrate.Category('Runtime')]
        [System.Management.Automation.SwitchParameter]
        # Use the default credentials for the proxy
        ${ProxyUseDefaultCredentials}
    )
    
    process {

        $HasTargetVMName = $PSBoundParameters.ContainsKey('TargetVMName')
        $HasTargetDiskName = $PSBoundParameters.ContainsKey('TargetDiskName')
        $HasTargetVmSize = $PSBoundParameters.ContainsKey('TargetVMSize')
        $HasTargetNetworkId = $PSBoundParameters.ContainsKey('TargetNetworkId')
        $HasTestNetworkId = $PSBoundParameters.ContainsKey('TestNetworkId')
        $HasTargetResourceGroupID = $PSBoundParameters.ContainsKey('TargetResourceGroupID')
        $HasNicToUpdate = $PSBoundParameters.ContainsKey('NicToUpdate')
        $HasDiskToUpdate = $PSBoundParameters.ContainsKey('DiskToUpdate')
        $HasTargetAvailabilitySet = $PSBoundParameters.ContainsKey('TargetAvailabilitySet')
        $HasTargetAvailabilityZone = $PSBoundParameters.ContainsKey('TargetAvailabilityZone')
        $HasSqlServerLicenseType = $PSBoundParameters.ContainsKey('SqlServerLicenseType')
        $HasLinuxLicenseType = $PSBoundParameters.ContainsKey('LinuxLicenseType')
        $HasUpdateTag = $PSBoundParameters.ContainsKey('UpdateTag')
        $HasUpdateTagOperation = $PSBoundParameters.ContainsKey('UpdateTagOperation')
        $HasUpdateVMTag = $PSBoundParameters.ContainsKey('UpdateVMTag')
        $HasUpdateVMTagOperation = $PSBoundParameters.ContainsKey('UpdateVMTagOperation')
        $HasUpdateNicTag = $PSBoundParameters.ContainsKey('UpdateNicTag')
        $HasUpdateNicTagOperation = $PSBoundParameters.ContainsKey('UpdateNicTagOperation')
        $HasUpdateDiskTag = $PSBoundParameters.ContainsKey('UpdateDiskTag')
        $HasUpdateDiskTagOperation = $PSBoundParameters.ContainsKey('UpdateDiskTagOperation')
        $HasTargetBootDignosticStorageAccount = $PSBoundParameters.ContainsKey('TargetBootDiagnosticsStorageAccount')

        $null = $PSBoundParameters.Remove('TargetObjectID')
        $null = $PSBoundParameters.Remove('TargetVMName')
        $null = $PSBoundParameters.Remove('TargetDiskName')
        $null = $PSBoundParameters.Remove('TargetVMSize')
        $null = $PSBoundParameters.Remove('TargetNetworkId')
        $null = $PSBoundParameters.Remove('TestNetworkId')
        $null = $PSBoundParameters.Remove('TargetResourceGroupID')
        $null = $PSBoundParameters.Remove('NicToUpdate')
        $null = $PSBoundParameters.Remove('DiskToUpdate')
        $null = $PSBoundParameters.Remove('TargetAvailabilitySet')
        $null = $PSBoundParameters.Remove('TargetAvailabilityZone')
        $null = $PSBoundParameters.Remove('SqlServerLicenseType')
        $null = $PSBoundParameters.Remove('LinuxLicenseType')
        $null = $PSBoundParameters.Remove('UpdateTag')
        $null = $PSBoundParameters.Remove('UpdateTagOperation')
        $null = $PSBoundParameters.Remove('UpdateVMTag')
        $null = $PSBoundParameters.Remove('UpdateVMTagOperation')
        $null = $PSBoundParameters.Remove('UpdateNicTag')
        $null = $PSBoundParameters.Remove('UpdateNicTagOperation')
        $null = $PSBoundParameters.Remove('UpdateDiskTag')
        $null = $PSBoundParameters.Remove('UpdateDiskTagOperation')

        $null = $PSBoundParameters.Remove('InputObject')
        $null = $PSBoundParameters.Remove('TargetBootDiagnosticsStorageAccount')
        $parameterSet = $PSCmdlet.ParameterSetName

        if ($parameterSet -eq 'ByInputObjectVMwareCbt') {
            $TargetObjectID = $InputObject.Id
        }
        $MachineIdArray = $TargetObjectID.Split("/")
        $ResourceGroupName = $MachineIdArray[4]
        $VaultName = $MachineIdArray[8]
        $FabricName = $MachineIdArray[10]
        $ProtectionContainerName = $MachineIdArray[12]
        $MachineName = $MachineIdArray[14]
            
        $null = $PSBoundParameters.Add("ResourceGroupName", $ResourceGroupName)
        $null = $PSBoundParameters.Add("ResourceName", $VaultName)
        $null = $PSBoundParameters.Add("FabricName", $FabricName)
        $null = $PSBoundParameters.Add("MigrationItemName", $MachineName)
        $null = $PSBoundParameters.Add("ProtectionContainerName", $ProtectionContainerName)
            
        $ReplicationMigrationItem = Az.Migrate.internal\Get-AzMigrateReplicationMigrationItem @PSBoundParameters
        if ($ReplicationMigrationItem -and ($ReplicationMigrationItem.ProviderSpecificDetail.InstanceType -eq 'VMwarecbt')) {
            $ProviderSpecificDetails = [Microsoft.Azure.PowerShell.Cmdlets.Migrate.Models.Api202401.VMwareCbtUpdateMigrationItemInput]::new()
                
            # Auto fill unchanged parameters
            $ProviderSpecificDetails.InstanceType = 'VMwareCbt'
            $ProviderSpecificDetails.LicenseType = $ReplicationMigrationItem.ProviderSpecificDetail.LicenseType
            $ProviderSpecificDetails.PerformAutoResync = $ReplicationMigrationItem.ProviderSpecificDetail.PerformAutoResync
                
            if ($HasTargetAvailabilitySet) {
                $ProviderSpecificDetails.TargetAvailabilitySetId = $TargetAvailabilitySet
            }
            else {
                $ProviderSpecificDetails.TargetAvailabilitySetId = $ReplicationMigrationItem.ProviderSpecificDetail.TargetAvailabilitySetId
            }

            if ($HasTargetAvailabilityZone) {
                $ProviderSpecificDetails.TargetAvailabilityZone = $TargetAvailabilityZone
            }
            else {
                $ProviderSpecificDetails.TargetAvailabilityZone = $ReplicationMigrationItem.ProviderSpecificDetail.TargetAvailabilityZone
            }

            if ($HasSqlServerLicenseType) {
                $validSqlLicenseSpellings = @{ 
                    NoLicenseType = "NoLicenseType";
                    PAYG          = "PAYG";
                    AHUB          = "AHUB"
                }
                $SqlServerLicenseType = $validSqlLicenseSpellings[$SqlServerLicenseType]
                $ProviderSpecificDetails.SqlServerLicenseType = $SqlServerLicenseType
            }
            else {
                $ProviderSpecificDetails.SqlServerLicenseType = $ReplicationMigrationItem.ProviderSpecificDetail.SqlServerLicenseType
            }

            if ($HasLinuxLicenseType) {
                $validLinuxLicenseSpellings = @{ 
                    NotSpecified  = "NotSpecified";
                    NoLicenseType = "NoLicenseType";
                    LinuxServer   = "LinuxServer";
                }
                $LinuxLicenseType = $validLinuxLicenseSpellings[$LinuxLicenseType]
                $ProviderSpecificDetails.LinuxLicenseType = $LinuxLicenseType
            }
            else {
                $ProviderSpecificDetails.LinuxLicenseType = $ReplicationMigrationItem.ProviderSpecificDetail.LinuxLicenseType
            }

            $UserProvidedTag = $null
            if ($HasUpdateTag -And $HasUpdateTagOperation -And $UpdateTag) {
                $operation = @("UpdateTag", $UpdateTagOperation)
                $UserProvidedTag += @{$operation = $UpdateTag }
            }

            if ($HasUpdateVMTag -And $HasUpdateVMTagOperation -And $UpdateVMTag) {
                $operation = @("UpdateVMTag", $UpdateVMTagOperation)
                $UserProvidedTag += @{$operation = $UpdateVMTag }
            }
            else {
                $ProviderSpecificDetails.TargetVmTag = $ReplicationMigrationItem.ProviderSpecificDetail.TargetVmTag
            }

            if ($HasUpdateNicTag -And $HasUpdateNicTagOperation -And $UpdateNicTag) {
                $operation = @("UpdateNicTag", $UpdateNicTagOperation)
                $UserProvidedTag += @{$operation = $UpdateNicTag }
            }
            else {
                $ProviderSpecificDetails.TargetNicTag = $ReplicationMigrationItem.ProviderSpecificDetail.TargetNicTag
            }

            if ($HasUpdateDiskTag -And $HasUpdateDiskTagOperation -And $UpdateDiskTag) {
                $operation = @("UpdateDiskTag", $UpdateDiskTagOperation)
                $UserProvidedTag += @{$operation = $UpdateDiskTag }
            }
            else {
                $ProviderSpecificDetails.TargetDiskTag = $ReplicationMigrationItem.ProviderSpecificDetail.TargetDiskTag
            }

            foreach ($tag in $UserProvidedTag.Keys) {
                $IllegalCharKey = New-Object Collections.Generic.List[String]
                $ExceededLengthKey = New-Object Collections.Generic.List[String]
                $ExceededLengthValue = New-Object Collections.Generic.List[String]
                $ResourceTag = $($UserProvidedTag.Item($tag))

                foreach ($key in $ResourceTag.Keys) {
                    if ($key.length -eq 0) {
                        throw "InvalidTagName : The tag name must be non-null, non-empty and non-whitespace only. Please provide an actual value."
                    }

                    if ($key.length -gt 512) {
                        $ExceededLengthKey.add($key)
                    }

                    if ($key -match "[<>%&\?/.]") {
                        $IllegalCharKey.add($key)
                    }

                    if ($($ResourceTag.Item($key)).length -gt 256) {
                        $ExceededLengthValue.add($($ResourceTag.Item($key)))
                    }
                }

                if ($IllegalCharKey.Count -gt 0) {
                    throw "InvalidTagNameCharacters : The tag names '$($IllegalCharKey -join ', ')' have reserved characters '<,>,%,&,\,?,/' or control characters."
                }

                if ($ExceededLengthKey.Count -gt 0) {
                    throw "InvalidTagName : Tag key too large. Following tag name '$($ExceededLengthKey -join ', ')' exceeded the maximum length. Maximum allowed length for tag name - '512' characters."
                }

                if ($ExceededLengthValue.Count -gt 0) {
                    throw "InvalidTagValueLength : Tag value too large. Following tag value '$($ExceededLengthValue -join ', ')' exceeded the maximum length. Maximum allowed length for tag value - '256' characters."
                }

                if ($tag[1] -eq "Merge") {
                    foreach ($key in $ResourceTag.Keys) {
                        if ($ReplicationMigrationItem.ProviderSpecificDetail.TargetVmTag.ContainsKey($key) -And `
                            ($tag[0] -eq "UpdateVMTag" -or $tag[0] -eq "UpdateTag")) {
                            $ReplicationMigrationItem.ProviderSpecificDetail.TargetVmTag.Remove($key)
                        }

                        if ($ReplicationMigrationItem.ProviderSpecificDetail.TargetNicTag.ContainsKey($key) -And `
                            ($tag[0] -eq "UpdateNicTag" -or $tag[0] -eq "UpdateTag")) {
                            $ReplicationMigrationItem.ProviderSpecificDetail.TargetNicTag.Remove($key)
                        }

                        if ($ReplicationMigrationItem.ProviderSpecificDetail.TargetDiskTag.ContainsKey($key) -And `
                            ($tag[0] -eq "UpdateDiskTag" -or $tag[0] -eq "UpdateTag")) {
                            $ReplicationMigrationItem.ProviderSpecificDetail.TargetDiskTag.Remove($key)
                        }

                        if ($tag[0] -eq "UpdateVMTag" -or $tag[0] -eq "UpdateTag") {
                            $ReplicationMigrationItem.ProviderSpecificDetail.TargetVmTag.Add($key, $($ResourceTag.Item($key)))
                        }

                        if ($tag[0] -eq "UpdateNicTag" -or $tag[0] -eq "UpdateTag") {
                            $ReplicationMigrationItem.ProviderSpecificDetail.TargetNicTag.Add($key, $($ResourceTag.Item($key)))
                        }

                        if ($tag[0] -eq "UpdateDiskTag" -or $tag[0] -eq "UpdateTag") {
                            $ReplicationMigrationItem.ProviderSpecificDetail.TargetDiskTag.Add($key, $($ResourceTag.Item($key)))
                        }
                    }
                    
                    $ProviderSpecificDetails.TargetVmTag = $ReplicationMigrationItem.ProviderSpecificDetail.TargetVmTag
                    $ProviderSpecificDetails.TargetNicTag = $ReplicationMigrationItem.ProviderSpecificDetail.TargetNicTag
                    $ProviderSpecificDetails.TargetDiskTag = $ReplicationMigrationItem.ProviderSpecificDetail.TargetDiskTag
                }
                elseif ($tag[1] -eq "Replace") {
                    if ($tag[0] -eq "UpdateVMTag" -or $tag[0] -eq "UpdateTag") {
                        $ProviderSpecificDetails.TargetVmTag = $ResourceTag
                    }

                    if ($tag[0] -eq "UpdateNicTag" -or $tag[0] -eq "UpdateTag") {
                        $ProviderSpecificDetails.TargetNicTag = $ResourceTag
                    }

                    if ($tag[0] -eq "UpdateDiskTag" -or $tag[0] -eq "UpdateTag") {
                        $ProviderSpecificDetails.TargetDiskTag = $ResourceTag
                    }
                }
                else {
                    foreach ($key in $ResourceTag.Keys) {
                        if (($tag[0] -eq "UpdateVMTag" -or $tag[0] -eq "UpdateTag") `
                                -And $ReplicationMigrationItem.ProviderSpecificDetail.TargetVmTag.ContainsKey($key) `
                                -And ($($ReplicationMigrationItem.ProviderSpecificDetail.TargetVmTag.Item($key)) `
                                    -eq $($ResourceTag.Item($key)))) {
                            $ReplicationMigrationItem.ProviderSpecificDetail.TargetVmTag.Remove($key)
                        }

                        if (($tag[0] -eq "UpdateNicTag" -or $tag[0] -eq "UpdateTag") `
                                -And $ReplicationMigrationItem.ProviderSpecificDetail.TargetNicTag.ContainsKey($key) `
                                -And ($($ReplicationMigrationItem.ProviderSpecificDetail.TargetNicTag.Item($key)) `
                                    -eq $($ResourceTag.Item($key)))) {
                            $ReplicationMigrationItem.ProviderSpecificDetail.TargetNicTag.Remove($key)
                        }

                        if (($tag[0] -eq "UpdateDiskTag" -or $tag[0] -eq "UpdateTag") `
                                -And $ReplicationMigrationItem.ProviderSpecificDetail.TargetDiskTag.ContainsKey($key) `
                                -And ($($ReplicationMigrationItem.ProviderSpecificDetail.TargetDiskTag.Item($key)) `
                                    -eq $($ResourceTag.Item($key)))) {
                            $ReplicationMigrationItem.ProviderSpecificDetail.TargetDiskTag.Remove($key)
                        }
                    }

                    $ProviderSpecificDetails.TargetVmTag = $ReplicationMigrationItem.ProviderSpecificDetail.TargetVmTag
                    $ProviderSpecificDetails.TargetNicTag = $ReplicationMigrationItem.ProviderSpecificDetail.TargetNicTag
                    $ProviderSpecificDetails.TargetDiskTag = $ReplicationMigrationItem.ProviderSpecificDetail.TargetDiskTag
                }

                if ($ProviderSpecificDetails.TargetVmTag.Count -gt 50) {
                    throw "InvalidTags : Too many tags specified. Requested tag count - '$($ProviderSpecificDetails.TargetVmTag.Count)'. Maximum number of tags allowed - '50'."
                }

                if ($ProviderSpecificDetails.TargetNicTag.Count -gt 50) {
                    throw "InvalidTags : Too many tags specified. Requested tag count - '$($ProviderSpecificDetails.TargetNicTag.Count)'. Maximum number of tags allowed - '50'."
                }

                if ($ProviderSpecificDetails.TargetDiskTag.Count -gt 50) {
                    throw "InvalidTags : Too many tags specified. Requested tag count - '$($ProviderSpecificDetails.TargetDiskTag.Count)'. Maximum number of tags allowed - '50'."
                }
            }

            if ($HasTargetNetworkId) {
                $ProviderSpecificDetails.TargetNetworkId = $TargetNetworkId
            }
            else {
                $ProviderSpecificDetails.TargetNetworkId = $ReplicationMigrationItem.ProviderSpecificDetail.TargetNetworkId
            }

            if ($HasTestNetworkId) {
                $ProviderSpecificDetails.TestNetworkId = $TestNetworkId
            }
            else {
                $ProviderSpecificDetails.TestNetworkId = $ReplicationMigrationItem.ProviderSpecificDetail.VMNic[0].TestNetworkId
            }

            if ($HasTargetResourceGroupID) {
                $ProviderSpecificDetails.TargetResourceGroupId = $TargetResourceGroupID
            }
            else {
                $ProviderSpecificDetails.TargetResourceGroupId = $ReplicationMigrationItem.ProviderSpecificDetail.TargetResourceGroupId
            }

            if ($HasTargetVmSize) {
                $ProviderSpecificDetails.TargetVMSize = $TargetVmSize
            }
            else {
                $ProviderSpecificDetails.TargetVMSize = $ReplicationMigrationItem.ProviderSpecificDetail.TargetVmSize
            }

            if ($HasTargetBootDignosticStorageAccount) {
                $ProviderSpecificDetails.TargetBootDiagnosticsStorageAccountId = $TargetBootDiagnosticsStorageAccount
            }
            else {
                $ProviderSpecificDetails.TargetBootDiagnosticsStorageAccountId = $ReplicationMigrationItem.ProviderSpecificDetail.TargetBootDiagnosticsStorageAccountId
            }

            # Storage accounts need to be in the same subscription as that of the VM.
            if (($null -ne $ProviderSpecificDetails.TargetBootDiagnosticsStorageAccountId) -and ($ProviderSpecificDetails.TargetBootDiagnosticsStorageAccountId.length -gt 1)) {
                $TargetBDSASubscriptionId = $ProviderSpecificDetails.TargetBootDiagnosticsStorageAccountId.Split('/')[2]
                $TargetSubscriptionId = $ProviderSpecificDetails.TargetResourceGroupId.Split('/')[2]
                if ($TargetBDSASubscriptionId -ne $TargetSubscriptionId) {
                    $ProviderSpecificDetails.TargetBootDiagnosticsStorageAccountId = $null
                }
            }

            if ($HasTargetVMName) {
                if ($TargetVMName.length -gt 64 -or $TargetVMName.length -eq 0) {
                    throw "The target virtual machine name must be between 1 and 64 characters long."
                }
                $vmId = $ProviderSpecificDetails.TargetResourceGroupId + "/providers/Microsoft.Compute/virtualMachines/" + $TargetVMName
                $VMNamePresentinRg = Get-AzResource -ResourceId $vmId -ErrorVariable notPresent -ErrorAction SilentlyContinue
                if ($VMNamePresentinRg) {
                    throw "The target virtual machine name must be unique in the target resource group."
                }

                if ($TargetVMName -notmatch "^[^_\W][a-zA-Z0-9\-]{0,63}(?<![-._])$") {
                    throw "The target virtual machine name must begin with a letter or number, and can contain only letters, numbers, or hyphens(-). The names cannot contain special characters \/""[]:|<>+=;,?*@&, whitespace, or begin with '_' or end with '.' or '-'."
                }

                $ProviderSpecificDetails.TargetVMName = $TargetVMName
            }
            else {
                $ProviderSpecificDetails.TargetVMName = $ReplicationMigrationItem.ProviderSpecificDetail.TargetVMName
            }

            if ($HasDiskToUpdate) {
                $diskIdDiskTypeMap = @{}
                $originalDisks = $ReplicationMigrationItem.ProviderSpecificDetail.ProtectedDisk

                foreach($DiskObject in $originalDisks) {
                    if ($DiskObject.IsOSDisk -and $DiskObject.IsOSDisk -eq "True") {
                        $previousOsDiskId = $DiskObject.DiskId
                        Break
                    }
                }

                $diskNamePresentinRg = New-Object Collections.Generic.List[String]
                $duplicateDiskName = New-Object System.Collections.Generic.HashSet[String]
                $uniqueDiskUuids = [System.Collections.Generic.HashSet[String]]::new([StringComparer]::InvariantCultureIgnoreCase)
                $osDiskCount = 0
                foreach($DiskObject in $DiskToUpdate) {
                    if ($DiskObject.IsOSDisk -eq "True") {
                        $osDiskCount++
                        $changeOsDiskId = $DiskObject.DiskId
                        if ($osDiskCount -gt 1) {
                            throw "Multiple disks have been selected as OS Disk."
                        }
                    }

                    $matchingUserInputDisk = $null
                    $originalDisks = $ReplicationMigrationItem.ProviderSpecificDetail.ProtectedDisk
                    foreach ($orgDisk in $originalDisks) {
                        if ($orgDisk.DiskId -eq $DiskObject.DiskId)
                        {
                            $matchingUserInputDisk = $orgDisk
                            break
                        }
                    }

                    if ($matchingUserInputDisk -ne $null -and [string]::IsNullOrEmpty($DiskObject.TargetDiskName)) {
                        $DiskObject.TargetDiskName = $matchingUserInputDisk.TargetDiskName
                    }

                    if ($matchingUserInputDisk -ne $null -and [string]::IsNullOrEmpty($DiskObject.IsOSDisk)) {
                        $DiskObject.IsOSDisk = $matchingUserInputDisk.IsOSDisk
                    }

                    $diskId = $ProviderSpecificDetails.TargetResourceGroupId + "/providers/Microsoft.Compute/disks/" + $DiskObject.TargetDiskName
                    $diskNamePresent = Get-AzResource -ResourceId $diskId -ErrorVariable notPresent -ErrorAction SilentlyContinue
                    if ($diskNamePresent) {
                        $diskNamePresentinRg.Add($DiskObject.TargetDiskName)
                    }

                    if ($uniqueDiskUuids.Contains($DiskObject.DiskId)) {
                        throw "The disk uuid '$($DiskObject.DiskId)' is already taken."
                    }
                    $res = $uniqueDiskUuids.Add($DiskObject.DiskId)

                    if ($duplicateDiskName.Contains($DiskObject.TargetDiskName)) {
                        throw "The disk name '$($DiskObject.TargetDiskName)' is already taken."
                    }
                    $res = $duplicateDiskName.Add($DiskObject.TargetDiskName)
                }
                if ($diskNamePresentinRg) {
                    throw "Disks with name $($diskNamePresentinRg -join ', ')' already exists in the target resource group."
                }

                foreach($DiskObject in $DiskToUpdate) {
                    if ($DiskObject.IsOSDisk) {
                        $diskIdDiskTypeMap.Add($DiskObject.DiskId, $DiskObject.IsOSDisk)
                    }
                }

                if ($changeOsDiskId -ne $null -and $changeOsDiskId -ne $previousOsDiskId) {
                    if ($diskIdDiskTypeMap.ContainsKey($previousOsDiskId)) {
                        $rem = $diskIdDiskTypeMap.Remove($previousOsDiskId)
                        foreach($DiskObject in $DiskToUpdate) {
                            if ($DiskObject.DiskId -eq $previousOsDiskId) {
                                $DiskObject.IsOsDisk = "False"
                            }
                        }
                    }
                    else {
                        $updateDisk = [Microsoft.Azure.PowerShell.Cmdlets.Migrate.Models.Api202401.VMwareCbtUpdateDiskInput]::new()
                        $updateDisk.DiskId = $previousOsDiskId
                        $updateDisk.IsOSDisk = "False"
                        $originalDisks = $ReplicationMigrationItem.ProviderSpecificDetail.ProtectedDisk
                        foreach ($orgDisk in $originalDisks) {
                           if ($orgDisk.DiskId -eq $previousOsDiskId) {
                               $updateDisk.TargetDiskName = $orgDisk.TargetDiskName
                               break
                            }
                        }
                        $DiskToUpdate += $updateDisk
                    }
                    $diskIdDiskTypeMap.Add($previousOsDiskId, "False")
                }

                $osDiskCount = 0

                foreach ($DiskObject in $originalDisks) {
                   if ($diskIdDiskTypeMap.Contains($DiskObject.DiskId)) {
                       if ($diskIdDiskTypeMap.($DiskObject.DiskId) -eq "True") {
                           $osDiskCount++
                       }
                   }
                   elseif ($DiskObject.IsOSDisk -eq "True") {
                       $osDiskCount++
                   }
                }

                if ($osDiskCount -eq 0) {
                   throw "OS disk cannot be excluded from migration."
                }
                elseif ($osDiskCount -ne 1) {
                   throw "Multiple disks have been selected as OS Disk."
                }
               $ProviderSpecificDetails.VMDisK = $DiskToUpdate
            }

            if ($HasTargetDiskName) {
                if ($TargetDiskName.length -gt 80 -or $TargetDiskName.length -eq 0) {
                    throw "The disk name must be between 1 and 80 characters long."
                }

                if ($TargetDiskName -notmatch "^[^_\W][a-zA-Z0-9_\-\.]{0,79}(?<![-.])$") {
                    throw "The disk name must begin with a letter or number, end with a letter, number or underscore, and may contain only letters, numbers, underscores, periods, or hyphens."
                }

                $diskId = $ProviderSpecificDetails.TargetResourceGroupId + "/providers/Microsoft.Compute/disks/" + $TargetDiskName
                $diskNamePresent = Get-AzResource -ResourceId $diskId -ErrorVariable notPresent -ErrorAction SilentlyContinue

                if ($diskNamePresent) {
                    throw "A disk with name $($TargetDiskName)' already exists in the target resource group."
                }

                [Microsoft.Azure.PowerShell.Cmdlets.Migrate.Models.Api202401.IVMwareCbtUpdateDiskInput[]]$updateDisksArray = @()
                $originalDisks = $ReplicationMigrationItem.ProviderSpecificDetail.ProtectedDisk
                foreach ($DiskObject in $originalDisks) {
                    if ( $DiskObject.IsOSDisk) {
                        $updateDisk = [Microsoft.Azure.PowerShell.Cmdlets.Migrate.Models.Api202401.VMwareCbtUpdateDiskInput]::new()
                        $updateDisk.DiskId = $DiskObject.DiskId
                        $updateDisk.TargetDiskName = $TargetDiskName
                        $updateDisksArray += $updateDisk
                        $ProviderSpecificDetails.VMDisk = $updateDisksArray
                        break
                    }
                }
            }

            $originalNics = $ReplicationMigrationItem.ProviderSpecificDetail.VMNic
            [Microsoft.Azure.PowerShell.Cmdlets.Migrate.Models.Api202401.IVMwareCbtNicInput[]]$updateNicsArray = @()
            $nicNamePresentinRg = New-Object Collections.Generic.List[String]
            $duplicateNicName = New-Object System.Collections.Generic.HashSet[String]

            foreach ($storedNic in $originalNics) {
                $updateNic = [Microsoft.Azure.PowerShell.Cmdlets.Migrate.Models.Api202401.VMwareCbtNicInput]::new()
                $updateNic.IsPrimaryNic = $storedNic.IsPrimaryNic
                $updateNic.IsSelectedForMigration = $storedNic.IsSelectedForMigration
                $updateNic.NicId = $storedNic.NicId
                $updateNic.TargetStaticIPAddress = $storedNic.TargetIPAddress
                $updateNic.TestStaticIPAddress = $storedNic.TestIPAddress
                $updateNic.TargetSubnetName = $storedNic.TargetSubnetName
                $updateNic.TestSubnetName = $storedNic.TestSubnetName
                $updateNic.TargetNicName = $storedNic.TargetNicName

                $matchingUserInputNic = $null
                if ($HasNicToUpdate) {
                    foreach ($userInputNic in $NicToUpdate) {
                        if ($userInputNic.NicId -eq $storedNic.NicId) {
                            $matchingUserInputNic = $userInputNic
                            break
                        }
                    }
                }
                if ($null -ne $matchingUserInputNic) {
                    if ($null -ne $matchingUserInputNic.IsPrimaryNic) {
                        $updateNic.IsPrimaryNic = $matchingUserInputNic.IsPrimaryNic
                        $updateNic.IsSelectedForMigration = $matchingUserInputNic.IsSelectedForMigration
                        if ($updateNic.IsSelectedForMigration -eq "false") {
                            $updateNic.TargetSubnetName = ""
                            $updateNic.TargetStaticIPAddress = ""
                        }
                    }
                    if ($null -ne $matchingUserInputNic.TargetSubnetName) {
                        $updateNic.TargetSubnetName = $matchingUserInputNic.TargetSubnetName
                    }
                    if ($null -ne $matchingUserInputNic.TestSubnetName) {
                        $updateNic.TestSubnetName = $matchingUserInputNic.TestSubnetName
                    }
                    if ($null -ne $matchingUserInputNic.TargetNicName) {
                        $nicId = $ProviderSpecificDetails.TargetResourceGroupId + "/providers/Microsoft.Network/networkInterfaces/" + $matchingUserInputNic.TargetNicName
                        $nicNamePresent = Get-AzResource -ResourceId $nicId -ErrorVariable notPresent -ErrorAction SilentlyContinue

                        if ($nicNamePresent) {
                            $nicNamePresentinRg.Add($matchingUserInputNic.TargetNicName)
                        }
                        $updateNic.TargetNicName = $matchingUserInputNic.TargetNicName

                        if ($duplicateNicName.Contains($matchingUserInputNic.TargetNicName)) {
                            throw "The NIC name '$($matchingUserInputNic.TargetNicName)' is already taken."
                        }
                        $res = $duplicateNicName.Add($matchingUserInputNic.TargetNicName)
                    }
                    if ($null -ne $matchingUserInputNic.TargetStaticIPAddress) {
                        if ($matchingUserInputNic.TargetStaticIPAddress -eq "auto") {
                            $updateNic.TargetStaticIPAddress = $null
                        }
                        else {
                            $isValidIpAddress = [ipaddress]::TryParse($matchingUserInputNic.TargetStaticIPAddress,[ref][ipaddress]::Loopback)
                             if(!$isValidIpAddress) {
                                 throw "(InvalidPrivateIPAddressFormat) Static IP address value '$($matchingUserInputNic.TargetStaticIPAddress)' is invalid."
                             }
                             $updateNic.TargetStaticIPAddress = $matchingUserInputNic.TargetStaticIPAddress
                        }
                    }
                    if ($null -ne $matchingUserInputNic.TestStaticIPAddress) {
                        if ($matchingUserInputNic.TestStaticIPAddress -eq "auto") {
                            $updateNic.TestStaticIPAddress = $null
                        }
                        else {
                            $isValidIpAddress = [ipaddress]::TryParse($matchingUserInputNic.TestStaticIPAddress,[ref][ipaddress]::Loopback)
                             if(!$isValidIpAddress) {
                                 throw "(InvalidPrivateIPAddressFormat) Static IP address value '$($matchingUserInputNic.TestStaticIPAddress)' is invalid."
                             }
                             $updateNic.TestStaticIPAddress = $matchingUserInputNic.TestStaticIPAddress
                        }
                    }
                }
                $updateNicsArray += $updateNic
            }

            # validate there is exactly one primary nic
            $primaryNicCountInUpdate = 0
            foreach ($nic in $updateNicsArray) {
                if ($nic.IsPrimaryNic -eq "true") {
                    $primaryNicCountInUpdate += 1
                }
            }
            if ($primaryNicCountInUpdate -ne 1) {
                throw "One NIC has to be Primary."
            }

            if ($nicNamePresentinRg) {
                throw "NIC name '$($nicNamePresentinRg -join ', ')' must be unique in the target resource group."
            }

            $ProviderSpecificDetails.VMNic = $updateNicsArray
            $null = $PSBoundParameters.Add('ProviderSpecificDetail', $ProviderSpecificDetails)
            $null = $PSBoundParameters.Add('NoWait', $true)
            $output = Az.Migrate.internal\Update-AzMigrateReplicationMigrationItem @PSBoundParameters
            $JobName = $output.Target.Split("/")[12].Split("?")[0]

            $null = $PSBoundParameters.Remove('NoWait')
            $null = $PSBoundParameters.Remove('ProviderSpecificDetail')
            $null = $PSBoundParameters.Remove("ResourceGroupName")
            $null = $PSBoundParameters.Remove("ResourceName")
            $null = $PSBoundParameters.Remove("FabricName")
            $null = $PSBoundParameters.Remove("MigrationItemName")
            $null = $PSBoundParameters.Remove("ProtectionContainerName")

            $null = $PSBoundParameters.Add('JobName', $JobName)
            $null = $PSBoundParameters.Add('ResourceName', $VaultName)
            $null = $PSBoundParameters.Add('ResourceGroupName', $ResourceGroupName)

            return Az.Migrate.internal\Get-AzMigrateReplicationJob @PSBoundParameters
        }
        else {
            throw "Either machine doesn't exist or provider/action isn't supported for this machine"
        }
    }
}   
# SIG # Begin signature block
# MIIoVAYJKoZIhvcNAQcCoIIoRTCCKEECAQExDzANBglghkgBZQMEAgEFADB5Bgor
# BgEEAYI3AgEEoGswaTA0BgorBgEEAYI3AgEeMCYCAwEAAAQQH8w7YFlLCE63JNLG
# KX7zUQIBAAIBAAIBAAIBAAIBADAxMA0GCWCGSAFlAwQCAQUABCBqMAeUjkn9cBDn
# +hu+kAKjRktCKNuDQ/8dt/5BT9LsKqCCDYUwggYDMIID66ADAgECAhMzAAAEA73V
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
# HAYKKwYBBAGCNwIBCzEOMAwGCisGAQQBgjcCARUwLwYJKoZIhvcNAQkEMSIEIAyF
# wa8xmpg5KICPyfEH6/3ypWv1bowHD9vz/YRWzJDpMEIGCisGAQQBgjcCAQwxNDAy
# oBSAEgBNAGkAYwByAG8AcwBvAGYAdKEagBhodHRwOi8vd3d3Lm1pY3Jvc29mdC5j
# b20wDQYJKoZIhvcNAQEBBQAEggEAkcs1vLuOVY/pzXAuDk/RBmkRTcX5dm83jS/j
# t078QXo/+EMZU+hBBd8dJXgIZ+3+PQK8Yu6ZjhTo9GNA1kuU/y/DnMTHLLTVnuUT
# uKsEgbSDKxN2hjstEW11dXSmnbYW/67CitNqfQBhnEo7aK0OWrkcgtCuz5SnPkZk
# D3qXcyDfJ9sh8JT4A1e+kxmsBLWihHpozNZisMugCCOTIYSpTqRaqhKNZ/9ZNyXt
# oLJ8wUWjBGdtn5fZDrJ89eSw7laWtM8fBDQ3uLaHEw/NwXTSTFQVdDheJiLR9Tsb
# nLo5cZm04aJw+CvpCN+LTB12tCsJuwaWtuk/dkK+mLFCBB2ZM6GCF68wgherBgor
# BgEEAYI3AwMBMYIXmzCCF5cGCSqGSIb3DQEHAqCCF4gwgheEAgEDMQ8wDQYJYIZI
# AWUDBAIBBQAwggFZBgsqhkiG9w0BCRABBKCCAUgEggFEMIIBQAIBAQYKKwYBBAGE
# WQoDATAxMA0GCWCGSAFlAwQCAQUABCCETXh3kXCL0dHdB3ogX5B5z+pY0fW5lEuF
# jsdFn9JXXgIGZus6zI1BGBIyMDI0MTEwMTE1MDQxNy45OFowBIACAfSggdmkgdYw
# gdMxCzAJBgNVBAYTAlVTMRMwEQYDVQQIEwpXYXNoaW5ndG9uMRAwDgYDVQQHEwdS
# ZWRtb25kMR4wHAYDVQQKExVNaWNyb3NvZnQgQ29ycG9yYXRpb24xLTArBgNVBAsT
# JE1pY3Jvc29mdCBJcmVsYW5kIE9wZXJhdGlvbnMgTGltaXRlZDEnMCUGA1UECxMe
# blNoaWVsZCBUU1MgRVNOOjJBMUEtMDVFMC1EOTQ3MSUwIwYDVQQDExxNaWNyb3Nv
# ZnQgVGltZS1TdGFtcCBTZXJ2aWNloIIR/jCCBygwggUQoAMCAQICEzMAAAH5H2eN
# dauk8bEAAQAAAfkwDQYJKoZIhvcNAQELBQAwfDELMAkGA1UEBhMCVVMxEzARBgNV
# BAgTCldhc2hpbmd0b24xEDAOBgNVBAcTB1JlZG1vbmQxHjAcBgNVBAoTFU1pY3Jv
# c29mdCBDb3Jwb3JhdGlvbjEmMCQGA1UEAxMdTWljcm9zb2Z0IFRpbWUtU3RhbXAg
# UENBIDIwMTAwHhcNMjQwNzI1MTgzMTA5WhcNMjUxMDIyMTgzMTA5WjCB0zELMAkG
# A1UEBhMCVVMxEzARBgNVBAgTCldhc2hpbmd0b24xEDAOBgNVBAcTB1JlZG1vbmQx
# HjAcBgNVBAoTFU1pY3Jvc29mdCBDb3Jwb3JhdGlvbjEtMCsGA1UECxMkTWljcm9z
# b2Z0IElyZWxhbmQgT3BlcmF0aW9ucyBMaW1pdGVkMScwJQYDVQQLEx5uU2hpZWxk
# IFRTUyBFU046MkExQS0wNUUwLUQ5NDcxJTAjBgNVBAMTHE1pY3Jvc29mdCBUaW1l
# LVN0YW1wIFNlcnZpY2UwggIiMA0GCSqGSIb3DQEBAQUAA4ICDwAwggIKAoICAQC0
# PUwffIAdYc1WyUL4IFOP8yl3nksM+1CuE3tZ6oWFF4L3EpdKOhtbVkfMdTxXYE4l
# SJiDt8MnYDEZUbKi9S2AZmDb4Zq4UqTdmOOwtKyp6FgixRCuBf6v9UBNpbz841bL
# qU7IZnBmnF9XYRfioCHqZvaFp0C691tGXVArW18GVHd914IFAb7JvP0kVnjks3am
# zw1zXGvjU3xCLcpUkthfSJsRsCSSxHhtuzMLO9j691KuNbIoCNHpiBiFoFoPETYo
# MnaxBEUUX96ALEqCiB0XdUgmgIT9a7L0y4SDKl5rUd6LuUUa90tBkfkmjZBHm43y
# GIxzxnjtFEm4hYI57IgnVidGKKJulRnvb7Cm/wtOi/TIfoLkdH8Pz4BPi+q0/nsh
# NewP0M86hvy2O2x589xAl5tQ2KrJ/JMvmPn8n7Z34Y8JxcRih5Zn6euxlJ+t3kMc
# zii8KYPeWJ+BifOM6vLiCFBP9y+Z0fAWvrIkamFb8cbwZB35wHjDvAak6EdUlvLj
# iQZUrwzNj2zfYPLVMecmDynvLWwQbP8DXLzhm3qAiwhNhpxweEEqnhw5U2t+hFVT
# HYb/ROvsOTd+kJTy77miWo8/AqBmznuOX6U6tFWxfUBgSYCfILIaupEDOkZfKTUe
# 80gGlI025MFCTsUG+75imLoDtLZXZOPqXNhZUG+4YQIDAQABo4IBSTCCAUUwHQYD
# VR0OBBYEFInto7qclckj16KPNLlCRHZGWeAAMB8GA1UdIwQYMBaAFJ+nFV0AXmJd
# g/Tl0mWnG1M1GelyMF8GA1UdHwRYMFYwVKBSoFCGTmh0dHA6Ly93d3cubWljcm9z
# b2Z0LmNvbS9wa2lvcHMvY3JsL01pY3Jvc29mdCUyMFRpbWUtU3RhbXAlMjBQQ0El
# MjAyMDEwKDEpLmNybDBsBggrBgEFBQcBAQRgMF4wXAYIKwYBBQUHMAKGUGh0dHA6
# Ly93d3cubWljcm9zb2Z0LmNvbS9wa2lvcHMvY2VydHMvTWljcm9zb2Z0JTIwVGlt
# ZS1TdGFtcCUyMFBDQSUyMDIwMTAoMSkuY3J0MAwGA1UdEwEB/wQCMAAwFgYDVR0l
# AQH/BAwwCgYIKwYBBQUHAwgwDgYDVR0PAQH/BAQDAgeAMA0GCSqGSIb3DQEBCwUA
# A4ICAQBmIAmAVuR/uN+HH+aZmWcZmulp74canFbGzwjv29RvwZCi7nQzWezuLAbY
# Jx2hdqrtWClWQ1/W68iGsZikoIFdD5JonY7QG/C4lHtSyBNoo3SP/J/d+kcPSS0f
# 4SQS4Zez0MEvK3vWK61WTCjD2JCZKTiggrxLwCs0alI7N6671N0mMGOxqya4n7ar
# lOOauAQrI97dMCkCKjxx3D9vVwECaO0ju2k1hXk/JEjcrU2G4OB8SPmTKcYX+6LM
# /U24dLEX9XWSz/a0ISiuKJwziTU8lNMDRMKM1uSmYFywAyXFPMGdayqcEK3135R3
# 1VrcjD0GzhxyuSAGMu2De9gZhqvrXmh9i1T526n4u5TR3bAEMQbWeFJYdo767bLp
# KLcBo0g23+k4wpTqXgBbS4NZQff04cfcSoUe1OyxldoM6O3JGBuowaaR/wojeohU
# FknZdCmeES5FuH4CCmZGf9rjXQOTtW0+Da4LjbZYsLwfwhWT8V6iJJLi8Wh2GdwV
# 60nRkrfrDEBrcWI+AF5tFbJW1nvreoMPPENvSYHocv0cR9Ns37igcKRlrUcqXwHS
# zxGIUEx/9bv47sQ9n7AwfzB2SNntJux1211GBEBGpHwgU9a6tD6yft+0SJ9qiPO4
# IRqFIByrzrKPBB5M831gb1vfhFO6ueSkP7A8ZMHVZxwymwuUzTCCB3EwggVZoAMC
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
# blNoaWVsZCBUU1MgRVNOOjJBMUEtMDVFMC1EOTQ3MSUwIwYDVQQDExxNaWNyb3Nv
# ZnQgVGltZS1TdGFtcCBTZXJ2aWNloiMKAQEwBwYFKw4DAhoDFQCqzlaNY7vNUAqY
# hx3CGqBm/KnpRqCBgzCBgKR+MHwxCzAJBgNVBAYTAlVTMRMwEQYDVQQIEwpXYXNo
# aW5ndG9uMRAwDgYDVQQHEwdSZWRtb25kMR4wHAYDVQQKExVNaWNyb3NvZnQgQ29y
# cG9yYXRpb24xJjAkBgNVBAMTHU1pY3Jvc29mdCBUaW1lLVN0YW1wIFBDQSAyMDEw
# MA0GCSqGSIb3DQEBCwUAAgUA6s8PlzAiGA8yMDI0MTEwMTA4MjgwN1oYDzIwMjQx
# MTAyMDgyODA3WjB3MD0GCisGAQQBhFkKBAExLzAtMAoCBQDqzw+XAgEAMAoCAQAC
# AgyqAgH/MAcCAQACAhQ+MAoCBQDq0GEXAgEAMDYGCisGAQQBhFkKBAIxKDAmMAwG
# CisGAQQBhFkKAwKgCjAIAgEAAgMHoSChCjAIAgEAAgMBhqAwDQYJKoZIhvcNAQEL
# BQADggEBABCzBK8g5kYQXdiEk+D1LJImZa2OBWZm2G/bol6NtEQUf+l/vpMqQ7PE
# /tNURknCwPD6ZF0ONZLxMZwNN0AujNvoyquJEbLf96QeekR+2CYTivl2CGVX4o9I
# TsbTHClErkdMQ4IakvvMSkNl4zCzL5gupTyDzc7vozWsCPyoKrBZEgSdSb1CzhDL
# OpfL4Ee52GKKHfnSrWkHANmWKvbqm52kzQdC0B2FRuZR4f+HF74JAc/Vv7raZ9g1
# dhSSZcdx6t0T5jA3Bq/y+CVr+NBXQF5rMxk+CLkP6WmF0/0zfoUjJHYmkbwptfx8
# 6E5J0Zi2EeyrykOT/DEBCWEnCqGQK84xggQNMIIECQIBATCBkzB8MQswCQYDVQQG
# EwJVUzETMBEGA1UECBMKV2FzaGluZ3RvbjEQMA4GA1UEBxMHUmVkbW9uZDEeMBwG
# A1UEChMVTWljcm9zb2Z0IENvcnBvcmF0aW9uMSYwJAYDVQQDEx1NaWNyb3NvZnQg
# VGltZS1TdGFtcCBQQ0EgMjAxMAITMwAAAfkfZ411q6TxsQABAAAB+TANBglghkgB
# ZQMEAgEFAKCCAUowGgYJKoZIhvcNAQkDMQ0GCyqGSIb3DQEJEAEEMC8GCSqGSIb3
# DQEJBDEiBCCjvHCERlw4WYhmIRJYYIKJzU2AUSt1vgMAEmC7135RyDCB+gYLKoZI
# hvcNAQkQAi8xgeowgecwgeQwgb0EIDkjjMge8I37ZPrpFQ4sJmtQRV2gqUqXxV4I
# 7lJsYtgQMIGYMIGApH4wfDELMAkGA1UEBhMCVVMxEzARBgNVBAgTCldhc2hpbmd0
# b24xEDAOBgNVBAcTB1JlZG1vbmQxHjAcBgNVBAoTFU1pY3Jvc29mdCBDb3Jwb3Jh
# dGlvbjEmMCQGA1UEAxMdTWljcm9zb2Z0IFRpbWUtU3RhbXAgUENBIDIwMTACEzMA
# AAH5H2eNdauk8bEAAQAAAfkwIgQgcUeEHMzDDvBjSUj+QEA32wm22PLJEJSvQuA9
# TAen/skwDQYJKoZIhvcNAQELBQAEggIAPxsi4Vs7BezIpAobot0QdyoBqhFQlZa5
# OjcepbKi/l3wtz8EbluqmDDCHeWsUrkn6vlioYxq/mUL+zGrxjKsvKPN52DvcTqZ
# Ag7UjhpJ0N4zhoMuNhRhoT5Iq0g71O0L1LFSx61JoS8tERFS8bAG9dFd8rskKZFS
# gUg9EnYqMMdd+3e/+psggQlQG6vFf02cJIWYs4pPRErIFOufJcfnCA2/jYR2pdiP
# Igqw/lT/DGIa3LKPV7ywgxRlUtXj7BEcR7rInfAzget9dAnyCdsXm8PO4n8+CZF9
# oKcIURI/kfGuro6NfKVBnrWn/L9aYENsiU5qmgcS/kRwgyvl/DPyNQPs4j64rqSR
# uS0AfPEpXwfAf6X5dzVICQPf8QcKoq/PDTm2J1QCfTI3uoq3U4p0HUyGVa3YnAXb
# CcXx8PjUdAtBWqp7ws5eGzZ3AWARPzNaWkLFcQNB5LzsVDzPXxYHN9499xVRije7
# GM/odeY4B0yR97f9IhIE6vsiEkovjxL1TMihaipnC5l+hzbhGSn+x/JeGdLqiF2R
# yqLOzHfoA/e5Lq9ISj2JPsPrE47xag6KPrbP4Q8x25zHXkjqGAGNjiNTqgQVQ7dJ
# sqb58zk65IazUf40zNmvB+uy/Leq94k/HqiPgzTD+n21zt5NDU5OIMzPI3XU4+iT
# veg3v9pz/fw=
# SIG # End signature block
