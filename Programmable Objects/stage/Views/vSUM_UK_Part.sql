IF OBJECT_ID('[stage].[vSUM_UK_Part]') IS NOT NULL
	DROP VIEW [stage].[vSUM_UK_Part];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [stage].[vSUM_UK_Part] AS
SELECT
	CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM(dbo.summers()) ,'#', TRIM(PartNum))))) AS PartID 
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(TRIM(dbo.summers())))) AS CompanyID
	,CONCAT(UPPER(TRIM(dbo.summers())),'#', [PartNum]) AS PartCode
	,PartitionKey
	,UPPER(TRIM(dbo.summers())) as  [Company]
	,[PartNum]
	--,[PartName]
	,[PartDescription]
	--,[PartDescription2]
	--,[PartDescription3]
	--,TRIM([ProductGroup]) AS ProductGroup
	--,TRIM([ProductGroup2])	AS ProductGroup2	
	,TRIM([ProductGroup3]) AS ProductGroup3
	,TRIM([ProductGroup4]) AS ProductGroup4
	,COALESCE(B.BrandReportingName, 'Other') AS [Brand] 
	--,NULL AS MainSupplier
	--,NULL AS AlternativeSupplier
	,[CommodityCode]
	--,'' AS PartReplacementNum
	--,'' AS PartStatus
	,[CountryOfOrigin]
	,TRY_CONVERT(decimal(18,4), [NetWeight]) AS NetWeight -- Added try_convert since stage table field was changed to nvarchar to handle rows skipped in pipeline /SM 2021-04-20
	--,'' AS UoM
	--,[Material]
	,[Barcode]
	--,[ReOrderLevel]
	--,'' AS PartResponsible
	--,[StartDate]
	--,[EndDate]
	--,[Site]
	--,'' as pep
FROM [stage].[SUM_UK_Part] AS P
LEFT JOIN [stage].[ACO_UK_mapBrand] B ON P.Brand = B.BrandERPName
;
GO
