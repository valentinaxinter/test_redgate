IF OBJECT_ID('[stage].[vMIT_UK_Part]') IS NOT NULL
	DROP VIEW [stage].[vMIT_UK_Part];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [stage].[vMIT_UK_Part] AS
--COMMENT EMPTY FIELDS // ADD UPPER() TRIM() INTO PartID 22-12-28 VA
SELECT 
	--CONVERT([binary](32),HASHBYTES('SHA2_256',CONCAT([Company],'#',TRIM([PartNum])))) AS PartID
	CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM([Company]),'#',TRIM([PartNum]))))) AS PartID
	,CONVERT([binary](32),HASHBYTES('SHA2_256',[Company])) AS CompanyID
	,CONCAT([Company],'#',TRIM([PartNum])) AS PartCode
	,PartitionKey

	,[Company]
	,TRIM([PartNum]) AS [PartNum] -- different cases are used for PartNum, it affects query results! data-Input quality should be improved!
	--,'' AS [PartName]
	,MAX([PartDescription]) AS [PartDescription]
	,MAX([PartDescription2]) AS [PartDescription2]
	--,'' AS [PartDescription3]
	--,NULL AS MainSupplier
	--,NULL AS AlternativeSupplier
	,MAX([ProductGroup]) AS [ProductGroup]
	--,'' AS [ProductGroup2]
	--,'' AS [ProductGroup3]
	--,'' AS [ProductGroup4]
	--,'' AS [Brand]
	,TRIM([CommodityCode]) AS [CommodityCode]
	--,'' AS PartReplacementNum
	--,'' AS PartStatus
	,TRIM([CountryOfOrigin]) AS [CountryOfOrigin]
	,[NetWeight]
	--,'' AS UoM
	--,'' AS [Material]
	--,'' AS [Barcode]
	,MAX([ReorderLevel]) AS [ReorderLevel]
	--,'' AS PartResponsible
	--,'' AS [StartDate]
	--,'' AS [EndDate]
	--,'' AS ItemStatus
FROM [stage].[MIT_UK_Part]

GROUP BY 
	PartitionKey, Company, TRIM([PartNum]), TRIM([CommodityCode]), TRIM([CountryOfOrigin]), NetWeight
GO
