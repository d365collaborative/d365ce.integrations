
<#
    .SYNOPSIS
        Get data from an Data Entity using OData
        
    .DESCRIPTION
        Get data from an Data Entity using the OData endpoint of the Dynamics 365 Customer Engagement
        
    .PARAMETER EntityName
        Name of the Data Entity you want to work against
        
        The parameter is Case Sensitive, because the OData endpoint in D365CE is Case Sensitive
        
        Remember that most Data Entities in a D365CE environment is named by its singular name, but most be retrieve using the plural name
        
        E.g. The account Data Entity is named "account", but can only be retrieving using "accounts"
        
        Use the XRMToolBox (https://www.xrmtoolbox.com) to help you identify the names of the Data Entities that you are looking for
        
    .PARAMETER EntitySetName
        Name of the Data Entity you want to work against
        
        The parameter is created specifically to be used when piping from Get-D365CeODataPublicEntity
        
    .PARAMETER ODataQuery
        Valid OData query string that you want to pass onto the D365 OData endpoint while retrieving data
        
        OData specific query options are:
        $filter
        $expand
        $select
        $orderby
        $top
        $skip
        
        Each option has different characteristics, which is well documented at: http://docs.oasis-open.org/odata/odata/v4.0/odata-v4.0-part2-url-conventions.html
        
    .PARAMETER Charset
        The charset / encoding that you want the cmdlet to use while fetching the odata entity
        
        The default value is: "UTF8"
        
        The charset has to be a valid http charset like: ASCII, ANSI, ISO-8859-1, UTF-8
        
    .PARAMETER Tenant
        Azure Active Directory (AAD) tenant id (Guid) that the D365CE environment is connected to, that you want to access through OData
        
    .PARAMETER Url
        URL / URI for the D365CE environment you want to access through OData
        
    .PARAMETER ClientId
        The ClientId obtained from the Azure Portal when you created a Registered Application
        
    .PARAMETER ClientSecret
        The ClientSecret obtained from the Azure Portal when you created a Registered Application
        
    .PARAMETER FullODataMeta
        Instruct the cmdlet to request all metadata to be filled into the payload
        
        Useful when you are looking for navigation properties and linked entities
        
    .PARAMETER EnableException
        This parameters disables user-friendly warnings and enables the throwing of exceptions
        This is less user friendly, but allows catching exceptions in calling scripts
        
    .PARAMETER RawOutput
        Instructs the cmdlet to include the outer structure of the response received from OData endpoint
        
        The output will still be a PSCustomObject
        
    .PARAMETER OutputAsJson
        Instructs the cmdlet to convert the output to a Json string
        
    .EXAMPLE
        PS C:\> Get-D365CeODataEntityData -EntityName accounts -ODataQuery '$top=1'
        
        This will get Accounts from the OData endpoint.
        It will use the "Account" entity, and its EntitySetName / CollectionName "accounts".
        It will get the top 1 results from the list of accounts.
        
        It will use the default OData configuration details that are stored in the configuration store.
        
    .EXAMPLE
        PS C:\> Get-D365CeODataEntityData -EntityName accounts -ODataQuery '$top=1' -FullODataMeta
        
        This will get Accounts, and include all metadata, from the OData endpoint.
        It will use the "Account" entity, and its EntitySetName / CollectionName "accounts".
        It will get the top 1 results from the list of accounts.
        
        It will use the default OData configuration details that are stored in the configuration store.
        
    .EXAMPLE
        PS C:\> Get-D365CeODataEntityData -EntityName accounts -ODataQuery '$top=10&$filter=address1_city eq ''New York'''
        
        This will get Accounts from the OData endpoint.
        It will use the Account entity, and its EntitySetName / CollectionName "Accounts".
        It will get the top 10 results from the list of accounts.
        It will filter the entities for records where the "address1_city" is 'New York'.
        
        It will use the default OData configuration details that are stored in the configuration store.
        
    .LINK
        Add-D365CeODataConfig
        
    .LINK
        Get-D365CeActiveODataConfig
        
    .LINK
        Set-D365CeActiveODataConfig
        
    .NOTES
        The OData standard is using the $ (dollar sign) for many functions and features, which in PowerShell is normally used for variables.
        
        Whenever you want to use the different query options, you need to take the $ sign and single quotes into consideration.
        
        Example of an execution where I want the top 1 result only, with a specific city filled out.
        This example is using single quotes, to help PowerShell not trying to convert the $ into a variable.
        Because the OData standard is using single quotes as text qualifiers, we need to escape them with multiple single quotes.
        
        -ODataQuery '$top=1&$filter=address1_city eq ''New York'''
        
        Tags: OData, Data, Entity, Query
        
        Author: Mötz Jensen (@Splaxi)
        
#>

function Get-D365CeODataEntityData {
    [CmdletBinding(DefaultParameterSetName = "Default")]
    [OutputType()]
    param (
        [Parameter(Mandatory = $true, ParameterSetName = "Specific")]
        [Alias('Name')]
        [string] $EntityName,

        [Parameter(Mandatory = $false)]
        [string] $ODataQuery,

        [string] $Charset = "UTF-8",
        
        [Parameter(Mandatory = $false)]
        [Alias('$AADGuid')]
        [string] $Tenant = $Script:ODataTenant,

        [Parameter(Mandatory = $false)]
        [Alias('URI')]
        [string] $URL = $Script:ODataUrl,

        [Parameter(Mandatory = $false)]
        [string] $ClientId = $Script:ODataClientId,

        [Parameter(Mandatory = $false)]
        [string] $ClientSecret = $Script:ODataClientSecret,

        [switch] $FullODataMeta,

        [switch] $EnableException,

        [switch] $RawOutput,

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

        $Charset = $Charset.ToLower()
        if ($Charset -like "utf*" -and $Charset -notlike "utf-*") {
            $Charset = $Charset -replace "utf", "utf-"
        }
    }

    process {
        Invoke-TimeSignal -Start

        Write-PSFMessage -Level Verbose -Message "Building request for the OData endpoint for entity: $entity." -Target $entity

        [System.UriBuilder] $odataEndpoint = $URL
        
        $odataEndpoint.Path = "$apiPath/$EntityName"

        if (-not ([string]::IsNullOrEmpty($ODataQuery))) {
            $odataEndpoint.Query = "$ODataQuery"
        }

        if($FullODataMeta){
            $headers.Add("Content-Type","application/json; odata.metadata=full; charset=$Charset")
        }
        else {
            $headers.Add("Content-Type","application/json; charset=$Charset")
        }
        
        try {
            Write-PSFMessage -Level Verbose -Message "Executing http request against the OData endpoint." -Target $($odataEndpoint.Uri.AbsoluteUri)
            $res = Invoke-RestMethod -Method Get -Uri $odataEndpoint.Uri.AbsoluteUri -Headers $headers

            if (-not $RawOutput) {
                $res = $res.Value
            }

            if ($OutputAsJson) {
                $res | ConvertTo-Json -Depth 10
            }
            else {
                $res
            }
        }
        catch {
            $messageString = "Something went wrong while retrieving data from the OData endpoint for the entity: $EntityName"
            Write-PSFMessage -Level Host -Message $messageString -Exception $PSItem.Exception -Target $EntityName
            Stop-PSFFunction -Message "Stopping because of errors." -Exception $([System.Exception]::new($($messageString -replace '<[^>]+>', ''))) -ErrorRecord $_
            return
        }

        Invoke-TimeSignal -End
    }
}