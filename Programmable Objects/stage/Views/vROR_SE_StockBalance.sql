IF OBJECT_ID('[stage].[vROR_SE_StockBalance]') IS NOT NULL
	DROP VIEW [stage].[vROR_SE_StockBalance];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [stage].[vROR_SE_StockBalance] AS
SELECT
	CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT([Company], '#', TRIM([WarehouseCode]), '#', TRIM(BinNum), '#', TRIM(PartNum))))) AS ItemWarehouseID
	,UPPER(TRIM([WarehouseCode])) AS WarehouseCode
	,UPPER(CONCAT([Company], '#', TRIM(PartNum), '#', TRIM([WarehouseCode]))) AS ItemWarehouseCode
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER([Company]))) AS CompanyID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM([Company]), '#', TRIM([SupplierNum]))))) AS SupplierID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM([Company]), '#', TRIM(PartNum))))) AS PartID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM([Company]), '#', TRIM([WarehouseCode]))))) AS WarehouseID
	,PartitionKey

	,UPPER(Company) AS Company
	,UPPER(TRIM(PartNum)) AS PartNum
	,UPPER(TRIM(SupplierNum)) AS SupplierNum
	,CASE WHEN TRIM(BinNum) like '' OR BinNum like ' ' THEN NULL ELSE TRIM(BinNum) END AS BinNum
	,'' AS BatchNum
	,CONVERT(decimal(18,4), IIF(DelivTime = '', NULL, DelivTime)) AS [DelivTime]-- convert to days
	,CONVERT(date, MAX(LastStockTakeDate)) AS LastStockTakeDate
	,CONVERT(date, LastStdCostCalDate) AS LastStdCostCalDate
	,CONVERT(date, '1900-01-01') AS DelivDateSupplier
	,CONVERT(date, '1900-01-01') AS DelivDateCust
	,CONVERT(date, '1900-01-01') AS OrderDateSupplier
	,CONVERT(date, '1900-01-01') AS OrderDateCust
	,TRIM(Currency) AS Currency
	,CONVERT(decimal(18,2), REPLACE(ExchangeRate, ',', '.')) AS ExchangeRate
	,CONVERT(decimal(18,2), REPLACE(SafetyStock, ',', '.')) AS SafetyStock --  -- gives convertion error!!!
	,CONVERT(decimal(18,2), REPLACE(MaxStockQty, ',', '.')) AS MaxStockQty --CAST(MaxStockQty AS decimal(18,2))
	,CONVERT(decimal(18,4), REPLACE(StockBalance, ',', '.')) AS StockBalance
	,CONVERT(decimal(18,4), REPLACE(StockValue, ',', '.')) AS StockValue
	,AVG(CONVERT(decimal(18,4), REPLACE(AvgCost, ',', '.'))) AS AvgCost
	,CONVERT(decimal(18,4), REPLACE(SalesRemainingQty, ',', '.')) AS SalesRemainingQty
	,CONVERT(decimal(18,4), REPLACE(PurchaseRemainingqty, ',', '.')) AS PurchaseRemainingqty
	--,ReserveQty
	--,BackOrderQty
	--,OrderQty
	,CONVERT(decimal(18,4), REPLACE(StockTakeDiff, ',', '.')) AS StockTakeDiff
	,CONVERT(decimal(18,4), ReOrderLevel) AS  ReOrderLevel --
	,CONVERT(decimal(18,4), OptimalOrderQty) AS  OptimalOrderQty --
	--,'' AS SBRes1
	--,'' AS SBRes2
	--,'' AS SBRes3
FROM 
	[stage].[ROR_SE_StockBalance]
WHERE AvgCost != '0.0000'
GROUP BY
	PartitionKey, Company, PartNum, SupplierNum, BinNum, DelivTime, LastStdCostCalDate, Currency, SafetyStock, MaxStockQty, StockBalance, StockValue, StockTakeDiff, ReOrderLevel, OptimalOrderQty, [WarehouseCode], ExchangeRate, SalesRemainingQty, PurchaseRemainingqty
GO
