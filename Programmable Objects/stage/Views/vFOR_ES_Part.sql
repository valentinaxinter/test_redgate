IF OBJECT_ID('[stage].[vFOR_ES_Part]') IS NOT NULL
	DROP VIEW [stage].[vFOR_ES_Part];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO








CREATE view [stage].[vFOR_ES_Part] AS

SELECT 
	CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM([Company]),'#',TRIM([PartNum]))))) AS PartID
	,CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(TRIM([Company])))) AS CompanyID
	,UPPER(CONCAT(TRIM([Company]),'#',TRIM([PartNum]))) AS PartCode
	,PartitionKey

	,[Company]
	,UPPER(TRIM([PartNum])) AS PartNum
	,[PartName]
	--,''	AS [PartDescription]
	--,''	AS [PartDescription2]
	--,'' AS [PartDescription3]
	,NULL AS MainSupplier
	,NULL AS AlternativeSupplier
	,[ProductGroup]
	,[ProductGroup2]
	--,'' AS [ProductGroup3]
	--,'' AS [ProductGroup4]
	--,'' AS [Brand]
	--,'' AS [CommodityCode]
	--,'' AS PartReplacementNum
	--,'' AS PartStatus
	--,'' AS [CountryOfOrigin]
	,[NetWeight]
	,UoM
	,[Material]
	,[Barcode]
	,[ReOrderLevel]
	--,'' PartResponsible
	--,'' AS [StartDate]
	--,'' AS [EndDate]
FROM [stage].[FOR_ES_Part]
--GROUP BY [PartitionKey],[Company],[PartNum],[PartDescription],[PartDescription2],[ProductGroup],[ProductGroup2],[ProductGroup3],[CommodityCode],[CountryOfOrigin],[NetWeight],[ReorderLevel]
GO
