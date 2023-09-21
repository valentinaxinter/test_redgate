IF OBJECT_ID('[stage].[vCYE_ES_Warehouse]') IS NOT NULL
	DROP VIEW [stage].[vCYE_ES_Warehouse];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [stage].[vCYE_ES_Warehouse] AS
--ADD TRIM() INTO WarehouseID 23-01-03 VA
SELECT 
	CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM('CYESA'), '#', TRIM([WarehouseCode]))))) AS WarehouseID
--	CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT('CYESA', '#', [WarehouseCode])))) AS WarehouseID
	,'2022-12-16 00:00:00' AS PartitionKey

	,'CYESA' AS Company
	,UPPER(TRIM([WarehouseCode])) AS [WarehouseCode]
	,[WarehouseName]
	,[WarehouseDistrict]
	,[WarehouseAddress]
	,[WarehouseName] AS [WarehouseDescription]
	,'Plant(Location)' AS [WarehouseType]
	,[WarehouseCountry]
	,[Site] AS [WarehouseSite]
FROM [prestage].[CYE_ES_Warehouse]

UNION ALL

SELECT 
	CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM('CYESA'), '#', TRIM([SalesOfficeDescrip]))))) AS WarehouseID
--	CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT('CYESA', '#', TRIM([SalesOfficeDescrip]))))) AS WarehouseID
	,'2022-12-16 00:00:00' AS PartitionKey

	,'CYESA' AS Company
	,UPPER(TRIM(SalesOfficeDescrip)) AS [WarehouseCode]
	,SalesOfficeDescrip AS [WarehouseName]
	,'' AS [WarehouseDistrict]
	,'' AS [WarehouseAddress]
	,SalesOfficeDescrip AS [WarehouseDescription]
	,'SalesOffice' AS [WarehouseType]
	,IIF(SalesOfficeCode = 'OF86', 'Islas Canarias', 'España') AS [WarehouseCountry]
	,'' AS [WarehouseSite]
FROM [prestage].[CYE_ES_SalesOffice]

--GROUP BY 
--	PartitionKey,[Company],[WarehouseCode],[WarehouseName],[WarehouseDistrict], [WarehouseDescription], [WarehouseAddress],[WarehouseType],[WarehouseCountry], [Site]
GO
