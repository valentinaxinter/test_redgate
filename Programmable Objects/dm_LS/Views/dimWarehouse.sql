IF OBJECT_ID('[dm_LS].[dimWarehouse]') IS NOT NULL
	DROP VIEW [dm_LS].[dimWarehouse];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [dm_LS].[dimWarehouse] AS

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
WHERE com.BusinessArea = 'Lifting Solutions' AND com.[Status] = 'Active'

--WHERE [Company] in ('AFISCM', 'CDKCERT', 'CEECERT','CERDE', 'CFICERT', 'CLTCERT', 'CLVCERT', 'CSECERT', 'CUKCERT', 'CNOEHAU', 'CNOCERT', 'CERPL', 'CyESA', 'HFIHAKL', 'TRACLEV', 'MENBE14','MENNL01','MENNL02','MENNL03','MENNL04','MENNL07','MENNL11')
GO
