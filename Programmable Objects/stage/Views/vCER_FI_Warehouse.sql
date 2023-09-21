IF OBJECT_ID('[stage].[vCER_FI_Warehouse]') IS NOT NULL
	DROP VIEW [stage].[vCER_FI_Warehouse];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [stage].[vCER_FI_Warehouse] AS
--COMMENT EMPTY FIELD 2022-12-21 VA
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
FROM [stage].[CER_FI_Warehouse]

GROUP BY 
	PartitionKey,[Company],[WarehouseCode],[WarehouseName],[WarehouseDistrict],[WarehouseAddress],[WarehouseType],[WarehouseCountry]
GO