IF OBJECT_ID('[stage].[vCYE_ES_Part]') IS NOT NULL
	DROP VIEW [stage].[vCYE_ES_Part];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [stage].[vCYE_ES_Part] AS
--COMMENT EMPTY FIELDS // ADD TRIM() INTO PartID 23-01-03 VA
SELECT 
	CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM([Company]), '#', TRIM([PartNum]))))) AS PartID
--	CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT([Company], '#', TRIM([PartNum]))))) AS PartID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER([Company]))) AS CompanyID
	,UPPER(CONCAT([Company], '#', TRIM([PartNum]))) AS PartCode
	,PartitionKey

	,UPPER([Company]) AS [Company]
	,UPPER(TRIM([PartNum])) AS [PartNum]
	--,'' AS [PartName]
	,[PartDescription]
	,[PartDescription2]
	,CASE WHEN LEFT(PartNum, 2) = 'Y9' THEN 'Service'
		WHEN PartNum in ('YPCB', 'YPCD', 'YTAC', 'YTCD') THEN 'Assembled Product' --20210525 /DZ+ET
		ELSE NULL END AS [PartDescription3]
	--,NULL AS MainSupplier
	--,NULL AS AlternativeSupplier
	,[ProductGroup2] AS [ProductGroup]
	,[ProductGroup] AS [ProductGroup2]
	--,'' AS [ProductGroup3]
	--,'' AS [ProductGroup4]
	--,'' AS [Brand]
	,[CommodityCode]
	--,'' AS PartReplacementNum
	--,'' AS PartStatus
	,[CountryOfOrigin]
	,[NetWeight]
	--,'' AS UoM
	--,'' AS [Material]
	--,'' AS [Barcode]
	--,NULL AS ReOrderLevel
	--,'' AS PartResponsible
	--,'' AS [StartDate]
	--,'' AS [EndDate]
	--,0 AS [Volume]
	--,'' AS ItemStatus
FROM [stage].[CYE_ES_Part]
GO
