IF OBJECT_ID('[stage].[vJEN_NO_Part]') IS NOT NULL
	DROP VIEW [stage].[vJEN_NO_Part];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [stage].[vJEN_NO_Part] AS
--COMMENT EMPTY FIELDS // ADD UPPER()TRIM() INTO 2022-12-23
SELECT 
	CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM([Company]),'#',TRIM([PartNum]))))) AS PartID
	--CONVERT([binary](32),HASHBYTES('SHA2_256',CONCAT([Company],'#',[PartNum]))) AS PartID
	,CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER([Company]))) AS CompanyID
	,CONCAT([Company],'#',TRIM([PartNum])) AS PartCode
	,PartitionKey

	,UPPER([Company]) AS [Company]
	,UPPER(TRIM([PartNum])) AS [PartNum]
	--,'' AS [PartName]
	,[PartDescription]
	,[PartDescription2]
	--,'' AS [PartDescription3]
	,SupplierCode AS MainSupplier
	,NULL AS AlternativeSupplier
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
FROM [stage].[JEN_NO_Part]
WHERE [PartDescription] != 'IKKE BRUK !!'
GO
