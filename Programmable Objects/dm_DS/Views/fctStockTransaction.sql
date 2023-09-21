IF OBJECT_ID('[dm_DS].[fctStockTransaction]') IS NOT NULL
	DROP VIEW [dm_DS].[fctStockTransaction];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [dm_DS].[fctStockTransaction] AS

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

FROM dm.FactStockTransaction st
LEFT JOIN dbo.Company com ON st.Company = com.Company
WHERE com.BusinessArea = 'Driveline Solutions' AND com.[Status] = 'Active'


--WHERE Company  in ('AFISCM', 'CDKCERT', 'CEECERT', 'CFICERT', 'CLTCERT', 'CLVCERT', 'CSECERT', 'CUKCERT', 'CNOEHAU', 'CNOCERT', 'CERPL', 'CyESA', 'HFIHAKL', 'TRACLEV')  -- LS basket

--GROUP BY  -- Aggregate those fields in dw.FactOrder which have more than one values, such as different NeedbyDate & DelivDate and different discountPercent, left over fields should by in GROUP BY
GO
