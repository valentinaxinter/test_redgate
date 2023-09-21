IF OBJECT_ID('[stage].[vACO_UK_Part]') IS NOT NULL
	DROP VIEW [stage].[vACO_UK_Part];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE VIEW [stage].[vACO_UK_Part] AS
--COMMENT empty fields / ADD UPPER() TRIM() INTO PartID
SELECT 
	CONVERT([binary](32), HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM([Company]),'#',TRIM(PartNum))))) AS PartID 
	--CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT([Company] ,'#', PartNum))) AS PartID 
	,CONVERT([binary](32), HASHBYTES('SHA2_256', [Company])) AS CompanyID
	,CONCAT([Company],'#', TRIM(PartNum)) AS PartCode
	,PartitionKey


	,[Company]
	,TRIM(PartNum) AS [PartNum]
	,[PartName]
	,[PartDescription]
	,[PartDescription2]
	,[PartDescription3]
	,TRIM([ProductGroup]) AS ProductGroup
	,TRIM([ProductGroup2])	AS ProductGroup2	
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
	,[Material]
	,[Barcode]
	,[ReOrderLevel]
	--,'' AS PartResponsible
	,[StartDate]
	,[EndDate]
	,[Site]

FROM [stage].[ACO_UK_Part] AS P
LEFT JOIN [stage].[ACO_UK_mapBrand] B ON P.Brand = B.BrandERPName
GROUP BY
	PartitionKey, [Company], TRIM(PartNum), [PartName], [PartDescription], [PartDescription2], B.BrandReportingName, [PartDescription3], [ProductGroup3], [ProductGroup4], [ProductGroup], [ProductGroup2], [CommodityCode], [CountryOfOrigin], [NetWeight], [Brand], [Barcode], [Volume], [Material], [Site], [StartDate], [EndDate], [ReorderLevel]
GO
