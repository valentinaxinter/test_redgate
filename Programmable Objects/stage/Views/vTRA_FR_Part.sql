IF OBJECT_ID('[stage].[vTRA_FR_Part]') IS NOT NULL
	DROP VIEW [stage].[vTRA_FR_Part];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [stage].[vTRA_FR_Part] AS
--COMMENT EMPTY FIELDS // ADD TRIM() UPPER() INTO PartID 22-12-29 VA
SELECT
	--CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT(UPPER(Company),'#', TRIM([PartNum])))) AS PartID
	CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM(Company),'#', TRIM([PartNum]))))) AS PartID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(Company))) AS CompanyID
	,CONCAT(Company, '#', TRIM(UPPER(Company))) AS PartCode
	,PartitionKey

	,UPPER(Company) AS [Company]
	,TRIM([PartNum]) AS [PartNum]
	,TRIM([PartName]) AS [PartName]
	,TRIM([PartDescription]) AS [PartDescription]
	,TRIM([PartDescription2]) AS [PartDescription2]
	,TRIM([PartDescription3]) AS [PartDescription3]
	,LEFT(TRIM([MainSupplier]), 100) AS [MainSupplier]
	,TRIM([AlternativeSupplier]) AS [AlternativeSupplier]
	,TRIM([ProductGroup]) AS [ProductGroup]
	,TRIM([ProductGroup2]) AS [ProductGroup2]
	,TRIM([ProductGroup3]) AS [ProductGroup3]
	,TRIM([ProductGroup4]) AS [ProductGroup4]
	,TRIM([Brand]) AS [Brand]
	,TRIM([CommodityCode]) AS [CommodityCode]
	,TRIM([PartReplacementNum]) AS [PartReplacementNum]
	,IIF(TRIM([PartStatus]) = '', 'Aktiv', TRIM([PartStatus])) AS [PartStatus]
	,TRIM([CountryOfOrigin]) AS [CountryOfOrigin]
	,IIF([NetWeight] = '' or [NetWeight] IS NULL, 0,  TRY_CONVERT(decimal (18,4), [NetWeight])) AS [NetWeight]
	,TRIM([UoM]) AS [UoM]
	--,'' AS [Material]
	--,'' AS [Barcode]
	--,NULL AS [ReOrderLevel]
	--,'' AS [PartResponsible]
	--,'' AS [StartDate]
	--,'' AS [EndDate]
FROM [stage].[TRA_FR_Part]
GO
