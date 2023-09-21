IF OBJECT_ID('[stage].[vCER_NO_Part]') IS NOT NULL
	DROP VIEW [stage].[vCER_NO_Part];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [stage].[vCER_NO_Part] AS
--COMMENT EMPTY FIELDS / ADD TRIM()UPPER() INTO PartID 2022-12-16 VA
SELECT 
	CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM(Company),'#',TRIM([PartNum]))))) AS PartID
	--CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT(Company,'#',TRIM([PartNum])))) AS PartID
	,CONVERT([binary](32),HASHBYTES('SHA2_256',Company)) AS CompanyID
	,CONCAT(Company,'#',[PartNum]) AS PartCode
	,PartitionKey

	,Company
	,TRIM([PartNum]) AS [PartNum]
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
	,[Brand]
	,[CommodityCode]
	--,'' PartReplacementNum
	,[ItemStatus] AS PartStatus
	,[CountryOfOrigin]
	,[NetWeight]
	--,'' AS UoM
	--,'' AS [Material]
	--,'' AS [Barcode]
	,MAX([ReorderLevel]) AS [ReOrderLevel]
	--,'' AS PartResponsible
	--,'' AS [StartDate]
	--,'' AS [EndDate]
	,MAX([MinOrderQty]) AS [MinOrderQty]
	,MAX([SupplierCode]) AS [SupplierCode]
FROM 
	[stage].[CER_NO_Part]
GROUP BY
	PartitionKey, Company, [PartNum], [PartDescription], [PartDescription2], [ProductGroup], [ProductGroup2], [Brand], [CommodityCode], [CountryOfOrigin], [NetWeight], [ItemStatus]--, [ReorderLevel], [MinOrderQty], [SupplierCode]
GO
