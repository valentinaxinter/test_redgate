IF OBJECT_ID('[dm].[FactStockTransaction]') IS NOT NULL
	DROP VIEW [dm].[FactStockTransaction];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [dm].[FactStockTransaction] AS

SELECT 
	CONVERT(bigint, StockTransactionID) AS StockTransactionID
    ,CONVERT(bigint, CompanyID ) AS CompanyID
    ,CONVERT(bigint, PartID ) AS PartID
    ,CONVERT(bigint, WarehouseID ) AS WarehouseID
	,CONVERT(bigint, CONVERT([binary](32), HASHBYTES('SHA2_256', TRIM(Currency))) ) AS CurrencyID
	,CONVERT(int, replace(CONVERT(date, [TransactionDate]), '-', '')) AS TransactionDateID
	,IIF(([TransactionDescription] = 'Incoming goods' OR [TransactionDescription] =  'Incomming Goods' OR [TransactionDescription] =  'purchase'), CONVERT(bigint, SupplierID ), NULL) AS SupplierID
	,IIF(([TransactionDescription] = 'Incoming goods' OR [TransactionDescription] =  'Incomming Goods' OR [TransactionDescription] =  'purchase'), CONVERT(bigint, PurchaseOrderNumID ), NULL) AS PurchaseOrderNumID
	,IIF(([TransactionDescription] = 'Incoming goods' OR [TransactionDescription] =  'Incomming Goods' OR [TransactionDescription] =  'purchase'), CONVERT(bigint, PurchaseInvoiceID ), NULL) AS PurchaseInvoiceID
	,IIF([TransactionDescription] = 'Outgoing goods' OR [TransactionDescription] = 'Sales', CONVERT(bigint, CustomerID ), NULL) AS CustomerID
	,IIF([TransactionDescription] = 'Outgoing goods' OR [TransactionDescription] = 'Sales', CONVERT(bigint, SalesOrderNumID ), NULL) AS SalesOrderNumID
	,IIF([TransactionDescription] = 'Outgoing goods' OR [TransactionDescription] = 'Sales', CONVERT(bigint, SalesInvoiceID ), NULL) AS SalesInvoiceID
	,CONCAT(Right(Year([TransactionDate]), 2), RIGHT(CONCAT('0', Month( [TransactionDate]) ),2), '-', Currency) AS CurrencyMonthKey

	,[Company]
	,[WarehouseCode]
	,[TransactionCode]
	,[TransactionDescription]
	,[IssuerReceiverNum]
	,IIF(Company = 'ACZARKOV', STRes3, '') AS IssuerReceiverName
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
FROM 
	[dw].[StockTransaction] st
--WHERE [TransactionDate] >= DATEADD(year, DATEDIFF(YEAR, 0, dateadd(year, - 5, GETDATE())), 0)
GO
