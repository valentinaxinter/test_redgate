IF OBJECT_ID('[stage].[vCER_FI_Part]') IS NOT NULL
	DROP VIEW [stage].[vCER_FI_Part];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [stage].[vCER_FI_Part] AS
--COMMENT EMPTY FIELDS // ADD TRIM()UPPER() 2022-12-21 VA
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
	--,''AS [PartDescription3]
	,MainSupplier
	,AlternativeSupplier
	,[ProductGroup]
	,[ProductGroup2]
	,ProdCategory AS [ProductGroup3]
	,ProdGroup AS [ProductGroup4]
	--,'' AS [Brand]
	,[CommodityCode]
	--,'' AS PartReplacementNum
	--,'' AS PartStatus
	,[CountryOfOrigin]
	,[NetWeight]
	--,'' AS [UoM]
	--,'' AS [Material]
	,EAN AS [Barcode]
	,[ReOrderLevel]
	--,'' AS PartResponsible
	--,'' AS [StartDate]
	--,'' AS [EndDate]

FROM [stage].[CER_FI_Part]
GO
