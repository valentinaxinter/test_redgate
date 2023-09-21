IF OBJECT_ID('[stage].[vATZ_UK_Warehouse]') IS NOT NULL
	DROP VIEW [stage].[vATZ_UK_Warehouse];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [stage].[vATZ_UK_Warehouse] AS
--COMMENT EMPTY FIELDS 2022-12-27 VA
SELECT 
	CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM([Company]), '#', TRIM([WarehouseCode]))))) AS WarehouseID
	,PartitionKey

	,UPPER(TRIM([Company])) AS Company
	,UPPER(TRIM([WarehouseCode])) AS [WarehouseCode]
	,[WarehouseName]
	,[WarehouseDistrict]
	,[WarehouseAddress]
	,[WarehouseDescription]
	,[WarehouseType]
	,[WarehouseCountry]
	--,'' AS [WarehouseSite]
FROM [stage].[ATZ_UK_Warehouse]

GROUP BY 
	PartitionKey,[Company],[WarehouseCode],[WarehouseName],[WarehouseDistrict],[WarehouseAddress],[WarehouseDescription],[WarehouseType],[WarehouseCountry]
GO
