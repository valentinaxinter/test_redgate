IF OBJECT_ID('[stage].[vFOR_PL_Warehouse]') IS NOT NULL
	DROP VIEW [stage].[vFOR_PL_Warehouse];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [stage].[vFOR_PL_Warehouse] AS
--COMMENT EMPTY FIELDS // ADD TRIM()UPPER() INTO WarehouseID 23-01-11 VA
SELECT 
	 CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM([Company]),'#',TRIM([WarehouseCode]))))) AS WarehouseID
--	CONVERT([binary](32),HASHBYTES('SHA2_256',CONCAT([Company],'#',TRIM([WarehouseCode])))) AS WarehouseID
	,PartitionKey
	,Company
	,TRIM([WarehouseCode])	AS [WarehouseCode]
	,[WarehouseName]
	,[WarehouseDistrict]
	,[WarehouseAddress]
	--,''	AS [WarehouseDescription]
	--,''	AS [WarehouseType]
	,[WarehouseCountry]
	--,'' AS [WarehouseSite]
FROM [stage].[FOR_PL_Warehouse]
GO
