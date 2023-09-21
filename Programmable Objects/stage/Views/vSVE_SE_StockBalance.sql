IF OBJECT_ID('[stage].[vSVE_SE_StockBalance]') IS NOT NULL
	DROP VIEW [stage].[vSVE_SE_StockBalance];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [stage].[vSVE_SE_StockBalance] AS
SELECT
	CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT([Company], '#', TRIM([WarehouseCode]), '#', TRIM(BinNum), '#', TRIM(PartNum))))) AS ItemWarehouseID
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
	,TRIM(BatchNum) AS BatchNum
	,CONVERT(decimal(18,4), IIF(DelivTime = '', NULL, DelivTime)) AS [DelivTime]-- convert to days
	,TRY_CONVERT(date, LastStockTakeDate) AS LastStockTakeDate
	,TRY_CONVERT(date, '1900-01-01') AS LastStdCostCalDate
	,CONVERT(date, '1900-01-01') AS DelivDateSupplier
	,CONVERT(date, '1900-01-01') AS DelivDateCust
	,CONVERT(date, '1900-01-01') AS OrderDateSupplier
	,CONVERT(date, '1900-01-01') AS OrderDateCust
	,TRIM(Currency) AS Currency
	,CONVERT(decimal(18,2), SafetyStock) AS SafetyStock --  -- gives convertion error!!!
	,CONVERT(decimal(18,2), MaxStockQty) AS MaxStockQty --CAST(MaxStockQty AS decimal(18,2))
	,CONVERT(decimal(18,4), StockBalance) AS StockBalance
	,CONVERT(decimal(18,4), StockValue) AS StockValue
	,CONVERT(decimal(18,4), AvgCost) AS AvgCost
	--,ReserveQty
	--,BackOrderQty
	--,OrderQty
	--,StockTakeDiff
	,CONVERT(decimal(18,4), ReOrderLevel) AS  ReOrderLevel --
	,CONVERT(decimal(18,4), OptimalOrderQty) AS  OptimalOrderQty --
	,UPPER(TRIM(WarehouseCode)) AS WarehouseCode
	--,'' AS SBRes1
	--,'' AS SBRes2
	--,'' AS SBRes3
FROM 
	[stage].[SVE_SE_StockBalance]
WHERE CONVERT(decimal(18,4), StockBalance) > 0
GO
