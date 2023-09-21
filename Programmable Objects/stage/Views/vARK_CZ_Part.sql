IF OBJECT_ID('[stage].[vARK_CZ_Part]') IS NOT NULL
	DROP VIEW [stage].[vARK_CZ_Part];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [stage].[vARK_CZ_Part] AS
--ADD TRIM() INTO PartID 2022-12-16 VA
SELECT 
	CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM([Company]), '#', TRIM([PartNum]))))) AS PartID
	,CONCAT([Company], '#', TRIM([PartNum])) AS PartCode
	,CONVERT([binary](32), HASHBYTES('SHA2_256', [Company])) AS CompanyID
	,PartitionKey

	,[Company]
	,TRIM([PartNum]) AS PartNum
	,LEFT([PartName], 100) AS [PartName]
	,[PartDescription]
	,[PartDescription2]
	,'Part' AS [PartDescription3]
	,NULL AS MainSupplier
	,NULL AS AlternativeSupplier
	,[ProductGroup]
	,[ProductGroup2]
	,[ProductGroup3]
	,[ProductGroup4]
	,[Brand]
	,'' AS [Barcode]
	,'' AS UOM
	,MAX([CommodityCode]) AS [CommodityCode]
	,[CountryOfOrigin]
	,[NetWeight]
	,[Volume]
	,[Material]
	,PartStatus
	,'' AS [PartReplacementNum]
	,'' AS [PartResponsible]
	,[ReorderLevel] AS [ReOrderLevel]
	,[StartDate]
	,[EndDate]

FROM 
	[stage].[ARK_CZ_Part]
WHERE [PartNum] NOT IN ('TextLine', 'ServicePurchase')

GROUP BY
	PartitionKey, [Company], [PartNum], LEFT([PartName],100), [PartDescription], [PartDescription2], [ProductGroup],  [ProductGroup2], [ProductGroup3], [ProductGroup4], [Brand], [CountryOfOrigin], [NetWeight], [Volume], [Material], [ReorderLevel], [StartDate], [EndDate], PartStatus --, [CommodityCode]

-- Added as a quick fix to the null partNum relation to the invoice table. Added as a union to make the logic visible 
-- Should be replaced with Inferred member logic later /SM 2021-04-19
UNION ALL

SELECT
	0x655F5AD0E529617C17DE44A8AB611798347A1DED06EA54AC1C79DAC013BEFEE8 AS PartID
	,CONCAT('ACZARKOV', '#', 'TextLine') AS PartCode
	,0x0C506A3C3C1F5F2AD836AC48E636BA9A9E1153166018D0E47910ADA53BD8BB3E AS CompanyID
	,'20210421'	AS PartitionKey
	,'ACZARKOV' AS [Company]
	,'TextLine' AS PartNum -- TextLine it will not work
	,'Service' AS [PartName]
	,'Service' AS	[PartDescription]
	,''	AS [PartDescription2]
	,'Service' AS [PartDescription3]
	,NULL AS MainSupplier
	,NULL AS AlternativeSupplier
	,'Service' AS [ProductGroup]
	,'' AS [ProductGroup2]
	,'' AS [ProductGroup3]
	,'' AS [ProductGroup4]
	,'' AS [Brand]
	,'' AS [Barcode]
	,'H' AS UOM
	,'' AS [CommodityCode]
	,'' AS [CountryOfOrigin]
	,0 AS [NetWeight]
	,0 AS [Volume]
	,'' AS [Material]
	,'' AS PartStatus
	,'' AS [PartReplacementNum]
	,'' AS [PartResponsible]
	,0 AS  [ReOrderLevel]
	,''	AS StartDate
	,''	AS EndDate

UNION ALL

SELECT
	0x655F5AD0E529617C17DE44A8AB611798347A1DED06EA54AC1C79DAC013BEFEE9 AS PartID
	,CONCAT('ACZARKOV', '#', 'ServicePurchase') AS PartCode
	,0x0C506A3C3C1F5F2AD836AC48E636BA9A9E1153166018D0E47910ADA53BD8BB3E AS CompanyID
	,'20211101'	AS PartitionKey
	,'ACZARKOV' AS [Company]
	,'ServicePurchase' AS PartNum
	,'Service' AS [PartName]
	,'Service' AS	[PartDescription]
	,''	AS [PartDescription2]
	,'Service' AS [PartDescription3]
	,NULL AS MainSupplier
	,NULL AS AlternativeSupplier
	,'Service' AS [ProductGroup]
	,'' AS [ProductGroup2]
	,'' AS [ProductGroup3]
	,'' AS [ProductGroup4]
	,'' AS [Brand]
	,'' AS [Barcode]
	,'H' AS UOM
	,'' AS [CommodityCode]
	,'' AS [CountryOfOrigin]
	,0 AS [NetWeight]
	,0 AS [Volume]
	,'' AS [Material]
	,'' AS PartStatus
	,'' AS [PartReplacementNum]
	,'' AS [PartResponsible]
	,0 AS  [ReOrderLevel]
	,''	AS StartDate
	,''	AS EndDate
GO
