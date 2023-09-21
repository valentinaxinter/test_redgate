IF OBJECT_ID('[stage].[vFOR_SE_StockBalance]') IS NOT NULL
	DROP VIEW [stage].[vFOR_SE_StockBalance];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [stage].[vFOR_SE_StockBalance] AS
--COMMENT EMPTY FIELD 2022-12-20 VA
SELECT
	CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM([Company]),'#',TRIM([PartNum]),'#',TRIM([WarehouseCode]),'#',TRIM(BatchNumber),'#',[StockTakDate])))) AS ItemWarehouseID
	,UPPER(CONCAT([Company],'#',TRIM([PartNum]),'#',TRIM([WarehouseCode]))) AS ItemWarehouseCode
	,CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM([Company]),'#',TRIM([PartNum]))))) AS PartID
	,CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(TRIM([Company])))) AS CompanyID
	,CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM([Company]),'#',TRIM([SupplierNum]))))) AS SupplierID -- var '0000000'
	,CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM([Company]),'#',TRIM([WarehouseCode]))))) AS WarehouseID
	,[PartitionKey]
	,UPPER(TRIM([WarehouseCode])) AS WarehouseCode
	,CurrencyCode AS Currency
	,UPPER(TRIM([Company])) AS Company
	,DefaultBinNo AS BinNum
	,BatchNumber AS BatchNum
	,UPPER(TRIM([SupplierNum])) AS SupplierNum
	,UPPER(TRIM([PartNum])) AS PartNum
	--,0 AS [DelivTime]
	,convert(date, [StockTakDate]) AS LastStockTakeDate
	,'' AS LastStdCostCalDate
	,SafetyStock
	,MaxStockQty
	,[StockBalance]
	--,0 AS StockValue
	,CostPrice AS AvgCost
	,[ReservedQty] AS ReserveQty
	,[BackOrderQty] AS BackOrderQty
	,[QtyOrdered] AS OrderQty
	,[StockTakDiff] AS StockTakeDiff
	,[ReOrderLevel]
	--,0 AS [OptimalOrderQty]
	--,'' AS SBRes1
	--,'' AS SBRes2
	--,'' AS SBRes3


	,0 AS [FIFOValue]
	,'' AS [DelivTimeToWHS]-- will not be sent out to new companies, not delete in DW for that use as reservation
	,'' AS [DelivTimeDesc]-- will not be sent out to new companies, not delete in DW for that use as reservation
	,'' AS [DaysOnStock]
	,DelivDateSupplier
	,DelivDateCust
	,convert(date, '') AS OrderDateSupplier
	,convert(date, '') AS OrderDateCust
	,BatchNumber
	,'' AS BatchNoPrefix-- will not be sent out to new companies, not delete in DW for that use as reservation
	,'' AS BatchNoSuffix-- will not be sent out to new companies, not delete in DW for that use as reservation
	
	
FROM 
	[stage].[FOR_SE_StockBalance]
GROUP BY [PartitionKey], [Company], [PartNum], [WarehouseCode], [StockBalance], [ReservedQty], [BackOrderQty], [QtyOrdered], [StockTakDiff], [ReOrderLevel], CostPrice, DefaultBinNo, [SupplierNum], [StockTakDate], BatchNumber, MaxStockQty, CurrencyCode, DelivDateSupplier, DelivDateCust, SafetyStock --re-introduced GROUP BY 20210928, otherwise many duplications, should check the source query JOINS. /DZ
GO
