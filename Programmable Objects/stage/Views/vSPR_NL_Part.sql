IF OBJECT_ID('[stage].[vSPR_NL_Part]') IS NOT NULL
	DROP VIEW [stage].[vSPR_NL_Part];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [stage].[vSPR_NL_Part] AS
--COMMENT EMPTY FIELDS // ADD TRIM()UPPER() INTO
SELECT
--CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT(Company,'#', TRIM(PartNum)))) AS PartID
	CONVERT([binary](32), HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM(Company),'#', TRIM(PartNum))))) AS PartID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', Company)) AS CompanyID
	,CONCAT(Company, '#', TRIM([PartNum])) AS PartCode
	,PartitionKey

	,[Company]
	,TRIM(PartNum) AS [PartNum]
--	,PartNum AS [PartNum1]
	,TRIM([PartName]) AS [PartName]
	,TRIM([PartDescription]) AS [PartDescription]
	--,'' AS [PartDescription2]
	--,'' AS [PartDescription3]
	,TRIM((MainSupplier)) AS MainSupplier
	--,'' AS AlternativeSupplier
	,TRIM([ProductGroup]) AS [ProductGroup]
	--,'' AS [ProductGroup2]
	--,'' AS [ProductGroup3]
	--,'' AS [ProductGroup4]
	,TRIM([Brand]) AS [Brand]
	,TRIM([ComodityCode]) AS [CommodityCode]
	--,'' AS [PartReplacementNum]
	--,'' AS [PartStatus]
	,TRIM(([CountryOfOrigin])) AS [CountryOfOrigin]
	--,NULL AS [NetWeight] --REPLACE(REPLACE(REPLACE([NetWeight], '0 kg', 0), ',', '.'), ';', '')
	,TRIM(MAX([UoM])) AS [UoM]
	--,'' AS [Material]
	--,'' AS [Barcode]
	--,NULL AS [ReOrderLevel] --CAST(REPLACE([ReOrderLevel], 'na', null) AS decimal(18,4))
	--,'' AS [PartResponsible]
	,CONVERT(date, '1900-01-01') AS [StartDate]
	,CONVERT(date, '1900-01-01') AS [EndDate]
FROM [stage].[SPR_NL_Part]
GROUP BY
	PartitionKey, Company, [PartNum], [PartName], [PartDescription], [ProductGroup], [Brand], [ComodityCode], [CountryOfOrigin], MainSupplier
GO
