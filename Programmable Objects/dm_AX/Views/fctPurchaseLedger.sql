IF OBJECT_ID('[dm_AX].[fctPurchaseLedger]') IS NOT NULL
	DROP VIEW [dm_AX].[fctPurchaseLedger];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




CREATE VIEW [dm_AX].[fctPurchaseLedger] AS
SELECT 
 [PurchaseLedgerID]
,[Company]
,[SupplierNum]
,[PurchaseOrderNum]
,[PurchaseInvoiceNum]
,[PurchaseInvoiceDate]
,[PurchaseDueDate]
,[PurchaseLastPaymentDate]
,[InvoiceAmount]
,[ExchangeRate]
,[Currency]
,[VATAmount]
,[VATCode]
,[PayToName]
,[PayToCity]
,[PayToContact]
,[PaymentTerms]
,[PrePaymentNum]
,[LastPaymentNum]
,[PLRes1]
,[PLRes2]
,[PLRes3]
,[PurchaseLedgerCode]
,[CompanyID]
,[SupplierID]
,[PurchaseInvoiceID]
,[PurchaseOrderNumID]
,[CurrencyID]
,[PurchaseInvoiceDateID]
,[PartitionKey]
,[PaidInvoiceAmount]
,[RemainingInvoiceAmount]
,[AccountingDate]
,[AgingPeriod]
,[AgingSort]
,[VATCodeDesc]
,[LinkToOriginalInvoice]
  FROM [dm].[FactPurchaseLedger]
WHERE [Company] in ('AXISE','AXHSE') -- HQ basket
GO
