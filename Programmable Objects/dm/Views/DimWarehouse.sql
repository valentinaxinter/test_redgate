IF OBJECT_ID('[dm].[DimWarehouse]') IS NOT NULL
	DROP VIEW [dm].[DimWarehouse];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [dm].[DimWarehouse] AS

SELECT
	--CONVERT(bigint, CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT([Company], '#', [WarehouseCode])))) AS WareHouseID 
	CONVERT(bigint,WareHouseID ) AS WareHouseID 
	,CONVERT(bigint, CONVERT([binary](32), HASHBYTES('SHA2_256', [Company]))) AS CompanyID
	,[Company]
	,MAX([WarehouseCode]) AS [WarehouseCode]
	,MAX([WarehouseName]) AS [WarehouseName]
	,MAX([WarehouseDistrict]) AS [WarehouseDistrict]
	,MAX([WarehouseAddress]) AS [WarehouseAddress]
	,MAX([WarehouseDescription]) AS [WarehouseDescription]
	,MAX([WarehouseType]) AS [WarehouseType]
	,MAX([WarehouseCountry]) AS [WarehouseCountry]
	,MAX([WarehouseSite]) AS [WarehouseSite]
FROM 
	dw.Warehouse
WHERE [WarehouseName] <> 'Exclude' OR WarehouseName IS NULL -- Added Or IS NULL condition since those rows need to be included. The Condition <> 'Exclude' does remove WarehouseName with value NULL /SM 2021-05-07
GROUP BY
	[WarehouseID], [Company], [WarehouseCode]
GO
