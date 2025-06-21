function Initialize-AzDataProtectionRestoreRequest
{
	[OutputType('Microsoft.Azure.PowerShell.Cmdlets.DataProtection.Models.Api20240401.IAzureBackupRestoreRequest')]
    [CmdletBinding(PositionalBinding=$false, DefaultParameterSetName='AlternateLocationFullRecovery')]
    [Microsoft.Azure.PowerShell.Cmdlets.DataProtection.Description('Initializes Restore Request object for triggering restore on a protected backup instance.')]

    param(
        [Parameter(ParameterSetName="OriginalLocationFullRecovery", Mandatory, HelpMessage='Datasource Type')]
        [Parameter(ParameterSetName="AlternateLocationFullRecovery", Mandatory, HelpMessage='Datasource Type')]
        [Parameter(ParameterSetName="OriginalLocationILR", Mandatory, HelpMessage='Datasource Type')]
        [Parameter(ParameterSetName="RestoreAsFiles", Mandatory, HelpMessage='Datasource Type')]
        [Parameter(ParameterSetName="AlternateLocationILR", Mandatory, HelpMessage='Datasource Type')]
        [Microsoft.Azure.PowerShell.Cmdlets.DataProtection.Support.DatasourceTypes]
        ${DatasourceType},

        [Parameter(ParameterSetName="OriginalLocationFullRecovery", Mandatory, HelpMessage='DataStore Type of the Recovery point')]
        [Parameter(ParameterSetName="AlternateLocationFullRecovery", Mandatory, HelpMessage='DataStore Type of the Recovery point')]
        [Parameter(ParameterSetName="OriginalLocationILR", Mandatory, HelpMessage='DataStore Type of the Recovery point')]
        [Parameter(ParameterSetName="RestoreAsFiles", Mandatory, HelpMessage='DataStore Type of the Recovery point')]
        [Parameter(ParameterSetName="AlternateLocationILR", Mandatory, HelpMessage='DataStore Type of the Recovery point')]
        [Microsoft.Azure.PowerShell.Cmdlets.DataProtection.Support.DataStoreType]
        ${SourceDataStore},

        [Parameter(ParameterSetName="OriginalLocationFullRecovery", Mandatory=$false, HelpMessage='Id of the recovery point to be restored.')]
        [Parameter(ParameterSetName="AlternateLocationFullRecovery", Mandatory=$false, HelpMessage='Id of the recovery point to be restored.')]
        [Parameter(ParameterSetName="OriginalLocationILR", Mandatory=$false, HelpMessage='Id of the recovery point to be restored.')]
        [Parameter(ParameterSetName="RestoreAsFiles", Mandatory=$false, HelpMessage='Id of the recovery point to be restored.')]
        [Parameter(ParameterSetName="AlternateLocationILR", Mandatory=$false, HelpMessage='Id of the recovery point to be restored.')]
        [System.String]
        ${RecoveryPoint},
        
        [Parameter(ParameterSetName="OriginalLocationFullRecovery", Mandatory=$false, HelpMessage='Point In Time for restore.')]
        [Parameter(ParameterSetName="AlternateLocationFullRecovery", Mandatory=$false, HelpMessage='Point In Time for restore.')]
        [Parameter(ParameterSetName="OriginalLocationILR", Mandatory=$false, HelpMessage='Point In Time for restore.')]
        # [Parameter(ParameterSetName="AlternateLocationILR", Mandatory=$false, HelpMessage='Point In Time for restore.')]
        [System.DateTime]
        ${PointInTime},

        [Parameter(ParameterSetName="OriginalLocationFullRecovery", Mandatory=$false, HelpMessage='Rehydration duration for the archived recovery point to stay rehydrated, default value for rehydration duration is 15.')]
        [Parameter(ParameterSetName="AlternateLocationFullRecovery", Mandatory=$false, HelpMessage='Rehydration duration for the archived recovery point to stay rehydrated, default value for rehydration duration is 15.')]
        [Parameter(ParameterSetName="OriginalLocationILR", Mandatory=$false, HelpMessage='Rehydration duration for the archived recovery point to stay rehydrated, default value for rehydration duration is 15.')]
        [Parameter(ParameterSetName="RestoreAsFiles", Mandatory=$false, HelpMessage='Rehydration duration for the archived recovery point to stay rehydrated, default value for rehydration duration is 15.')]
        # [Parameter(ParameterSetName="AlternateLocationILR", Mandatory=$false, HelpMessage='Rehydration duration for the archived recovery point to stay rehydrated, default value for rehydration duration is 15.')]
        [System.String]
        ${RehydrationDuration},

        [Parameter(ParameterSetName="OriginalLocationFullRecovery", Mandatory=$false, HelpMessage='Rehydration priority for archived recovery point. This parameter is mandatory for rehydrate restore of archived points.')]
        [Parameter(ParameterSetName="AlternateLocationFullRecovery", Mandatory=$false, HelpMessage='Rehydration priority for archived recovery point. This parameter is mandatory for rehydrate restore of archived points.')]
        [Parameter(ParameterSetName="OriginalLocationILR", Mandatory=$false, HelpMessage='Rehydration priority for archived recovery point. This parameter is mandatory for rehydrate restore of archived points.')]
        [Parameter(ParameterSetName="RestoreAsFiles", Mandatory=$false, HelpMessage='Rehydration priority for archived recovery point. This parameter is mandatory for rehydrate restore of archived points.')]
        # [Parameter(ParameterSetName="AlternateLocationILR", Mandatory=$false, HelpMessage='Rehydration priority for archived recovery point. This parameter is mandatory for rehydrate restore of archived points.')]
        [ValidateSet("Standard")]
        [System.String]
        ${RehydrationPriority},

        [Parameter(ParameterSetName="OriginalLocationFullRecovery", Mandatory, HelpMessage='Target Restore Location')]
        [Parameter(ParameterSetName="AlternateLocationFullRecovery", Mandatory, HelpMessage='Target Restore Location')]
        [Parameter(ParameterSetName="OriginalLocationILR", Mandatory, HelpMessage='Target Restore Location')]
        [Parameter(ParameterSetName="RestoreAsFiles", Mandatory, HelpMessage='Target Restore Location')]
        [Parameter(ParameterSetName="AlternateLocationILR", Mandatory, HelpMessage='Target Restore Location')]
        [System.String]
        ${RestoreLocation},

        [Parameter(ParameterSetName="OriginalLocationFullRecovery", Mandatory, HelpMessage='Restore Target Type')]
        [Parameter(ParameterSetName="AlternateLocationFullRecovery", Mandatory, HelpMessage='Restore Target Type')]
        [Parameter(ParameterSetName="OriginalLocationILR", Mandatory, HelpMessage='Restore Target Type')]
        [Parameter(ParameterSetName="RestoreAsFiles", Mandatory, HelpMessage='Restore Target Type')]
        [Parameter(ParameterSetName="AlternateLocationILR", Mandatory, HelpMessage='Restore Target Type')]
        [Microsoft.Azure.PowerShell.Cmdlets.DataProtection.Support.RestoreTargetType]
        ${RestoreType},

        [Parameter(ParameterSetName="OriginalLocationFullRecovery", Mandatory, HelpMessage='Backup Instance object to trigger original localtion restore.')]
        [Parameter(ParameterSetName="OriginalLocationILR", Mandatory, HelpMessage='Backup Instance object to trigger original localtion restore.')]
        [Microsoft.Azure.PowerShell.Cmdlets.DataProtection.Models.Api20240401.BackupInstanceResource]
        ${BackupInstance},

        # this is applicable to all workloads wherever ALR supported.
        [Parameter(ParameterSetName="AlternateLocationFullRecovery", Mandatory, HelpMessage='Specify the target resource ID for restoring backup data in an alternate location. For instance, provide the target database ARM ID that you want to restore to, for workloadType AzureDatabaseForPostgreSQL.')]
        [Parameter(ParameterSetName="AlternateLocationILR", Mandatory, HelpMessage='Specify the target resource ID for restoring backup data in an alternate location. For instance, provide the target database ARM ID that you want to restore to, for workloadType AzureDatabaseForPostgreSQL.')]
        [System.String]
        ${TargetResourceId},

        # this parameter is being used in OSS cross subscription restore as files
        [Parameter(ParameterSetName="RestoreAsFiles", Mandatory=$false, HelpMessage='Target storage account container ARM Id to which backup data will be restored as files. This parameter is required for restoring as files when cross subscription restore is disabled on the backup vault.')]
        [System.String]
        ${TargetResourceIdForRestoreAsFile},

        [Parameter(ParameterSetName="RestoreAsFiles", Mandatory, HelpMessage='Target storage account container Id to which backup data will be restored as files.')]
        [System.String]
        ${TargetContainerURI},

        [Parameter(ParameterSetName="RestoreAsFiles", Mandatory=$false, HelpMessage='File name to be prefixed to the restored backup data.')]
        [System.String]
        ${FileNamePrefix},

        [Parameter(ParameterSetName="OriginalLocationILR", Mandatory, HelpMessage='Switch parameter to enable item level recovery.')]
        [Parameter(ParameterSetName="AlternateLocationILR", Mandatory, HelpMessage='Switch parameter to enable item level recovery.')]
        [Switch]
        ${ItemLevelRecovery},
                
        [Parameter(ParameterSetName="OriginalLocationILR", Mandatory=$false, HelpMessage='Container names for Item Level Recovery.')]
        [Parameter(ParameterSetName="AlternateLocationILR", Mandatory=$false, HelpMessage='Container names for Item Level Recovery.')]
        [System.String[]]
        ${ContainersList},
                
        [Parameter(ParameterSetName="AlternateLocationILR", Mandatory=$false, HelpMessage='Use this parameter to filter block blobs by prefix in a container for alternate location ILR. When you specify a prefix, only blobs matching that prefix in the container will be restored. Input for this parameter is a hashtable where each key is a container name and each value is an array of string prefixes for that container.')]
        [Hashtable]
        ${PrefixMatch},

        [Parameter(ParameterSetName="OriginalLocationILR", Mandatory=$false, HelpMessage='Specify the blob restore start range for PITR. You can use this option to specify the starting range for a subset of blobs in each container to restore. use a forward slash (/) to separate the container name from the blob prefix pattern.')]
        # [Parameter(ParameterSetName="AlternateLocationILR", Mandatory=$false, HelpMessage='Minimum matching value for Item Level Recovery.')]
        [System.String[]]
        ${FromPrefixPattern},

        [Parameter(ParameterSetName="OriginalLocationILR", Mandatory=$false, HelpMessage='Specify the blob restore end range for PITR. You can use this option to specify the ending range for a subset of blobs in each container to restore. use a forward slash (/) to separate the container name from the blob prefix pattern.')]
        # [Parameter(ParameterSetName="AlternateLocationILR", Mandatory=$false, HelpMessage='Maximum matching value for Item Level Recovery.')]
        [System.String[]]
        ${ToPrefixPattern},

        [Parameter(ParameterSetName="OriginalLocationILR", Mandatory=$false, HelpMessage='Restore configuration for restore. Use this parameter to restore with AzureKubernetesService.')]
        [Parameter(ParameterSetName="AlternateLocationILR", Mandatory=$false, HelpMessage='Restore configuration for restore. Use this parameter to restore with AzureKubernetesService.')]
        [Parameter(ParameterSetName="OriginalLocationFullRecovery", Mandatory=$false, HelpMessage='Restore configuration for restore. Use this parameter to restore with AzureKubernetesService.')]
        [Parameter(ParameterSetName="AlternateLocationFullRecovery", Mandatory=$false, HelpMessage='Restore configuration for restore. Use this parameter to restore with AzureKubernetesService.')]
        [PSObject]
        ${RestoreConfiguration},

        [Parameter(ParameterSetName="OriginalLocationFullRecovery", Mandatory=$false, HelpMessage='Secret uri for secret store authentication of data source. This parameter is only supported for AzureDatabaseForPostgreSQL currently.')]
        [Parameter(ParameterSetName="AlternateLocationFullRecovery", Mandatory=$false, HelpMessage='Secret uri for secret store authentication of data source. This parameter is only supported for AzureDatabaseForPostgreSQL currently.')]
        [Parameter(ParameterSetName="OriginalLocationILR", Mandatory=$false, HelpMessage='Secret uri for secret store authentication of data source. This parameter is only supported for AzureDatabaseForPostgreSQL currently.')]
        [Parameter(ParameterSetName="RestoreAsFiles", Mandatory=$false, HelpMessage='Secret uri for secret store authentication of data source. This parameter is only supported for AzureDatabaseForPostgreSQL currently.')]
        [System.String]
        ${SecretStoreURI},

        [Parameter(ParameterSetName="OriginalLocationFullRecovery", Mandatory=$false, HelpMessage='Secret store type for secret store authentication of data source. This parameter is only supported for AzureDatabaseForPostgreSQL currently.')]
        [Parameter(ParameterSetName="AlternateLocationFullRecovery", Mandatory=$false, HelpMessage='Secret store type for secret store authentication of data source. This parameter is only supported for AzureDatabaseForPostgreSQL currently.')]
        [Parameter(ParameterSetName="OriginalLocationILR", Mandatory=$false, HelpMessage='Secret store type for secret store authentication of data source. This parameter is only supported for AzureDatabaseForPostgreSQL currently.')]
        [Parameter(ParameterSetName="RestoreAsFiles", Mandatory=$false, HelpMessage='Secret store type for secret store authentication of data source. This parameter is only supported for AzureDatabaseForPostgreSQL currently.')]
        [ValidateSet("AzureKeyVault")]
        [Microsoft.Azure.PowerShell.Cmdlets.DataProtection.Support.SecretStoreTypes]
        ${SecretStoreType}    
    )

    process
    {         
        # Validations
        $parameterSetName = $PsCmdlet.ParameterSetName

        $restoreRequest = $null
        $restoreMode = $null
        $manifest = LoadManifest -DatasourceType $DatasourceType.ToString()

        # Choose Restore Request Type Based on Recovery Point ID/ Time
        if(($RecoveryPoint -ne $null) -and ($RecoveryPoint -ne ""))
        {               
            Write-Debug -Message $RecoveryPoint
            
            if($PSBoundParameters.ContainsKey("RehydrationPriority")){
                $restoreRequest = [Microsoft.Azure.PowerShell.Cmdlets.DataProtection.Models.Api20240401.AzureBackupRestoreWithRehydrationRequest]::new()
                $restoreRequest.ObjectType = "AzureBackupRestoreWithRehydrationRequest"   
                $restoreRequest.RehydrationPriority = $RehydrationPriority
                if($PSBoundParameters.ContainsKey("RehydrationDuration")){
                    $restoreRequest.RehydrationRetentionDuration = "P" + $RehydrationDuration + "D"
                }
                else{
                    $restoreRequest.RehydrationRetentionDuration = "P15D"
                }                
            }
            else{
                $restoreRequest = [Microsoft.Azure.PowerShell.Cmdlets.DataProtection.Models.Api20240401.AzureBackupRecoveryPointBasedRestoreRequest]::new()
                $restoreRequest.ObjectType = "AzureBackupRecoveryPointBasedRestoreRequest"            
            }            
            $restoreRequest.RecoveryPointId = $RecoveryPoint
            $restoreMode = "RecoveryPointBased"
        }
        elseif(($PointInTime -ne $null)  -and ($PointInTime -ne "")) # RecoveryPointInTimeBasedRestore
        {
            $utcTime = $PointInTime.ToUniversalTime().ToString("yyyy-MM-ddTHH:mm:ss.0000000Z")
            Write-Debug -Message $utcTime
            $restoreRequest = [Microsoft.Azure.PowerShell.Cmdlets.DataProtection.Models.Api20240401.AzureBackupRecoveryTimeBasedRestoreRequest]::new()
            $restoreRequest.ObjectType = "AzureBackupRecoveryTimeBasedRestoreRequest"
            $restoreRequest.RecoveryPointTime = $utcTime
            $restoreMode = "PointInTimeBased"
        }
        else{
            $errormsg = "Please input either RecoveryPoint or PointInTime parameter"
    		throw $errormsg
        }
        
        #Validate Restore Options = recoverypoint, ALR, OLR, ILR
        ValidateRestoreOptions -DatasourceType $DatasourceType -RestoreMode $restoreMode -RestoreTargetType $RestoreType -ItemLevelRecovery $ItemLevelRecovery -SecretStoreURI $SecretStoreURI

        # Initialize Restore Target Info based on Type provided

        if($RestoreType -eq "RestoreAsFiles") 
        {
           $restoreRequest.RestoreTargetInfo = [Microsoft.Azure.PowerShell.Cmdlets.DataProtection.Models.Api20240401.RestoreFilesTargetInfo]::new()
           $restoreRequest.RestoreTargetInfo.ObjectType = "RestoreFilesTargetInfo"

           if($manifest.fileNamePrefixDisabled -and $PSBoundParameters.ContainsKey("FileNamePrefix")){
               $errormsg = "FileNamePrefix can't be set for given DatasourceType. Please try again after removing FileNamePrefix parameter"
    		   throw $errormsg
           }
           elseif($manifest.fileNamePrefixDisabled -and !($PSBoundParameters.ContainsKey("TargetContainerURI"))){
               $errormsg = "TargetContainerURI parameter is required for RestoreAsFiles for given DatasourceType"
    		   throw $errormsg
           }
           elseif( !$manifest.fileNamePrefixDisabled -and (!($PSBoundParameters.ContainsKey("FileNamePrefix")) -or !($PSBoundParameters.ContainsKey("TargetContainerURI"))) ){
                $errormsg = "FileNamePrefix and TargetContainerURI parameters are required for RestoreAsFiles for given DatasourceType"
    		    throw $errormsg
           }

           if($manifest.fileNamePrefixDisabled){
               $restoreRequest.RestoreTargetInfo.TargetDetail.FilePrefix = "dummyprefix"
           }
           else{
               $restoreRequest.RestoreTargetInfo.TargetDetail.FilePrefix = $FileNamePrefix
           }
           
           $restoreRequest.RestoreTargetInfo.TargetDetail.RestoreTargetLocationType = "AzureBlobs"
           $restoreRequest.RestoreTargetInfo.TargetDetail.Url = $TargetContainerURI

           # mandatory for Cross Subscription restore scenario for OSS
           if(($PSBoundParameters.ContainsKey("TargetResourceIdForRestoreAsFile"))){
               $restoreRequest.RestoreTargetInfo.TargetDetail.TargetResourceArmId = $TargetResourceIdForRestoreAsFile                
           }
        }
        elseif(!($ItemLevelRecovery))
        {   
            # RestoreTargetInfo for OLR ALR Full recovery
            if($DatasourceType -ne "AzureKubernetesService"){
                $restoreRequest.RestoreTargetInfo = [Microsoft.Azure.PowerShell.Cmdlets.DataProtection.Models.Api20240401.RestoreTargetInfo]::new()
                $restoreRequest.RestoreTargetInfo.ObjectType = "restoreTargetInfo"
            }
            else{
                $restoreRequest.RestoreTargetInfo = [Microsoft.Azure.PowerShell.Cmdlets.DataProtection.Models.Api20240401.ItemLevelRestoreTargetInfo]::new()
                $restoreRequest.RestoreTargetInfo.ObjectType = "itemLevelRestoreTargetInfo"
                $restoreCriteriaList = @()

                # ItemLevelRecovery for AzureKubernetesService
                if($RestoreConfiguration -ne $null){
                    $restoreCriteria = $RestoreConfiguration
                }
                else{
                    $errormsg = "Please input parameter RestoreConfiguration for AKS cluster restore. Use command New-AzDataProtectionRestoreConfigurationClientObject for creating the RestoreConfiguration"
    		        throw $errormsg
                }                
                
                $restoreCriteriaList += ($restoreCriteria)
                $restoreRequest.RestoreTargetInfo.RestoreCriterion = $restoreCriteriaList
            }
        }        
        else 
        {
            # ILR: ItemLevelRestoreTargetInfo
            $restoreRequest.RestoreTargetInfo = [Microsoft.Azure.PowerShell.Cmdlets.DataProtection.Models.Api20240401.ItemLevelRestoreTargetInfo]::new()
            $restoreRequest.RestoreTargetInfo.ObjectType = "itemLevelRestoreTargetInfo"

            $restoreCriteriaList = @()
            
            # can generalise this condition to manifest level if needed
            if($DatasourceType -ne "AzureKubernetesService"){ # TODO: remove Datasource dependency
                
                if(($RecoveryPoint -ne $null) -and ($RecoveryPoint -ne "") -and $ContainersList.length -gt 0){
                    $hasPrefixMatch = $PSBoundParameters.Remove("PrefixMatch")
                    for($i = 0; $i -lt $ContainersList.length; $i++){
                                
                        $restoreCriteria = [Microsoft.Azure.PowerShell.Cmdlets.DataProtection.Models.Api20240401.ItemPathBasedRestoreCriteria]::new()

                        $restoreCriteria.ObjectType = "ItemPathBasedRestoreCriteria"
                        $restoreCriteria.ItemPath = $ContainersList[$i]
                        $restoreCriteria.IsPathRelativeToBackupItem = $true

                        if($hasPrefixMatch){
                            $pathPrefix = $PrefixMatch[$ContainersList[$i]]
                            if($pathPrefix -ne $null -and !($pathPrefix -is [Array])){
                                throw "values for PrefixMatch must be string array for each container"
                            }
                            $restoreCriteria.SubItemPathPrefix = $pathPrefix
                        }

                        # adding a criteria for each container given
                        $restoreCriteriaList += ($restoreCriteria)
                    }
                }
                elseif($ContainersList.length -gt 0){
                    for($i = 0; $i -lt $ContainersList.length; $i++){
                                
                        $restoreCriteria = [Microsoft.Azure.PowerShell.Cmdlets.DataProtection.Models.Api20240401.RangeBasedItemLevelRestoreCriteria]::new()

                        $restoreCriteria.ObjectType = "RangeBasedItemLevelRestoreCriteria"
                        $restoreCriteria.MinMatchingValue = $ContainersList[$i]
                        $restoreCriteria.MaxMatchingValue = $ContainersList[$i] + "-0"

                        # adding a criteria for each container given
                        $restoreCriteriaList += ($restoreCriteria)
                    }
                }
                elseif($FromPrefixPattern.length -gt 0){
                
                    if(($FromPrefixPattern.length -ne $ToPrefixPattern.length) -or ($FromPrefixPattern.length -gt 10) -or ($ToPrefixPattern.length -gt 10)){
                        $errormsg = "FromPrefixPattern and ToPrefixPattern parameters maximum length can be 10 and must be equal "
    			        throw $errormsg
                    }
                
                    for($i = 0; $i -lt $FromPrefixPattern.length; $i++){
                                
                        $restoreCriteria =  [Microsoft.Azure.PowerShell.Cmdlets.DataProtection.Models.Api20240401.RangeBasedItemLevelRestoreCriteria]::new()

                        $restoreCriteria.ObjectType = "RangeBasedItemLevelRestoreCriteria"
                        $restoreCriteria.MinMatchingValue = $FromPrefixPattern[$i]
                        $restoreCriteria.MaxMatchingValue = $ToPrefixPattern[$i]

                        # adding a criteria for each container given
                        $restoreCriteriaList += ($restoreCriteria)
                    }                
                }    
                else{
                     $errormsg = "Provide ContainersList or Prefixes for Item Level Recovery"
    			     throw $errormsg            
                }
            }
            else{
                # ItemLevelRecovery for AzureKubernetesService
                if($RestoreConfiguration -ne $null){
                    $restoreCriteria = $RestoreConfiguration
                }
                else{
                    $errormsg = "Please input parameter RestoreConfiguration for AKS cluster restore. Use command New-AzDataProtectionRestoreConfigurationClientObject for creating the RestoreConfiguration"
    		        throw $errormsg
                }
                
                $restoreCriteriaList += ($restoreCriteria)
            }

            $restoreRequest.RestoreTargetInfo.RestoreCriterion = $restoreCriteriaList
        }

        # Fill other fields of Restore Object based on inputs given        
        $restoreRequest.SourceDataStoreType = $SourceDataStore
        $restoreRequest.RestoreTargetInfo.RestoreLocation = $RestoreLocation

        
        if($RestoreType -eq "AlternateLocation"){

            if(($TargetResourceId -eq $null) -or ($TargetResourceId -eq ""))
            {
                $errormsg = "Please input TargetResourceId for alternate location recovery"
    		    throw $errormsg
            }
            $resourceId = $TargetResourceId
        }
        elseif($RestoreType -eq "OriginalLocation"){

            if(($BackupInstance -eq $null) -or ($BackupInstance -eq ""))
            {                
                $errormsg = "Please input BackupInstance for original location recovery"
    		    throw $errormsg
            }
            $resourceId = $BackupInstance.Property.DataSourceInfo.ResourceId
        }

        if( ($resourceId -ne $null) -and ($resourceId -ne "") )
        {            
            # set DatasourceInfo for OLR, ALR, OriginalLocationILR
            $restoreRequest.RestoreTargetInfo.DatasourceInfo = GetDatasourceInfo -ResourceId $resourceId -ResourceLocation $RestoreLocation -DatasourceType $DatasourceType
            
            if($manifest.isProxyResource -eq $true)  
            {
                $restoreRequest.RestoreTargetInfo.DatasourceSetInfo = GetDatasourceSetInfo -DatasourceInfo $restoreRequest.RestoreTargetInfo.DatasourceInfo -DatasourceType $DatasourceType
            }
        } 
        
        # secret store authentication
        if($PSBoundParameters.ContainsKey("SecretStoreURI"))
        {
            if($manifest.supportSecretStoreAuthentication -eq $true){
                if(!($PSBoundParameters.ContainsKey("SecretStoreType")))
                {        
                    $errormsg = "Please input SecretStoreType"
        		    throw $errormsg                    
                }
                $restoreRequest.RestoreTargetInfo.DatasourceAuthCredentials = [Microsoft.Azure.PowerShell.Cmdlets.DataProtection.Models.Api20240401.SecretStoreBasedAuthCredentials]::new()
                $restoreRequest.RestoreTargetInfo.DatasourceAuthCredentials.ObjectType = "SecretStoreBasedAuthCredentials"
                $restoreRequest.RestoreTargetInfo.DatasourceAuthCredentials.SecretStoreResource =  [Microsoft.Azure.PowerShell.Cmdlets.DataProtection.Models.Api20240401.SecretStoreResource]::new()
                $restoreRequest.RestoreTargetInfo.DatasourceAuthCredentials.SecretStoreResource.SecretStoreType = $SecretStoreType
                $restoreRequest.RestoreTargetInfo.DatasourceAuthCredentials.SecretStoreResource.Uri = $SecretStoreURI
            }
            else{
                $errormsg = "Please ensure that secret store based authentication is supported for given data source"
        		throw $errormsg
            }            
        }

        return $restoreRequest
    }
}
# SIG # Begin signature block
# MIIoQwYJKoZIhvcNAQcCoIIoNDCCKDACAQExDzANBglghkgBZQMEAgEFADB5Bgor
# BgEEAYI3AgEEoGswaTA0BgorBgEEAYI3AgEeMCYCAwEAAAQQH8w7YFlLCE63JNLG
# KX7zUQIBAAIBAAIBAAIBAAIBADAxMA0GCWCGSAFlAwQCAQUABCARERpVcK//U0xi
# QSw/1BojPlg+TAhZJ3vp57jyS73XEaCCDXYwggX0MIID3KADAgECAhMzAAAEBGx0
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
# MAwGCisGAQQBgjcCARUwLwYJKoZIhvcNAQkEMSIEIF18htah8AIE9kULlHtB40Db
# X7Sryw5yiptZU1QGt8HyMEIGCisGAQQBgjcCAQwxNDAyoBSAEgBNAGkAYwByAG8A
# cwBvAGYAdKEagBhodHRwOi8vd3d3Lm1pY3Jvc29mdC5jb20wDQYJKoZIhvcNAQEB
# BQAEggEAWZTRMz92UmvuonRnUGgTYp4gqmuNFtqJGpAdCNtblKV2IcZvxkeRwmzK
# q0//9drznIF6iqAbq1ohJATrhmia/ddid4/Xem27/TqAbnlb9z06M370St+IZWJE
# Lc5hpMphlHDKCx4xcpZJxat1l+U6VBKHdXYWd08qZd4HaohkgWDVct5jbyPnpr35
# ggiUo3/GLzDI7X8/g2/9GkKBK0KKh/sLJlgz0MX4yv/ibGRhsDpCF1YCnLVxoi8T
# XUpxMdzwgB3x0uiazAaKUFos1VAgbfxeLR6vWx0idYHDmrxI8N50SkUr+rzbfvvH
# J4dGHf3TWy2Wpijn8/zA7DJLbIt42KGCF60wghepBgorBgEEAYI3AwMBMYIXmTCC
# F5UGCSqGSIb3DQEHAqCCF4YwgheCAgEDMQ8wDQYJYIZIAWUDBAIBBQAwggFaBgsq
# hkiG9w0BCRABBKCCAUkEggFFMIIBQQIBAQYKKwYBBAGEWQoDATAxMA0GCWCGSAFl
# AwQCAQUABCCeEVgQ+KsAZH08mmeZf/AwwBM+jB5Mx52K/J3iWtXAAAIGZuthA1Nc
# GBMyMDI0MTEwMTE1MDQxNi4xOTZaMASAAgH0oIHZpIHWMIHTMQswCQYDVQQGEwJV
# UzETMBEGA1UECBMKV2FzaGluZ3RvbjEQMA4GA1UEBxMHUmVkbW9uZDEeMBwGA1UE
# ChMVTWljcm9zb2Z0IENvcnBvcmF0aW9uMS0wKwYDVQQLEyRNaWNyb3NvZnQgSXJl
# bGFuZCBPcGVyYXRpb25zIExpbWl0ZWQxJzAlBgNVBAsTHm5TaGllbGQgVFNTIEVT
# Tjo1OTFBLTA1RTAtRDk0NzElMCMGA1UEAxMcTWljcm9zb2Z0IFRpbWUtU3RhbXAg
# U2VydmljZaCCEfswggcoMIIFEKADAgECAhMzAAAB9BdGhcDLPznlAAEAAAH0MA0G
# CSqGSIb3DQEBCwUAMHwxCzAJBgNVBAYTAlVTMRMwEQYDVQQIEwpXYXNoaW5ndG9u
# MRAwDgYDVQQHEwdSZWRtb25kMR4wHAYDVQQKExVNaWNyb3NvZnQgQ29ycG9yYXRp
# b24xJjAkBgNVBAMTHU1pY3Jvc29mdCBUaW1lLVN0YW1wIFBDQSAyMDEwMB4XDTI0
# MDcyNTE4MzA1OVoXDTI1MTAyMjE4MzA1OVowgdMxCzAJBgNVBAYTAlVTMRMwEQYD
# VQQIEwpXYXNoaW5ndG9uMRAwDgYDVQQHEwdSZWRtb25kMR4wHAYDVQQKExVNaWNy
# b3NvZnQgQ29ycG9yYXRpb24xLTArBgNVBAsTJE1pY3Jvc29mdCBJcmVsYW5kIE9w
# ZXJhdGlvbnMgTGltaXRlZDEnMCUGA1UECxMeblNoaWVsZCBUU1MgRVNOOjU5MUEt
# MDVFMC1EOTQ3MSUwIwYDVQQDExxNaWNyb3NvZnQgVGltZS1TdGFtcCBTZXJ2aWNl
# MIICIjANBgkqhkiG9w0BAQEFAAOCAg8AMIICCgKCAgEApwhOE6bQgC9qq4jJGX2A
# 1yoObfk0qetQ8kkj+5m37WBxDlsZ5oJnjfzHspqPiOEVzZ2y2ygGgNZ3/xdZQN7f
# 9A1Wp1Adh5qHXZZh3SBX8ABuc69Tb3cJ5KCZcXDsufwmXeCj81EzJEIZquVdV8ST
# lQueB/b1MIYt5RKis3uwzdlfSl0ckHbGzoO91YTKg6IExqKYojGreCopnIKxOvkr
# 5VZsj2f95Bb1LGEvuhBIm/C7JysvJvBZWNtrspzyXVnuo+kDEyZwpkphsR8Zvdi+
# s/pQiofmdbW1UqzWlqXQVgoYXbaYkEyaSh/heBtwj1tue+LcuOcHAPgbwZvQLksK
# aK46oktregOR4e0icsGiAWR9IL+ny4mlCUNA84F7GEEWOEvibig7wsrTa6ZbzuMs
# yTi2Az4qPV3QRkFgxSbp4R4OEKnin8Jz4XLI1wXhBhIpMGfA3BT850nqamzSiD5L
# 5px+VtfCi0MJTS2LDF1PaVZwlyVZIVjVHK8oh2HYG9T26FjR9/I85i5ExxmhHpxM
# 2Z+UhJeZA6Lz452m/+xrA4xrdYas5cm7FUhy24rPLVH+Fy+ZywHAp9c9oWTrtjfI
# KqLIvYtgJc41Q8WxbZPR7B1uft8BFsvz2dOSLkxPDLcXWy16ANy73v0ipCxAwUEC
# 9hssi0LdB8ThiNf/4A+RZ8sCAwEAAaOCAUkwggFFMB0GA1UdDgQWBBQrdGWhCtEs
# Pid1LJzsTaLTKQbfmzAfBgNVHSMEGDAWgBSfpxVdAF5iXYP05dJlpxtTNRnpcjBf
# BgNVHR8EWDBWMFSgUqBQhk5odHRwOi8vd3d3Lm1pY3Jvc29mdC5jb20vcGtpb3Bz
# L2NybC9NaWNyb3NvZnQlMjBUaW1lLVN0YW1wJTIwUENBJTIwMjAxMCgxKS5jcmww
# bAYIKwYBBQUHAQEEYDBeMFwGCCsGAQUFBzAChlBodHRwOi8vd3d3Lm1pY3Jvc29m
# dC5jb20vcGtpb3BzL2NlcnRzL01pY3Jvc29mdCUyMFRpbWUtU3RhbXAlMjBQQ0El
# MjAyMDEwKDEpLmNydDAMBgNVHRMBAf8EAjAAMBYGA1UdJQEB/wQMMAoGCCsGAQUF
# BwMIMA4GA1UdDwEB/wQEAwIHgDANBgkqhkiG9w0BAQsFAAOCAgEA3cHSDxJKUDsg
# acIfRX60ugODShsBqwtEURUbUXeDmYYSa5oFj34RujW3gOeCt/ObDO45vfpnYG5O
# S5YowwsFw19giCI6JV+ccG/qqM08nxASbzwWtqtorzQiJh9upsE4TVZeKYXmbyx7
# WN9tdbVIrCelVj7P6ifMHTSLt6BmyoS2xlC2cfgKPPA13vS3euqUl6zwe7GAhjfj
# NXjKlE4SNWJvdqgrv0GURKjqmamNvhmSJane6TYzpdDCegq8adlGH85I1EWKmfER
# b1lzKy5OMO2e9IkAlvydpUun0C3sNEtp0ehliT0Sraq8jcYVDH4A2C/MbLBIwikj
# wiFGQ4SlFLT2Tgb4GvvpcWVzBxwDo9IRBwpzngbyzbhh95UVOrQL2rbWHrHDSE3d
# gdL2yuaHRgY7HYYLs5Lts30wU9Ouh8N54RUta6GFZFx5A4uITgyJcVdWVaN0qjs0
# eEjwEyNUv0cRLuHWJBejkMe3qRAhvCjnhro7DGRWaIldyfzZqln6FsnLQ3bl+ZvV
# JWTYJuL+IZLI2Si3IrIRfjccn29X2BX/vz2KcYubIjK6XfYvrZQN4XKbnvSqBNAw
# IPY2xJeB4o9PDEFI2rcPaLUyz5IV7JP3JRpgg3xsUqvFHlSG6uMIWjwH0GQIIwrC
# 2zRy+lNZsOKnruyyHMQTP7jy5U92qEEwggdxMIIFWaADAgECAhMzAAAAFcXna54C
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
# Tjo1OTFBLTA1RTAtRDk0NzElMCMGA1UEAxMcTWljcm9zb2Z0IFRpbWUtU3RhbXAg
# U2VydmljZaIjCgEBMAcGBSsOAwIaAxUAv+LZ/Vg0s17Xek4iG9R9c/7+AI6ggYMw
# gYCkfjB8MQswCQYDVQQGEwJVUzETMBEGA1UECBMKV2FzaGluZ3RvbjEQMA4GA1UE
# BxMHUmVkbW9uZDEeMBwGA1UEChMVTWljcm9zb2Z0IENvcnBvcmF0aW9uMSYwJAYD
# VQQDEx1NaWNyb3NvZnQgVGltZS1TdGFtcCBQQ0EgMjAxMDANBgkqhkiG9w0BAQsF
# AAIFAOrPNc4wIhgPMjAyNDExMDExMTExMTBaGA8yMDI0MTEwMjExMTExMFowdDA6
# BgorBgEEAYRZCgQBMSwwKjAKAgUA6s81zgIBADAHAgEAAgISKDAHAgEAAgITezAK
# AgUA6tCHTgIBADA2BgorBgEEAYRZCgQCMSgwJjAMBgorBgEEAYRZCgMCoAowCAIB
# AAIDB6EgoQowCAIBAAIDAYagMA0GCSqGSIb3DQEBCwUAA4IBAQCbuFnbxY0xbj+G
# PbuTdYHZl4s9LOjeIGYjTEdcbPym8G3HFlCTjhc0/2oi8DRKNwYLSRlU2B0vpGSn
# OZTnreY7rzTnop4HX2gqOsNFPtLPZ9bxk655hC33l3A3fBCo+gM7707+OKcDKdty
# R1UNAN8Kqsur5Om3sdg3YNObbWxzFFMsIY4idtW/AG2Go/+V2wd5RwuMjiMLLKKb
# sYVnCRyWpi2bDm7k6LhSBEGQJ0g+M8AtNV4itIioVbl7C1OZdh+X+bCRRZ7ZJI6p
# a3MXjamAuUwZGI1ZRZhi3kw1IbipUHX8hAykBLccq7ux54g4vxWkW40mklil4wUQ
# f1SQLyX8MYIEDTCCBAkCAQEwgZMwfDELMAkGA1UEBhMCVVMxEzARBgNVBAgTCldh
# c2hpbmd0b24xEDAOBgNVBAcTB1JlZG1vbmQxHjAcBgNVBAoTFU1pY3Jvc29mdCBD
# b3Jwb3JhdGlvbjEmMCQGA1UEAxMdTWljcm9zb2Z0IFRpbWUtU3RhbXAgUENBIDIw
# MTACEzMAAAH0F0aFwMs/OeUAAQAAAfQwDQYJYIZIAWUDBAIBBQCgggFKMBoGCSqG
# SIb3DQEJAzENBgsqhkiG9w0BCRABBDAvBgkqhkiG9w0BCQQxIgQgHaVkHQz5sqnj
# OQAOZEl1ZGjskkor71viUIzEAgk8u0IwgfoGCyqGSIb3DQEJEAIvMYHqMIHnMIHk
# MIG9BCA/WMJ8biaT6njvkknB8Q7hSQIi8ys6vIBvZg60RBjWazCBmDCBgKR+MHwx
# CzAJBgNVBAYTAlVTMRMwEQYDVQQIEwpXYXNoaW5ndG9uMRAwDgYDVQQHEwdSZWRt
# b25kMR4wHAYDVQQKExVNaWNyb3NvZnQgQ29ycG9yYXRpb24xJjAkBgNVBAMTHU1p
# Y3Jvc29mdCBUaW1lLVN0YW1wIFBDQSAyMDEwAhMzAAAB9BdGhcDLPznlAAEAAAH0
# MCIEIMhkEo/fFznPQATQ4VPPXyUO1qYEug0RwKROWHge9EZTMA0GCSqGSIb3DQEB
# CwUABIICAAu/l7h7s9SF7dEojR8+ntrnpNZ00TimLn7N9P+rsVbi1T9QA+WVBUHZ
# 5TgZDz0J8rpuA5yYBU5aBXTlUvYQ0ZgvPLcQwG7gDR6lN+0eY77XyBc1nGhBZ0aE
# wwnZJD4lsd5txPX5yMP0USwQKE4ElfPl9ts2zw8xBtZcoBfWjJ6GF0TFuFO/CPML
# MDaACF0pNY6KK8e5XgrtXuAXgkBFZC1Or0YwFPtW8M/a+DqV1X4PfJZsM5OjepKh
# gjAD1lnsNfC97/7Y17inuDPeJ72LAQ+FsriGZBdHevXBeiONYMw7/FjhjNvZ3dlw
# 3KHYR0zQ4m9u81KfWzUE2MxM/PlBHlpVzwhKL0632IM2mvoBpRZDv9sZpAMxa1a7
# BJxPUxozL8Cq9dMMl7XaQ+Wgi+8ZHKmux+yxk66uOBBIac+pyp4PSvLnW/Bxnfyg
# 4CEvOGOU9nZEWwi83oZSlBgV298WH+YIpxQACHKQurDW3nYzZIghcG2yVxYJgfiL
# POC0ef8CfF/bA0BrRXYZVT5ksE5gJh8OwI864YRkffTBj19Q6Bap2JrMzNe36JKN
# Ln9GcyqxpB7QXMWpQwVqCnNTzBMLXxPzXDe07JmPeG2/6qAc8snFA0r8hq08YZQX
# eWYdcGGUbf/NW4ag/VPan4N5Jym0ZiIKGwOXdVK1/6XtUqR+OVi0
# SIG # End signature block
