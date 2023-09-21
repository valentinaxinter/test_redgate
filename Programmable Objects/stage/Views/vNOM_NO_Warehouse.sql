IF OBJECT_ID('[stage].[vNOM_NO_Warehouse]') IS NOT NULL
	DROP VIEW [stage].[vNOM_NO_Warehouse];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE   view [stage].[vNOM_NO_Warehouse] AS
--COMMENT EMPTY FIELDS 23-01-09 VA
SELECT 
	
	CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM([Company]),'#',TRIM([WarehouseCode]))))) AS WarehouseID
	,PartitionKey
	,[Company] AS Company
	,[WarehouseCode]
	,[WarehouseName]
	--,'' AS WarehouseDistrict
	--,'' AS WarehouseAddress
	--,'' AS WarehouseDescription
	--,'' AS WarehouseType
	--,'' AS WarehouseCountry
	--,'' AS WarehouseSite
FROM [stage].[NOM_NO_Warehouse]
GO
