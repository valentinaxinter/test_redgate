IF OBJECT_ID('[stage].[vCER_NO_StockBalance]') IS NOT NULL
	DROP VIEW [stage].[vCER_NO_StockBalance];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE   VIEW [stage].[vCER_NO_StockBalance] AS

SELECT
	CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM([Company]),'#',TRIM([PartNum]),'#',TRIM([WarehouseCode]) /*,'#',TRIM(BatchNum),'#', BinNum, '#', [LastStockTakeDate]*/)))) AS ItemWarehouseID
	,UPPER(CONCAT([Company],'#',TRIM([PartNum]),'#',TRIM([WarehouseCode]))) AS ItemWarehouseCode
	,CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM([Company]),'#',TRIM([PartNum]))))) AS PartID
	,CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(TRIM([Company])))) AS CompanyID
	,CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM([Company]),'#',TRIM([SupplierNum]))))) AS SupplierID -- var '0000000'
	,CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM([Company]),'#',TRIM([WarehouseCode]))))) AS WarehouseID
	,[PartitionKey]

	,UPPER(TRIM([Company])) AS Company
	,UPPER(TRIM([WarehouseCode])) AS WarehouseCode
	,Currency
	,Max(BinNum)	AS BinNum --Currently there are some duplicates here and BinNum needs to be aggregated. It is only around 6 duplicate rows /SM 2021-05-21
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
	--,'' AS [DelivTimeToWHS]-- will not be sent out to new companies, not delete in DW for that use as reservation
	--,'' AS [DelivTimeDesc]-- will not be sent out to new companies, not delete in DW for that use as reservation
	--,'' AS [DaysOnStock]
	,convert(date, '') AS OrderDateSupplier
	,convert(date, '') AS OrderDateCust
	--,'' AS BatchNoPrefix-- will not be sent out to new companies, not delete in DW for that use as reservation
	--,'' AS BatchNoSuffix-- will not be sent out to new companies, not delete in DW for that use as reservation
	
FROM 
	[stage].[CER_NO_StockBalance]
GROUP BY
	[PartitionKey],[Company],[PartNum],[WarehouseCode],[StockBalance],[ReserveQty],[BackOrderQty],[OrderQty],[StockTakeDiff],[ReOrderLevel],/*BinNum,*/[SupplierNum],[DelivTime], [LastStockTakeDate],LastStdCostCalDate,
	BatchNum, StockValue,[OptimalOrderQty], MaxStockQty,Currency --BatchNoPrefix,BatchNoSuffix,,[DelivTimeToWHS]
GO
