IF OBJECT_ID('[stage].[vTRA_SE_StockBalance]') IS NOT NULL
	DROP VIEW [stage].[vTRA_SE_StockBalance];

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE VIEW [stage].[vTRA_SE_StockBalance]
	AS select 
	CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM([Company]),'#',TRIM([PartNum]),'#',TRIM([WarehouseCode]))))) AS ItemWarehouseID,
	UPPER(CONCAT([Company],'#',TRIM([PartNum]),'#',TRIM([WarehouseCode]))) AS ItemWarehouseCode,
	CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM([Company]),'#',TRIM([PartNum]))))) AS PartID,
	CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(TRIM([Company])))) AS CompanyID,
	CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM([Company]),'#',TRIM([WarehouseCode]))))) AS WarehouseID
	
	,PartitionKey
	,upper(Company) as Company
	,trim(WarehouseCode) as WarehouseCode
	, trim(BinNum) as BinNum
	, trim(PartNum) as PartNum
	, cast(DelivTime as smallint) as DelivTime
	, cast(LastStockTakeDate as date) as LastStockTakeDate
	, cast(LastStdCostCalDate as date) as LastStdCostCalDate
	,cast(StockBalance as decimal (18,4)) as StockBalance 
	,cast(StockValue as decimal (18,4)) as StockValue
	,cast(SalesRemainingQty as decimal (18,4)) as SalesRemainingQty
	,cast(PurchaseRemainingqty as decimal (18,4)) as PurchaseRemainingqty
	,cast(SafetyStock as decimal (18,4)) as SafetyStock
	,cast(OptimalOrderQty as decimal (18,4)) as OptimalOrderQty
	,cast(AvgCost as decimal (18,4)) as AvgCost
	,cast(IsActiveRecord as bit) as IsActiveRecord
	,trim(Currency) as Currency
from stage.TRA_SE_StockBalance
;
GO
