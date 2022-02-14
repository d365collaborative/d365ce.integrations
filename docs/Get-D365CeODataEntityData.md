﻿---
external help file: d365ce.integrations-help.xml
Module Name: d365ce.integrations
online version:
schema: 2.0.0
---

# Get-D365CeODataEntityData

## SYNOPSIS
Get data from an Data Entity using OData

## SYNTAX

### Default (Default)
```
Get-D365CeODataEntityData -EntityName <String> [-ODataQuery <String>] [-Charset <String>] [-Tenant <String>]
 [-URL <String>] [-ClientId <String>] [-ClientSecret <String>] [-FullODataMeta] [-EnableException] [-RawOutput]
 [-OutputAsJson] [<CommonParameters>]
```

### NextLink
```
Get-D365CeODataEntityData -EntityName <String> [-ODataQuery <String>] [-Charset <String>] [-Tenant <String>]
 [-URL <String>] [-ClientId <String>] [-ClientSecret <String>] [-FullODataMeta] [-TraverseNextLink]
 [-ThrottleSeed <Int32>] [-EnableException] [-RawOutput] [-OutputAsJson] [<CommonParameters>]
```

## DESCRIPTION
Get data from an Data Entity using the OData endpoint of the Dynamics 365 Customer Engagement

## EXAMPLES

### EXAMPLE 1
```
Get-D365CeODataEntityData -EntityName accounts -ODataQuery '$top=1'
```

This will get Accounts from the OData endpoint.
It will use the "Account" entity, and its EntitySetName / CollectionName "accounts".
It will get the top 1 results from the list of accounts.

It will use the default OData configuration details that are stored in the configuration store.

### EXAMPLE 2
```
Get-D365CeODataEntityData -EntityName accounts -ODataQuery '$top=1' -FullODataMeta
```

This will get Accounts, and include all metadata, from the OData endpoint.
It will use the "Account" entity, and its EntitySetName / CollectionName "accounts".
It will get the top 1 results from the list of accounts.

It will use the default OData configuration details that are stored in the configuration store.

### EXAMPLE 3
```
Get-D365CeODataEntityData -EntityName accounts -ODataQuery '$top=10&$filter=address1_city eq ''New York'''
```

This will get Accounts from the OData endpoint.
It will use the Account entity, and its EntitySetName / CollectionName "Accounts".
It will get the top 10 results from the list of accounts.
It will filter the entities for records where the "address1_city" is 'New York'.

It will use the default OData configuration details that are stored in the configuration store.

### EXAMPLE 4
```
Get-D365CeODataEntityData -EntityName accounts -TraverseNextLink
```

This will get Accounts from the OData endpoint.
It will use the Account entity, and its EntitySetName / CollectionName "Accounts".
It will traverse all NextLink that will occur while fetching data from the OData endpoint.

It will use the default OData configuration details that are stored in the configuration store.

### EXAMPLE 5
```
Get-D365CeODataEntityData -EntityName accounts -TraverseNextLink -ThrottleSeed 2
```

This will get Accounts from the OData endpoint, and sleep/pause between 1 and 2 seconds for each NextLink.
It will use the Account entity, and its EntitySetName / CollectionName "Accounts".
It will traverse all NextLink that will occur while fetching data from the OData endpoint.
It will use the ThrottleSeed 2 to sleep/pause the execution, to mitigate the 429 pushback from the endpoint.

It will use the default OData configuration details that are stored in the configuration store.

## PARAMETERS

### -EntityName
Name of the Data Entity you want to work against

The parameter is Case Sensitive, because the OData endpoint in D365CE is Case Sensitive

Remember that most Data Entities in a D365CE environment is named by its singular name, but most be retrieve using the plural name

E.g.
The account Data Entity is named "account", but can only be retrieving using "accounts"

Use the XRMToolBox (https://www.xrmtoolbox.com) to help you identify the names of the Data Entities that you are looking for

```yaml
Type: String
Parameter Sets: (All)
Aliases: Name

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ODataQuery
Valid OData query string that you want to pass onto the D365 OData endpoint while retrieving data

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

### -Charset
The charset / encoding that you want the cmdlet to use while fetching the odata entity

The default value is: "UTF8"

The charset has to be a valid http charset like: ASCII, ANSI, ISO-8859-1, UTF-8

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: UTF-8
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

### -FullODataMeta
Instruct the cmdlet to request all metadata to be filled into the payload

Useful when you are looking for navigation properties and linked entities

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

### -TraverseNextLink
Instruct the cmdlet to keep traversing the NextLink if the result set from the OData endpoint is larger than what one round trip can handle

The system default is 5,000 (5 thousands) at the time of writing this feature in February 2022

```yaml
Type: SwitchParameter
Parameter Sets: NextLink
Aliases:

Required: True
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -ThrottleSeed
Instruct the cmdlet to invoke a thread sleep between 1 and ThrottleSeed value

This is to help to mitigate the 429 retry throttling on the OData endpoints

It will only be available in combination with the TraverseNextLink parameter

```yaml
Type: Int32
Parameter Sets: NextLink
Aliases:

Required: False
Position: Named
Default value: 0
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

Example of an execution where I want the top 1 result only, with a specific city filled out.
This example is using single quotes, to help PowerShell not trying to convert the $ into a variable.
Because the OData standard is using single quotes as text qualifiers, we need to escape them with multiple single quotes.

-ODataQuery '$top=1&$filter=address1_city eq ''New York'''

Tags: OData, Data, Entity, Query

Author: Mötz Jensen (@Splaxi)

## RELATED LINKS

[Add-D365CeODataConfig]()

[Get-D365CeActiveODataConfig]()

[Set-D365CeActiveODataConfig]()

