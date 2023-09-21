IF OBJECT_ID('[stage].[vTRA_FR_Warehouse]') IS NOT NULL
	DROP VIEW [stage].[vTRA_FR_Warehouse];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [stage].[vTRA_FR_Warehouse] AS
--COMMENT EMPTY FIELDS 22-12-29 VA
SELECT 
	CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM([Company]), '#', TRIM([WarehouseCode]))))) AS WarehouseID
	,PartitionKey

	,UPPER(TRIM([Company])) AS Company
	,UPPER(TRIM([WarehouseCode])) AS [WarehouseCode]
	,TRIM([WarehouseName]) AS [WarehouseName]
	--,'' AS [WarehouseDistrict]
	--,'' AS [WarehouseAddress]
	--,'' AS [WarehouseDescription]
	--,'' AS [WarehouseType]
	,'France' AS [WarehouseCountry]
	--,'' AS [WarehouseSite]
FROM [stage].[TRA_FR_Warehouse]

--GROUP BY 
--	PartitionKey,[Company],[WarehouseCode],[WarehouseName]
GO
