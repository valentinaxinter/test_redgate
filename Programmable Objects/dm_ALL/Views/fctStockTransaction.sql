IF OBJECT_ID('[dm_ALL].[fctStockTransaction]') IS NOT NULL
	DROP VIEW [dm_ALL].[fctStockTransaction];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [dm_ALL].[fctStockTransaction] AS

SELECT 
 [StockTransactionID]
,[CompanyID]
,[PartID]
,[WarehouseID]
,[CurrencyID]
,[TransactionDateID]
,[SupplierID]
,[PurchaseOrderNumID]
,[PurchaseInvoiceID]
,[CustomerID]
,[SalesOrderNumID]
,[SalesInvoiceID]
,[CurrencyMonthKey]
,[Company]
,[WarehouseCode]
,[TransactionCode]
,[TransactionDescription]
,[IssuerReceiverNum]
,[IssuerReceiverName]
,[OrderNum]
,[OrderLine]
,[InvoiceNum]
,[InvoiceLine]
,[PartNum]
,[BinNum]
,[BatchNum]
,[TransactionDate]
,[TransactionTime]
,[TransactionQty]
,[TransactionValue]
,[CostPrice]
,[SalesUnitPrice]
,[Currency]
,[Reference]
,[AdjustmentDate]
,[IndexKey]
,[InternalExternal]
FROM dm.FactStockTransaction
GO
