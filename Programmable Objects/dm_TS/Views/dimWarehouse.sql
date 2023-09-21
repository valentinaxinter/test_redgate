IF OBJECT_ID('[dm_TS].[dimWarehouse]') IS NOT NULL
	DROP VIEW [dm_TS].[dimWarehouse];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO









CREATE VIEW [dm_TS].[dimWarehouse] AS

SELECT 
[WareHouseID]
,[CompanyID]
,[Company]
,[WarehouseCode]
,[WarehouseName]
,[WarehouseDistrict]
,[WarehouseAddress]
,[WarehouseDescription]
,[WarehouseType]
,[WarehouseCountry]
,[WarehouseSite]
FROM [dm].[DimWareHouse] /*temp putting (CERPL) Certex PL here such that they see the data in same company*/
WHERE [Company] in (
'FESFORA'
, 'FSEFORA'
, 'FFRFORA'
, 'FORPL'
, 'CERPL'
, 'FFRGPI'
, 'FFRLEX'
, 'IFIWIDN'
, 'IEEWIDN'
, 'TMTFI'
, 'TMTEE'
, 'FITMT'
, 'EETMT'
, 'ABKSE'
, 'ROROSE'
,'STESE'
,'CERBG'
,'FORBG'
)
GO
