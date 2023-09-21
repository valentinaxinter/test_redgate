IF OBJECT_ID('[stage].[vLEX_FR_Part]') IS NOT NULL
	DROP VIEW [stage].[vLEX_FR_Part];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [stage].[vLEX_FR_Part] AS
--COMMENT EMPTY FIELDS / ADD TRIM()UPPER() INTO PartID 2022-12-13 VA
SELECT 
	CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM([Company]), '#', TRIM([PartNum]))))) AS PartID
	--CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT([Company], '#', TRIM([PartNum])))) AS PartID
	,CONCAT([Company], '#', TRIM([PartNum])) AS PartCode
	,CONVERT([binary](32), HASHBYTES('SHA2_256', [Company])) AS CompanyID
	,PartitionKey

	,[Company]
	,TRIM([PartNum]) AS [PartNum]
	,[PartName]
	,[PartDescription]
	,[PartDescription2]
	,[PartDescription3]
	--,NULL AS MainSupplier
	--,NULL AS AlternativeSupplier
	,[ProductGroup]
	,[ProductGroup2]
	,[ProductGroup3]
	,[ProductGroup4]
	,[Brand]
	,[CommodityCode]
	--,'' AS [PartReplacementNum]
	--,'' AS [PartStatus]
	,[CountryOfOrigin]
	,[NetWeight]
	--,'' AS [UoM]
	,[Material]
	,[Barcode]
	--,0 AS [ReorderLevel]
	--,'' AS [PartResponsible]
	,[StartDate]
	,[EndDate]
FROM [stage].[LEX_FR_Part]
GO
