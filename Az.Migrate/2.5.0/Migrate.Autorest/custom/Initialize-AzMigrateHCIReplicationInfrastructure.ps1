
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
Initializes the infrastructure for the migrate project.
.Description
The Initialize-AzMigrateHCIReplicationInfrastructure cmdlet initializes the infrastructure for the migrate project in AzStackHCI scenario.
.Link
https://learn.microsoft.com/powershell/module/az.migrate/initialize-azmigratehcireplicationinfrastructure
#>

function Initialize-AzMigrateHCIReplicationInfrastructure {
    [OutputType([System.Boolean], ParameterSetName = 'AzStackHCI')]
    [CmdletBinding(DefaultParameterSetName = 'AzStackHCI', PositionalBinding = $false, SupportsShouldProcess, ConfirmImpact = 'Medium')]
    param(
        [Parameter(Mandatory)]
        [ValidateNotNull()]
        [Microsoft.Azure.PowerShell.Cmdlets.Migrate.Category('Path')]
        [System.String]
        # Specifies the Resource Group of the Azure Migrate Project in the current subscription.
        ${ResourceGroupName},

        [Parameter(Mandatory)]
        [ValidateNotNull()]
        [Microsoft.Azure.PowerShell.Cmdlets.Migrate.Category('Path')]
        [System.String]
        # Specifies the name of the Azure Migrate project to be used for server migration.
        ${ProjectName},

        [Parameter()]
        [Microsoft.Azure.PowerShell.Cmdlets.Migrate.Category('Path')]
        [System.String]
        # Specifies the Storage Account ARM Id to be used for private endpoint scenario.
        ${CacheStorageAccountId},

        [Parameter()]
        [System.String]
        [Microsoft.Azure.PowerShell.Cmdlets.Migrate.Runtime.DefaultInfo(Script = '(Get-AzContext).Subscription.Id')]
        # Azure Subscription ID.
        ${SubscriptionId},

        [Parameter(Mandatory)]
        [Microsoft.Azure.PowerShell.Cmdlets.Migrate.Category('Path')]
        [System.String]
        # Specifies the source appliance name for the AzStackHCI scenario.
        ${SourceApplianceName},

        [Parameter(Mandatory)]
        [Microsoft.Azure.PowerShell.Cmdlets.Migrate.Category('Path')]
        [System.String]
        # Specifies the target appliance name for the AzStackHCI scenario.
        ${TargetApplianceName},

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

        [Parameter()]
        [Microsoft.Azure.PowerShell.Cmdlets.Migrate.Category('Runtime')]
        [System.Management.Automation.SwitchParameter]
        # Returns true when the command succeeds
        ${PassThru},
    
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
        Import-Module $PSScriptRoot\Helper\AzStackHCICommonSettings.ps1
        Import-Module $PSScriptRoot\Helper\CommonHelper.ps1

        CheckResourcesModuleDependency
        CheckStorageModuleDependency
        Import-Module Az.Resources
        Import-Module Az.Storage

        $context = Get-AzContext
        # Get SubscriptionId
        if ([string]::IsNullOrEmpty($SubscriptionId)) {
            Write-Host "No -SubscriptionId provided. Using the one from Get-AzContext."

            $SubscriptionId = $context.Subscription.Id
            if ([string]::IsNullOrEmpty($SubscriptionId)) {
                throw "Please login to Azure to select a subscription."
            }
        }
        Write-Host "*Selected Subscription Id: '$($SubscriptionId)'"
    
        # Get resource group
        $resourceGroup = Get-AzResourceGroup -Name $ResourceGroupName -ErrorVariable notPresent -ErrorAction SilentlyContinue
        if ($null -eq $resourceGroup) {
            throw "Resource group '$($ResourceGroupName)' does not exist in the subscription. Please create the resource group and try again."
        }
        Write-Host "*Selected Resource Group: '$($ResourceGroupName)'"

        # Verify user validity
        $userObject = Get-AzADUser -UserPrincipalName $context.Subscription.ExtendedProperties.Account

        if (-not $userObject) {
            $userObject = Get-AzADUser -Mail $context.Subscription.ExtendedProperties.Account
        }

        if (-not $userObject) {
            $mailNickname = "{0}#EXT#" -f $($context.Account.Id -replace '@', '_')

            $userObject = Get-AzADUser | 
            Where-Object { $_.MailNickname -eq $mailNickname }
        }

        if (-not $userObject) {
            if ($context.Account.Id.StartsWith("MSI@")) {
                $hostname = $env:COMPUTERNAME
                $userObject = Get-AzADServicePrincipal -DisplayName $hostname
            }
            else {
                $userObject = Get-AzADServicePrincipal -ApplicationID $context.Account.Id
            }
        }

        if (-not $userObject) {
            throw 'User Object Id Not Found!'
        }

        # Get Migrate Project
        $migrateProject = InvokeAzMigrateGetCommandWithRetries `
            -CommandName "Az.Migrate\Get-AzMigrateProject" `
            -Parameters @{"Name" = $ProjectName; "ResourceGroupName" = $ResourceGroupName} `
            -ErrorMessage "Migrate project '$($ProjectName)' not found."

        # Access Discovery Service
        $discoverySolutionName = "Servers-Discovery-ServerDiscovery"
        $discoverySolution = InvokeAzMigrateGetCommandWithRetries `
            -CommandName "Az.Migrate\Get-AzMigrateSolution" `
            -Parameters @{"SubscriptionId" = $SubscriptionId; "ResourceGroupName" = $ResourceGroupName; "MigrateProjectName" = $ProjectName; "Name" = $discoverySolutionName} `
            -ErrorMessage "Server Discovery Solution '$discoverySolutionName' not found."

        # Get Appliances Mapping
        $appMap = @{}
        if ($null -ne $discoverySolution.DetailExtendedDetail["applianceNameToSiteIdMapV2"]) {
            $appMapV2 = $discoverySolution.DetailExtendedDetail["applianceNameToSiteIdMapV2"] | ConvertFrom-Json
            # Fetch all appliance from V2 map first. Then these can be updated if found again in V3 map.
            foreach ($item in $appMapV2) {
                $appMap[$item.ApplianceName.ToLower()] = $item.SiteId
            }
        }
    
        if ($null -ne $discoverySolution.DetailExtendedDetail["applianceNameToSiteIdMapV3"]) {
            $appMapV3 = $discoverySolution.DetailExtendedDetail["applianceNameToSiteIdMapV3"] | ConvertFrom-Json
            foreach ($item in $appMapV3) {
                $t = $item.psobject.properties
                $appMap[$t.Name.ToLower()] = $t.Value.SiteId
            }
        }

        if ($null -eq $discoverySolution.DetailExtendedDetail["applianceNameToSiteIdMapV2"] -And
            $null -eq $discoverySolution.DetailExtendedDetail["applianceNameToSiteIdMapV3"] ) {
            throw "Server Discovery Solution missing Appliance Details. Invalid Solution."           
        }

        $hyperVSiteTypeRegex = "(?<=/Microsoft.OffAzure/HyperVSites/).*$"
        $vmwareSiteTypeRegex = "(?<=/Microsoft.OffAzure/VMwareSites/).*$"

        # Validate SourceApplianceName & TargetApplianceName
        $sourceSiteId = $appMap[$SourceApplianceName.ToLower()]
        $targetSiteId = $appMap[$TargetApplianceName.ToLower()]
        if ($sourceSiteId -match $hyperVSiteTypeRegex -and $targetSiteId -match $hyperVSiteTypeRegex) {
            $instanceType = $AzStackHCIInstanceTypes.HyperVToAzStackHCI
        }
        elseif ($sourceSiteId -match $vmwareSiteTypeRegex -and $targetSiteId -match $hyperVSiteTypeRegex) {
            $instanceType = $AzStackHCIInstanceTypes.VMwareToAzStackHCI
        }
        else {
            throw "Error encountered in matching the given source appliance name '$SourceApplianceName' and target appliance name '$TargetApplianceName'. Please verify the VM site type to be either for HyperV or VMware for both source and target appliances, and the appliance names are correct."
        }

        # Get Data Replication Service, or the AMH solution
        $amhSolutionName = "Servers-Migration-ServerMigration_DataReplication"
        $amhSolution = InvokeAzMigrateGetCommandWithRetries `
            -CommandName "Az.Migrate\Get-AzMigrateSolution" `
            -Parameters @{"SubscriptionId" = $SubscriptionId; "ResourceGroupName" = $ResourceGroupName; "MigrateProjectName" = $ProjectName; "Name" = $amhSolutionName} `
            -ErrorMessage "No Data Replication Service Solution '$amhSolutionName' found. Please verify your appliance setup."

        # Get Source and Target Fabrics
        $allFabrics = Az.Migrate\Get-AzMigrateHCIReplicationFabric -ResourceGroupName $ResourceGroupName
        foreach ($fabric in $allFabrics) {
            if ($fabric.Property.CustomProperty.MigrationSolutionId -ne $amhSolution.Id) {
                continue
            }

            if (($instanceType -eq $AzStackHCIInstanceTypes.HyperVToAzStackHCI) -and
                ($fabric.Property.CustomProperty.InstanceType -ceq $FabricInstanceTypes.HyperVInstance)) {
                $sourceFabric = $fabric
            }
            elseif (($instanceType -eq $AzStackHCIInstanceTypes.VMwareToAzStackHCI) -and
                ($fabric.Property.CustomProperty.InstanceType -ceq $FabricInstanceTypes.VMwareInstance)) {
                $sourceFabric = $fabric
            }
            elseif ($fabric.Property.CustomProperty.InstanceType -ceq $FabricInstanceTypes.AzStackHCIInstance) {
                $targetFabric = $fabric
            }

            if (($null -ne $sourceFabric) -and ($null -ne $targetFabric)) {
                break
            }
        }

        if ($null -eq $sourceFabric) {
            throw "No source Fabric found. Please verify your appliance setup."
        }
        Write-Host "*Selected Source Fabric: '$($sourceFabric.Name)'"

        if ($null -eq $targetFabric) {
            throw "No target Fabric found. Please verify your appliance setup."
        }
        Write-Host "*Selected Target Fabric: '$($targetFabric.Name)'"

        # Get Source and Target Dras from Fabrics
        $sourceDras = InvokeAzMigrateGetCommandWithRetries `
            -CommandName "Az.Migrate.Internal\Get-AzMigrateDra" `
            -Parameters @{"FabricName" = $sourceFabric.Name; "ResourceGroupName" = $ResourceGroupName} `
            -ErrorMessage "No source Fabric Agent (DRA) found. Please verify your appliance setup."

        $sourceDra = $sourceDras[0]
        Write-Host "*Selected Source Dra: '$($sourceDra.Name)'"

        $targetDras = InvokeAzMigrateGetCommandWithRetries `
            -CommandName "Az.Migrate.Internal\Get-AzMigrateDra" `
            -Parameters @{"FabricName" = $targetFabric.Name; "ResourceGroupName" = $ResourceGroupName} `
            -ErrorMessage "No target Fabric Agent (DRA) found. Please verify your appliance setup."

        $targetDra = $targetDras[0]
        Write-Host "*Selected Target Dra: '$($targetDra.Name)'"
        
        # Get Replication Vault
        $replicationVaultName = $amhSolution.DetailExtendedDetail["vaultId"].Split("/")[8]
        $replicationVault = InvokeAzMigrateGetCommandWithRetries `
            -CommandName "Az.Migrate.Internal\Get-AzMigrateVault" `
            -Parameters @{"ResourceGroupName" = $ResourceGroupName; "Name" = $replicationVaultName} `
            -ErrorMessage "No Replication Vault '$replicationVaultName' found in Resource Group '$ResourceGroupName'."

        # Put Policy
        $policyName = $replicationVault.Name + $instanceType + "policy"
        $policy = Az.Migrate.Internal\Get-AzMigratePolicy `
            -ResourceGroupName $ResourceGroupName `
            -Name $policyName `
            -VaultName $replicationVault.Name `
            -SubscriptionId $SubscriptionId `
            -ErrorVariable notPresent `
            -ErrorAction SilentlyContinue
        
        # Default policy is found
        if ($null -ne $policy) {
            # Give time for create/update to reach a terminal state. Timeout after 10min
            if ($policy.Property.ProvisioningState -eq [ProvisioningState]::Creating -or
                $policy.Property.ProvisioningState -eq [ProvisioningState]::Updating) {
                Write-Host "Policy '$($policyName)' found in Provisioning State '$($policy.Property.ProvisioningState)'."

                for ($i = 0; $i -lt 20; $i++) {
                    Start-Sleep -Seconds 30
                    $policy = Az.Migrate.Internal\Get-AzMigratePolicy -InputObject $policy

                    if (-not (
                            $policy.Property.ProvisioningState -eq [ProvisioningState]::Creating -or
                            $policy.Property.ProvisioningState -eq [ProvisioningState]::Updating)) {
                        break
                    }
                }

                # Make sure Policy is no longer in Creating or Updating state
                if ($policy.Property.ProvisioningState -eq [ProvisioningState]::Creating -or
                    $policy.Property.ProvisioningState -eq [ProvisioningState]::Updating) {
                    throw "Policy '$($policyName)' times out with Provisioning State: '$($policy.Property.ProvisioningState)'. Please re-run this command or contact support if help needed."
                }
            }

            # Check and remove if policy is in a bad terminal state
            if ($policy.Property.ProvisioningState -eq [ProvisioningState]::Canceled -or
                $policy.Property.ProvisioningState -eq [ProvisioningState]::Failed) {
                Write-Host "Policy '$($policyName)' found but in an unusable terminal Provisioning State '$($policy.Property.ProvisioningState)'.`nRemoving policy..."
                    
                # Remove policy
                try {
                    Az.Migrate.Internal\Remove-AzMigratePolicy -InputObject $policy | Out-Null
                }
                catch {
                    if ($_.Exception.Message -notmatch "Status: OK") {
                        throw $_.Exception.Message
                    }
                }

                Start-Sleep -Seconds 30
                $policy = Az.Migrate.Internal\Get-AzMigratePolicy `
                    -InputObject $policy `
                    -ErrorVariable notPresent `
                    -ErrorAction SilentlyContinue

                # Make sure Policy is no longer in Canceled or Failed state
                if ($null -ne $policy -and
                    ($policy.Property.ProvisioningState -eq [ProvisioningState]::Canceled -or
                    $policy.Property.ProvisioningState -eq [ProvisioningState]::Failed)) {
                    throw "Failed to change the Provisioning State of policy '$($policyName)'by removing. Please re-run this command or contact support if help needed."
                }
            }

            # Give time to remove policy. Timeout after 10min
            if ($null -eq $policy -and $policy.Property.ProvisioningState -eq [ProvisioningState]::Deleting) {
                Write-Host "Policy '$($policyName)' found in Provisioning State '$($policy.Property.ProvisioningState)'."

                for ($i = 0; $i -lt 20; $i++) {
                    Start-Sleep -Seconds 30
                    $policy = Az.Migrate.Internal\Get-AzMigratePolicy `
                        -InputObject $policy `
                        -ErrorVariable notPresent `
                        -ErrorAction SilentlyContinue
                    
                    if ($null -eq $policy -or $policy.Property.ProvisioningState -eq [ProvisioningState]::Deleted) {
                        break
                    }
                    elseif ($policy.Property.ProvisioningState -eq [ProvisioningState]::Deleting) {
                        continue
                    }

                    throw "Policy '$($policyName)' has an unexpected Provisioning State of '$($policy.Property.ProvisioningState)' during removal process. Please re-run this command or contact support if help needed."
                }

                # Make sure Policy is no longer in Deleting state
                if ($null -ne $policy -and $policy.Property.ProvisioningState -eq [ProvisioningState]::Deleting) {
                    throw "Policy '$($policyName)' times out with Provisioning State: '$($policy.Property.ProvisioningState)'. Please re-run this command or contact support if help needed."
                }
            }

            # Indicate policy was removed
            if ($null -eq $policy -or $policy.Property.ProvisioningState -eq [ProvisioningState]::Deleted) {
                Write-Host "Policy '$($policyName)' was removed."
            }
        }

        # Refresh local policy object if exists
        if ($null -ne $policy) {
            $policy = Az.Migrate.Internal\Get-AzMigratePolicy -InputObject $policy
        }

        # Create policy if not found or previously deleted
        if ($null -eq $policy -or $policy.Property.ProvisioningState -eq [ProvisioningState]::Deleted) {
            Write-Host "Creating Policy..."

            $params = @{
                InstanceType                     = $instanceType;
                RecoveryPointHistoryInMinute     = $ReplicationDetails.PolicyDetails.DefaultRecoveryPointHistoryInMinutes;
                CrashConsistentFrequencyInMinute = $ReplicationDetails.PolicyDetails.DefaultCrashConsistentFrequencyInMinutes;
                AppConsistentFrequencyInMinute   = $ReplicationDetails.PolicyDetails.DefaultAppConsistentFrequencyInMinutes;
            }

            # Setup Policy deployment parameters
            $policyProperties = [Microsoft.Azure.PowerShell.Cmdlets.Migrate.Models.Api20210216Preview.PolicyModelProperties]::new()
            if ($instanceType -eq $AzStackHCIInstanceTypes.HyperVToAzStackHCI) {
                $policyCustomProperties = [Microsoft.Azure.PowerShell.Cmdlets.Migrate.Models.Api20210216Preview.HyperVToAzStackHcipolicyModelCustomProperties]::new()
            }
            elseif ($instanceType -eq $AzStackHCIInstanceTypes.VMwareToAzStackHCI) {
                $policyCustomProperties = [Microsoft.Azure.PowerShell.Cmdlets.Migrate.Models.Api20210216Preview.VMwareToAzStackHcipolicyModelCustomProperties]::new()
            }
            else {
                throw "Instance type '$($instanceType)' is not supported. Currently, for AzStackHCI scenario, only HyperV and VMware as the source is supported."
            }
            $policyCustomProperties.InstanceType = $params.InstanceType
            $policyCustomProperties.RecoveryPointHistoryInMinute = $params.RecoveryPointHistoryInMinute
            $policyCustomProperties.CrashConsistentFrequencyInMinute = $params.CrashConsistentFrequencyInMinute
            $policyCustomProperties.AppConsistentFrequencyInMinute = $params.AppConsistentFrequencyInMinute
            $policyProperties.CustomProperty = $policyCustomProperties
        
            try {
                Az.Migrate.Internal\New-AzMigratePolicy `
                    -Name $policyName `
                    -ResourceGroupName $ResourceGroupName `
                    -VaultName $replicationVaultName `
                    -Property $policyProperties `
                    -SubscriptionId $SubscriptionId `
                    -NoWait | Out-Null
            }
            catch {
                if ($_.Exception.Message -notmatch "Status: OK") {
                    throw $_.Exception.Message
                }
            }

            # Check Policy creation status every 30s. Timeout after 10min
            for ($i = 0; $i -lt 20; $i++) {
                Start-Sleep -Seconds 30
                $policy = Az.Migrate.Internal\Get-AzMigratePolicy `
                    -ResourceGroupName $ResourceGroupName `
                    -Name $policyName `
                    -VaultName $replicationVault.Name `
                    -SubscriptionId $SubscriptionId `
                    -ErrorVariable notPresent `
                    -ErrorAction SilentlyContinue
                if ($null -eq $policy) {
                    throw "Unexpected error occurred during policy creation. Please re-run this command or contact support if help needed."
                }
                
                # Stop if policy reaches a terminal state
                if ($policy.Property.ProvisioningState -eq [ProvisioningState]::Succeeded -or
                    $policy.Property.ProvisioningState -eq [ProvisioningState]::Deleted -or
                    $policy.Property.ProvisioningState -eq [ProvisioningState]::Canceled -or
                    $policy.Property.ProvisioningState -eq [ProvisioningState]::Failed) {
                    break
                }
            }

            # Make sure Policy is in a terminal state
            if (-not (
                    $policy.Property.ProvisioningState -eq [ProvisioningState]::Succeeded -or
                    $policy.Property.ProvisioningState -eq [ProvisioningState]::Deleted -or
                    $policy.Property.ProvisioningState -eq [ProvisioningState]::Canceled -or
                    $policy.Property.ProvisioningState -eq [ProvisioningState]::Failed)) {
                throw "Policy '$($policyName)' times out with Provisioning State: '$($policy.Property.ProvisioningState)' during creation process. Please re-run this command or contact support if help needed."
            }
        }
        
        if ($policy.Property.ProvisioningState -ne [ProvisioningState]::Succeeded) {
            throw "Policy '$($policyName)' has an unexpected Provisioning State of '$($policy.Property.ProvisioningState)'. Please re-run this command or contact support if help needed."
        }

        $policy = Az.Migrate.Internal\Get-AzMigratePolicy `
            -ResourceGroupName $ResourceGroupName `
            -Name $policyName `
            -VaultName $replicationVault.Name `
            -SubscriptionId $SubscriptionId `
            -ErrorVariable notPresent `
            -ErrorAction SilentlyContinue
        if ($null -eq $policy) {
            throw "Unexpected error occurred during policy creation. Please re-run this command or contact support if help needed."
        }
        elseif ($policy.Property.ProvisioningState -ne [ProvisioningState]::Succeeded) {
            throw "Policy '$($policyName)' has an unexpected Provisioning State of '$($policy.Property.ProvisioningState)'. Please re-run this command or contact support if help needed."
        }
        else {
            Write-Host "*Selected Policy: '$($policyName)'"
        }

        # Put Cache Storage Account
        $amhSolution = Az.Migrate\Get-AzMigrateSolution `
            -ResourceGroupName $ResourceGroupName `
            -MigrateProjectName $ProjectName `
            -Name "Servers-Migration-ServerMigration_DataReplication" `
            -SubscriptionId $SubscriptionId `
            -ErrorVariable notPresent `
            -ErrorAction SilentlyContinue
        if ($null -eq $amhSolution) {
            throw "No Data Replication Service Solution found. Please verify your appliance setup."
        }

        $amhStoredStorageAccountId = $amhSolution.DetailExtendedDetail["replicationStorageAccountId"]
        
        # Record of rsa found in AMH solution
        if (![string]::IsNullOrEmpty($amhStoredStorageAccountId)) {
            $amhStoredStorageAccountName = $amhStoredStorageAccountId.Split("/")[8]
            $amhStoredStorageAccount = Get-AzStorageAccount `
                -ResourceGroupName $ResourceGroupName `
                -Name $amhStoredStorageAccountName `
                -ErrorVariable notPresent `
                -ErrorAction SilentlyContinue

            # Wait for amhStoredStorageAccount to reach a terminal state
            if ($null -ne $amhStoredStorageAccount -and
                $null -ne $amhStoredStorageAccount.ProvisioningState -and
                $amhStoredStorageAccount.ProvisioningState -ne [StorageAccountProvisioningState]::Succeeded) {
                # Check rsa state every 30s if not Succeeded already. Timeout after 10min
                for ($i = 0; $i -lt 20; $i++) {
                    Start-Sleep -Seconds 30
                    $amhStoredStorageAccount = Get-AzStorageAccount `
                        -ResourceGroupName $ResourceGroupName `
                        -Name $amhStoredStorageAccountName `
                        -ErrorVariable notPresent `
                        -ErrorAction SilentlyContinue
                        # Stop if amhStoredStorageAccount is not found or in a terminal state
                    if ($null -eq $amhStoredStorageAccount -or
                        $null -eq $amhStoredStorageAccount.ProvisioningState -or
                        $amhStoredStorageAccount.ProvisioningState -eq [StorageAccountProvisioningState]::Succeeded) {
                        break
                    }
                }
            }
            
            # amhStoredStorageAccount exists and in Succeeded state
            if ($null -ne $amhStoredStorageAccount -and
                $amhStoredStorageAccount.ProvisioningState -eq [StorageAccountProvisioningState]::Succeeded) {
                # Use amhStoredStorageAccount and ignore user provided Cache Storage Account Id
                if (![string]::IsNullOrEmpty($CacheStorageAccountId) -and $amhStoredStorageAccount.Id -ne $CacheStorageAccountId) {
                    Write-Host "A Cache Storage Account '$($amhStoredStorageAccountName)' has been linked already. The given -CacheStorageAccountId '$($CacheStorageAccountId)' will be ignored."
                }

                $cacheStorageAccount = $amhStoredStorageAccount
            }
            elseif ($null -eq $amhStoredStorageAccount -or $null -eq $amhStoredStorageAccount.ProvisioningState) {
                # amhStoredStorageAccount is found but in a bad state, so log to ask user to remove
                if ($null -ne $amhStoredStorageAccount -and $null -eq $amhStoredStorageAccount.ProvisioningState) {
                    Write-Host "A previously linked Cache Storage Account with Id '$($amhStoredStorageAccountId)' is found but in a unusable state. Please remove it manually and re-run this command."
                }

                # amhStoredStorageAccount is not found or in a bad state but AMH has a record of it, so remove the record
                if ($amhSolution.DetailExtendedDetail.ContainsKey("replicationStorageAccountId")) {
                    $amhSolution.DetailExtendedDetail.Remove("replicationStorageAccountId") | Out-Null
                    $amhSolution.DetailExtendedDetail.Add("replicationStorageAccountId", $null) | Out-Null
                    Az.Migrate.Internal\Set-AzMigrateSolution `
                        -MigrateProjectName $ProjectName `
                        -Name $amhSolution.Name `
                        -ResourceGroupName $ResourceGroupName `
                        -DetailExtendedDetail $amhSolution.DetailExtendedDetail.AdditionalProperties | Out-Null
                }
            }
            else {
                throw "A linked Cache Storage Account with Id '$($amhStoredStorageAccountId)' times out with Provisioning State: '$($amhStoredStorageAccount.ProvisioningState)'. Please re-run this command or contact support if help needed."
            }

            $amhSolution = Az.Migrate\Get-AzMigrateSolution `
                -ResourceGroupName $ResourceGroupName `
                -MigrateProjectName $ProjectName `
                -Name "Servers-Migration-ServerMigration_DataReplication" `
                -SubscriptionId $SubscriptionId `
                -ErrorVariable notPresent `
                -ErrorAction SilentlyContinue
                # Check if AMH record is removed
            if (($null -eq $amhStoredStorageAccount -or $null -eq $amhStoredStorageAccount.ProvisioningState) -and
                ![string]::IsNullOrEmpty($amhSolution.DetailExtendedDetail["replicationStorageAccountId"])) {
                throw "Unexpected error occurred in unlinking Cache Storage Account with Id '$($amhSolution.DetailExtendedDetail["replicationStorageAccountId"])'. Please re-run this command or contact support if help needed."
            }
        }

        # No linked Cache Storage Account found in AMH solution but user provides a Cache Storage Account Id
        if ($null -eq $cacheStorageAccount -and ![string]::IsNullOrEmpty($CacheStorageAccountId)) {
            $userProvidedStorageAccountIdSegs = $CacheStorageAccountId.Split("/")
            if ($userProvidedStorageAccountIdSegs.Count -ne 9) {
                throw "Invalid Cache Storage Account Id '$($CacheStorageAccountId)' provided. Please provide a valid one."
            }

            $userProvidedStorageAccountName = ($userProvidedStorageAccountIdSegs[8]).ToLower()

            # Check if user provided Cache Storage Account exists
            $userProvidedStorageAccount = Get-AzStorageAccount `
                -ResourceGroupName $ResourceGroupName `
                -Name $userProvidedStorageAccountName `
                -ErrorVariable notPresent `
                -ErrorAction SilentlyContinue

            # Wait for userProvidedStorageAccount to reach a terminal state
            if ($null -ne $userProvidedStorageAccount -and
                $null -ne $userProvidedStorageAccount.ProvisioningState -and
                $userProvidedStorageAccount.ProvisioningState -ne [StorageAccountProvisioningState]::Succeeded) {
                # Check rsa state every 30s if not Succeeded already. Timeout after 10min
                for ($i = 0; $i -lt 20; $i++) {
                    Start-Sleep -Seconds 30
                    $userProvidedStorageAccount = Get-AzStorageAccount `
                        -ResourceGroupName $ResourceGroupName `
                        -Name $userProvidedStorageAccountName `
                        -ErrorVariable notPresent `
                        -ErrorAction SilentlyContinue
                    # Stop if userProvidedStorageAccount is not found or in a terminal state
                    if ($null -eq $userProvidedStorageAccount -or
                        $null -eq $userProvidedStorageAccount.ProvisioningState -or
                        $userProvidedStorageAccount.ProvisioningState -eq [StorageAccountProvisioningState]::Succeeded) {
                        break
                    }
                }
            }

            if ($null -ne $userProvidedStorageAccount -and
                $userProvidedStorageAccount.ProvisioningState -eq [StorageAccountProvisioningState]::Succeeded) {
                $cacheStorageAccount = $userProvidedStorageAccount
            }
            elseif ($null -eq $userProvidedStorageAccount) {
                throw "Cache Storage Account with Id '$($CacheStorageAccountId)' is not found. Please re-run this command without -CacheStorageAccountId to create one automatically or re-create the Cache Storage Account yourself and try again."
            }
            elseif ($null -eq $userProvidedStorageAccount.ProvisioningState) {
                throw "Cache Storage Account with Id '$($CacheStorageAccountId)' is found but in an unusable state. Please re-run this command without -CacheStorageAccountId to create one automatically or re-create the Cache Storage Account yourself and try again."
            }
            else {
                throw "Cache Storage Account with Id '$($CacheStorageAccountId)' is found but times out with Provisioning State: '$($userProvidedStorageAccount.ProvisioningState)'. Please re-run this command or contact support if help needed."
            }
        }

        # No Cache Storage Account found or provided, so create one
        if ($null -eq $cacheStorageAccount) {
            $suffix = (GenerateHashForArtifact -Artifact "$($sourceSiteId)/$($SourceApplianceName)").ToString()
            if ($suffixHash.Length -gt 14) {
                $suffix = $suffixHash.Substring(0, 14)
            }
            $cacheStorageAccountName = "migratersa" + $suffix
            $cacheStorageAccountId = "/subscriptions/$($SubscriptionId)/resourceGroups/$($ResourceGroupName)/providers/Microsoft.Storage/storageAccounts/$($cacheStorageAccountName)"

            # Check if default Cache Storage Account already exists, which it shoudln't
            $cacheStorageAccount = Get-AzStorageAccount `
                -ResourceGroupName $ResourceGroupName `
                -Name $cacheStorageAccountName `
                -ErrorVariable notPresent `
                -ErrorAction SilentlyContinue
            if ($null -ne $cacheStorageAccount) {
                throw "Unexpected error encountered: Cache Storage Account '$($cacheStorageAccountName)' already exists. Please re-run this command to create a different one or contact support if help needed."
            }

            Write-Host "Creating Cache Storage Account with default name '$($cacheStorageAccountName)'..."

            $params = @{
                name                                = $cacheStorageAccountName;
                location                            = $migrateProject.Location;
                migrateProjectName                  = $migrateProject.Name;
                skuName                             = "Standard_LRS";
                tags                                = @{ "Migrate Project" = $migrateProject.Name };
                kind                                = "StorageV2";
                encryption                          = @{ services = @{blob = @{ enabled = $true }; file = @{ enabled = $true } } };
            }

            # Create Cache Storage Account
            $cacheStorageAccount = New-AzStorageAccount `
                -ResourceGroupName $ResourceGroupName `
                -Name $params.name `
                -SkuName $params.skuName `
                -Location $params.location `
                -Kind $params.kind `
                -Tags $params.tags `
                -AllowBlobPublicAccess $true

            if ($null -ne $cacheStorageAccount -and
                $null -ne $cacheStorageAccount.ProvisioningState -and
                $cacheStorageAccount.ProvisioningState -ne [StorageAccountProvisioningState]::Succeeded) {
                # Check rsa state every 30s if not Succeeded already. Timeout after 10min
                for ($i = 0; $i -lt 20; $i++) {
                    Start-Sleep -Seconds 30
                    $cacheStorageAccount = Get-AzStorageAccount `
                        -ResourceGroupName $ResourceGroupName `
                        -Name $params.name `
                        -ErrorVariable notPresent `
                        -ErrorAction SilentlyContinue
                    # Stop if cacheStorageAccount is not found or in a terminal state
                    if ($null -eq $cacheStorageAccount -or
                        $null -eq $cacheStorageAccount.ProvisioningState -or
                        $cacheStorageAccount.ProvisioningState -eq [StorageAccountProvisioningState]::Succeeded) {
                        break
                    }
                }
            }

            if ($null -eq $cacheStorageAccount -or $null -eq $cacheStorageAccount.ProvisioningState) {
                throw "Unexpected error occurs during Cache Storgae Account creation process. Please re-run this command or provide -CacheStorageAccountId of the one created own your own."
            }
            elseif ($cacheStorageAccount.ProvisioningState -ne [StorageAccountProvisioningState]::Succeeded) {
                throw "Cache Storage Account with Id '$($cacheStorageAccount.Id)' times out with Provisioning State: '$($cacheStorageAccount.ProvisioningState)' during creation process. Please remove it manually and re-run this command or contact support if help needed."
            }
        }

        # Sanity check
        if ($null -eq $cacheStorageAccount -or
            $null -eq $cacheStorageAccount.ProvisioningState -or
            $cacheStorageAccount.ProvisioningState -ne [StorageAccountProvisioningState]::Succeeded) {
            throw "Unexpected error occurs during Cache Storgae Account selection process. Please re-run this command or contact support if help needed."
        }

        $params = @{
            contributorRoleDefId                = [System.Guid]::parse($RoleDefinitionIds.ContributorId);
            storageBlobDataContributorRoleDefId = [System.Guid]::parse($RoleDefinitionIds.StorageBlobDataContributorId);
            sourceAppAadId                      = $sourceDra.ResourceAccessIdentityObjectId;
            targetAppAadId                      = $targetDra.ResourceAccessIdentityObjectId;
        }

        # Grant Source Dra AAD App access to Cache Storage Account as "Contributor"
        $hasAadAppAccess = Get-AzRoleAssignment `
            -ObjectId $params.sourceAppAadId `
            -RoleDefinitionId $params.contributorRoleDefId `
            -Scope $cacheStorageAccount.Id `
            -ErrorVariable notPresent `
            -ErrorAction SilentlyContinue
        if ($null -eq $hasAadAppAccess) {
            New-AzRoleAssignment `
                -ObjectId $params.sourceAppAadId `
                -RoleDefinitionId $params.contributorRoleDefId `
                -Scope $cacheStorageAccount.Id | Out-Null
        }

        # Grant Source Dra AAD App access to Cache Storage Account as "StorageBlobDataContributor"
        $hasAadAppAccess = Get-AzRoleAssignment `
            -ObjectId $params.sourceAppAadId `
            -RoleDefinitionId $params.storageBlobDataContributorRoleDefId `
            -Scope $cacheStorageAccount.Id `
            -ErrorVariable notPresent `
            -ErrorAction SilentlyContinue
        if ($null -eq $hasAadAppAccess) {
            New-AzRoleAssignment `
                -ObjectId $params.sourceAppAadId `
                -RoleDefinitionId $params.storageBlobDataContributorRoleDefId `
                -Scope $cacheStorageAccount.Id | Out-Null
        }

        # Grant Target Dra AAD App access to Cache Storage Account as "Contributor"
        $hasAadAppAccess = Get-AzRoleAssignment `
            -ObjectId $params.targetAppAadId `
            -RoleDefinitionId $params.contributorRoleDefId `
            -Scope $cacheStorageAccount.Id `
            -ErrorVariable notPresent `
            -ErrorAction SilentlyContinue
        if ($null -eq $hasAadAppAccess) {
            New-AzRoleAssignment `
                -ObjectId $params.targetAppAadId `
                -RoleDefinitionId $params.contributorRoleDefId `
                -Scope $cacheStorageAccount.Id | Out-Null
        }

        # Grant Target Dra AAD App access to Cache Storage Account as "StorageBlobDataContributor"
        $hasAadAppAccess = Get-AzRoleAssignment `
            -ObjectId $params.targetAppAadId `
            -RoleDefinitionId $params.storageBlobDataContributorRoleDefId `
            -Scope $cacheStorageAccount.Id `
            -ErrorVariable notPresent `
            -ErrorAction SilentlyContinue
        if ($null -eq $hasAadAppAccess) {
            New-AzRoleAssignment `
                -ObjectId $params.targetAppAadId `
                -RoleDefinitionId $params.storageBlobDataContributorRoleDefId `
                -Scope $cacheStorageAccount.Id | Out-Null
        }

        # Give time for role assignments to be created. Times out after 2min
        $rsaPermissionGranted = $false
        for ($i = 0; $i -lt 3; $i++) {
            # Check Source Dra AAD App access to Cache Storage Account as "Contributor"
            $hasAadAppAccess = Get-AzRoleAssignment `
                -ObjectId $params.sourceAppAadId `
                -RoleDefinitionId $params.contributorRoleDefId `
                -Scope $cacheStorageAccount.Id `
                -ErrorVariable notPresent `
                -ErrorAction SilentlyContinue
            $rsaPermissionGranted = $null -ne $hasAadAppAccess

            # Check Source Dra AAD App access to Cache Storage Account as "StorageBlobDataContributor"
            $hasAadAppAccess = Get-AzRoleAssignment `
                -ObjectId $params.sourceAppAadId `
                -RoleDefinitionId $params.storageBlobDataContributorRoleDefId `
                -Scope $cacheStorageAccount.Id `
                -ErrorVariable notPresent `
                -ErrorAction SilentlyContinue
            $rsaPermissionGranted = $rsaPermissionGranted -and ($null -ne $hasAadAppAccess)

            # Check Target Dra AAD App access to Cache Storage Account as "Contributor"
            $hasAadAppAccess = Get-AzRoleAssignment `
                -ObjectId $params.targetAppAadId `
                -RoleDefinitionId $params.contributorRoleDefId `
                -Scope $cacheStorageAccount.Id `
                -ErrorVariable notPresent `
                -ErrorAction SilentlyContinue
            $rsaPermissionGranted = $rsaPermissionGranted -and ($null -ne $hasAadAppAccess)

            # Check Target Dra AAD App access to Cache Storage Account as "StorageBlobDataContributor"
            $hasAadAppAccess = Get-AzRoleAssignment `
                -ObjectId $params.targetAppAadId `
                -RoleDefinitionId $params.storageBlobDataContributorRoleDefId `
                -Scope $cacheStorageAccount.Id `
                -ErrorVariable notPresent `
                -ErrorAction SilentlyContinue
            $rsaPermissionGranted = $rsaPermissionGranted -and ($null -ne $hasAadAppAccess)

            if ($rsaPermissionGranted) {
                break
            }

            Start-Sleep -Seconds 30
        }

        if (!$rsaPermissionGranted) {
            throw "Failed to grant Cache Storage Account permissions. Please re-run this command or contact support if help needed."
        }

        $amhSolution = Az.Migrate\Get-AzMigrateSolution `
            -ResourceGroupName $ResourceGroupName `
            -MigrateProjectName $ProjectName `
            -Name "Servers-Migration-ServerMigration_DataReplication" `
            -SubscriptionId $SubscriptionId
        if ($amhSolution.DetailExtendedDetail.ContainsKey("replicationStorageAccountId")) {
            $amhStoredStorageAccountId = $amhSolution.DetailExtendedDetail["replicationStorageAccountId"]
            if ([string]::IsNullOrEmpty($amhStoredStorageAccountId)) {
                # Remove "replicationStorageAccountId" key
                $amhSolution.DetailExtendedDetail.Remove("replicationStorageAccountId")  | Out-Null
            }
            elseif ($amhStoredStorageAccountId -ne $cacheStorageAccount.Id) {
                # Record of rsa mismatch
                throw "Unexpected error occurred in linking Cache Storage Account with Id '$($cacheStorageAccount.Id)'. Please re-run this command or contact support if help needed."
            }
        }

        # Update AMH record with chosen Cache Storage Account
        if (!$amhSolution.DetailExtendedDetail.ContainsKey("replicationStorageAccountId")) {
            $amhSolution.DetailExtendedDetail.Add("replicationStorageAccountId", $cacheStorageAccount.Id)
            Az.Migrate.Internal\Set-AzMigrateSolution `
                -MigrateProjectName $ProjectName `
                -Name $amhSolution.Name `
                -ResourceGroupName $ResourceGroupName `
                -DetailExtendedDetail $amhSolution.DetailExtendedDetail.AdditionalProperties | Out-Null
        }

        Write-Host "*Selected Cache Storage Account: '$($cacheStorageAccount.StorageAccountName)' in Resource Group '$($ResourceGroupName)' at Location '$($cacheStorageAccount.Location)' for Migrate Project '$($migrateProject.Name)'"

        # Put replication extension
        $replicationExtensionName = ($sourceFabric.Id -split '/')[-1] + "-" + ($targetFabric.Id -split '/')[-1] + "-MigReplicationExtn"
        $replicationExtension = Az.Migrate.Internal\Get-AzMigrateReplicationExtension `
            -ResourceGroupName $ResourceGroupName `
            -Name $replicationExtensionName `
            -VaultName $replicationVaultName `
            -SubscriptionId $SubscriptionId `
            -ErrorVariable notPresent `
            -ErrorAction SilentlyContinue

        # Remove replication extension if does not match the selected Cache Storage Account
        if ($null -ne $replicationExtension -and $replicationExtension.Property.CustomProperty.StorageAccountId -ne $cacheStorageAccount.Id) {
            Write-Host "Replication Extension '$($replicationExtensionName)' found but linked to a different Cache Storage Account '$($replicationExtension.Property.CustomProperty.StorageAccountId)'."
        
            try {
                Az.Migrate.Internal\Remove-AzMigrateReplicationExtension -InputObject $replicationExtension | Out-Null
            }
            catch {
                if ($_.Exception.Message -notmatch "Status: OK") {
                    throw $_.Exception.Message
                }
            }

            Write-Host "Removing Replication Extension and waiting for 2 minutes..."
            Start-Sleep -Seconds 120
            $replicationExtension = Az.Migrate.Internal\Get-AzMigrateReplicationExtension `
                -InputObject $replicationExtension `
                -ErrorVariable notPresent `
                -ErrorAction SilentlyContinue

            if ($null -eq $replicationExtension) {
                Write-Host "Replication Extension '$($replicationExtensionName)' was removed."
            }
        }

        # Replication extension exists
        if ($null -ne $replicationExtension) {
            # Give time for create/update to reach a terminal state. Timeout after 10min
            if ($replicationExtension.Property.ProvisioningState -eq [ProvisioningState]::Creating -or
                $replicationExtension.Property.ProvisioningState -eq [ProvisioningState]::Updating) {
                Write-Host "Replication Extension '$($replicationExtensionName)' found in Provisioning State '$($replicationExtension.Property.ProvisioningState)'."

                for ($i = 0; $i -lt 20; $i++) {
                    Start-Sleep -Seconds 30
                    $replicationExtension = Az.Migrate.Internal\Get-AzMigrateReplicationExtension `
                        -InputObject $replicationExtension `
                        -ErrorVariable notPresent `
                        -ErrorAction SilentlyContinue

                    if (-not (
                            $replicationExtension.Property.ProvisioningState -eq [ProvisioningState]::Creating -or
                            $replicationExtension.Property.ProvisioningState -eq [ProvisioningState]::Updating)) {
                        break
                    }
                }

                # Make sure replication extension is no longer in Creating or Updating state
                if ($replicationExtension.Property.ProvisioningState -eq [ProvisioningState]::Creating -or
                    $replicationExtension.Property.ProvisioningState -eq [ProvisioningState]::Updating) {
                    throw "Replication Extension '$($replicationExtensionName)' times out with Provisioning State: '$($replicationExtension.Property.ProvisioningState)'. Please re-run this command or contact support if help needed."
                }
            }

            # Check and remove if replication extension is in a bad terminal state
            if ($replicationExtension.Property.ProvisioningState -eq [ProvisioningState]::Canceled -or
                $replicationExtension.Property.ProvisioningState -eq [ProvisioningState]::Failed) {
                Write-Host "Replication Extension '$($replicationExtensionName)' found but in an unusable terminal Provisioning State '$($replicationExtension.Property.ProvisioningState)'.`nRemoving Replication Extension..."
                    
                # Remove replication extension
                try {
                    Az.Migrate.Internal\Remove-AzMigrateReplicationExtension -InputObject $replicationExtension | Out-Null
                }
                catch {
                    if ($_.Exception.Message -notmatch "Status: OK") {
                        throw $_.Exception.Message
                    }
                }

                Start-Sleep -Seconds 30
                $replicationExtension = Az.Migrate.Internal\Get-AzMigrateReplicationExtension `
                    -InputObject $replicationExtension `
                    -ErrorVariable notPresent `
                    -ErrorAction SilentlyContinue

                # Make sure replication extension is no longer in Canceled or Failed state
                if ($null -ne $replicationExtension -and
                    ($replicationExtension.Property.ProvisioningState -eq [ProvisioningState]::Canceled -or
                    $replicationExtension.Property.ProvisioningState -eq [ProvisioningState]::Failed)) {
                    throw "Failed to change the Provisioning State of Replication Extension '$($replicationExtensionName)'by removing. Please re-run this command or contact support if help needed."
                }
            }

            # Give time to remove replication extension. Timeout after 10min
            if ($null -ne $replicationExtension -and
                $replicationExtension.Property.ProvisioningState -eq [ProvisioningState]::Deleting) {
                Write-Host "Replication Extension '$($replicationExtensionName)' found in Provisioning State '$($replicationExtension.Property.ProvisioningState)'."

                for ($i = 0; $i -lt 20; $i++) {
                    Start-Sleep -Seconds 30
                    $replicationExtension = Az.Migrate.Internal\Get-AzMigrateReplicationExtension `
                        -InputObject $replicationExtension `
                        -ErrorVariable notPresent `
                        -ErrorAction SilentlyContinue

                    if ($null -eq $replicationExtension -or $replicationExtension.Property.ProvisioningState -eq [ProvisioningState]::Deleted) {
                        break
                    }
                    elseif ($replicationExtension.Property.ProvisioningState -eq [ProvisioningState]::Deleting) {
                        continue
                    }

                    throw "Replication Extension '$($replicationExtensionName)' has an unexpected Provisioning State of '$($replicationExtension.Property.ProvisioningState)' during removal process. Please re-run this command or contact support if help needed."
                }

                # Make sure replication extension is no longer in Deleting state
                if ($null -ne $replicationExtension -and $replicationExtension.Property.ProvisioningState -eq [ProvisioningState]::Deleting) {
                    throw "Replication Extension '$($replicationExtensionName)' times out with Provisioning State: '$($replicationExtension.Property.ProvisioningState)'. Please re-run this command or contact support if help needed."
                }
            }

            # Indicate replication extension was removed
            if ($null -eq $replicationExtension -or $replicationExtension.Property.ProvisioningState -eq [ProvisioningState]::Deleted) {
                Write-Host "Replication Extension '$($replicationExtensionName)' was removed."
            }
        }

        # Refresh local replication extension object if exists
        if ($null -ne $replicationExtension) {
            $replicationExtension = Az.Migrate.Internal\Get-AzMigrateReplicationExtension -InputObject $replicationExtension
        }

        # Create replication extension if not found or previously deleted
        if ($null -eq $replicationExtension -or $replicationExtension.Property.ProvisioningState -eq [ProvisioningState]::Deleted) {
            Write-Host "Waiting 2 minutes for permissions to sync before creating Replication Extension..."
            Start-Sleep -Seconds 120

            Write-Host "Creating Replication Extension..."
            $params = @{
                InstanceType                = $instanceType;
                SourceFabricArmId           = $sourceFabric.Id;
                TargetFabricArmId           = $targetFabric.Id;
                StorageAccountId            = $cacheStorageAccount.Id;
                StorageAccountSasSecretName = $null;
            }

            # Setup Replication Extension deployment parameters
            $replicationExtensionProperties = [Microsoft.Azure.PowerShell.Cmdlets.Migrate.Models.Api20210216Preview.ReplicationExtensionModelProperties]::new()
        
            if ($instanceType -eq $AzStackHCIInstanceTypes.HyperVToAzStackHCI) {
                $replicationExtensionCustomProperties = [Microsoft.Azure.PowerShell.Cmdlets.Migrate.Models.Api20210216Preview.HyperVToAzStackHcireplicationExtensionModelCustomProperties]::new()
                $replicationExtensionCustomProperties.HyperVFabricArmId = $params.SourceFabricArmId
                
            }
            elseif ($instanceType -eq $AzStackHCIInstanceTypes.VMwareToAzStackHCI) {
                $replicationExtensionCustomProperties = [Microsoft.Azure.PowerShell.Cmdlets.Migrate.Models.Api20210216Preview.VMwareToAzStackHcireplicationExtensionModelCustomProperties]::new()
                $replicationExtensionCustomProperties.VMwareFabricArmId = $params.SourceFabricArmId
            }
            else {
                throw "Currently, for AzStackHCI scenario, only HyperV and VMware as the source is supported."
            }
            $replicationExtensionCustomProperties.InstanceType = $params.InstanceType
            $replicationExtensionCustomProperties.AzStackHCIFabricArmId = $params.TargetFabricArmId
            $replicationExtensionCustomProperties.StorageAccountId = $params.StorageAccountId
            $replicationExtensionCustomProperties.StorageAccountSasSecretName = $params.StorageAccountSasSecretName
            $replicationExtensionProperties.CustomProperty = $replicationExtensionCustomProperties

            try {
                Az.Migrate.Internal\New-AzMigrateReplicationExtension `
                    -Name $replicationExtensionName `
                    -ResourceGroupName $ResourceGroupName `
                    -VaultName $replicationVaultName `
                    -Property $replicationExtensionProperties `
                    -SubscriptionId $SubscriptionId `
                    -NoWait | Out-Null
            }
            catch {
                if ($_.Exception.Message -notmatch "Status: OK") {
                    throw $_.Exception.Message
                }
            }

            # Check replication extension creation status every 30s. Timeout after 10min
            for ($i = 0; $i -lt 20; $i++) {
                Start-Sleep -Seconds 30
                $replicationExtension = Az.Migrate.Internal\Get-AzMigrateReplicationExtension `
                    -ResourceGroupName $ResourceGroupName `
                    -Name $replicationExtensionName `
                    -VaultName $replicationVaultName `
                    -SubscriptionId $SubscriptionId `
                    -ErrorVariable notPresent `
                    -ErrorAction SilentlyContinue
                if ($null -eq $replicationExtension) {
                    throw "Unexpected error occurred during Replication Extension creation. Please re-run this command or contact support if help needed."
                }
                
                # Stop if replication extension reaches a terminal state
                if ($replicationExtension.Property.ProvisioningState -eq [ProvisioningState]::Succeeded -or
                    $replicationExtension.Property.ProvisioningState -eq [ProvisioningState]::Deleted -or
                    $replicationExtension.Property.ProvisioningState -eq [ProvisioningState]::Canceled -or
                    $replicationExtension.Property.ProvisioningState -eq [ProvisioningState]::Failed) {
                    break
                }
            }

            # Make sure replicationExtension is in a terminal state
            if (-not (
                    $replicationExtension.Property.ProvisioningState -eq [ProvisioningState]::Succeeded -or
                    $replicationExtension.Property.ProvisioningState -eq [ProvisioningState]::Deleted -or
                    $replicationExtension.Property.ProvisioningState -eq [ProvisioningState]::Canceled -or
                    $replicationExtension.Property.ProvisioningState -eq [ProvisioningState]::Failed)) {
                throw "Replication Extension '$($replicationExtensionName)' times out with Provisioning State: '$($replicationExtension.Property.ProvisioningState)' during creation process. Please re-run this command or contact support if help needed."
            }
        }
        
        if ($replicationExtension.Property.ProvisioningState -ne [ProvisioningState]::Succeeded) {
            throw "Replication Extension '$($replicationExtensionName)' has an unexpected Provisioning State of '$($replicationExtension.Property.ProvisioningState)'. Please re-run this command or contact support if help needed."
        }

        $replicationExtension = Az.Migrate.Internal\Get-AzMigrateReplicationExtension `
            -ResourceGroupName $ResourceGroupName `
            -Name $replicationExtensionName `
            -VaultName $replicationVaultName `
            -SubscriptionId $SubscriptionId `
            -ErrorVariable notPresent `
            -ErrorAction SilentlyContinue
        if ($null -eq $replicationExtension) {
            throw "Unexpected error occurred during Replication Extension creation. Please re-run this command or contact support if help needed."
        }
        elseif ($replicationExtension.Property.ProvisioningState -ne [ProvisioningState]::Succeeded) {
            throw "Replication Extension '$($replicationExtensionName)' has an unexpected Provisioning State of '$($replicationExtension.Property.ProvisioningState)'. Please re-run this command or contact support if help needed."
        }
        else {
            Write-Host "*Selected Replication Extension: '$($replicationExtensionName)'"
        }

        if ($PassThru) {
            return $true
        }
    }
}
# SIG # Begin signature block
# MIIoQwYJKoZIhvcNAQcCoIIoNDCCKDACAQExDzANBglghkgBZQMEAgEFADB5Bgor
# BgEEAYI3AgEEoGswaTA0BgorBgEEAYI3AgEeMCYCAwEAAAQQH8w7YFlLCE63JNLG
# KX7zUQIBAAIBAAIBAAIBAAIBADAxMA0GCWCGSAFlAwQCAQUABCApy4GyrY+Y69ES
# awA+gHdaw11AKPrODx3gkazHGUkkjaCCDXYwggX0MIID3KADAgECAhMzAAAEBGx0
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
# /Xmfwb1tbWrJUnMTDXpQzTGCGiMwghofAgEBMIGVMH4xCzAJBgNVBAYTAlVTMRMw
# EQYDVQQIEwpXYXNoaW5ndG9uMRAwDgYDVQQHEwdSZWRtb25kMR4wHAYDVQQKExVN
# aWNyb3NvZnQgQ29ycG9yYXRpb24xKDAmBgNVBAMTH01pY3Jvc29mdCBDb2RlIFNp
# Z25pbmcgUENBIDIwMTECEzMAAAQEbHQG/1crJ3IAAAAABAQwDQYJYIZIAWUDBAIB
# BQCgga4wGQYJKoZIhvcNAQkDMQwGCisGAQQBgjcCAQQwHAYKKwYBBAGCNwIBCzEO
# MAwGCisGAQQBgjcCARUwLwYJKoZIhvcNAQkEMSIEINMHok8scKDlm8kry6QzINES
# varOxKc60HCs5x3VbU/jMEIGCisGAQQBgjcCAQwxNDAyoBSAEgBNAGkAYwByAG8A
# cwBvAGYAdKEagBhodHRwOi8vd3d3Lm1pY3Jvc29mdC5jb20wDQYJKoZIhvcNAQEB
# BQAEggEANQm1SXKuwP0SA32WDA6NAjg1CCpru/HoHYw42TlZWCYWISNw5i7lTDG/
# PUXCv45xqNbmqZ8oXHgx5B78in+KNmWGLqLCn4thgsBEdPvUDucOFEThN0O2LjfC
# xHG4tnEvx2+nXpx4Us6ftSKP67MKGVrGG+6O/czCepDv0OqMYLBTVoV88mvnMdG3
# BL8BwhKBB6fkoMJ4+IDbihAnrNANkhCpv4MWacClwGr3IIzOQrs6OsQXJCu7yK10
# SnDoOeQWyoQk6x6vh80rqLm2rlRyNBRqySX4rxdx+hx+EIKsQ5jKyuuq+t7m2WL3
# Ii+hwigcGxnKYOe2/2m1Vt10Al+996GCF60wghepBgorBgEEAYI3AwMBMYIXmTCC
# F5UGCSqGSIb3DQEHAqCCF4YwgheCAgEDMQ8wDQYJYIZIAWUDBAIBBQAwggFaBgsq
# hkiG9w0BCRABBKCCAUkEggFFMIIBQQIBAQYKKwYBBAGEWQoDATAxMA0GCWCGSAFl
# AwQCAQUABCD103QnT4X9NL/bIfaP1jOaAO3Y+T1iHjRaZETeSWXQDQIGZut+8l1V
# GBMyMDI0MTEwMTE1MDQxOS4xMzVaMASAAgH0oIHZpIHWMIHTMQswCQYDVQQGEwJV
# UzETMBEGA1UECBMKV2FzaGluZ3RvbjEQMA4GA1UEBxMHUmVkbW9uZDEeMBwGA1UE
# ChMVTWljcm9zb2Z0IENvcnBvcmF0aW9uMS0wKwYDVQQLEyRNaWNyb3NvZnQgSXJl
# bGFuZCBPcGVyYXRpb25zIExpbWl0ZWQxJzAlBgNVBAsTHm5TaGllbGQgVFNTIEVT
# Tjo2RjFBLTA1RTAtRDk0NzElMCMGA1UEAxMcTWljcm9zb2Z0IFRpbWUtU3RhbXAg
# U2VydmljZaCCEfswggcoMIIFEKADAgECAhMzAAAB/Bigr8xpWoc6AAEAAAH8MA0G
# CSqGSIb3DQEBCwUAMHwxCzAJBgNVBAYTAlVTMRMwEQYDVQQIEwpXYXNoaW5ndG9u
# MRAwDgYDVQQHEwdSZWRtb25kMR4wHAYDVQQKExVNaWNyb3NvZnQgQ29ycG9yYXRp
# b24xJjAkBgNVBAMTHU1pY3Jvc29mdCBUaW1lLVN0YW1wIFBDQSAyMDEwMB4XDTI0
# MDcyNTE4MzExNFoXDTI1MTAyMjE4MzExNFowgdMxCzAJBgNVBAYTAlVTMRMwEQYD
# VQQIEwpXYXNoaW5ndG9uMRAwDgYDVQQHEwdSZWRtb25kMR4wHAYDVQQKExVNaWNy
# b3NvZnQgQ29ycG9yYXRpb24xLTArBgNVBAsTJE1pY3Jvc29mdCBJcmVsYW5kIE9w
# ZXJhdGlvbnMgTGltaXRlZDEnMCUGA1UECxMeblNoaWVsZCBUU1MgRVNOOjZGMUEt
# MDVFMC1EOTQ3MSUwIwYDVQQDExxNaWNyb3NvZnQgVGltZS1TdGFtcCBTZXJ2aWNl
# MIICIjANBgkqhkiG9w0BAQEFAAOCAg8AMIICCgKCAgEAp1DAKLxpbQcPVYPHlJHy
# W7W5lBZjJWWDjMfl5WyhuAylP/LDm2hb4ymUmSymV0EFRQcmM8BypwjhWP8F7x4i
# O88d+9GZ9MQmNh3jSDohhXXgf8rONEAyfCPVmJzM7ytsurZ9xocbuEL7+P7EkIwo
# OuMFlTF2G/zuqx1E+wANslpPqPpb8PC56BQxgJCI1LOF5lk3AePJ78OL3aw/Ndlk
# vdVl3VgBSPX4Nawt3UgUofuPn/cp9vwKKBwuIWQEFZ837GXXITshd2Mfs6oYfxXE
# tmj2SBGEhxVs7xERuWGb0cK6afy7naKkbZI2v1UqsxuZt94rn/ey2ynvunlx0R6/
# b6nNkC1rOTAfWlpsAj/QlzyM6uYTSxYZC2YWzLbbRl0lRtSz+4TdpUU/oAZSB+Y+
# s12Rqmgzi7RVxNcI2lm//sCEm6A63nCJCgYtM+LLe9pTshl/Wf8OOuPQRiA+stTs
# g89BOG9tblaz2kfeOkYf5hdH8phAbuOuDQfr6s5Ya6W+vZz6E0Zsenzi0OtMf5RC
# a2hADYVgUxD+grC8EptfWeVAWgYCaQFheNN/ZGNQMkk78V63yoPBffJEAu+B5xlT
# PYoijUdo9NXovJmoGXj6R8Tgso+QPaAGHKxCbHa1QL9ASMF3Os1jrogCHGiykfp1
# dKGnmA5wJT6Nx7BedlSDsAkCAwEAAaOCAUkwggFFMB0GA1UdDgQWBBSY8aUrsUaz
# hxByH79dhiQCL/7QdjAfBgNVHSMEGDAWgBSfpxVdAF5iXYP05dJlpxtTNRnpcjBf
# BgNVHR8EWDBWMFSgUqBQhk5odHRwOi8vd3d3Lm1pY3Jvc29mdC5jb20vcGtpb3Bz
# L2NybC9NaWNyb3NvZnQlMjBUaW1lLVN0YW1wJTIwUENBJTIwMjAxMCgxKS5jcmww
# bAYIKwYBBQUHAQEEYDBeMFwGCCsGAQUFBzAChlBodHRwOi8vd3d3Lm1pY3Jvc29m
# dC5jb20vcGtpb3BzL2NlcnRzL01pY3Jvc29mdCUyMFRpbWUtU3RhbXAlMjBQQ0El
# MjAyMDEwKDEpLmNydDAMBgNVHRMBAf8EAjAAMBYGA1UdJQEB/wQMMAoGCCsGAQUF
# BwMIMA4GA1UdDwEB/wQEAwIHgDANBgkqhkiG9w0BAQsFAAOCAgEAT7ss/ZAZ0bTa
# FsrsiJYd//LQ6ImKb9JZSKiRw9xs8hwk5Y/7zign9gGtweRChC2lJ8GVRHgrFkBx
# ACjuuPprSz/UYX7n522JKcudnWuIeE1p30BZrqPTOnscD98DZi6WNTAymnaS7it5
# qAgNInreAJbTU2cAosJoeXAHr50YgSGlmJM+cN6mYLAL6TTFMtFYJrpK9TM5Ryh5
# eZmm6UTJnGg0jt1pF/2u8PSdz3dDy7DF7KDJad2qHxZORvM3k9V8Yn3JI5YLPuLs
# o2J5s3fpXyCVgR/hq86g5zjd9bRRyyiC8iLIm/N95q6HWVsCeySetrqfsDyYWStw
# L96hy7DIyLL5ih8YFMd0AdmvTRoylmADuKwE2TQCTvPnjnLk7ypJW29t17Yya4V+
# Jlz54sBnPU7kIeYZsvUT+YKgykP1QB+p+uUdRH6e79Vaiz+iewWrIJZ4tXkDMmL2
# 1nh0j+58E1ecAYDvT6B4yFIeonxA/6Gl9Xs7JLciPCIC6hGdliiEBpyYeUF0ohZF
# n7NKQu80IZ0jd511WA2bq6x9aUq/zFyf8Egw+dunUj1KtNoWpq7VuJqapckYsmvm
# mYHZXCjK1Eus7V1I+aXjrBYuqyM9QpeFZU4U01YG15uWwUCaj0uZlah/RGSYMd84
# y9DCqOpfeKE6PLMk7hLnhvcOQrnxP6kwggdxMIIFWaADAgECAhMzAAAAFcXna54C
# m0mZAAAAAAAVMA0GCSqGSIb3DQEBCwUAMIGIMQswCQYDVQQGEwJVUzETMBEGA1UE
# CBMKV2FzaGluZ3RvbjEQMA4GA1UEBxMHUmVkbW9uZDEeMBwGA1UEChMVTWljcm9z
# b2Z0IENvcnBvcmF0aW9uMTIwMAYDVQQDEylNaWNyb3NvZnQgUm9vdCBDZXJ0aWZp
# Y2F0ZSBBdXRob3JpdHkgMjAxMDAeFw0yMTA5MzAxODIyMjVaFw0zMDA5MzAxODMy
# MjVaMHwxCzAJBgNVBAYTAlVTMRMwEQYDVQQIEwpXYXNoaW5ndG9uMRAwDgYDVQQH
# EwdSZWRtb25kMR4wHAYDVQQKExVNaWNyb3NvZnQgQ29ycG9yYXRpb24xJjAkBgNV
# BAMTHU1pY3Jvc29mdCBUaW1lLVN0YW1wIFBDQSAyMDEwMIICIjANBgkqhkiG9w0B
# AQEFAAOCAg8AMIICCgKCAgEA5OGmTOe0ciELeaLL1yR5vQ7VgtP97pwHB9KpbE51
# yMo1V/YBf2xK4OK9uT4XYDP/XE/HZveVU3Fa4n5KWv64NmeFRiMMtY0Tz3cywBAY
# 6GB9alKDRLemjkZrBxTzxXb1hlDcwUTIcVxRMTegCjhuje3XD9gmU3w5YQJ6xKr9
# cmmvHaus9ja+NSZk2pg7uhp7M62AW36MEBydUv626GIl3GoPz130/o5Tz9bshVZN
# 7928jaTjkY+yOSxRnOlwaQ3KNi1wjjHINSi947SHJMPgyY9+tVSP3PoFVZhtaDua
# Rr3tpK56KTesy+uDRedGbsoy1cCGMFxPLOJiss254o2I5JasAUq7vnGpF1tnYN74
# kpEeHT39IM9zfUGaRnXNxF803RKJ1v2lIH1+/NmeRd+2ci/bfV+AutuqfjbsNkz2
# K26oElHovwUDo9Fzpk03dJQcNIIP8BDyt0cY7afomXw/TNuvXsLz1dhzPUNOwTM5
# TI4CvEJoLhDqhFFG4tG9ahhaYQFzymeiXtcodgLiMxhy16cg8ML6EgrXY28MyTZk
# i1ugpoMhXV8wdJGUlNi5UPkLiWHzNgY1GIRH29wb0f2y1BzFa/ZcUlFdEtsluq9Q
# BXpsxREdcu+N+VLEhReTwDwV2xo3xwgVGD94q0W29R6HXtqPnhZyacaue7e3Pmri
# Lq0CAwEAAaOCAd0wggHZMBIGCSsGAQQBgjcVAQQFAgMBAAEwIwYJKwYBBAGCNxUC
# BBYEFCqnUv5kxJq+gpE8RjUpzxD/LwTuMB0GA1UdDgQWBBSfpxVdAF5iXYP05dJl
# pxtTNRnpcjBcBgNVHSAEVTBTMFEGDCsGAQQBgjdMg30BATBBMD8GCCsGAQUFBwIB
# FjNodHRwOi8vd3d3Lm1pY3Jvc29mdC5jb20vcGtpb3BzL0RvY3MvUmVwb3NpdG9y
# eS5odG0wEwYDVR0lBAwwCgYIKwYBBQUHAwgwGQYJKwYBBAGCNxQCBAweCgBTAHUA
# YgBDAEEwCwYDVR0PBAQDAgGGMA8GA1UdEwEB/wQFMAMBAf8wHwYDVR0jBBgwFoAU
# 1fZWy4/oolxiaNE9lJBb186aGMQwVgYDVR0fBE8wTTBLoEmgR4ZFaHR0cDovL2Ny
# bC5taWNyb3NvZnQuY29tL3BraS9jcmwvcHJvZHVjdHMvTWljUm9vQ2VyQXV0XzIw
# MTAtMDYtMjMuY3JsMFoGCCsGAQUFBwEBBE4wTDBKBggrBgEFBQcwAoY+aHR0cDov
# L3d3dy5taWNyb3NvZnQuY29tL3BraS9jZXJ0cy9NaWNSb29DZXJBdXRfMjAxMC0w
# Ni0yMy5jcnQwDQYJKoZIhvcNAQELBQADggIBAJ1VffwqreEsH2cBMSRb4Z5yS/yp
# b+pcFLY+TkdkeLEGk5c9MTO1OdfCcTY/2mRsfNB1OW27DzHkwo/7bNGhlBgi7ulm
# ZzpTTd2YurYeeNg2LpypglYAA7AFvonoaeC6Ce5732pvvinLbtg/SHUB2RjebYIM
# 9W0jVOR4U3UkV7ndn/OOPcbzaN9l9qRWqveVtihVJ9AkvUCgvxm2EhIRXT0n4ECW
# OKz3+SmJw7wXsFSFQrP8DJ6LGYnn8AtqgcKBGUIZUnWKNsIdw2FzLixre24/LAl4
# FOmRsqlb30mjdAy87JGA0j3mSj5mO0+7hvoyGtmW9I/2kQH2zsZ0/fZMcm8Qq3Uw
# xTSwethQ/gpY3UA8x1RtnWN0SCyxTkctwRQEcb9k+SS+c23Kjgm9swFXSVRk2XPX
# fx5bRAGOWhmRaw2fpCjcZxkoJLo4S5pu+yFUa2pFEUep8beuyOiJXk+d0tBMdrVX
# VAmxaQFEfnyhYWxz/gq77EFmPWn9y8FBSX5+k77L+DvktxW/tM4+pTFRhLy/AsGC
# onsXHRWJjXD+57XQKBqJC4822rpM+Zv/Cuk0+CQ1ZyvgDbjmjJnW4SLq8CdCPSWU
# 5nR0W2rRnj7tfqAxM328y+l7vzhwRNGQ8cirOoo6CGJ/2XBjU02N7oJtpQUQwXEG
# ahC0HVUzWLOhcGbyoYIDVjCCAj4CAQEwggEBoYHZpIHWMIHTMQswCQYDVQQGEwJV
# UzETMBEGA1UECBMKV2FzaGluZ3RvbjEQMA4GA1UEBxMHUmVkbW9uZDEeMBwGA1UE
# ChMVTWljcm9zb2Z0IENvcnBvcmF0aW9uMS0wKwYDVQQLEyRNaWNyb3NvZnQgSXJl
# bGFuZCBPcGVyYXRpb25zIExpbWl0ZWQxJzAlBgNVBAsTHm5TaGllbGQgVFNTIEVT
# Tjo2RjFBLTA1RTAtRDk0NzElMCMGA1UEAxMcTWljcm9zb2Z0IFRpbWUtU3RhbXAg
# U2VydmljZaIjCgEBMAcGBSsOAwIaAxUATkEpJXOaqI2wfqBsw4NLVwqYqqqggYMw
# gYCkfjB8MQswCQYDVQQGEwJVUzETMBEGA1UECBMKV2FzaGluZ3RvbjEQMA4GA1UE
# BxMHUmVkbW9uZDEeMBwGA1UEChMVTWljcm9zb2Z0IENvcnBvcmF0aW9uMSYwJAYD
# VQQDEx1NaWNyb3NvZnQgVGltZS1TdGFtcCBQQ0EgMjAxMDANBgkqhkiG9w0BAQsF
# AAIFAOrPU74wIhgPMjAyNDExMDExMzE4NTRaGA8yMDI0MTEwMjEzMTg1NFowdDA6
# BgorBgEEAYRZCgQBMSwwKjAKAgUA6s9TvgIBADAHAgEAAgIJeTAHAgEAAgIUkzAK
# AgUA6tClPgIBADA2BgorBgEEAYRZCgQCMSgwJjAMBgorBgEEAYRZCgMCoAowCAIB
# AAIDB6EgoQowCAIBAAIDAYagMA0GCSqGSIb3DQEBCwUAA4IBAQAlb4fHxx/s/h2B
# nx8lieji5tvnns6Ujn9Pu/hkN86wA/tIVH2U/VNcStoL2lgKdzUGpgYUPOfPGnDT
# iLHWfif+XnUn82N/J9eKX3XL2hh6jNH+mt/O2smPQ9Lt9ycYAK/Nxl3U0CcnKG0k
# yn4NB3Qq8sGpULvSngsWZQVrUiLddzly3Ia4n1vXiB6dXhpRMPMD00aTQ0CDydRA
# aKboaWIjxLhW38W6jzXtSRvMIdfio7CFjmDcugwikWbJB9DSP9XlGm1QKQ+igr4V
# LGYnlPugrxgK5JtyaqebBXmlcYq2PZSvrAd41hd6DEF9H9zIpGL4KxGc5JjN6J0M
# zo3maAEUMYIEDTCCBAkCAQEwgZMwfDELMAkGA1UEBhMCVVMxEzARBgNVBAgTCldh
# c2hpbmd0b24xEDAOBgNVBAcTB1JlZG1vbmQxHjAcBgNVBAoTFU1pY3Jvc29mdCBD
# b3Jwb3JhdGlvbjEmMCQGA1UEAxMdTWljcm9zb2Z0IFRpbWUtU3RhbXAgUENBIDIw
# MTACEzMAAAH8GKCvzGlahzoAAQAAAfwwDQYJYIZIAWUDBAIBBQCgggFKMBoGCSqG
# SIb3DQEJAzENBgsqhkiG9w0BCRABBDAvBgkqhkiG9w0BCQQxIgQg8+qQzibcedQi
# xiGu12l5fHHqbAFEHBAmnjL23z2njdgwgfoGCyqGSIb3DQEJEAIvMYHqMIHnMIHk
# MIG9BCCVQq+Qu+/h/BOVP4wweUwbHuCUhh+T7hq3d5MCaNEtYjCBmDCBgKR+MHwx
# CzAJBgNVBAYTAlVTMRMwEQYDVQQIEwpXYXNoaW5ndG9uMRAwDgYDVQQHEwdSZWRt
# b25kMR4wHAYDVQQKExVNaWNyb3NvZnQgQ29ycG9yYXRpb24xJjAkBgNVBAMTHU1p
# Y3Jvc29mdCBUaW1lLVN0YW1wIFBDQSAyMDEwAhMzAAAB/Bigr8xpWoc6AAEAAAH8
# MCIEIKSrfF6wsmpddiLsOcAQDxzmy5qKVcrqGzWbzHmwOhTjMA0GCSqGSIb3DQEB
# CwUABIICAJZKqpb2ZOHaSp915pQfqcy8sF+jZqaEUZBPyMW0HWyVsjDWeTVEzfEf
# epeSa1Qdj38uB4Dj9dFR55+DNkKZL3cw9BgPn+Raykn63EyM3FiunG5K4ogWLxyy
# GQJ+6RDCyHldXC5skUupwn+pI+2DFq6nyxsIkjD33epYRO/VO5KnZqyham0e5yaq
# 7f/HuLcwHyoe0HSTbrtD6OM/CfceHisgTCojJrKIHiCUJp+2pjws8AZn/7rX4Ib/
# MM5Y+Wu/9E4eC2DIlJSUnuV6bPjSMrMQcdSCEn2BMtkc1pCDg8hE2ex/J2si3Jrj
# 5ySaFAA/Zq8DXd2X8T5h0DOpKcRipvmGiBbqOY4wGULrskHOdy+8kdx3rviITzO2
# wSaNfUMGY/fQ8EPjEfxOZLri786q7mXIh/xWvNjj8/T0j9EfqQGNyNr+H9nbTDpK
# 2nlxFlmQb/V4YOgstEsJz3UaW2qZsl4XBrIlAvoBHX4+qph+JB3SR3s5UxdsyIZ3
# gu3fnLQR+b9bpVwnS12d4Pk9Hc8zQBN6SDggZM7U27ZO65s2rJJ4Ozi20mqdDx51
# PkRm7t3zpjzDKOdn43HvKVEZELYbAXYi8xk7OfwnWOIkAe9RwZPbIcd8cF31g3QS
# /C5szlsvsyEhvy9GmdB2pSbmOq6rSrbvezRztUtVuk8vIbI2WSmv
# SIG # End signature block
