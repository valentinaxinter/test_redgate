IF OBJECT_ID('[prestage].[vTRA_FR_StockBalance]') IS NOT NULL
	DROP VIEW [prestage].[vTRA_FR_StockBalance];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE VIEW [prestage].[vTRA_FR_StockBalance] AS

SELECT 
	CONCAT(CONVERT (date, SYSDATETIME()), ' 00:00:00') AS [PartitionKey]
	,Prop_0 AS [Company]
	,Prop_1 AS [WarehouseCode]
	,Prop_2 AS [Currency]
	,Prop_3 AS [BinNum]
	,Prop_4 AS [BatchNum]
	,Prop_5 AS [SupplierNum]
	,Prop_6 AS [PartNum]
	,Prop_7 AS [DelivTime]
	,CONVERT(date, CONCAT(SUBSTRING(Prop_8, 7,4), SUBSTRING(Prop_8, 4,2), SUBSTRING(Prop_8, 1,2))) AS [LastStockTakeDate]
	,CONVERT(date, CONCAT(SUBSTRING(Prop_9, 7,4), SUBSTRING(Prop_9, 4,2), SUBSTRING(Prop_9, 1,2))) AS [LastStdCostCalDat]
	,Prop_10 AS [MaxStockQty]
	,Prop_11 AS [StockBalance]
	,Prop_12 AS [StockValue]
	,Prop_13 AS [ReserveQty]
	,Prop_14 AS [BackOrderQty]
	,Prop_15 AS [OrderQty]
	,Prop_16 AS [StockTakeDiff]
	,Prop_17 AS [ReOrderLevel]
	,Prop_18 AS [SafetyStock]
	,Prop_19 AS [OptimalOrderQty]
	,Prop_20 AS [AvgCost]
	,Prop_21 AS [SBRes1]
	,Prop_22 AS [SBRes2]
	,Prop_23 AS [SBRes3]
FROM [prestage].[TRA_FR_StockBalance]
GO
