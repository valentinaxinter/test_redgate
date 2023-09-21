IF OBJECT_ID('[stage].[vCER_SE_StockBalance]') IS NOT NULL
	DROP VIEW [stage].[vCER_SE_StockBalance];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [stage].[vCER_SE_StockBalance] AS
--ADD TRIM() INTO Supplier 23-01-23 VA
SELECT
	CONVERT([binary](32),HASHBYTES('SHA2_256',CONCAT([Company],'#',TRIM(UPPER([PartNum])),'#',TRIM(UPPER([WarehouseCode]))))) AS ItemWarehouseID
	,CONCAT([Company],'#',TRIM(UPPER([PartNum])),'#',TRIM(UPPER([WarehouseCode]))) AS ItemWarehouseCode
	,CONVERT([binary](32), HASHBYTES('SHA2_256', TRIM([Company]))) AS CompanyID
	,CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM([Company]),'#',TRIM([SupplierNum]))))) AS SupplierID
	--,CONVERT([binary](32),HASHBYTES('SHA2_256',CONCAT([Company],'#',TRIM(UPPER([SupplierNum]))))) AS SupplierID
	,CONVERT([binary](32),HASHBYTES('SHA2_256',CONCAT([Company],'#',TRIM(UPPER([PartNum]))))) AS PartID
	,CONVERT([binary](32),HASHBYTES('SHA2_256',CONCAT([Company],'#',TRIM(UPPER([WarehouseCode]))))) AS WarehouseID
	,[PartitionKey]

	,TRIM(UPPER([WarehouseCode])) AS WarehouseCode
	,TRIM(UPPER(CurrencyCode)) AS Currency
	,[Company]
	,TRIM(UPPER([DefaultBinNo])) AS BinNum
	,TRIM(UPPER(BatchNumber)) AS BatchNum
	,TRIM(UPPER([SupplierNum])) AS [SupplierNum]
	,TRIM(UPPER([PartNum])) AS PartNum
	,[DelivTimeUnit] AS [DelivTime]
	,convert(date, [StockTakDate]) AS LastStockTakeDate
	,convert(date, [StdCostLaCaD]) AS LastStdCostCalDate
	,Null AS SafetyStock
	,MaxStockQty
	,[StockBalance]
	,Null AS StockValue
	,0 AS AvgCost
	,[ReservedQty] AS ReserveQty
	,[BackOrderQty]	AS BackOrderQty
	,[QtyOrdered]	AS OrderQty
	,[StockTakDiff]		AS StockTakeDiff
	,[ReOrderLevel]
	,[OptimalOrderQty]
	--,'' AS SBRes1
	--,'' AS SBRes2
	--,'' AS SBRes3

	--,[FIFOValue]
	--,'' AS [DelivTimeToWHS] -- will not be sent out to new companies, not delete in DW for that use as reservation
	--,'' AS [DelivTimeDesc] -- will not be sent out to new companies, not delete in DW for that use as reservation
	--,'' AS [DaysOnStock]
	--,convert(date, [DelivDateSupplier]) AS DelivDateSupplier
	--,convert(date, [DelivDateCust]) AS DelivDateCust
	--,convert(date, [OrderDateSupplier]) AS OrderDateSupplier
	--,convert(date, '') AS OrderDateCust
	--,'' AS BatchNoPrefix
	--,'' AS BatchNoSuffix
FROM 
	[stage].[CER_SE_StockBalance]
GROUP BY
	PartitionKey, Company, WarehouseCode, CurrencyCode, Company, DefaultBinNo, BatchNumber, SupplierNum, PartNum, DelivTimeUnit, StockTakDate, StdCostLaCaD, MaxStockQty, StockBalance, ReservedQty, BackOrderQty, QtyOrdered, StockTakDiff, ReOrderLevel, OptimalOrderQty
GO
