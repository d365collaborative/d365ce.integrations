﻿
<#
    .SYNOPSIS
        Get data from an Data Entity using OData, providing a key
        
    .DESCRIPTION
        Get data from an Data Entity, by providing a key, using the OData endpoint of the Dynamics 365 Customer Engagement
        
    .PARAMETER EntityName
        Name of the Data Entity you want to work against
        
        The parameter is Case Sensitive, because the OData endpoint in D365CE is Case Sensitive
        
        Remember that most Data Entities in a D365CE environment is named by its singular name, but most be retrieve using the plural name
        
        E.g. The builtin account Data Entity is named Account, but can only be retrieving using accounts
        
    .PARAMETER Key
        A string value that contains all needed fields and value to be a valid OData key
        
        The key needs to be a valid http encoded value and each datatype needs to handled appropriately
        
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
        
    .PARAMETER OutputAsJson
        Instructs the cmdlet to convert the output to a Json string
        
    .EXAMPLE
        PS C:\> Get-D365CeODataEntityDataByKey -EntityName accounts -Key "accountid=4b306dc7-ab04-4ddf-b18d-d75ffa2dba2c"
        
        This will get the specific Account from the OData endpoint.
        It will use the "Account" entity, and its EntitySetName / CollectionName "accounts".
        It will use the "accountid=4b306dc7-ab04-4ddf-b18d-d75ffa2dba2c" as key to identify the unique Account record.
        
        It will use the default OData configuration details that are stored in the configuration store.
        
    .EXAMPLE
        PS C:\> Get-D365CeODataEntityDataByKey -EntityName accounts -Key "accountid=4b306dc7-ab04-4ddf-b18d-d75ffa2dba2c" -FullODataMeta
        
        This will get the specific Account, and include all metadata, from the OData endpoint.
        It will use the "Account" entity, and its EntitySetName / CollectionName "accounts".
        It will use the "accountid=4b306dc7-ab04-4ddf-b18d-d75ffa2dba2c" as key to identify the unique Account record.
        
        It will use the default OData configuration details that are stored in the configuration store.
        
    .NOTES
        Tags: OData, Data, Entity, Query
        
        Author: Mötz Jensen (@Splaxi)
        
    .LINK
        Add-D365CeODataConfig
        
    .LINK
        Get-D365CeActiveODataConfig
        
    .LINK
        Set-D365CeActiveODataConfig
        
#>

function Get-D365CeODataEntityDataByKey {
    [CmdletBinding(DefaultParameterSetName = "Default")]
    [OutputType()]
    param (
        [Parameter(Mandatory = $true, ParameterSetName = "Specific")]
        [Alias('Name')]
        [string] $EntityName,

        [Parameter(Mandatory = $true, ParameterSetName = "Specific")]
        [string] $Key,

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
        
        $odataEndpoint.Path = "$apiPath/$EntityName($Key)"

        if (-not ([string]::IsNullOrEmpty($ODataQuery))) {
            $odataEndpoint.Query = "$ODataQuery"
        }
        
        if ($FullODataMeta) {
            $headers.Add("Content-Type", "application/json; odata.metadata=full; charset=$Charset")
        }
        else {
            $headers.Add("Content-Type", "application/json; charset=$Charset")
        }
        
        try {
            Write-PSFMessage -Level Verbose -Message "Executing http request against the OData endpoint." -Target $($odataEndpoint.Uri.AbsoluteUri)
            $res = Invoke-RestMethod -Method Get -Uri $odataEndpoint.Uri.AbsoluteUri -Headers $headers

            if ($OutputAsJson) {
                $res | ConvertTo-Json -Depth 10
            }
            else {
                $res
            }
        }
        catch [System.Net.WebException] {
            $webException = $_.Exception
            
            if (($webException.Status -eq [System.Net.WebExceptionStatus]::ProtocolError) -and (-not($null -eq $webException.Response))) {
                $resp = [System.Net.HttpWebResponse]$webException.Response

                if ($resp.StatusCode -eq [System.Net.HttpStatusCode]::NotFound) {
                    $messageString = "It seems that the OData endpoint was unable to locate the desired entity: $EntityName, based on the key: <c='em'>$key</c>. Please make sure that the key is <c='em'>valid</c> or try using the <c='em'>Get-D365CeOdataEntityData</c> cmdlet to search for the correct entity first."
                    Write-PSFMessage -Level Host -Message $messageString -Exception $PSItem.Exception -Target $EntityName
                    Stop-PSFFunction -Message "Stopping because of HTTP error 404." -Exception $([System.Exception]::new($($messageString -replace '<[^>]+>', ''))) -ErrorRecord $_
                    return
                }
                else {
                    $messageString = "Something went wrong while retrieving data from the OData endpoint for the entity: $EntityName"
                    Write-PSFMessage -Level Host -Message $messageString -Exception $PSItem.Exception -Target $EntityName
                    Stop-PSFFunction -Message "Stopping because of errors." -Exception $([System.Exception]::new($($messageString -replace '<[^>]+>', ''))) -ErrorRecord $_
                    return
                }
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