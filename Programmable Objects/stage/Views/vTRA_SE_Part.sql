IF OBJECT_ID('[stage].[vTRA_SE_Part]') IS NOT NULL
	DROP VIEW [stage].[vTRA_SE_Part];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [stage].[vTRA_SE_Part] AS
--COMMENT EMPTY FIELDS // ADD UPPER() TRIM() INTO PartID
SELECT
	--CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT(UPPER(Company), '#', UPPER(TRIM([PartNum]))))) AS PartID
	CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM(Company), '#', TRIM([PartNum]))))) AS PartID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(Company))) AS CompanyID
	,CONCAT(UPPER(Company), '#', TRIM([PartNum])) AS PartCode
	,PartitionKey

	,UPPER(Company) AS Company
	,UPPER(TRIM([PartNum])) AS [PartNum]
	,TRIM([PartName]) AS [PartName]
	,TRIM(([PartDescription])) AS [PartDescription] --MAX
	--,'' AS [PartDescription2]
	--,'' AS [PartDescription3]
	--,NULL AS MainSupplier
	--,NULL AS AlternativeSupplier
	,TRIM([ProductGroup]) AS [ProductGroup]
	,[ProductGroup2]
	--,'' AS [ProductGroup3]
	--,'' AS [ProductGroup4]
	--,'' AS [Brand]
	,TRIM([CommodityCode]) AS [CommodityCode]
	,TRIM(([PartReplacementNum])) AS [PartReplacementNum] --MIN
	,TRIM([PartStatus]) AS [PartStatus]
	,TRIM([CountryOfOrigin]) AS [CountryOfOrigin]
	--,NULL AS [NetWeight] --MAX --CONVERT(decimal (18,4), ([NetWeight]))
	,TRIM([UoM]) AS [UoM]
	--,'' AS [Material]
	--,'' AS [Barcode]
	--,NULL AS [ReOrderLevel] --CONVERT(decimal (18,4), [ReOrderLevel])
	--,'' AS [PartResponsible]
	,CONVERT(date, [StartDate]) AS [StartDate]
	--,'' AS [EndDate]
FROM [stage].[TRA_SE_Part]

--GROUP BY
--	PartitionKey, Company, [PartNum], [PartName], [ProductGroup], [ProductGroup2], [CommodityCode], [PartStatus], [CountryOfOrigin], [UoM], [ReOrderLevel], [StartDate]
GO
