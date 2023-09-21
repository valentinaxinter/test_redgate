IF OBJECT_ID('[dm_IN].[dimWarehouse]') IS NOT NULL
	DROP VIEW [dm_IN].[dimWarehouse];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE VIEW [dm_IN].[dimWarehouse] AS

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
WHERE Company  in ('OCSSE')  -- Industry basket
GO
