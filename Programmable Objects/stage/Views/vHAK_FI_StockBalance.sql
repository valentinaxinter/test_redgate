IF OBJECT_ID('[stage].[vHAK_FI_StockBalance]') IS NOT NULL
	DROP VIEW [stage].[vHAK_FI_StockBalance];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE     VIEW [stage].[vHAK_FI_StockBalance] AS

SELECT
	CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM([Company]),'#',TRIM([PartNum]),'#',TRIM([WarehouseCode])/*,'#',TRIM(BatchNum),'#', BinNum, '#', [LastStockTakeDate]*/)))) AS ItemWarehouseID
	,UPPER(CONCAT([Company],'#',TRIM([PartNum]),'#',TRIM([WarehouseCode]))) AS ItemWarehouseCode
	,CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM([Company]),'#',TRIM([PartNum]))))) AS PartID
	,CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(TRIM([Company])))) AS CompanyID
	,CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM([Company]),'#',TRIM([SupplierNum]))))) AS SupplierID -- var '0000000'
	,CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM([Company]),'#',TRIM([WarehouseCode]))))) AS WarehouseID
	,[PartitionKey]

	,UPPER(TRIM([Company])) AS Company
	,UPPER(TRIM([WarehouseCode])) AS WarehouseCode
	,Currency
	,BinNum
	,BatchNum
	,UPPER(TRIM([SupplierNum])) AS SupplierNum
	,UPPER(TRIM([PartNum])) AS PartNum
	,[DelivTime]
	,convert(date, [LastStockTakeDate]) AS LastStockTakeDate
	,LastStdCostCalDate
	--,0 AS SafetyStock
	,MaxStockQty
	,[StockBalance]
	,StockValue
	--,0 AS AvgCost
	,[ReserveQty]
	,[BackOrderQty]
	,[OrderQty]
	,[StockTakeDiff]
	,[ReOrderLevel]
	,[OptimalOrderQty]
	--,'' AS SBRes1
	--,'' AS SBRes2
	--,'' AS SBRes3
	--,0 AS [FIFOValue]
	,'' AS [DelivTimeToWHS]-- will not be sent out to new companies, not delete in DW for that use as reservation
	,'' AS [DelivTimeDesc]-- will not be sent out to new companies, not delete in DW for that use as reservation
	,'' AS [DaysOnStock]
	,convert(date, '') AS OrderDateSupplier
	,convert(date, '') AS OrderDateCust
	,'' AS BatchNoPrefix-- will not be sent out to new companies, not delete in DW for that use as reservation
	,'' AS BatchNoSuffix-- will not be sent out to new companies, not delete in DW for that use as reservation
	
FROM 
	[stage].[HAK_FI_StockBalance]
GROUP BY
	[PartitionKey],[Company],[PartNum],[WarehouseCode],[StockBalance],[ReserveQty],[BackOrderQty],[OrderQty],[StockTakeDiff],[ReOrderLevel],BinNum,[SupplierNum],[DelivTime], [LastStockTakeDate],LastStdCostCalDate,
	BatchNum, StockValue,[OptimalOrderQty], MaxStockQty,Currency --BatchNoPrefix,BatchNoSuffix,,[DelivTimeToWHS]
GO
