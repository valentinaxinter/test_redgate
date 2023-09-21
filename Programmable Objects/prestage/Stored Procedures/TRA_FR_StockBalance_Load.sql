IF OBJECT_ID('[prestage].[TRA_FR_StockBalance_Load]') IS NOT NULL
	DROP PROCEDURE [prestage].[TRA_FR_StockBalance_Load];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [prestage].[TRA_FR_StockBalance_Load] AS
BEGIN

Truncate table stage.[TRA_FR_StockBalance]

INSERT INTO 
	stage.TRA_FR_StockBalance 
	(PartitionKey, Company, PartNum, [WarehouseCode], Currency, BinNum, BatchNum, SupplierNum, DelivTime, LastStockTakeDate, LastStdCostCalDat, MaxStockQty, StockBalance, StockValue, ReserveQty, BackOrderQty, OrderQty, StockTakeDiff, ReOrderLevel, SafetyStock, OptimalOrderQty, AvgCost, SBRes1, SBRes2, SBRes3)
SELECT 
	PartitionKey, Company, PartNum, [WarehouseCode], Currency, BinNum, BatchNum, SupplierNum, DelivTime, LastStockTakeDate, LastStdCostCalDat, MaxStockQty, StockBalance, StockValue, ReserveQty, BackOrderQty, OrderQty, StockTakeDiff, ReOrderLevel, SafetyStock, OptimalOrderQty, AvgCost, SBRes1, SBRes2, SBRes3
FROM 
	[prestage].[vTRA_FR_StockBalance]

--Truncate table prestage.[TRA_FR_StockBalance]

End
GO
