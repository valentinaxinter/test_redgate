IF OBJECT_ID('[prestage].[vTRA_FR_Supplier]') IS NOT NULL
	DROP VIEW [prestage].[vTRA_FR_Supplier];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE VIEW [prestage].[vTRA_FR_Supplier] AS

SELECT 
	CONCAT(CONVERT (date, SYSDATETIME()), ' 00:00:00') AS [PartitionKey]
	,Prop_0 AS [Company]
	,Prop_1 AS [SupplierNum]
	,Prop_2 AS [MainSupplierName]
	,Prop_3 AS [SupplierName]
	,Prop_4 AS [AddressLine1]
	,Prop_5 AS [AddressLine2]
	,Prop_6 AS [AddressLine3]
	,Prop_7 AS [TelephoneNum]
	,Prop_8 AS [Email]
	,Prop_9 AS [ZipCode]
	,Prop_10 AS [City]
	,Prop_11 AS [District]
	,Prop_12 AS [CountryName]
	,Prop_13 AS [Region]
	,Prop_14 AS [SupplierCategory]
	,Prop_15 AS [SupplierResponsible]
	,Prop_16 AS [AccountNum]
	,Prop_17 AS [VATNum]
	,Prop_18 AS [InternalExternal]
	,Prop_19 AS [CodeOfConduct]
	,Prop_20 AS [SupplierScore]
	,Prop_21 AS [MinOrderQty]
	,Prop_22 AS [MinOrderValue]
	,Prop_23 AS [Website]
	,Prop_24 AS [Comments]
	,Prop_25 AS [SRes1]
	,Prop_26 AS [SRes2]
	,Prop_27 AS [SRes3]
FROM [prestage].[TRA_FR_Supplier]
GO
