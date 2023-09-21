IF OBJECT_ID('[stage].[vFOR_FR_Warehouse]') IS NOT NULL
	DROP VIEW [stage].[vFOR_FR_Warehouse];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE VIEW [stage].[vFOR_FR_Warehouse] AS

SELECT 
	CONVERT([binary](32), HASHBYTES('SHA2_256', Upper(CONCAT([Company], '#', TRIM([WarehouseCode]))))) AS WarehouseID
	,PartitionKey
	,[Company]
	,TRIM([WarehouseCode]) AS [WarehouseCode]
	,[WarehouseName]
	,[WarehouseDistrict]
	,[WarehouseAddress]
	,[WarehouseDescription]
	,[WarehouseType]
	,[WarehouseCountry]
	,'' AS [WarehouseSite]

FROM [stage].[FOR_FR_Warehouse]
where TRIM(WarehouseName) <> 'Ancien Roumanie ne plus utiliser' -- Temporary added to avoid a duplicate
GO
