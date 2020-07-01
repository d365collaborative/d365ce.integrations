@{
    # Script module or binary module file associated with this manifest
    RootModule        = 'd365ce.integrations.psm1'
	
    # Version number of this module.
    ModuleVersion     = '0.2.3'
	
    # ID used to uniquely identify this module
    GUID              = '05212d7b-cf13-42b7-9573-e1470803d03d'
	
    # Author of this module
    Author            = 'Mötz Jensen'
	
    # Company or vendor of this module
    CompanyName       = 'Essence Solutions'
	
    # Copyright statement for this module
    Copyright         = 'Copyright (c) 2019 Mötz Jensen'
	
    # Description of the functionality provided by this module
    Description       = 'Tools for working against the OData endpoint with the Dynamics 365 Customer Engagement (D365CE) platform'
	
    # Minimum version of the Windows PowerShell engine required by this module
    PowerShellVersion = '5.0'
	
    # Modules that must be imported into the global environment prior to importing
    # this module
    RequiredModules   = @(
        @{ ModuleName = 'PSFramework'; ModuleVersion = '1.0.19' }
        ,	@{ ModuleName = 'PSNotification'; ModuleVersion = '0.5.3' }
        ,	@{ ModuleName = 'PSOAuthHelper'; ModuleVersion = '0.2.5' }
    )
	
    # Assemblies that must be loaded prior to importing this module
    # RequiredAssemblies = @('bin\d365ce.integrations.dll')
	
    # Type files (.ps1xml) to be loaded when importing this module
    # TypesToProcess = @('xml\d365ce.integrations.Types.ps1xml')
	
    # Format files (.ps1xml) to be loaded when importing this module
    # FormatsToProcess = @('xml\d365ce.integrations.Format.ps1xml')
	
    # Functions to export from this module
    FunctionsToExport = @(
            'Add-D365CeODataConfig'
        ,	'Enable-D365CeException'
		
        ,   'Get-D365CeActiveODataConfig'
        ,	'Get-D365CeODataConfig'
        ,   'Get-D365CeODataEntity'
        ,   'Get-D365CeODataEntityData'
        ,	'Get-D365CeODataEntityDataByKey'
        
        ,   'Import-D365CeODataEntity'
        ,   'Import-D365CeODataEntityBatchMode'
        
        ,   'Remove-D365CeODataEntity'
        ,	'Set-D365CeActiveODataConfig'
        ,   'Update-D365CeODataEntity'
    )
	
    # Cmdlets to export from this module
    CmdletsToExport   = ''
	
    # Variables to export from this module
    VariablesToExport = ''
	
    # Aliases to export from this module
    AliasesToExport   = ''
	
    # List of all modules packaged with this module
    ModuleList        = @()
	
    # List of all files packaged with this module
    FileList          = @()
	
    # Private data to pass to the module specified in ModuleToProcess. This may also contain a PSData hashtable with additional module metadata used by PowerShell.
    PrivateData       = @{
		
        #Support for PowerShellGet galleries.
        PSData = @{
			
            # Tags applied to this module. These help with module discovery in online galleries.
            Tags         = @('d365ce', 'Dynamics365', 'D365', 'CustomerEngagement', 'CE', 'CRM', 'Dynamics365CE', 'Dynamics365Sales')
			
            # A URL to the license for this module.
            LicenseUri   = "https://opensource.org/licenses/MIT"
			
            # A URL to the main website for this project.
            ProjectUri   = 'https://github.com/d365collaborative/d365ce.integrations'
			
            # A URL to an icon representing this module.
            # IconUri = ''
			
            # ReleaseNotes of this module
            # ReleaseNotes = ''
			
            IsPrerelease = 'True'

        } # End of PSData hashtable
		
    } # End of PrivateData hashtable
}