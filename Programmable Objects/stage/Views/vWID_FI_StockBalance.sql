IF OBJECT_ID('[stage].[vWID_FI_StockBalance]') IS NOT NULL
	DROP VIEW [stage].[vWID_FI_StockBalance];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [stage].[vWID_FI_StockBalance] AS
--COMMENT EMPTY FIELDS // ADD TRIM()UPPER() INTO PartID 2022-12-15 VA
SELECT
	CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT([Company], '#', TRIM([PartNum]), '#', TRIM([WarehouseCode]), '#', TRIM(BinNum)))) AS ItemWarehouseID
	,TRIM(WarehouseCode) AS WarehouseCode
	,CONCAT([Company], '#', TRIM([PartNum]), '#', TRIM([WarehouseCode])) AS ItemWarehouseCode
	,CONVERT([binary](32), HASHBYTES('SHA2_256', [Company])) AS CompanyID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT([Company], '#', TRIM([SupplierNum])))) AS SupplierID
	--,CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT([Company], '#', TRIM([PartNum])))) AS PartID
	,CONVERT([binary](32), HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM([Company]), '#', TRIM([PartNum]))))) AS PartID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM([Company]), '#', TRIM([WarehouseCode]))))) AS WarehouseID
	,PartitionKey

	,Company
	,CASE WHEN TRIM(BinNum) like '' OR BinNum like ' ' THEN NULL ELSE TRIM(BinNum) END AS BinNum
	,BatchNum
	,TRIM(SupplierNum) AS SupplierNum
	,TRIM(PartNum) AS PartNum
	,CASE WHEN [DelivTimeDesc] = 'Weeks' THEN [DelivTime]*7
		WHEN [DelivTimeDesc] = 'Months' THEN [DelivTime]*30
		ELSE [DelivTime]
		END AS [DelivTime]-- convert to days
--	,[DelivTimeUnit] AS [DeliveryTime]
--	,[DelivTimeDesc] 
--	,'' AS DaysOnStock
	,CONVERT(date, LastStockTakeDate) AS LastStockTakeDate
	,CONVERT(date, LastStdCostCalDate) AS LastStdCostCalDate
	,CONVERT(date, [DelivDateSupplier]) AS DelivDateSupplier
	,CONVERT(date, [DelivDateCust]) AS DelivDateCust
	,CONVERT(date, [OrderDateSupplier]) AS OrderDateSupplier
	,CONVERT(date, '') AS OrderDateCust
	,TRIM(Currency) AS Currency
	--,NULL AS SafetyStock
	,MaxStockQty
	,StockBalance
	,FIFOValue AS StockValue
	,AvgCost
	,ReservedQty AS ReserveQty
	,BackOrderQty
	,QtyOrdered AS OrderQty
	,StockTakDiff AS StockTakeDiff
	,ReOrderLevel
	,OptimalOrderQty
	--,'' AS SBRes1
	--,'' AS SBRes2
	--,'' AS SBRes3
FROM 
	[stage].[WID_FI_StockBalance]
GO
