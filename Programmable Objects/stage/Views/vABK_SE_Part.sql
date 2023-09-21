IF OBJECT_ID('[stage].[vABK_SE_Part]') IS NOT NULL
	DROP VIEW [stage].[vABK_SE_Part];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [stage].[vABK_SE_Part] AS

SELECT 
	CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM([Company]),'#', TRIM([PartNum]))))) AS PartID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', [Company])) AS CompanyID
	,CONCAT([Company], '#', TRIM(UPPER([PartNum]))) AS PartCode
	,PartitionKey

	,[Company]
	,TRIM(UPPER(PartNum)) AS PartNum
	--,'' AS [PartName]
	,[PartDescription]
	,[PartDescription2]
	,[PartDescription3]
	,[ProductGroup] 
	,[ProductGroup2]
	,Res1_ProdCatNo AS [ProductGroup3]
	--,'' AS [ProductGroup4]
	,LEFT(PrimarySupplier, 50) AS MainSupplier -- at least 40 rows have length more than 50
	--,NULL AS AlternativeSupplier TO commented since there is no need 02/12/2022
	,[Brand]
	,[CommodityCode]
	,PartNumReplacement AS PartReplacementNum
	,ProductStatus AS PartStatus
	,[CountryOfOrigin]
	,[NetWeight]
	--,'' AS [UoM]
	,[Material]
	,[Barcode]
	,[ReorderLevel] AS [ReOrderLevel]
	--,'' AS PartResponsible
	,[StartDate]
	,[EndDate]
FROM [stage].[ABK_SE_Part]
GO
