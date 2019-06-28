@{
	# Script module or binary module file associated with this manifest
	ModuleToProcess = 'd365ce.integrations.psm1'
	
	# Version number of this module.
	ModuleVersion = '1.0.0'
	
	# ID used to uniquely identify this module
	GUID = '05212d7b-cf13-42b7-9573-e1470803d03d'
	
	# Author of this module
	Author = 'Motz'
	
	# Company or vendor of this module
	CompanyName = 'MyCompany'
	
	# Copyright statement for this module
	Copyright = 'Copyright (c) 2019 Motz'
	
	# Description of the functionality provided by this module
	Description = ''
	
	# Minimum version of the Windows PowerShell engine required by this module
	PowerShellVersion = '5.0'
	
	# Modules that must be imported into the global environment prior to importing
	# this module
	RequiredModules = @(
		@{ ModuleName='PSFramework'; ModuleVersion='1.0.19' }
	)
	
	# Assemblies that must be loaded prior to importing this module
	# RequiredAssemblies = @('bin\d365ce.integrations.dll')
	
	# Type files (.ps1xml) to be loaded when importing this module
	# TypesToProcess = @('xml\d365ce.integrations.Types.ps1xml')
	
	# Format files (.ps1xml) to be loaded when importing this module
	# FormatsToProcess = @('xml\d365ce.integrations.Format.ps1xml')
	
	# Functions to export from this module
	FunctionsToExport = @(
        	'Add-D365ODataConfig'
		,	'Enable-d365Exception'
		
        ,   'Get-D365ActiveODataConfig'
        ,	'Get-D365ODataConfig'
        ,   'Get-D365ODataEntityData'
        
        ,   'Import-D365ODataEntity'
        ,   'Import-D365ODataEntityBatchMode'
        
        ,   'Remove-D365ODataEntity'
        ,	'Set-D365ActiveODataConfig'

    )
	
	# Cmdlets to export from this module
	CmdletsToExport = ''
	
	# Variables to export from this module
	VariablesToExport = ''
	
	# Aliases to export from this module
	AliasesToExport = ''
	
	# List of all modules packaged with this module
	ModuleList = @()
	
	# List of all files packaged with this module
	FileList = @()
	
	# Private data to pass to the module specified in ModuleToProcess. This may also contain a PSData hashtable with additional module metadata used by PowerShell.
	PrivateData = @{
		
		#Support for PowerShellGet galleries.
		PSData = @{
			
			# Tags applied to this module. These help with module discovery in online galleries.
			# Tags = @()
			
			# A URL to the license for this module.
			# LicenseUri = ''
			
			# A URL to the main website for this project.
			# ProjectUri = ''
			
			# A URL to an icon representing this module.
			# IconUri = ''
			
			# ReleaseNotes of this module
			# ReleaseNotes = ''
			
		} # End of PSData hashtable
		
	} # End of PrivateData hashtable
}