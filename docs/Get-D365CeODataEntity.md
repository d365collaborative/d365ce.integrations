---
external help file: d365ce.integrations-help.xml
Module Name: d365ce.integrations
online version:
schema: 2.0.0
---

# Get-D365CeODataEntity

## SYNOPSIS
Get public OData Data Entity and their metadata

## SYNTAX

### Default (Default)
```
Get-D365CeODataEntity [-EntityName <String>] [-ODataQuery <String>] [-Tenant <String>] [-URL <String>]
 [-ClientId <String>] [-ClientSecret <String>] [-EnableException] [-RawOutput] [-OutNamesOnly] [-OutputAsJson]
 [<CommonParameters>]
```

### NameContains
```
Get-D365CeODataEntity -EntityNameContains <String> [-ODataQuery <String>] [-Tenant <String>] [-URL <String>]
 [-ClientId <String>] [-ClientSecret <String>] [-EnableException] [-RawOutput] [-OutNamesOnly] [-OutputAsJson]
 [<CommonParameters>]
```

## DESCRIPTION
Get a list with all the available OData Data Entities,and their metadata, that are exposed through the OData endpoint of the Dynamics 365 Customer Engagement instance

The cmdlet will search across the singular names for the Data Entities and across the collection names (plural)

## EXAMPLES

### EXAMPLE 1
```
Get-D365CeODataEntity -EntityName Account
```

This will get Data Entities from the OData endpoint.
This will search for the Data Entities that are named "Account".

### EXAMPLE 2
```
Get-D365CeODataEntity -EntityNameContains Account
```

This will get Data Entities from the OData endpoint.
It will use the search string "Account" to search for any entity in their singular & plural name contains that search term.

### EXAMPLE 3
```
Get-D365CeODataEntity -EntityNameContains Account -OutNamesOnly
```

This will get Data Entities from the OData endpoint.
It will use the search string "Account" to search for any entity in their singular & plural name contains that search term.
It will only output the names for the entities and not all their metadata details.

### EXAMPLE 4
```
Get-D365CeODataEntity -ODataQuery "`$filter=IsPrivate eq true" -OutNamesOnly
```

This will get Data Entities from the OData endpoint.
It will utilize the OData Query capabilities to filter for Data Entities that are "IsPrivate = $true".
It will only output the names for the entities and not all their metadata details.

## PARAMETERS

### -EntityName
Name of the Data Entity you are searching for

The parameter is Case Insensitive, to make it easier for the user to locate the correct Data Entity

```yaml
Type: String
Parameter Sets: Default
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -EntityNameContains
Name of the Data Entity you are searching for, but instructing the cmdlet to use search logic

Using this parameter enables you to supply only a portion of the name for the entity you are looking for, and still a valid result back

The parameter is Case Insensitive, to make it easier for the user to locate the correct Data Entity

```yaml
Type: String
Parameter Sets: NameContains
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ODataQuery
Valid OData query string that you want to pass onto the D365 OData endpoint while retrieving data

Important note:
If you are using -EntityName along with the -ODataQuery, you need to understand that the "$filter" query is already started.
Then you need to start with -ODataQuery ' and XYZ eq XYZ', e.g.
-ODataQuery ' and IsReadOnly eq false'
If you are using the -ODataQuery alone, you need to start the OData Query string correctly.
-ODataQuery '$filter=IsReadOnly eq false'

OData specific query options are:
$filter
$expand
$select
$orderby
$top
$skip

Each option has different characteristics, which is well documented at: http://docs.oasis-open.org/odata/odata/v4.0/odata-v4.0-part2-url-conventions.html

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Tenant
Azure Active Directory (AAD) tenant id (Guid) that the D365CE environment is connected to, that you want to access through OData

```yaml
Type: String
Parameter Sets: (All)
Aliases: $AADGuid

Required: False
Position: Named
Default value: $Script:ODataTenant
Accept pipeline input: False
Accept wildcard characters: False
```

### -URL
URL / URI for the D365CE environment you want to access through OData

```yaml
Type: String
Parameter Sets: (All)
Aliases: URI

Required: False
Position: Named
Default value: $Script:ODataUrl
Accept pipeline input: False
Accept wildcard characters: False
```

### -ClientId
The ClientId obtained from the Azure Portal when you created a Registered Application

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: $Script:ODataClientId
Accept pipeline input: False
Accept wildcard characters: False
```

### -ClientSecret
The ClientSecret obtained from the Azure Portal when you created a Registered Application

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: $Script:ODataClientSecret
Accept pipeline input: False
Accept wildcard characters: False
```

### -EnableException
This parameters disables user-friendly warnings and enables the throwing of exceptions
This is less user friendly, but allows catching exceptions in calling scripts

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -RawOutput
Instructs the cmdlet to include the outer structure of the response received from OData endpoint

The output will still be a PSCustomObject

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -OutNamesOnly
Instructs the cmdlet to only display the DataEntityName and the EntityName from the response received from OData endpoint

DataEntityName is the (logical) name of the entity from a code perspective.
EntityName is the public OData endpoint name of the entity.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -OutputAsJson
Instructs the cmdlet to convert the output to a Json string

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES
The OData standard is using the $ (dollar sign) for many functions and features, which in PowerShell is normally used for variables.

Whenever you want to use the different query options, you need to take the $ sign and single quotes into consideration.

Example of an execution where I want the top 1 result only, from a specific legal entity / company.
This example is using single quotes, to help PowerShell not trying to convert the $ into a variable.
Because the OData standard is using single quotes as text qualifiers, we need to escape them with multiple single quotes.

-ODataQuery '$top=1&$filter=dataAreaId eq ''Comp1'''

Tags: OData, Data, Entity, Query

Author: M ¶tz Jensen (@Splaxi)

## RELATED LINKS
