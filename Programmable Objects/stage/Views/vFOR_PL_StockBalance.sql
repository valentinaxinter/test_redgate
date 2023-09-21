IF OBJECT_ID('[stage].[vFOR_PL_StockBalance]') IS NOT NULL
	DROP VIEW [stage].[vFOR_PL_StockBalance];

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE VIEW [stage].[vFOR_PL_StockBalance]
	AS SELECT 
	CONVERT(binary(32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM(Company),'#',TRIM(PartNum),'#',TRIM(WarehouseCode))))) AS ItemWarehouseID
	,UPPER(CONCAT(Company,'#',TRIM(PartNum),'#',TRIM(WarehouseCode))) AS ItemWarehouseCode
	,CONVERT(binary(32),HASHBYTES('SHA2_256',UPPER(TRIM(Company)))) AS CompanyID
	--,CONVERT(binary(32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM(Company),'#',TRIM(SupplierNum))))) AS SupplierID
	,CONVERT(binary(32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM(Company),'#',TRIM(PartNum))))) AS PartID
	,CONVERT(binary(32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM(Company),'#',TRIM(WarehouseCode))))) AS WarehouseID
	,PartitionKey

	----------- Mandatory fields ------------

	,upper(trim(Company)) As Company
	,nullif(trim(WarehouseCode),'') as WarehouseCode
	,nullif(trim(PartNum),'') as PartNum
	,cast(StockBalance as decimal(18,4)) as StockBalance
	,cast(StockValue as decimal(18,4)) as StockValue
	,trim(Currency) as Currency
	
	----------- Other fields ------------
	, cast([LastStockTakeDate] as date) as LastStockTakeDate
	--, BinNum
	--, SupplierNum
	--, DelivTime
	--,LastStockTakeDate
	--,StockTakeDiff
	--,ExchangeRate
	,cast(SalesRemainingQty as decimal(18,4)) as SalesRemainingQty
	,cast(PurchaseRemainingqty as decimal(18,4)) as PurchaseRemainingqty
	,cast(AvgCost as decimal(18,4)) as AvgCost
	,cast(MaxStockQty as decimal(18,4)) as MaxStockQty
	--,CreatedTimeStamp
	--,ModifiedTimeStamp
	--,IsActiveRecord
	--,LastStdCostCalDate
	,cast(ReOrderLevel as decimal(18,4)) as ReOrderLevel
	,cast(SafetyStock as decimal(18,4)) as SafetyStock
	--,OptimalOrderQty
	--,SBRes1
	--,SBRes2
	--,SBRes3


	FROM [stage].[FOR_PL_StockBalance]
GO
