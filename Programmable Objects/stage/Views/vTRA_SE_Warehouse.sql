IF OBJECT_ID('[stage].[vTRA_SE_Warehouse]') IS NOT NULL
	DROP VIEW [stage].[vTRA_SE_Warehouse];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [stage].[vTRA_SE_Warehouse] AS
--COMMENT EMPY FIELDS // ADD TRIM() INTO WarehouseID 2022-12-27 VA
SELECT 
	CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM(Company), '#', TRIM([WarehouseCode]))))) AS WarehouseID
	--CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(UPPER(Company), '#', TRIM([WarehouseCode]))))) AS WarehouseID
	,PartitionKey

	,UPPER(Company) AS Company
	,UPPER(TRIM([WarehouseCode])) AS [WarehouseCode]
	,[WarehouseName]
	--,'' AS [WarehouseDistrict]
	,[WarehouseAddress]
	--,'' AS [WarehouseDescription]
	--,'' AS [WarehouseType]
	,[WarehouseCountry]
	,[Site] AS [WarehouseSite]
FROM [stage].[TRA_SE_Warehouse]

GROUP BY 
	PartitionKey,[Company],[WarehouseCode],[WarehouseName],[WarehouseAddress],[WarehouseCountry],[Site] --,[WarehouseDistrict],[WarehouseType]
GO
