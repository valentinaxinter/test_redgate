IF OBJECT_ID('[stage].[vOCS_SE_Part]') IS NOT NULL
	DROP VIEW [stage].[vOCS_SE_Part];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [stage].[vOCS_SE_Part] AS
--COMMENT EMPTY FIELDS // ADD UPPER() TRIM() INTO PartID 2022-12-21 VA
SELECT 
	CONVERT([binary](32), HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM([Company]),'#', TRIM([PartNum]))))) AS PartID
	--CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT([Company] ,'#', TRIM(UPPER([PartNum])) ))) AS PartID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', Upper(trim([Company])))) AS CompanyID
	,UPPER(CONCAT([Company], '#', TRIM([PartNum]))) AS PartCode
	,PartitionKey

	,[Company]
	,UPPER(TRIM(PartNum)) AS PartNum
	--,'' AS [PartName] 
	,MAX([PartDescription]) AS [PartDescription]
	,MAX([PartDescription2]) AS [PartDescription2]
	,MAX(Res1_ProdCatNo) AS [PartDescription3]
	--,NULL AS MainSupplier
	--,NULL AS AlternativeSupplier
	,MAX([ProductGroup]) AS [ProductGroup]
	,MAX([ProductGroup2]) AS [ProductGroup2]
	,MAX([ProductGroup3]) AS [ProductGroup3]
	,MAX([ProductGroup4]) AS [ProductGroup4]
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
	

FROM [stage].[OCS_SE_Part]

GROUP BY 
	PartitionKey, Company, TRIM(PartNum), TRIM([CommodityCode]), TRIM([CountryOfOrigin]), NetWeight
GO
