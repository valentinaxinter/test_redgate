IF OBJECT_ID('[stage].[vWID_FI_Warehouse]') IS NOT NULL
	DROP VIEW [stage].[vWID_FI_Warehouse];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [stage].[vWID_FI_Warehouse] AS

SELECT 
	CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM([Company]), '#', TRIM([WarehouseCode]))))) AS WarehouseID
	,PartitionKey

	,[Company]
	,TRIM([WarehouseCode]) AS [WarehouseCode]
	,[WarehouseName]
	,[WarehouseDistrict]
	,[WarehouseAddress]
	,[WarehouseDescription]
	,[WarehouseType]
	,[WarehouseCountry]
	--,'' AS [WarehouseSite]
FROM [stage].[WID_FI_Warehouse]
GO
