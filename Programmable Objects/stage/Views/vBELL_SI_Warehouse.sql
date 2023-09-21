IF OBJECT_ID('[stage].[vBELL_SI_Warehouse]') IS NOT NULL
	DROP VIEW [stage].[vBELL_SI_Warehouse];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [stage].[vBELL_SI_Warehouse] AS
--COMMENT EMPTY FIELD 2022-12-27
SELECT 
	CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM([Company]), '#', TRIM([WarehouseCode]))))) AS WarehouseID
	,PartitionKey

	,UPPER(TRIM([Company])) AS Company
	,IIF(UPPER(TRIM([WarehouseCode])) IS NULL, 'Central', UPPER(TRIM([WarehouseCode]))) AS [WarehouseCode]
	,[WarehouseName]
	,[WarehouseDistrict]
	,[WarehouseAddress]
	--,'' AS [WarehouseDescription]
	,[WarehouseType]
	,[WarehouseCountry]
	,[Site] AS [WarehouseSite]
FROM [stage].[BELL_SI_Warehouse]

GROUP BY 
	PartitionKey,[Company],[WarehouseCode],[WarehouseName],[WarehouseDistrict],[WarehouseAddress],[WarehouseType],[WarehouseCountry],[Site]
GO
