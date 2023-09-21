IF OBJECT_ID('[dm_TS].[fctStockBalance]') IS NOT NULL
	DROP VIEW [dm_TS].[fctStockBalance];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO








CREATE VIEW [dm_TS].[fctStockBalance] AS


SELECT 
 sb.[StockBalanceID]
,sb.[CompanyID]
,sb.[SupplierID]
,sb.[PartID]
,sb.[WarehouseID]
,sb.[CurrencyMonthKey]
,sb.[Company]
,sb.[Currency]
,sb.[BinNum]
,sb.[BatchNum]
,sb.[SupplierNum]
,sb.[PartNum]
,sb.[DelivTime]
,sb.[LastStockTakeDate]
,sb.[LastStdCostCalDate]
,sb.[SafetyStock]
,sb.[MaxStockQty]
,sb.[StockBalance]
,sb.[StockValue]
,sb.[AvgCost]
,sb.[ReserveQty]
,sb.[BackOrderQty]
,sb.[OrderQty]
,sb.[StockTakeDiff]
,sb.[ReOrderLevel]
,sb.[OptimalOrderQty]
,sb.[WarehouseCode]
,sb.[SBRes1]
,sb.[SBRes2]
,sb.[SBRes3]

FROM dm.FactStockBalance as sb

WHERE sb.Company  in ('FESFORA', 'FSEFORA', 'FFRFORA', 'FFRGPI', 'FFRLEX', 'IFIWIDN', 'IEEWIDN', 'TMTFI', 'TMTEE', 'FITMT', 'EETMT', 'ABKSE', 'ROROSE','STESE')  -- TS basket by 2021-08-05
GO
