IF OBJECT_ID('[stage].[vCER_EE_Part]') IS NOT NULL
	DROP VIEW [stage].[vCER_EE_Part];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [stage].[vCER_EE_Part] AS
--COMMENT EMPTY FIELDS / ADD UPPER()TRIM() INTO PartID 2022-12-15 VA
SELECT 
	CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM([Company]),'#',TRIM([PartNum]))))) AS PartID
	--CONVERT([binary](32),HASHBYTES('SHA2_256',CONCAT([Company],'#',[PartNum]))) AS PartID
	,CONVERT([binary](32),HASHBYTES('SHA2_256',[Company])) AS CompanyID
	,CONCAT([Company],'#',[PartNum]) AS PartCode
	,PartitionKey

	,[Company]
	,[PartNum] 
	--,'' AS [PartName]
	,[PartDescription]
	,[PartDescription2]
	--,'' AS [PartDescription3]
	--,NULL AS MainSupplier
	--,NULL AS AlternativeSupplier
	,[ProductGroup]
	,[ProductGroup2]
	--,'' AS [ProductGroup3]
	,[LabelFormat] AS [ProductGroup4]
	--,'' AS [Brand]
	,[CommodityCode]
	--,'' AS PartReplacementNum
	--,'' AS PartStatus
	,[CountryOfOrigin]
	,[NetWeight]
	--,'' AS UoM
	--,'' AS [Material]
	,EAN AS [Barcode]
	,[ReOrderLevel]
	--,'' AS PartResponsible
	--,'' AS [StartDate]
	--,'' AS [EndDate]
FROM [stage].[CER_EE_Part]
GO
