IF OBJECT_ID('[dm_IN].[fctStockBalance]') IS NOT NULL
	DROP VIEW [dm_IN].[fctStockBalance];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [dm_IN].[fctStockBalance] AS

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
FROM dm.FactStockBalance sb
LEFT JOIN dbo.Company com ON sb.Company = com.Company
WHERE com.BusinessArea = 'Industrial Solutions' AND com.[Status] = 'Active'
GO
