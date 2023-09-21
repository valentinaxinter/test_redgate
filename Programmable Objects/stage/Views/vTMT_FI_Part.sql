IF OBJECT_ID('[stage].[vTMT_FI_Part]') IS NOT NULL
	DROP VIEW [stage].[vTMT_FI_Part];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [stage].[vTMT_FI_Part] AS

SELECT 
	CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM(p.[Company]), '#', TRIM([PartNum]))))) AS PartID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(p.[Company]))) AS CompanyID
	,UPPER(CONCAT(p.[Company], '#', TRIM([PartNum]))) AS PartCode
	,p.PartitionKey

	,UPPER(p.[Company]) AS [Company]
	,UPPER(TRIM([PartNum]))	AS PartNum
	,'' AS [PartName] --[Version]
	,[PartDescription]
	,[PartDescription2]
	,[SalesTracking] AS [PartDescription3] 
	,CONCAT(SupplierCode, '-', MainSupplierName) AS MainSupplier
	--,NULL AS AlternativeSupplier
	,[ProductGroup]
	,[ProductGroup2]
	,[ProductGroup3]
	,CONCAT(Tuoteryhmä, '-', Selite) AS [ProductGroup4]
	,[PartType] AS [Brand]
	,[CommodityCode]
	--,'' AS PartReplacementNum
	--,'' AS PartStatus
	,[CountryOfOrigin]
	,[NetWeight]
	,UoM
	--,'' AS [Material]
	--,'' AS [Barcode]
	,[ReOrderLevel]
	--,'' AS [PartResponsible]  --PartResponsible
	--,'' AS [StartDate]
	--,'' AS [EndDate]
FROM [stage].[TMT_FI_Part] p
 LEFT JOIN [stage].[TMT_FI_Supplier] s ON p.SupplierCode = s.SupplierNum

GROUP BY p.[Company], p.PartitionKey, [PartNum], [PartDescription],[PartDescription2],[SalesTracking], SupplierCode, [ProductGroup], [ProductGroup2],[ProductGroup3], Tuoteryhmä, Selite, [CommodityCode], [CountryOfOrigin], [NetWeight], [ReOrderLevel], UoM, MainSupplierName, [PartType]
GO
