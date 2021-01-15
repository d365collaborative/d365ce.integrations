
<#
    .SYNOPSIS
        Update the broadcast message config variables
        
    .DESCRIPTION
        Update the active broadcast message config variables that the module will use as default values
        
    .EXAMPLE
        PS C:\> Update-BroadcastVariables
        
        This will update the broadcast variables.
        
    .NOTES
        Author: Mötz Jensen (@Splaxi)
#>

function Update-ODataVariables {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseShouldProcessForStateChangingFunctions", "")]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseSingularNouns", "")]
    [CmdletBinding()]
    [OutputType()]
    param ( )
    
    $configName = (Get-PSFConfig -FullName "d365ce.integrations.active.odata.config.name").Value

    if (([string]::IsNullOrEmpty($configName))) {
        return
    }

    $configName = $configName.ToString().ToLower()
    
    if (-not ($configName -eq "")) {
        $configHash = Get-D365CeActiveODataConfig -OutputAsHashtable
        foreach ($item in $configHash.Keys) {
            if ($item -eq "name") { continue }
            
            $name = "OData" + (Get-Culture).TextInfo.ToTitleCase($item)
        
            $valueMessage = $configHash[$item]

            if ($item -like "*client*" -and $valueMessage.Length -gt 20)
            {
                $valueMessage = $valueMessage.Substring(0,18) + "[...REDACTED...]"
            }

            Write-PSFMessage -Level Verbose -Message "$name - $valueMessage" -Target $valueMessage
            Set-Variable -Name $name -Value $configHash[$item] -Scope Script
        }
    }
}