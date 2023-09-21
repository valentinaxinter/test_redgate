IF OBJECT_ID('[stage].[vIOW_PL_Part]') IS NOT NULL
	DROP VIEW [stage].[vIOW_PL_Part];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [stage].[vIOW_PL_Part] AS

SELECT
	CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM([Company]), '#', TRIM(PartNum))))) AS PartID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(TRIM([Company])))) AS CompanyID
	,UPPER(CONCAT(TRIM([Company]), '#', TRIM([PartNum]))) AS PartCode
	,PartitionKey --getdate() AS 

	,UPPER(TRIM([Company])) AS [Company]
	,UPPER(TRIM(PartNum)) AS [PartNum]
	,TRIM([PartName]) AS [PartName]
	,TRIM([PartDescription]) AS [PartDescription]
	,TRIM([PartDescription2]) AS [PartDescription2]
	,TRIM([PartDescription3]) AS [PartDescription3]
	,TRIM((MainSupplier)) AS MainSupplier
	,TRIM(AlternativeSupplier) AS AlternativeSupplier
	,TRIM([ProductGroup2]) AS [ProductGroup] --switched productgroup and productgroup2 as it was in the wrong order, 2023-03-24 SB
	,TRIM([ProductGroup]) AS [ProductGroup2]
	,TRIM([ProductGroup3]) AS [ProductGroup3]
	,TRIM([ProductGroup4]) AS [ProductGroup4]
	,TRIM([Brand]) AS [Brand]
	,TRIM(CommodityCode) AS [CommodityCode]
	,TRIM([PartReplacementNum]) AS [PartReplacementNum]
	,TRIM([PartStatus]) AS [PartStatus]
	,TRIM(([CountryOfOrigin])) AS [CountryOfOrigin]
	,NULL AS [NetWeight] --CAST([NetWeight] AS decimal(18,2))
	,TRIM([UoM]) AS [UoM]
	,TRIM([Material]) AS [Material]
	,TRIM([Barcode]) AS [Barcode]
	,NULL AS [ReOrderLevel] --CAST([ReOrderLevel] AS decimal(18,2))
	,TRIM([PartResponsible]) AS [PartResponsible]
	,[StartDate]
	,[EndDate]

FROM [axbus].[IOW_PL_Part]
--GROUP BY
--	PartitionKey, Company, [PartNum], [PartName], [PartDescription], [ProductGroup], [Brand], CommodityCode, [CountryOfOrigin], MainSupplier, [PartDescription2],[PartDescription3], AlternativeSupplier, [ProductGroup2], [ProductGroup3], [ProductGroup4], [PartReplacementNum], [PartStatus], [UoM], [Material], [Barcode], [PartResponsible], [StartDate], [EndDate]
GO
