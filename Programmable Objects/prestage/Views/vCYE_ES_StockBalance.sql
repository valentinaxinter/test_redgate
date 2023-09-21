IF OBJECT_ID('[prestage].[vCYE_ES_StockBalance]') IS NOT NULL
	DROP VIEW [prestage].[vCYE_ES_StockBalance];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [prestage].[vCYE_ES_StockBalance] AS
SELECT 
	concat(CONVERT (date, SYSDATETIME()), ' 00:00:00') AS [PartitionKey]
	,'CYESA' AS [Company]
	,[WarehouseCode]
	,[Currency]
	,[BinNum]
	,[BatchNum]
	,[SupplierNum]
	,[PartNum]
	,[DelivTime]
	,[LastStockTakeDate]
	,[LastStdCostCalDate]
	,[MaxStockQty]
	,[StockBalance]
	,[StockValue]
	,[ReserveQty]
	,[BackOrderQty]
	,[OrderQty]
	,[StockTakeDiff]
	,[ReOrderLevel]
	,[SafetyStock]
	,[OptimalOrderQty]
	,[AvgCost]
	,[SBRes1]
	,[SBRes2]
	,[SBRes3]
FROM [prestage].[CYE_ES_StockBalance]
GO
