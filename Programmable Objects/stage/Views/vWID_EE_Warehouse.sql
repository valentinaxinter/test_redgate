IF OBJECT_ID('[stage].[vWID_EE_Warehouse]') IS NOT NULL
	DROP VIEW [stage].[vWID_EE_Warehouse];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [stage].[vWID_EE_Warehouse] AS
--COMMENT EMPTY FIELD 2022-12-23 VA
SELECT 
	CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM([Company]), '#', TRIM([WarehouseCode]))))) AS WarehouseID
	,PartitionKey

	,[Company]
	,TRIM([WarehouseCode]) AS [WarehouseCode]
	,[WarehouseName]
	,[WarehouseDistrict]
	,[WarehouseAddress]
	--,'' AS [WarehouseDescription]
	,[WarehouseType]
	,[WarehouseCountry]
	--,'' AS WarehouseSite
FROM [stage].[WID_EE_Warehouse]
GO
