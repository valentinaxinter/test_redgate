IF OBJECT_ID('[stage].[vHAK_FI_Part]') IS NOT NULL
	DROP VIEW [stage].[vHAK_FI_Part];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [stage].[vHAK_FI_Part] AS
--COMMENT EMPTY FIELDS // ADD UPPER()TRIM() INTO PartID 2022
SELECT 
	--CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT([Company] ,'#', TRIM(UPPER([PartNum]))))) AS PartID -- ,'#', TRIM(UPPER([Site]))
	CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM([Company]),'#', TRIM([PartNum]))))) AS PartID -- ,'#', TRIM(UPPER([Site]))
	,CONVERT([binary](32),HASHBYTES('SHA2_256',[Company])) AS CompanyID
	,UPPER(CONCAT([Company],'#',TRIM([PartNum]))) AS PartCode
	,PartitionKey

	,[Company]
	,UPPER(TRIM(PartNum)) AS PartNum
	--,'' AS [PartName]
	,TRIM([PartDescription]) AS [PartDescription]
	,TRIM([PartDescription2]) AS [PartDescription2]
	--,'' AS [PartDescription3]
	--,NULL AS MainSupplier
	--,NULL AS AlternativeSupplier
	,TRIM([ProductGroup]) AS [ProductGroup]
	,TRIM([ProductGroup2]) AS [ProductGroup2]
	--,'' AS [ProductGroup3]
	--,'' AS [ProductGroup4]
	--,'' AS [Brand]
	,TRIM([CommodityCode]) AS [CommodityCode]
	--,'' AS PartReplacementNum
	--,'' AS PartStatus
	,TRIM([CountryOfOrigin]) AS [CountryOfOrigin]
	,[NetWeight]
	--,'' AS [UoM]
	--,'' AS [Material]
	--,'' AS [Barcode]
	,MAX([ReorderLevel]) AS [ReOrderLevel]
	--,'' AS PartResponsible
	--,'' AS [StartDate]
	--,'' AS [EndDate]
FROM [stage].[HAK_FI_Part]

GROUP BY 
	PartitionKey, Company, TRIM(PartNum), TRIM([CommodityCode]), TRIM([CountryOfOrigin]), NetWeight, TRIM([PartDescription]), TRIM([PartDescription2]), TRIM([ProductGroup]), TRIM([ProductGroup2])
GO
