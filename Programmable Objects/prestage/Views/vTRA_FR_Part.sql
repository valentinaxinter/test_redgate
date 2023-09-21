IF OBJECT_ID('[prestage].[vTRA_FR_Part]') IS NOT NULL
	DROP VIEW [prestage].[vTRA_FR_Part];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE VIEW [prestage].[vTRA_FR_Part] AS

SELECT 
	CONCAT(CONVERT (date, SYSDATETIME()), ' 00:00:00') AS [PartitionKey]
	,Prop_0 AS [Company]
	,Prop_1 AS [PartNum]
	,Prop_2 AS [PartName]
	,Prop_3 AS [PartDescription]
	,Prop_4 AS [PartDescription2]
	,Prop_5 AS [PartDescription3]
	,Prop_6 AS [ProductGroup]
	,Prop_7 AS [ProductGroup2]
	,Prop_8 AS [ProductGroup3]
	,Prop_9 AS [ProductGroup4]
	,Prop_10 AS [Brand]
	,Prop_11 AS [CommodityCode]
	,Prop_12 AS [PartReplacementNum]
	,Prop_13 AS [PartStatus]
	,Prop_14 AS [CountryOfOrigin]
	,IIF(Prop_15 IS NULL, 0, TRY_CONVERT(decimal (18,2), Prop_15)) AS [NetWeight]
	,Prop_16 [UoM]
	,Prop_26 AS MainSupplier
	,Prop_27 AS AlternativeSupplier
FROM [prestage].[TRA_FR_Part]
GO
