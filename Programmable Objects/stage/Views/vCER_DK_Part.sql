IF OBJECT_ID('[stage].[vCER_DK_Part]') IS NOT NULL
	DROP VIEW [stage].[vCER_DK_Part];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [stage].[vCER_DK_Part] AS
--COMMENT empty fields / ADD UPPER(TRIM(Company)) into PartID 12-12-2022 VA
SELECT 
 
	CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM(Company),'#',TRIM(PartNum))))) AS PartID
	,UPPER(CONCAT([Company],'#',TRIM(PartNum))) AS PartCode
	,CONVERT([binary](32), HASHBYTES('SHA2_256',[Company])) AS CompanyID
	,PartitionKey

	,UPPER([Company]) AS Company
	,UPPER(TRIM(PartNum)) AS  PartNum
	--,'' AS [PartName]
	,[PartDescription]
	,[PartDescription2]
	--,'' AS [PartDescription3]
	--,NULL AS MainSupplier
	--,NULL AS AlternativeSupplier
	,[ProductGroup]
	,[ProductGroup2]
	--,'' AS [ProductGroup3]
	--,'' AS [ProductGroup4]
	,[Brand]
	--,'' AS [Barcode]
	,[CommodityCode]
	--,'' AS [PartReplacementNum]
	--,'' AS [PartStatus]
	,[CountryOfOrigin]
	,[NetWeight]
	--,'' AS [UoM]
	--,'' AS [Material]
	--,'' AS ItemStatus
	,[ReorderLevel] AS [ReOrderLevel]
	--,'' AS [PartResponsible]
	--,'' AS [StartDate]
	--,'' AS [EndDate]

FROM [stage].[CER_DK_Part]
GO
