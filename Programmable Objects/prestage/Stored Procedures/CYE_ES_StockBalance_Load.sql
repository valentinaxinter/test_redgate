IF OBJECT_ID('[prestage].[CYE_ES_StockBalance_Load]') IS NOT NULL
	DROP PROCEDURE [prestage].[CYE_ES_StockBalance_Load];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [prestage].[CYE_ES_StockBalance_Load] AS

BEGIN

Truncate table stage.[CYE_ES_StockBalance]

insert into stage.CYE_ES_StockBalance(
	[PartitionKey]
    ,[Company]
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
)
select 
	[PartitionKey]
	,[Company]
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
from [prestage].[vCYE_ES_StockBalance]

--Truncate table prestage.[CYE_ES_PartTranLine] --Two loads in LSSourceTables_CYESA_dev uses the same prestage. Truncating would create conflicts. /SM 2022-02-23

End
GO
