IF OBJECT_ID('[stage].[vCER_LT_Warehouse]') IS NOT NULL
	DROP VIEW [stage].[vCER_LT_Warehouse];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [stage].[vCER_LT_Warehouse] AS
--COMMENT EMPTY FIELDS 2022-12-14 VA
SELECT 
	CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM([Company]), '#', TRIM([WarehouseCode]))))) AS WarehouseID
	,PartitionKey

	,UPPER(TRIM([Company])) AS Company
	,UPPER(TRIM([WarehouseCode])) AS [WarehouseCode]
	,[WarehouseName]
	,[WarehouseDistrict]
	,[WarehouseAddress]
	--,'' AS [WarehouseDescription]
	,[WarehouseType]
	,[WarehouseCountry]
	--,'' AS [WarehouseSite]
FROM [stage].[CER_LT_Warehouse]

GROUP BY 
	PartitionKey,[Company],[WarehouseCode],[WarehouseName],[WarehouseDistrict],[WarehouseAddress],[WarehouseType],[WarehouseCountry]
GO
