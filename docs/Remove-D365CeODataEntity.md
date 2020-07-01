---
external help file: d365ce.integrations-help.xml
Module Name: d365ce.integrations
online version:
schema: 2.0.0
---

# Remove-D365CeODataEntity

## SYNOPSIS
Remove a Data Entity from Dynamics 365 Customer Engagement

## SYNTAX

```
Remove-D365CeODataEntity [-EntityName] <String> [-Key] <String> [[-Tenant] <String>] [[-URL] <String>]
 [[-ClientId] <String>] [[-ClientSecret] <String>] [-EnableException] [<CommonParameters>]
```

## DESCRIPTION
Removes a Data Entity, defined by the EntityKey, using the OData endpoint of the Dynamics 365 Customer Engagement

## EXAMPLES

### EXAMPLE 1
```
Remove-D365CeODataEntity -EntityName ExchangeRates -EntityKey "RateTypeName='TEST'","FromCurrency='DKK'","ToCurrency='EUR'","StartDate=2019-01-13T12:00:00Z"
```

This will remove a Data Entity from the D365CE environment through OData.
It will use the ExchangeRate entity, and its EntitySetName / CollectionName "ExchangeRates".
It will use the "RateTypeName='TEST'","FromCurrency='DKK'","ToCurrency='EUR'","StartDate=2019-01-13T12:00:00Z" as the unique key for the entity.

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
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Key
The key that will select the desired Data Entity uniquely across the OData endpoint

The key would most likely be made up from multiple values, but can also be a single value

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
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
Position: 3
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
Position: 4
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
Position: 5
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
Position: 6
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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES
Tags: OData, Data, Entity, Import, Upload

Author: Mötz Jensen (@Splaxi)

## RELATED LINKS

[Add-D365CeODataConfig]()

[Get-D365CeActiveODataConfig]()

[Set-D365CeActiveODataConfig]()

