IF OBJECT_ID('[dm_ALL].[fctPurchaseLedger]') IS NOT NULL
	DROP VIEW [dm_ALL].[fctPurchaseLedger];

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE VIEW [dm_ALL].[fctPurchaseLedger]
	AS 

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
GO
