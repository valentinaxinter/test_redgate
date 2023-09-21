IF OBJECT_ID('[stage].[vIOW_PL_Warehouse]') IS NOT NULL
	DROP VIEW [stage].[vIOW_PL_Warehouse];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [stage].[vIOW_PL_Warehouse] AS

SELECT 
	CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT([Company], '#', TRIM([WarehouseCode])))) AS WarehouseID
	,PartitionKey --getdate() AS 

	,Company
	,[WarehouseCode]
	,[WarehouseName]
	,[WarehouseDistrict]
	,[WarehouseAddress]
	,[WarehouseDescription]
	,[WarehouseType]
	,[WarehouseCountry]
	,[Site] AS [WarehouseSite]
FROM [axbus].[IOW_PL_Warehouse]
GO
