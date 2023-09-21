IF OBJECT_ID('[stage].[vNOM_DK_Warehouse]') IS NOT NULL
	DROP VIEW [stage].[vNOM_DK_Warehouse];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE   view [stage].[vNOM_DK_Warehouse] AS
--Comment empty fields 23-01-05 VA
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
FROM [stage].[NOM_DK_Warehouse]
GO
