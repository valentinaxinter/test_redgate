IF OBJECT_ID('[dm_ALL].[fctStockBalance]') IS NOT NULL
	DROP VIEW [dm_ALL].[fctStockBalance];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [dm_ALL].[fctStockBalance] AS

SELECT 
 [StockBalanceID]
,[CompanyID]
,[SupplierID]
,[PartID]
,[WarehouseID]
,[CurrencyMonthKey]
,[Company]
,[Currency]
,[BinNum]
,[BatchNum]
,[SupplierNum]
,[PartNum]
,[DelivTime]
,[LastStockTakeDate]
,[LastStdCostCalDate]
,[SafetyStock]
,[MaxStockQty]
,[StockBalance]
,[StockValue]
,[AvgCost]
,[ReserveQty]
,[BackOrderQty]
,[OrderQty]
,[StockTakeDiff]
,[ReOrderLevel]
,[OptimalOrderQty]
,[WarehouseCode]
,[SBRes1]
,[SBRes2]
,[SBRes3]
FROM dm.FactStockBalance
GO
