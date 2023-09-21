IF OBJECT_ID('[stage].[vSUM_UK_Warehouse]') IS NOT NULL
	DROP VIEW [stage].[vSUM_UK_Warehouse];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [stage].[vSUM_UK_Warehouse] AS
SELECT
	CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM(dbo.summers()), '#', TRIM([WarehouseCode]))))) AS WarehouseID
	,PartitionKey
	,UPPER(TRIM(dbo.summers())) AS Company
	,UPPER(TRIM([WarehouseCode])) AS [WarehouseCode]
	,trim([WarehouseName]) as [WarehouseName]
	,trim([WarehouseDistrict]) as [WarehouseDistrict]
	,trim([WarehouseAddress]) as [WarehouseAddress]
	,trim([WarehouseDescription]) as [WarehouseDescription]
	,trim([WarehouseType]) as [WarehouseType]
	,trim([WarehouseCountry]) [WarehouseCountry]
	,trim([Site]) AS [WarehouseSite]
	,[Partnum]
FROM [stage].[SUM_UK_Warehouse]
GO
