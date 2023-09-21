IF OBJECT_ID('[prestage].[vTRA_FR_Customer]') IS NOT NULL
	DROP VIEW [prestage].[vTRA_FR_Customer];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE VIEW [prestage].[vTRA_FR_Customer] AS

SELECT 
	CONCAT(CONVERT (date, SYSDATETIME()), ' 00:00:00') AS [PartitionKey]
	,Prop_0 AS [Company]
	,Prop_1 AS [CustomerNum]
	,Prop_2 AS [MainCustomerName]
	,Prop_3 AS [CustomerName]
	,Prop_4 AS [AddressLine1]
	,Prop_5 AS [AddressLine2]
	,Prop_6 AS [AddressLine3]
	,Prop_7 AS [TelephoneNum1]
	,Prop_8 AS [TelephoneNum2]
	,Prop_9 AS [Email]
	,Prop_10 AS [ZipCode]
	,Prop_11 AS [City]
	,Prop_12 AS [State]
	,Prop_13 AS [SalesDistrict]
	,Prop_14 AS [CountryName]
	,Prop_15 AS [Division]
	,Prop_16 AS [CustomerIndustry]
	,Prop_17 AS [CustomerSubIndustry]
	,Prop_18 AS [CustomerGroup]
	,Prop_19 AS [CustomerSubGroup]
	,Prop_20 AS [SalesPersonCode]
	,Prop_21 AS [SalesPersonName]
	,Prop_22 AS [SalesPersonResponsible]
	,Prop_23 AS [VATNum]
	,Prop_24 AS [AccountNum]
	,Prop_25 AS [InternalExternal]
	,Prop_26 AS [CustomerScore]
	,Prop_27 AS [CustomerType]
	,Prop_28 AS [CRes1]
	,Prop_29 AS [CRes2]
	,Prop_30 AS [CRes3]
	,Prop_31 AS [CountryCode]
FROM [prestage].[TRA_FR_Customer]
GO
