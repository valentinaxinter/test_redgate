IF OBJECT_ID('[stage].[vAXL_DE_Part]') IS NOT NULL
	DROP VIEW [stage].[vAXL_DE_Part];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE VIEW [stage].[vAXL_DE_Part] AS

SELECT 
	CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT([Company] ,'#', TRIM([PartNum]),'#', (IIF(TRIM([PartNum]) LIKE 'IACO%' , 'MISC. CHARGES', TRIM([PartDescription]) )))))) AS PartID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER([Company]))) AS CompanyID
	,UPPER(CONCAT([Company],'#', TRIM([PartNum]),'#', TRIM([PartDescription]))) AS PartCode
	,PartitionKey

	,UPPER([Company]) AS [Company]
	,UPPER(TRIM([PartNum])) AS [PartNum]
	,TRIM([PartName]) AS [PartName]
	,IIF(UPPER(TRIM([PartNum])) LIKE 'IACO%' , 'MISC. CHARGES', UPPER(TRIM([PartDescription]))) AS [PartDescription]
	,TRIM([PartDescription2]) AS [PartDescription2]
	,TRIM([PartDescription3]) AS [PartDescription3]
	,TRIM([ProductGroup]) AS [ProductGroup]
	,TRIM([ProductGroup2]) AS [ProductGroup2]
	,TRIM([ProductGroup3]) AS [ProductGroup3]
	,TRIM([ProductGroup4]) AS [ProductGroup4]
	,TRIM([Brand]) AS [Brand]
	,TRIM([CommodityCode]) AS [CommodityCode]
	,'' AS [PartReplacementNum]
	,[ItemStatus] AS [PartStatus]
	,MAX([CountryOfOrigin]) AS [CountryOfOrigin]
	,[NetWeight]
	,'' AS [UoM]
	,[Material]
	,[Barcode]
	,[Reorderlevel]
	,'' AS [PartResponsible]
	,MAX([StartDate]) AS [StartDate]
	,[EndDate]
FROM [stage].[AXL_DE_Part]
--WHERE [ItemStatus] <> 'D'
GROUP BY
	PartitionKey, [Company], TRIM([PartNum]), TRIM([PartName]), ([PartDescription]), TRIM([PartDescription2]), TRIM([PartDescription3]), TRIM([ProductGroup3]), TRIM([ProductGroup4]), TRIM([ProductGroup]), TRIM([ProductGroup2]), TRIM([CommodityCode]), [NetWeight], TRIM([Brand]), [Barcode], [Volume], [Material], [EndDate], [Reorderlevel], [ItemStatus]
GO
