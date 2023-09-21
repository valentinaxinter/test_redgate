IF OBJECT_ID('[stage].[vTMT_FI_Warehouse]') IS NOT NULL
	DROP VIEW [stage].[vTMT_FI_Warehouse];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [stage].[vTMT_FI_Warehouse] AS

SELECT 
	CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM([Company]), '#', TRIM([WarehouseCode]))))) AS WarehouseID
	,PartitionKey

	,UPPER([Company]) AS [Company]
	,TRIM([WarehouseCode]) AS [WarehouseCode]
	,[WarehouseName]
	,[WarehouseDistrict]
	,[WarehouseAddress]
	,[WarehouseDescription]
	,[WarehouseType]
	,[WarehouseCountry]
	,'' AS WarehouseSite
FROM [stage].[TMT_FI_Warehouse]
GO
