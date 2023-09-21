IF OBJECT_ID('[stage].[vSVE_SE_Part]') IS NOT NULL
	DROP VIEW [stage].[vSVE_SE_Part];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [stage].[vSVE_SE_Part] AS
--COMMENT EMPTY FIELDS // ADD TRIM() UPPER() INTO  PartID 23-01-03 VA
SELECT
	CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM(Company),'#', TRIM([PartNum]))))) AS PartID
--	CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT(Company,'#', TRIM([PartNum])))) AS PartID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', Company)) AS CompanyID
	,CONCAT(Company, '#', TRIM([PartNum])) AS PartCode
	,PartitionKey

	,[Company]
	,TRIM([PartNum]) AS [PartNum]
	,TRIM([PartName]) AS [PartName]
	,TRIM([PartDescription]) AS [PartDescription]
	,TRIM([PartDescription2]) AS [PartDescription2]
	,TRIM([PartDescription3]) AS [PartDescription3]
	,TRIM(PrimarySupplier) AS MainSupplier
	--,NULL AS AlternativeSupplier
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
FROM [stage].[SVE_SE_Part]
GO
