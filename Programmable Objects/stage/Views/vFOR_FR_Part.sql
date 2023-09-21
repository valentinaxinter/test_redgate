IF OBJECT_ID('[stage].[vFOR_FR_Part]') IS NOT NULL
	DROP VIEW [stage].[vFOR_FR_Part];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [stage].[vFOR_FR_Part] AS
--COMMENT empty fields / ADD UPPER(()TRIM() INTO PartID
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
	--,NULL AS MainSupplier
	--,NULL AS AlternativeSupplier
	,[PartDescription3]
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
FROM [stage].[FOR_FR_Part]
GO
