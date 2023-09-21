IF OBJECT_ID('[stage].[vAXL_DE_Warehouse]') IS NOT NULL
	DROP VIEW [stage].[vAXL_DE_Warehouse];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [stage].[vAXL_DE_Warehouse] AS

SELECT 
	CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(Company, '#', TRIM([WarehouseCode]))))) AS WarehouseID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER([Company]))) AS CompanyID
	,UPPER(CONCAT([Company],'#', TRIM([WarehouseCode]))) AS [WarehouseCode]
	,PartitionKey

	,UPPER([Company]) AS [Company]
	,TRIM([WarehouseName]) AS [WarehouseName]
	,TRIM([WarehouseDistrict]) AS [WarehouseDistrict]
	,TRIM([WarehouseAddress]) AS [WarehouseAddress]
	,TRIM([WarehouseDescription]) AS [WarehouseDescription]
	,TRIM([WarehouseType]) AS [WarehouseType]
	,TRIM([WarehouseCountry]) AS [WarehouseCountry]
	,TRIM([Site]) AS [WarehouseSite]

FROM [stage].[AXL_DE_Warehouse]
GO
