IF OBJECT_ID('[dm_FH].[dimWarehouse]') IS NOT NULL
	DROP VIEW [dm_FH].[dimWarehouse];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [dm_FH].[dimWarehouse] AS

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
FROM [dm].[DimWareHouse] whs
LEFT JOIN dbo.Company com ON whs.Company = com.Company
WHERE com.BusinessArea = 'Fluid Handling Solutions' AND com.[Status] = 'Active'
GO
