IF OBJECT_ID('[stage].[vJEN_SE_Part]') IS NOT NULL
	DROP VIEW [stage].[vJEN_SE_Part];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [stage].[vJEN_SE_Part] AS
--COMMENT EMPTY FIELD / ADD UPPER() TRIM() INTO PartID 2022-12-19 VA
SELECT 
	--CONVERT([binary](32),HASHBYTES('SHA2_256',CONCAT([Company],'#',[PartNum]))) AS PartID
	CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM([Company]),'#',TRIM([PartNum]))))) AS PartID
	,CONVERT([binary](32),HASHBYTES('SHA2_256',[Company])) AS CompanyID
	,CONCAT([Company],'#',[PartNum]) AS PartCode
	,PartitionKey

	,[Company]
	,[PartNum]
	--,'' AS [PartName]
	,[PartDescription]
	,[PartDescription2]
	--,'' AS [PartDescription3]
	,SupplierCode AS MainSupplier
	--,NULL AS AlternativeSupplier
	,[ProductGroup]
	,[ProductGroup2]
	--,'' AS [ProductGroup3]
	--,'' AS [ProductGroup4]
	--,'' AS [Brand]
	,[CommodityCode]
	--,'' AS PartReplacementNum
	,StockItemStatus AS PartStatus
	,[CountryOfOrigin]
	,[NetWeight]
	--,'' AS UoM
	--,'' AS [Material]
	,EAN AS [Barcode]
	,[ReOrderLevel]
	--,'' AS PartResponsible
	--,'' AS [StartDate]
	--,'' AS [EndDate]

FROM [stage].[JEN_SE_Part]
GO
