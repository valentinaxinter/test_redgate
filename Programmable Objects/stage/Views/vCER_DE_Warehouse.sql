IF OBJECT_ID('[stage].[vCER_DE_Warehouse]') IS NOT NULL
	DROP VIEW [stage].[vCER_DE_Warehouse];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create view [stage].[vCER_DE_Warehouse]
as

select 
CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT([Company], '#', TRIM([WarehouseCode]))))) AS WarehouseID,
Company,
WarehouseCode,
WarehouseName,
null as [WarehouseDistrict],
WarehouseAddress,
null as WarehouseDescription,
null as WarehouseType,
null as WarehouseCountry,
null as WarehouseSite,
PartitionKey
FROM stage.CER_DE_Warehouse;
GO
