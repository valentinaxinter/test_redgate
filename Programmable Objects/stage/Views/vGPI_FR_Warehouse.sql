IF OBJECT_ID('[stage].[vGPI_FR_Warehouse]') IS NOT NULL
	DROP VIEW [stage].[vGPI_FR_Warehouse];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [stage].[vGPI_FR_Warehouse] AS

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

FROM [stage].[GPI_FR_Warehouse]
GO
