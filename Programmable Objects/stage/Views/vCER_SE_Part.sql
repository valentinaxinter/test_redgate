IF OBJECT_ID('[stage].[vCER_SE_Part]') IS NOT NULL
	DROP VIEW [stage].[vCER_SE_Part];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [stage].[vCER_SE_Part] AS
--COMMENT empty fields / ADD TRIM(Company) into PartID VA - 12-13-2022
SELECT 
	CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM([Company]), '#', TRIM([PartNum]))))) AS PartID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', TRIM(([Company])))) AS CompanyID
	,CONCAT([Company], '#', TRIM(UPPER([PartNum]))) AS PartCode
	,PartitionKey

	,[Company]
	,TRIM(UPPER([PartNum])) AS [PartNum]
	--,'' AS [PartName]
	,[PartDescription]
	,[PartDescription2]
	--,'' AS [PartDescription3]
	--,NULL AS MainSupplier
	--,NULL AS AlternativeSupplier
	,[ProductGroup]
	,[ProductGroup2]
	,GoodsType AS [ProductGroup3] --request by Petter Wallin 20230329 ticket #SR-102535
	,LTMGroupOR AS [ProductGroup4] --request by Petter Wallin 20230329 ticket #SR-102535
	--,'' AS [Brand]
	,[CommodityCode]
	--,'' AS PartReplacementNum
	--,'' AS PartStatus
	,[CountryOfOrigin]
	,[NetWeight]
	--,'' AS UoM
	--,'' AS [Material]
	,[EAN] AS [Barcode]
	,[ReOrderLevel]
	--,'' AS PartResponsible
	--,'' AS [StartDate]
	--,'' AS [EndDate]
	--,'' AS ItemStatus
	
	

FROM [stage].[CER_SE_Part]
GO
