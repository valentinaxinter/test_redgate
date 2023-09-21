IF OBJECT_ID('[stage].[vPAS_PL_Part]') IS NOT NULL
	DROP VIEW [stage].[vPAS_PL_Part];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [stage].[vPAS_PL_Part] AS
--COMMENT EMPTY FIELDS // ADD TRIM() INTO PartID 23-01-05 VA
SELECT 
	CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM([company]),'#', TRIM(partnum))))) AS PartID
     --CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT([company] ,'#', TRIM(UPPER(partnum))))) AS PartID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', [company])) AS CompanyID
	,CONCAT([company], '#', TRIM(UPPER(partnum))) AS PartCode
	,PartitionKey

	,[company] AS [Company]
	,TRIM(UPPER(partnum)) AS [PartNum]
	,TRIM([partname]) AS [PartName]
	,[partdescription] AS [PartDescription]
	,[partdescription2] AS [PartDescription2]
	--,'' AS [PartDescription3]
	--,NULL AS MainSupplier
	--,NULL AS AlternativeSupplier
	,iif(SUBSTRING(partnum, 1, 2) in ('WP','WU') ,'W – Own production',[productgroup]) AS [ProductGroup]
	,CASE 
	WHEN SUBSTRING(partnum, 1, 2) = 'WP' THEN 'WP – Gaskets'
	WHEN SUBSTRING(partnum, 1, 2) = 'WU' THEN 'WU – Seals'
	ELSE [productgroup2] END AS [ProductGroup2]
	,[productgroup3] AS [ProductGroup3]
	--,'' AS [ProductGroup4]
	,[brand] AS [Brand]
	,[commoditycode] AS [CommodityCode]
	,[partstatus] AS PartStatus
	--,'' AS PartReplacementNum
	,[countryoforigin] AS [CountryOfOrigin]
	,[netweight] AS [NetWeight]
	--,'' AS UoM
	,[material] AS [Material]
	,[barcode] AS [Barcode]
	,[reorderlevel] AS [ReOrderLevel]
	--,'' AS PartResponsible
	,[startdate] AS [StartDate]
	,[enddate] AS [EndDate]

FROM [stage].[PAS_PL_Part]
GO
