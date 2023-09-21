IF OBJECT_ID('[stage].[vNOM_SE_Part]') IS NOT NULL
	DROP VIEW [stage].[vNOM_SE_Part];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [stage].[vNOM_SE_Part] AS
--COMMENT EMPTY FIELD 2022-12-20 VA
SELECT 
	CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM(vp.[Company]), '#', TRIM([PartNum]))))) AS PartID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(TRIM(vp.[Company])))) AS CompanyID
	,UPPER(CONCAT(TRIM(vp.[Company]),'#',TRIM([PartNum]))) AS PartCode
	,PartitionKey

	,UPPER(TRIM(vp.[Company])) AS Company
	,UPPER(TRIM([PartNum])) AS PartNum
	--,'' AS [PartName]
	,[PartDescription]
	,[PartDescription2]
	,DiscountGroup AS [PartDescription3]
	,CONCAT(TRIM(vp.SupplierCode), '-', TRIM(vs.SupplierName)) AS MainSupplier
	,ParentSupplier AS AlternativeSupplier
	,[ProductGroup]
	,[ProductGroup2]
	,[ProductGroup3]
	,[ProductGroup4]
	--,'' AS [Brand]
	,[CommodityCode]
	--,'' AS PartReplacementNum
	--,'' AS PartStatus
	,[CountryOfOrigin]
	,[NetWeight]
	--,'' AS [UoM]
	--,'' AS [Material]
	--,'' AS [Barcode]
	,[ReOrderLevel]
	,PartResponsible
	--,'' AS [StartDate]
	--,'' AS [EndDate]
FROM [stage].[NOM_SE_Part] vp
LEFT JOIN  [dw].[vAll_Supplier] vs ON vp.Company = vs.Company AND vp.SupplierCode = vs.SupplierNum
--GROUP BY
--	PartitionKey, vp.Company, PartNum, PartDescription, PartDescription2, ProductGroup, ProductGroup2, ProductGroup3, ProductGroup4, CommodityCode, CountryOfOrigin, NetWeight, ReorderLevel, PartResponsible, DiscountGroup, SupplierCode
GO
