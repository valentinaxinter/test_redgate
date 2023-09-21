IF OBJECT_ID('[stage].[vJEN_DK_Part]') IS NOT NULL
	DROP VIEW [stage].[vJEN_DK_Part];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [stage].[vJEN_DK_Part] AS
--COMMENT EMPTY FIELDS // ADD TRIM() INTO PartID 22-12-29 VA
SELECT 
	--CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT([Company], '#', TRIM([PartNum]))))) AS PartID
	CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM([Company]), '#', TRIM([PartNum]))))) AS PartID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER([Company]))) AS CompanyID
	,UPPER(CONCAT([Company], '#', TRIM([PartNum]))) AS PartCode
	,PartitionKey

	,UPPER([Company]) AS [Company]
	,UPPER(TRIM([PartNum])) AS [PartNum]
	--,'' AS [PartName]
	,TRIM([PartDescription]) AS [PartDescription]
	,TRIM([PartDescription2]) AS [PartDescription2]
	--,'' AS [PartDescription3]
	,MAX(TRIM(SupplierCode)) AS MainSupplier
	--,NULL AS AlternativeSupplier
	,TRIM([ProductGroup]) AS [ProductGroup]
	,TRIM([ProductGroup2]) AS [ProductGroup2]
	--,'' AS [ProductGroup3]
	--,'' AS [ProductGroup4]
	--,'' AS [Brand]
	,([CommodityCode]) AS [CommodityCode]
	--,'' AS PartReplacementNum
	,MAX(StockItemStatus) AS PartStatus
	,MAX([CountryOfOrigin]) AS [CountryOfOrigin]
	,[NetWeight]
	--,'' AS UoM
	--,'' AS [Material]
	,(EAN) AS [Barcode]
	--,MAX([ReOrderLevel]) AS [ReOrderLevel]
	--,'' AS PartResponsible
	--,'' AS [StartDate]
	--,'' AS [EndDate]
FROM [stage].[JEN_DK_Part]
GROUP BY [Company], PartitionKey, TRIM([PartNum]), TRIM([PartDescription]), TRIM([PartDescription2]), [ProductGroup], [ProductGroup2], [CommodityCode], [NetWeight], EAN--, StockItemStatus -- [CountryOfOrigin]
GO
