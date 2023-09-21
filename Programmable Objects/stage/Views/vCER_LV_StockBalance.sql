IF OBJECT_ID('[stage].[vCER_LV_StockBalance]') IS NOT NULL
	DROP VIEW [stage].[vCER_LV_StockBalance];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [stage].[vCER_LV_StockBalance] AS
--COMMENT EMPTY FIELDS 2022-12-21 VA
SELECT
	CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM([Company]),'#',TRIM([PartNum]),'#',TRIM([WarehouseCode]) /*,'#',TRIM(BatchNum),'#', BinNum, '#', [LastStockTakeDate]  Comented due to history/duplicate rows /SM 2021-04-16*/)))) AS ItemWarehouseID
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
	,convert(date, LastStdCostCalDate) AS LastStdCostCalDate
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
FROM 
	[stage].[CER_LV_StockBalance]
GROUP BY
	[PartitionKey], [Company], [PartNum], [WarehouseCode], [StockBalance], [ReserveQty], [BackOrderQty], [OrderQty], [StockTakeDiff], [ReOrderLevel], BinNum, [SupplierNum], [DelivTime], [LastStockTakeDate], LastStdCostCalDate,
	BatchNum, StockValue, [OptimalOrderQty], MaxStockQty,Currency
GO
