IF OBJECT_ID('[stage].[vCER_DK_Warehouse]') IS NOT NULL
	DROP VIEW [stage].[vCER_DK_Warehouse];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [stage].[vCER_DK_Warehouse] AS
-- COMMENT empty fields/ ADD TRIM into WarehouseID 12-12-2022 VA
SELECT 
	CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM([Company]), '#', TRIM([WarehouseCode]))))) AS WarehouseID
	,PartitionKey

	,UPPER(TRIM([Company])) AS Company
	,COALESCE(UPPER(TRIM([WarehouseCode])),'') AS [WarehouseCode]		--Added coalesce statement due to that one row for Missing Code is an empty warehouse code
	,[WarehouseName]
	--,'' AS [WarehouseDistrict]
	,[WarehouseAddress]
	--,'' AS [WarehouseDescription]
	--,''	AS [WarehouseType]
	--,'' AS [WarehouseCountry]
	--,'' AS [WarehouseSite]
FROM [stage].[CER_DK_Warehouse]

GROUP BY 
	PartitionKey,[Company],[WarehouseCode],[WarehouseName],[WarehouseAddress]
GO
