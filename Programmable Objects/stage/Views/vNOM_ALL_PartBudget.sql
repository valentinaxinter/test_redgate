IF OBJECT_ID('[stage].[vNOM_ALL_PartBudget]') IS NOT NULL
	DROP VIEW [stage].[vNOM_ALL_PartBudget];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [stage].[vNOM_ALL_PartBudget] AS

SELECT 
	CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM(vp.[Company]),'#',TRIM([PartNum]))))) AS PartID
	,CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(TRIM(vp.[Company])))) AS CompanyID
	,UPPER(CONCAT(TRIM(vp.[Company]),'#',TRIM([PartNum]))) AS PartCode
	,'2022-01-01' AS PartitionKey

	,UPPER(TRIM(vp.[Company])) AS Company
	,UPPER(TRIM([PartNum])) AS PartNum
	,UPPER(TRIM([PartNum])) AS [PartName]
	,[PartDescription]
	,[PartDescription2]
	,[PartDescription3]
	,CONCAT(TRIM(vp.ParentSupplier), '-', TRIM(vs.SupplierName)) AS MainSupplier
	,ParentSupplier AS AlternativeSupplier
	,[ProductGroup]
	,[ProductGroup2]
	,[ProductGroup3]
	,[ProductGroup4]
	,'' AS [Brand]
	,[CommodityCode]
	,'' AS PartReplacementNum
	,'' AS PartStatus
	,[CountryOfOrigin]
	,null AS [NetWeight]
	,'' AS [UoM]
	,'' AS [Material]
	,'' AS [Barcode]
	,null AS [ReOrderLevel]
	,PartResponsible
	,'' AS [StartDate]
	,'' AS [EndDate]
FROM [stage].[NOM_ALL_PartBudget] vp
LEFT JOIN  [dw].[vAll_Supplier] vs ON vp.Company = vs.Company AND vp.ParentSupplier = vs.SupplierNum
--GROUP BY
--	PartitionKey, vp.Company, PartNum, PartDescription, PartDescription2, ProductGroup, ProductGroup2, ProductGroup3, ProductGroup4, CommodityCode, CountryOfOrigin, NetWeight, ReorderLevel, PartResponsible, DiscountGroup, SupplierCode
GO
