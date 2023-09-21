IF OBJECT_ID('[prestage].[vCYE_ES_Part]') IS NOT NULL
	DROP VIEW [prestage].[vCYE_ES_Part];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE VIEW [prestage].[vCYE_ES_Part] AS

SELECT 
	CONVERT([binary](32),HASHBYTES('SHA2_256',CONCAT([Company],'#',[PartNum]))) AS PartID
	,CONCAT([Company],'#',[PartNum]) AS PartCode
	,CONVERT([binary](32),HASHBYTES('SHA2_256',[Company])) AS CompanyID	  
	,CONCAT(CONVERT (date, SYSDATETIME()), ' 00:00:00') AS [PartitionKey]

	,'CYESA' AS [Company]
	,[PartNum]
	,'' AS [PartName]
	,[PartDescription]
	,[PartDescription2]
	,'' AS [PartDescription3]
	,[ProductGroup]
	,[ProductGroup2]
	,'' AS [ProductGroup3]
	,'' AS [ProductGroup4]
	,'' AS [Brand]
	,'' AS [Barcode]
	,[CommodityCode]
	,[CountryOfOrigin]
	,REPLACE(NetWeight,',','.') AS [NetWeight]
	,0 AS [Volume]
	,'' AS [Material]
	,SupplierCode
	,0 AS [ReorderLevel]
	,'' AS [StartDate]
	,'' AS [EndDate]
	,'' AS ItemStatus
FROM [prestage].[CYE_ES_Part]
GO
