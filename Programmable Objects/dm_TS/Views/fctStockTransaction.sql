IF OBJECT_ID('[dm_TS].[fctStockTransaction]') IS NOT NULL
	DROP VIEW [dm_TS].[fctStockTransaction];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO







CREATE VIEW [dm_TS].[fctStockTransaction] AS


SELECT 
 st.[StockTransactionID]
,st.[CompanyID]
,st.[PartID]
,st.[WarehouseID]
,st.[CurrencyID]
,st.[TransactionDateID]
,st.[SupplierID]
,st.[PurchaseOrderNumID]
,st.[PurchaseInvoiceID]
,st.[CustomerID]
,st.[SalesOrderNumID]
,st.[SalesInvoiceID]
,st.[CurrencyMonthKey]
,st.[Company]
,st.[WarehouseCode]
,st.[TransactionCode]
,st.[TransactionDescription]
,st.[IssuerReceiverNum]
,st.[IssuerReceiverName]
,st.[OrderNum]
,st.[OrderLine]
,st.[InvoiceNum]
,st.[InvoiceLine]
,st.[PartNum]
,st.[BinNum]
,st.[BatchNum]
,st.[TransactionDate]
,st.[TransactionTime]
,st.[TransactionQty]
,st.[TransactionValue]
,st.[CostPrice]
,st.[SalesUnitPrice]
,st.[Currency]
,st.[Reference]
,st.[AdjustmentDate]
,st.[IndexKey]
,st.[InternalExternal]

FROM dm.FactStockTransaction as st

WHERE st.Company  in ('FESFORA', 'FSEFORA', 'FFRFORA', 'FFRGPI', 'FFRLEX', 'IFIWIDN', 'IEEWIDN', 'TMTFI', 'TMTEE', 'FITMT', 'EETMT', 'ABKSE', 'ROROSE','STESE')  -- TS basket by 2021-08-05
GO
