
<#
    .SYNOPSIS
        Import a Data Entity into Dynamics 365 Customer Engagement
        
    .DESCRIPTION
        Imports a Data Entity, defined as a json payload, using the OData endpoint of the Dynamics 365 Customer Engagement
        
    .PARAMETER EntityName
        Name of the Data Entity you want to work against
        
        The parameter is Case Sensitive, because the OData endpoint in D365CE is Case Sensitive
        
        Remember that most Data Entities in a D365CE environment is named by its singular name, but most be retrieve using the plural name
        
        E.g. The account Data Entity is named "account", but can only be retrieving using "accounts"
        
        Use the XRMToolBox (https://www.xrmtoolbox.com) to help you identify the names of the Data Entities that you are looking for
        
    .PARAMETER Payload
        The entire string contain the json object that you want to import into the D365CE environment
        
        Remember that json is text based and can use either single quotes (') or double quotes (") as the text qualifier, so you might need to escape the different quotes in your payload before passing it in
        
    .PARAMETER PayloadCharset
        The charset / encoding that you want the cmdlet to use while importing the odata entity
        
        The default value is: "UTF8"
        
        The charset has to be a valid http charset like: ASCII, ANSI, ISO-8859-1, UTF-8
        
    .PARAMETER RefPath
        Path for working with the referene capabilities of the OData endpoint
        
        Can be used to map / assiociate an entity to another, like systemuser to a role
        
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
        
    .EXAMPLE
        PS C:\> Import-D365CeODataEntity -EntityName "ExchangeRates" -Payload '{"@odata.type" :"Microsoft.Dynamics.DataEntities.ExchangeRate", "RateTypeName": "TEST", "FromCurrency": "DKK", "ToCurrency": "EUR", "StartDate": "2019-01-03T00:00:00Z", "Rate": 745.10, "ConversionFactor": "Hundred", "RateTypeDescription": "TEST"}'
        
        This will import a Data Entity into Dynamics 365 Customer Engagement using the OData endpoint.
        The EntityName used for the import is ExchangeRates.
        The Payload is a valid json string, containing all the needed properties.
        
    .EXAMPLE
        PS C:\> $Payload = '{"@odata.type" :"Microsoft.Dynamics.DataEntities.ExchangeRate", "RateTypeName": "TEST", "FromCurrency": "DKK", "ToCurrency": "EUR", "StartDate": "2019-01-03T00:00:00Z", "Rate": 745.10, "ConversionFactor": "Hundred", "RateTypeDescription": "TEST"}'
        PS C:\> Import-D365CeODataEntity -EntityName "ExchangeRates" -Payload $Payload
        
        This will import a Data Entity into Dynamics 365 Customer Engagement using the OData endpoint.
        First the desired json data is put into the $Payload variable.
        The EntityName used for the import is ExchangeRates.
        The $Payload variable is passed to the cmdlet.
        
    .EXAMPLE
        PS C:\> $Payload = '{"@odata.id":"[Organization URI]/api/data/v9.0/roles(00000000-0000-0000-0000-000000000001)"}'
        PS C:\> Import-D365CeODataEntity -EntityName "systemusers" -Payload $Payload -RefPath '(00000000-0000-0000-0000-000000000002)/systemuserroles_association/$ref'
        
        This will create a referene between the systemusers Data Entity and the systemuserroles in Dynamics 365 Customer Engagement using the OData endpoint.
        First the desired json data is put into the $Payload variable.
        The EntityName used for the import is systemusers.
        The RefPath '(00000000-0000-0000-0000-000000000002)/systemuserroles_association/$ref' is the systemuser "00000000-0000-0000-0000-000000000002" which you want to associate with the role "00000000-0000-0000-0000-000000000001"
        The $Payload variable is passed to the cmdlet.
        
    .NOTES
        Tags: OData, Data, Entity, Import, Upload
        
        Author: Mötz Jensen (@Splaxi)
        
        The reference parameter was implemented based on the details on this stackoverflow post: https://stackoverflow.com/questions/51238107/associate-role-to-a-user-microsoft-dynamics-crm-rest-api
        
    .LINK
        Add-D365CeODataConfig
        
    .LINK
        Get-D365CeActiveODataConfig
        
    .LINK
        Set-D365CeActiveODataConfig
#>

function Import-D365CeODataEntity {
    [CmdletBinding()]
    [OutputType()]
    param (
        [Parameter(Mandatory = $true)]
        [string] $EntityName,

        [Parameter(Mandatory = $true)]
        [Alias('Json')]
        [AllowEmptyString()]
        [string] $Payload,

        [string] $PayloadCharset = "UTF-8",

        [string] $RefPath,

        [Alias('$AADGuid')]
        [string] $Tenant = $Script:ODataTenant,

        [Alias('URI')]
        [string] $URL = $Script:ODataUrl,

        [string] $ClientId = $Script:ODataClientId,

        [string] $ClientSecret = $Script:ODataClientSecret,

        [switch] $EnableException

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

        $PayloadCharset = $PayloadCharset.ToLower()
        if ($PayloadCharset -like "utf*" -and $PayloadCharset -notlike "utf-*") {
            $PayloadCharset = $PayloadCharset -replace "utf", "utf-"
        }
    }

    process {
        Invoke-TimeSignal -Start

        Write-PSFMessage -Level Verbose -Message "Building request for the OData endpoint for entity named: $EntityName." -Target $EntityName
        
        [System.UriBuilder] $odataEndpoint = $URL

        $odataEndpoint.Path = "$apiPath/$EntityName" + $RefPath

        try {
            Write-PSFMessage -Level Verbose -Message "Executing http request against the OData endpoint." -Target $($odataEndpoint.Uri.AbsoluteUri)
            Invoke-RestMethod -Method POST -Uri $odataEndpoint.Uri.AbsoluteUri -Headers $headers -ContentType "application/json;charset=$PayloadCharset" -Body $Payload
        }
        catch {
            $messageString = "Something went wrong while importing data through the OData endpoint for the entity: $EntityName"
            Write-PSFMessage -Level Host -Message $messageString -Exception $PSItem.Exception -Target $EntityName
            Stop-PSFFunction -Message "Stopping because of errors." -Exception $([System.Exception]::new($($messageString -replace '<[^>]+>', ''))) -ErrorRecord $_
            return
        }

        Invoke-TimeSignal -End
    }
}