IF OBJECT_ID('[prestage].[CYE_ES_Warehouse_Load]') IS NOT NULL
	DROP PROCEDURE [prestage].[CYE_ES_Warehouse_Load];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [prestage].[CYE_ES_Warehouse_Load]
AS
BEGIN

Truncate table stage.[CYE_ES_Warehouse]

insert into 
stage.CYE_ES_Warehouse(
	PartitionKey
	,[Company]
	,[WarehouseCode]
	,[WarehouseName]
	,[WarehouseDistrict]
	,[WarehouseAddress]
	,[WarehouseDescription]
	,[WarehouseType]
	,[WarehouseCountry]
	,[Site]
	)
select 
	PartitionKey
	,[Company]
	,[WarehouseCode]
	,[WarehouseName]
	,[WarehouseDistrict]
	,[WarehouseAddress]
	,[WarehouseDescription]
	,[WarehouseType]
	,[WarehouseCountry]
	,[Site]
from [prestage].[vCYE_ES_Warehouse]

--Truncate table prestage.[CYE_ES_Warehouse]

End
GO
