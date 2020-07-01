
<#
    .SYNOPSIS
        Get public OData Data Entity and their metadata
        
        
    .DESCRIPTION
        Get a list with all the available OData Data Entities,and their metadata, that are exposed through the OData endpoint of the Dynamics 365 Customer Engagement instance
        
        The cmdlet will search across the singular names for the Data Entities and across the collection names (plural)
        
    .PARAMETER EntityName
        Name of the Data Entity you are searching for
        
        The parameter is Case Insensitive, to make it easier for the user to locate the correct Data Entity
        
    .PARAMETER EntityNameContains
        Name of the Data Entity you are searching for, but instructing the cmdlet to use search logic
        
        Using this parameter enables you to supply only a portion of the name for the entity you are looking for, and still a valid result back
        
        The parameter is Case Insensitive, to make it easier for the user to locate the correct Data Entity
        
    .PARAMETER ODataQuery
        Valid OData query string that you want to pass onto the D365 OData endpoint while retrieving data
        
        Important note:
        If you are using -EntityName along with the -ODataQuery, you need to understand that the "$filter" query is already started. Then you need to start with -ODataQuery ' and XYZ eq XYZ', e.g. -ODataQuery ' and IsReadOnly eq false'
        If you are using the -ODataQuery alone, you need to start the OData Query string correctly. -ODataQuery '$filter=IsReadOnly eq false'
        
        OData specific query options are:
        $filter
        $expand
        $select
        $orderby
        $top
        $skip
        
        Each option has different characteristics, which is well documented at: http://docs.oasis-open.org/odata/odata/v4.0/odata-v4.0-part2-url-conventions.html
        
    .PARAMETER Tenant
        Azure Active Directory (AAD) tenant id (Guid) that the D365CE environment is connected to, that you want to access through OData
        
    .PARAMETER Url
        URL / URI for the D365CE environment you want to access through OData
        
    .PARAMETER ClientId
        The ClientId obtained from the Azure Portal when you created a Registered Application
        
    .PARAMETER ClientSecret
        The ClientSecret obtained from the Azure Portal when you created a Registered Application
        
    .PARAMETER EnableException
        This parameters disables user-friendly warnings and enables the throwing of exceptions
        This is less user friendly, but allows catching exceptions in calling scripts
        
    .PARAMETER RawOutput
        Instructs the cmdlet to include the outer structure of the response received from OData endpoint
        
        The output will still be a PSCustomObject
        
    .PARAMETER OutNamesOnly
        Instructs the cmdlet to only display the DataEntityName and the EntityName from the response received from OData endpoint
        
        DataEntityName is the (logical) name of the entity from a code perspective.
        EntityName is the public OData endpoint name of the entity.
        
    .PARAMETER OutputAsJson
        Instructs the cmdlet to convert the output to a Json string
        
    .EXAMPLE
        PS C:\> Get-D365CeODataEntity -EntityName Account
        
        This will get Data Entities from the OData endpoint.
        This will search for the Data Entities that are named "Account".
        
    .EXAMPLE
        PS C:\> Get-D365CeODataEntity -EntityNameContains Account
        
        This will get Data Entities from the OData endpoint.
        It will use the search string "Account" to search for any entity in their singular & plural name contains that search term.
        
    .EXAMPLE
        PS C:\> Get-D365CeODataEntity -EntityNameContains Account -OutNamesOnly
        
        This will get Data Entities from the OData endpoint.
        It will use the search string "Account" to search for any entity in their singular & plural name contains that search term.
        It will only output the names for the entities and not all their metadata details.
        
    .EXAMPLE
        PS C:\> Get-D365CeODataEntity -ODataQuery "`$filter=IsPrivate eq true" -OutNamesOnly
        
        This will get Data Entities from the OData endpoint.
        It will utilize the OData Query capabilities to filter for Data Entities that are "IsPrivate = $true".
        It will only output the names for the entities and not all their metadata details.
        
    .NOTES
        The OData standard is using the $ (dollar sign) for many functions and features, which in PowerShell is normally used for variables.
        
        Whenever you want to use the different query options, you need to take the $ sign and single quotes into consideration.
        
        Example of an execution where I want the top 1 result only, from a specific legal entity / company.
        This example is using single quotes, to help PowerShell not trying to convert the $ into a variable.
        Because the OData standard is using single quotes as text qualifiers, we need to escape them with multiple single quotes.
        
        -ODataQuery '$top=1&$filter=dataAreaId eq ''Comp1'''
        
        Tags: OData, Data, Entity, Query
        
        Author: MÃ¶tz Jensen (@Splaxi)
#>
function Get-D365CeODataEntity {
    [CmdletBinding(DefaultParameterSetName = "Default")]
    [OutputType()]
    param (

        [Parameter(Mandatory = $false, ParameterSetName = "Default")]
        [string] $EntityName,

        [Parameter(Mandatory = $true, ParameterSetName = "NameContains")]
        [string] $EntityNameContains,

        [string] $ODataQuery,

        [Alias('$AADGuid')]
        [string] $Tenant = $Script:ODataTenant,

        [Alias('URI')]
        [string] $URL = $Script:ODataUrl,

        [string] $ClientId = $Script:ODataClientId,

        [string] $ClientSecret = $Script:ODataClientSecret,

        [switch] $EnableException,

        [switch] $RawOutput,

        [switch] $OutNamesOnly,

        [switch] $OutputAsJson

    )


    begin {
        $bearerParms = @{
            Url          = $Url
            ClientId     = $ClientId
            ClientSecret = $ClientSecret
            Tenant       = $Tenant
        }

        $bearer = New-BearerToken @bearerParms

        $headerParms = @{
            URL         = $URL
            BearerToken = $bearer
        }

        $headers = New-AuthorizationHeaderBearerToken @headerParms

        $apiPath = Get-PSFConfigValue -FullName "d365ce.integrations.api.version"
        [System.UriBuilder] $odataEndpoint = $URL
        $odataEndpoint.Path = "$apiPath/EntityDefinitions"
    }

    process {
        if (Test-PSFFunctionInterrupt) { return }

        Invoke-TimeSignal -Start

        $odataEndpoint.Query = ""
        
        if (-not ([string]::IsNullOrEmpty($EntityName))) {
            Write-PSFMessage -Level Verbose -Message "Building request for the Metadata OData endpoint for entity named: $EntityName." -Target $EntityName

            $searchEntityName = $EntityName
            $odataEndpoint.Query = "`$filter=(LogicalName eq '$EntityName' or SchemaName eq '$EntityName' or LogicalCollectionName eq '$EntityName' or CollectionSchemaName eq '$EntityName' or EntitySetName eq '$EntityName')"
        }
    
        if (-not ([string]::IsNullOrEmpty($ODataQuery))) {
            $odataEndpoint.Query = $($odataEndpoint.Query + "$ODataQuery").Replace("?", "")
        }

        try {
            Write-PSFMessage -Level Verbose -Message "Executing http request against the Metadata OData endpoint." -Target $($odataEndpoint.Uri.AbsoluteUri)
            $res = Invoke-RestMethod -Method Get -Uri $odataEndpoint.Uri.AbsoluteUri -Headers $headers -ContentType 'application/json'

            if (-not ([string]::IsNullOrEmpty($EntityNameContains))) {
                Write-PSFMessage -Level Verbose -Message "Filtering the list of entities for entity that contains: $EntityNameContains." -Target $EntityNameContains

                $searchEntityName = $EntityNameContains

                $res.Value = $res.Value | Where-Object { $_.LogicalName -like "*$EntityNameContains*" `
                        -or $_.SchemaName -like "*$EntityNameContains*" `
                        -or $_.LogicalCollectionName -like "*$EntityNameContains*" `
                        -or $_.CollectionSchemaName -like "*$EntityNameContains*" `
                        -or $_.EntitySetName -like "*$EntityNameContains*" `
                }
            }

            if (-not ($RawOutput)) {
                $res = $res.Value | Sort-Object -Property SchemaName

                if ($OutNamesOnly) {
                    $res = $res | Select-PSFObject "SchemaName as EntityName", "CollectionSchemaName as CollectionSchemaName", "EntitySetName as EntitySetName"
                }
            }

            if ($OutputAsJson) {
                $res | ConvertTo-Json -Depth 10
            }
            else {
                $res
            }
        }
        catch {
            $messageString = "Something went wrong while searching the Metadata OData endpoint for the entity: $searchEntityName"
            Write-PSFMessage -Level Host -Message $messageString -Exception $PSItem.Exception -Target $entityName
            Stop-PSFFunction -Message "Stopping because of errors." -Exception $([System.Exception]::new($($messageString -replace '<[^>]+>', ''))) -ErrorRecord $_
            return
        }

        Invoke-TimeSignal -End
    }
}