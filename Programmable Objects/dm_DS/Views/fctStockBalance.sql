IF OBJECT_ID('[dm_DS].[fctStockBalance]') IS NOT NULL
	DROP VIEW [dm_DS].[fctStockBalance];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [dm_DS].[fctStockBalance] AS

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
WHERE com.BusinessArea = 'Driveline Solutions' AND com.[Status] = 'Active'

--WHERE Company  in ('AFISCM', 'CDKCERT', 'CEECERT','CERDE', 'CFICERT', 'CLTCERT', 'CLVCERT', 'CSECERT', 'CUKCERT', 'CNOEHAU', 'CNOCERT', 'CERPL', 'CyESA', 'HFIHAKL', 'TRACLEV','MENBE14','MENNL01','MENNL02','MENNL03','MENNL04','MENNL07','MENNL11')  -- LS basket
GO
