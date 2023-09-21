IF OBJECT_ID('[stage].[vCER_DE_StockBalance]') IS NOT NULL
	DROP VIEW [stage].[vCER_DE_StockBalance];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create view [stage].[vCER_DE_StockBalance]
as

select 
CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM([Company]),'#',TRIM([PartNum]),'#',TRIM([WarehouseCode]))))) AS ItemWarehouseID,
TRIM([WarehouseCode]) as WarehouseCode,
TRIM(Currency) as Currency,
TRIM(Company) as Company,
BinNum,
BatchNum,
null as SupplierNum,
PartNum,
DelivTime,
LastStockTakeDate,
LastStdCostCalDate,
SafetyStock,
MaxStockQty,
StockBalance,
StockValue,
ReserveQty,
BackOrderQty,
OrderQty,
null as StockTakeDiff,
ReOrderLevel,
OptimalOrderQty,
AvgCost,
UPPER(CONCAT([Company],'#',TRIM([PartNum]),'#',TRIM([WarehouseCode]))) AS ItemWarehouseCode,
SBRes1,
SBRes2,
SBRes3,
CONVERT([binary](32),HASHBYTES('SHA2_256',[Company])) AS CompanyID,
CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM([Company]),'#','')))) AS SupplierID,
CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM([Company]),'#',TRIM([PartNum]))))) AS PartID,
CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM([Company]),'#',TRIM([WarehouseCode]))))) AS WarehouseID,
PartitionKey
FROM stage.CER_DE_StockBalance;
GO
