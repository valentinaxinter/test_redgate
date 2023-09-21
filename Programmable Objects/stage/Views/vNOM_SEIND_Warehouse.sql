IF OBJECT_ID('[stage].[vNOM_SEIND_Warehouse]') IS NOT NULL
	DROP VIEW [stage].[vNOM_SEIND_Warehouse];

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE VIEW [stage].[vNOM_SEIND_Warehouse] AS

SELECT 
	
	CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM([Company]), '#', TRIM([WarehouseCode]))))) AS WarehouseID
	,PartitionKey
	,TRIM([Company]) AS Company
	,TRIM([WarehouseCode]) AS [WarehouseCode]
	,TRIM([WarehouseName]) AS [WarehouseName]
	--,'' AS WarehouseDistrict
	--,'' AS WarehouseAddress
	--,'' AS WarehouseDescription
	--,'' AS WarehouseType
	--,'' AS WarehouseCountry
	--,'' AS WarehouseSite
FROM [stage].[NOM_SEIND_Warehouse]
GO
