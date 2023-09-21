IF OBJECT_ID('[stage].[vFOR_SE_Part]') IS NOT NULL
	DROP VIEW [stage].[vFOR_SE_Part];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE view [stage].[vFOR_SE_Part] AS
--COMMENT EMPTY FIELDS 2022-12-20 VA
SELECT 
	CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM([Company]), '#', TRIM([PartNum]))))) AS PartID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(TRIM([Company])))) AS CompanyID
	,UPPER(CONCAT(TRIM([Company]),'#',TRIM([PartNum]))) AS PartCode
	,PartitionKey

	,UPPER([Company]) AS [Company]
	,UPPER(TRIM([PartNum])) AS PartNum
	--,'' AS [PartName]
	,[PartDescription]
	,[PartDescription2]
	--,'' AS [PartDescription3]
	--,NULL AS MainSupplier
	--,NULL AS AlternativeSupplier
	,[ProductGroup]
	,[ProductGroup2]
	,[ProductGroup3]
	,[ProductGroup4]
	--,'' AS [Brand]
	,[CommodityCode]
	--,'' AS PartReplacementNum
	--,'' AS PartStatus
	,[CountryOfOrigin]
	,[NetWeight]
	--,'' AS UoM
	--,'' AS [Material]
	--,'' AS [Barcode]
	,[ReOrderLevel]
	,PartResponsible
	--,'' AS [StartDate]
	--,'' AS [EndDate]
FROM [stage].[FOR_SE_Part]
--GROUP BY 
--      [PartitionKey],[Company],[PartNum],[PartDescription],[PartDescription2],[ProductGroup],[ProductGroup2],[ProductGroup3],[CommodityCode],[CountryOfOrigin],[NetWeight],[ReorderLevel], [ProductGroup4], PartResponsible
GO
