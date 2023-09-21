IF OBJECT_ID('[dm_DS].[dimWarehouse]') IS NOT NULL
	DROP VIEW [dm_DS].[dimWarehouse];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/****** Object:  View [dm].[fctStockTran_LS]    Script Date: 2020-10-08 16:08:21 ******/

CREATE VIEW [dm_DS].[dimWarehouse] AS

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
FROM dm.DimWarehouse whs
LEFT JOIN dbo.Company com ON whs.Company = com.Company
WHERE com.BusinessArea = 'Driveline Solutions' AND com.[Status] = 'Active' 
--WHERE Company  in ('MIT', 'ATZ', 'Transaut', 'IPLIOWTR')  -- DS basket
GO
