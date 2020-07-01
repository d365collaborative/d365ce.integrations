---
external help file: d365ce.integrations-help.xml
Module Name: d365ce.integrations
online version:
schema: 2.0.0
---

# Update-D365CeODataEntity

## SYNOPSIS
Update a Data Entity in Dynamics 365 Customer Engagement

## SYNTAX

```
Update-D365CeODataEntity [-EntityName] <String> [-Key] <String> [-Payload] <String> [[-Tenant] <String>]
 [[-URL] <String>] [[-ClientId] <String>] [[-ClientSecret] <String>] [-EnableException] [<CommonParameters>]
```

## DESCRIPTION
Updates a Data Entity, defined as a json payload, using the OData endpoint of the Dynamics 365 Customer Engagement platform

## EXAMPLES

### EXAMPLE 1
```
Update-D365CeODataEntity -EntityName "accounts" -Key "accountid=4b306dc7-ab04-4ddf-b18d-d75ffa2dba2c" -Payload '{"address2_city": "Chicago"}'
```

This will update a Data Entity in Dynamics 365 Customer Engagement using the OData endpoint.
The EntityName used for the import is "accounts".
It will use the "accountid=4b306dc7-ab04-4ddf-b18d-d75ffa2dba2c" as key to identify the unique Account record.
The Payload is a valid json string, containing the needed properties that we want to update.

It will use the default OData configuration details that are stored in the configuration store.

### EXAMPLE 2
```
$Payload = '{"address2_city": "Chicago"}'
```

PS C:\\\> Update-D365CeODataEntity -EntityName "accounts" -Key "accountid=4b306dc7-ab04-4ddf-b18d-d75ffa2dba2c" -Payload $Payload

This will update a Data Entity in Dynamics 365 Customer Engagement using the OData endpoint.
First the desired json data is put into the $Payload variable.
The EntityName used for the import is "accounts".
It will use the "accountid=4b306dc7-ab04-4ddf-b18d-d75ffa2dba2c" as key to identify the unique Account record.
The $Payload variable is passed to the cmdlet.

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

### -Payload
The entire string contain the json object that you want to import into the D365CE environment

Remember that json is text based and can use either single quotes (') or double quotes (") as the text qualifier, so you might need to escape the different quotes in your payload before passing it in

```yaml
Type: String
Parameter Sets: (All)
Aliases: Json

Required: True
Position: 3
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
Position: 4
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
Position: 5
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
Position: 6
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
Position: 7
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
Tags: OData, Data, Entity, Update, Upload

Author: Mötz Jensen (@Splaxi)

## RELATED LINKS

[Add-D365CeODataConfig]()

[Get-D365CeActiveODataConfig]()

[Set-D365CeActiveODataConfig]()

