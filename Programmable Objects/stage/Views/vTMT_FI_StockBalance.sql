IF OBJECT_ID('[stage].[vTMT_FI_StockBalance]') IS NOT NULL
	DROP VIEW [stage].[vTMT_FI_StockBalance];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [stage].[vTMT_FI_StockBalance] AS
--ADD TRIM() INTO PartID 23-01-09 VA
--ADD TRIM() INTO SupplierID 23-01-24 VA
SELECT
	CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT([Company], '#', TRIM(PartNum), '#', TRIM([WarehouseCode]), '#', TRIM(BinNum), '#', TRIM(BatchNum), '#', TRIM([version]))))) AS ItemWarehouseID
	,UPPER(CONCAT([Company], '#', TRIM(WarehouseCode))) AS WarehouseCode
	,UPPER(CONCAT([Company], '#', CONCAT(TRIM(PartNum), '-', TRIM([Version])), '#', TRIM([WarehouseCode]))) AS ItemWarehouseCode
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER([Company]))) AS CompanyID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM([Company]), '#', TRIM([SupplierNum]))))) AS SupplierID
	--,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT([Company], '#', TRIM([SupplierNum]))))) AS SupplierID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM([Company]), '#', TRIM(PartNum))))) AS PartID
	--,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT([Company], '#', TRIM(PartNum))))) AS PartID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM([Company]), '#', TRIM([WarehouseCode]))))) AS WarehouseID
	,CONVERT(varchar(50), getdate()) AS PartitionKey

	,UPPER(Company) AS Company
	,UPPER(TRIM(PartNum)) AS PartNum
	,UPPER(TRIM(SupplierNum)) AS SupplierNum
	,CASE WHEN TRIM(BinNum) like '' OR BinNum like ' ' THEN NULL ELSE TRIM(BinNum) END AS BinNum
	,TRIM(BatchNum) AS BatchNum
	,[DelivTime]-- convert to days
	,CONVERT(date, LastStockTakeDate) AS LastStockTakeDate
	,CONVERT(date, LastStdCostCalDate) AS LastStdCostCalDate
	,CONVERT(date, '1900-01-01') AS DelivDateSupplier
	,CONVERT(date, '1900-01-01') AS DelivDateCust
	,CONVERT(date, '1900-01-01') AS OrderDateSupplier
	,CONVERT(date, '1900-01-01') AS OrderDateCust
	,TRIM(Currency) AS Currency
	,SafetyStock
	,MaxStockQty
	,CONVERT(decimal(18,4), StockBalance) AS StockBalance
	,CONVERT(decimal(18,4), StockValue) AS StockValue
	,AvgCost
	,ReserveQty
	,BackOrderQty
	,OrderQty
	,StockTakeDiff
	,ReOrderLevel
	,OptimalOrderQty
	,OpenProdOrder AS SBRes1
	,UsageQty AS SBRes2
	,ProdQty AS SBRes3
FROM 
	[stage].[TMT_FI_StockBalance]
GO
