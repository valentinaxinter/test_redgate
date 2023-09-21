IF OBJECT_ID('[dm_ALL].[fctSalesLedger]') IS NOT NULL
	DROP VIEW [dm_ALL].[fctSalesLedger];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [dm_ALL].[fctSalesLedger] AS 
SELECT 
 [SalesLedgerID]
,[SalesPersonNameID]
,[Company]
,[CustomerNum]
,[SalesInvoiceNum]
,[SalesInvoiceDate]
,[SalesDueDate]
,[SalesLastPaymentDate]
,[InvoiceAmount]
,[RemainingInvoiceAmount]
,[ExchangeRate]
,[Currency]
,[VATAmount]
,[VATCode]
,[PayToName]
,[PayToCity]
,[PayToContact]
,[PaymentTerms]
,[SLRes1]
,[SLRes2]
,[SLRes3]
,[SalesLedgerCode]
,[CompanyID]
,[PartitionKey]
,[PaidInvoiceAmount]
,[AccountingDate]
,[AgingPeriod]
,[AgingSort]
,[VATCodeDesc]
,[CustomerID]
,[LinkToOriginalInvoice]
,[SalesInvoiceDateID]
,[PaymentStatus]
,[WarehouseID]
FROM [dm].[FactSalesLedger]
GO
