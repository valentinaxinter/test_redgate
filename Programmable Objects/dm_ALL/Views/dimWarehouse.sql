IF OBJECT_ID('[dm_ALL].[dimWarehouse]') IS NOT NULL
	DROP VIEW [dm_ALL].[dimWarehouse];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [dm_ALL].[dimWarehouse] AS

SELECT 
 whs.[WareHouseID]
,whs.[CompanyID]
,whs.[Company]
,whs.[WarehouseCode]
,whs.[WarehouseName]
,whs.[WarehouseDistrict]
,whs.[WarehouseAddress]
,whs.[WarehouseDescription]
,whs.[WarehouseType]
,whs.[WarehouseCountry]
,whs.[WarehouseSite]
FROM dm.DimWarehouse as whs
GO
