IF OBJECT_ID('[stage].[vSPR_NL_Warehouse]') IS NOT NULL
	DROP VIEW [stage].[vSPR_NL_Warehouse];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE VIEW [stage].[vSPR_NL_Warehouse] AS

SELECT 
	CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM([Company]), '#', TRIM([WarehouseCode]))))) AS WarehouseID
	,PartitionKey

	,UPPER(TRIM([Company])) AS Company
	,UPPER(TRIM([WarehouseCode])) AS [WarehouseCode]
	,TRIM([WarehouseName]) AS [WarehouseName]
	,TRIM([WarehouseDistrict]) AS [WarehouseDistrict]
	,TRIM([WarehouseAddress]) AS [WarehouseAddress]
	,TRIM([WarehouseDescription]) AS [WarehouseDescription]
	,TRIM([WarehouseType]) AS [WarehouseType]
	,TRIM([WarehouseCountry]) AS [WarehouseCountry]
	,TRIM([WarehouseSite]) AS [WarehouseSite]
FROM [stage].[SPR_NL_Warehouse]

GROUP BY 
	PartitionKey,[Company],[WarehouseCode],[WarehouseName],[WarehouseDistrict],[WarehouseAddress],[WarehouseDescription],[WarehouseType],[WarehouseCountry], [WarehouseSite]
GO
