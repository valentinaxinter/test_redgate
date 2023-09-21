IF OBJECT_ID('[dm_PT].[dimWarehouse]') IS NOT NULL
	DROP VIEW [dm_PT].[dimWarehouse];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [dm_PT].[dimWarehouse] AS

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
FROM [dm].[DimWarehouse] whs
LEFT JOIN dbo.Company com ON whs.Company = com.Company
WHERE com.BusinessArea = 'Power Transmission Solutions' AND com.[Status] = 'Active'

--WHERE [Company] in ('ACZARKOV', 'AcornUK', 'BSIBELL', 'JDKJENSS', 'JDKKALTE', 'JFIJENSS', 'MNLMAK', 'JNOJENSS', 'NORNO', 'JSEJENSS', 'SSWSE', 'NomoSE', 'NomoDK', 'NomoFI', 'NomoNo', 'PASSEROT', 'SKSSCOFI', 'SCOFI', 'SMKFI', 'SNLSPRUI', 'SPRUITNL', 'SVESE')  -- The PT basket
GO
