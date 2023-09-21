IF OBJECT_ID('[stage].[vBELL_SI_Part]') IS NOT NULL
	DROP VIEW [stage].[vBELL_SI_Part];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [stage].[vBELL_SI_Part] AS

SELECT 
	CONVERT([binary](32), HASHBYTES('SHA2_256',UPPER(CONCAT([Company],'#',IIF(LEFT(TRIM([PartNum]), 1) = 'I', SUBSTRING(TRIM([PartNum]), 2, 50), TRIM([PartNum])))))) AS PartID
	--CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT([Company],'#',IIF(LEFT(TRIM([PartNum]), 1) = 'I', SUBSTRING(TRIM([PartNum]), 2, 50), TRIM([PartNum]))))) AS PartID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', [Company])) AS CompanyID
	,CONCAT([Company], '#', IIF(LEFT(TRIM([PartNum]), 1) = 'I', SUBSTRING(TRIM([PartNum]), 2, 50), TRIM([PartNum]))) AS PartCode
	,PartitionKey

	,[Company]
	,IIF(LEFT(TRIM([PartNum]), 1) = 'I', SUBSTRING(TRIM([PartNum]), 2, 50), TRIM([PartNum])) AS [PartNum]
	--,'' AS [PartName]

	,[PartDescription]
	,[PartDescription2]
	--,'' AS [PartDescription3]
	,Vendor AS MainSupplier -- Bell added on 2022-12-07
	--,NULL AS AlternativeSupplier
	,LEFT([ProductGroup], 45) AS [ProductGroup]
	,LEFT([ProductGroup2], 45) AS [ProductGroup2]
	,InventoryPostingGroup AS [ProductGroup3] -- Bell added on 2022-12-07
	--,'' AS [ProductGroup4]
	--,'' AS [Brand]
	,[CommodityCode]
	,ShelfNo AS PartReplacementNum-- Bell added on 2022-12-07
	--,'' AS PartStatus
	,[CountryOfOrigin]
	,[NetWeight]
	--,'' AS UoM
	--,'' AS [Material]
	,[Barcode]
	,[ReorderLevel]
	--,'' AS PartResponsible
	--,'' AS [StartDate]
	--,'' AS [EndDate]
FROM [stage].[BELL_SI_Part]
GO
