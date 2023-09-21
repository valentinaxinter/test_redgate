IF OBJECT_ID('[dm_AX].[fctGeneralLedger]') IS NOT NULL
	DROP VIEW [dm_AX].[fctGeneralLedger];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO






CREATE VIEW [dm_AX].[fctGeneralLedger] AS 
SELECT 
 [GeneralLedgerID]
,[AccountID]
,[CustomerID]
,[SupplierID]
,[CompanyID]
,[ProjectID]
,[CostUnitID]
,[CostBearerID]
,[PartitionKey]
,[Company]
,[AccountNum]
,[CostUnitNum]
,[CostBearerNum]
,[JournalType]
,[JournalDate]
,[JournalNum]
,[JournalLine]
,[AccountingDate]
,[Description]
,[Currency]
,[ExchangeRate]
,[InvoiceAmount]
,[InvoiceAmountLC]
,[CustomerNum]
,[SupplierNum]
,[SalesInvoiceNum]
,[PurchaseInvoiceNum]
,[SupplierInvoiceNum]
,[LinkToOriginalInvoice]
,[DeliveryCountry]
,[TransactionNum]
,[VATCode]
,[VATCodeDesc]
,[GLRes1]
,[GLRes2]
,[GLRes3]
  FROM [dm].[FactGeneralLedger]
WHERE [Company] in ('AXISE','AXHSE') -- HQ basket
GO
