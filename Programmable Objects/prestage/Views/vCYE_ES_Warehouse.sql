IF OBJECT_ID('[prestage].[vCYE_ES_Warehouse]') IS NOT NULL
	DROP VIEW [prestage].[vCYE_ES_Warehouse];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO







CREATE VIEW [prestage].[vCYE_ES_Warehouse] AS

SELECT 
	CONCAT(CONVERT (date, SYSDATETIME()), ' 00:00:00') AS [PartitionKey]
	,'CYESA' AS [Company]
	,[WarehouseCode]
	,[WarehouseName]
	,[WarehouseDistrict]
	,[WarehouseAddress]
	,[WarehouseDescription]
	,[WarehouseType]
	,[WarehouseCountry]
	,[Site]
FROM [prestage].[CYE_ES_Warehouse]

GROUP BY 
	[WarehouseCode],[WarehouseName],[WarehouseDistrict], [WarehouseDescription], [WarehouseAddress],[WarehouseType],[WarehouseCountry], [Site]
GO
