IF OBJECT_ID('[stage].[vCER_UK_Part]') IS NOT NULL
	DROP VIEW [stage].[vCER_UK_Part];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [stage].[vCER_UK_Part] AS
--COMMENT EMPTY FIELDS // ADD UPPER() TRIM() 2022-12-20 va
SELECT 
	--CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT([Company], '#', [PartNum]))) AS PartID
	CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM([Company]), '#', TRIM([PartNum]))))) AS PartID
	,CONCAT([Company], '#', [PartNum]) AS PartCode
	,CONVERT([binary](32), HASHBYTES('SHA2_256', [Company])) AS CompanyID
	,PartitionKey

	,[Company]
	,[PartNum]
	--,'' AS [PartName]
	,[PartDescription]
	,[PartDescription2]
	--,'' AS [PartDescription3]
	--,NULL AS MainSupplier
	--,NULL AS AlternativeSupplier
	,[ProductGroup]
	,[ProductGroup2]
	--,'' AS [ProductGroup3]
	--,'' AS [ProductGroup4]
	--,'' AS [Brand]
	,[Barcode]
	,[CommodityCode]
	--,'' AS [PartReplacementNum]
	--,'' AS [PartStatus]
	,[CountryOfOrigin]
	,[NetWeight]
	--,'' AS [UoM]
	--,'' AS [Material]
	--,'' AS [PartResponsible]
	,[ReorderLevel] AS [ReOrderLevel]
	--,'' AS [StartDate]
	--,'' AS [EndDate]

FROM [stage].[CER_UK_Part]
GO
