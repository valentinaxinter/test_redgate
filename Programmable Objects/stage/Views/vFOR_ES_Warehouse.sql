IF OBJECT_ID('[stage].[vFOR_ES_Warehouse]') IS NOT NULL
	DROP VIEW [stage].[vFOR_ES_Warehouse];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO







CREATE VIEW [stage].[vFOR_ES_Warehouse] AS

SELECT 
	CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM([Company]),'#',TRIM([WarehouseCode]))))) AS WarehouseID
	,PartitionKey
	,UPPER(TRIM([Company])) AS Company
	,UPPER(TRIM([WarehouseCode])) AS [WarehouseCode]
	,[WarehouseName]
	,[WarehouseDistrict]
	,[WarehouseAddress]
	--,''	AS [WarehouseDescription]
	--,''	AS [WarehouseType]
	,[WarehouseCountry]
	--,'' AS [WarehouseSite]

FROM [stage].[FOR_ES_Warehouse]
GO
