IF OBJECT_ID('[dm_DEMO].[dimWarehouse]') IS NOT NULL
	DROP VIEW [dm_DEMO].[dimWarehouse];

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE VIEW [dm_DEMO].[dimWarehouse] AS

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
FROM [dm].[DimWareHouse] as whs /*temp putting (CERPL) Certex PL here such that they see the data in same company*/
WHERE [Company] in ('DEMO')
GO
