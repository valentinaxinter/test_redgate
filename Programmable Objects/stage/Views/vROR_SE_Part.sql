IF OBJECT_ID('[stage].[vROR_SE_Part]') IS NOT NULL
	DROP VIEW [stage].[vROR_SE_Part];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [stage].[vROR_SE_Part] AS
--COMMENT EMPTY FIELDS 2022-12-22  VA
--NO NEED TO USED THE UPPER() IN PartID. Data from source could be the same PartNum but different  product. '10031OR' has an example.
SELECT
	
	CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT(p.Company,'#', TRIM([PartNum])))) AS PartID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', p.Company)) AS CompanyID
	,CONCAT(p.Company, '#', TRIM([PartNum])) AS PartCode
	,IIF(p.PartitionKey is NULL, Getdate(), p.PartitionKey) AS PartitionKey

	,p.[Company]
	,TRIM([PartNum]) AS [PartNum]
	,TRIM([PartName]) AS [PartName]
	,TRIM([PartDescription]) AS [PartDescription]
	,TRIM([PartDescription2]) AS [PartDescription2]
	,TRIM([PartDescription3]) AS [PartDescription3]
	,CONCAT(TRIM(MainSupplier), ' - ', s.SupplierName) AS MainSupplier
	--,'' AS AlternativeSupplier
	,TRIM([ProductGroup]) AS [ProductGroup]
	,TRIM([ProductGroup2]) AS [ProductGroup2]
	,TRIM([ProductGroup3]) AS [ProductGroup3]
	,TRIM([ProductGroup4]) AS [ProductGroup4]
	,TRIM([Brand]) AS [Brand]
	,TRIM([CommodityCode]) AS [CommodityCode]
	,TRIM([PartReplacementNum]) AS [PartReplacementNum]
	,IIF(TRIM([PartStatus]) = '', 'Aktiv', TRIM([PartStatus])) AS [PartStatus]
	,TRIM([CountryOfOrigin]) AS [CountryOfOrigin]
	,TRY_CONVERT(decimal (18,4), [NetWeight]) AS [NetWeight]
	,TRIM([UoM]) AS [UoM]
	,TRIM([Material]) AS [Material]
	,TRIM([Barcode]) AS [Barcode]
	,[ReOrderLevel]
	,[PartResponsible]
	,CONVERT(date, [StartDate]) AS [StartDate]
	,CONVERT(date, [EndDate]) AS [EndDate]
	--,'' AS PRes1
	--,'' AS PRes2
	--,'' AS PRes3
FROM [stage].[Ror_SE_Part] p
	LEFT JOIN [stage].[ROR_SE_Supplier] s ON p.MainSupplier = s.SupplierNum
WHERE p.PartitionKey is not null
GO
