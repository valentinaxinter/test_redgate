IF OBJECT_ID('[dm_IN].[fctSalesLedger]') IS NOT NULL
	DROP VIEW [dm_IN].[fctSalesLedger];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [dm_IN].[fctSalesLedger] AS 
SELECT 
 sl.[SalesLedgerID]
,sl.[SalesPersonNameID]
,sl.[Company]
,sl.[CustomerNum]
,sl.[SalesInvoiceNum]
,sl.[SalesInvoiceDate]
,sl.[SalesDueDate]
,sl.[SalesLastPaymentDate]
,sl.[InvoiceAmount]
,sl.[RemainingInvoiceAmount]
,sl.[ExchangeRate]
,sl.[Currency]
,sl.[VATAmount]
,sl.[VATCode]
,sl.[PayToName]
,sl.[PayToCity]
,sl.[PayToContact]
,sl.[PaymentTerms]
,sl.[SLRes1]
,sl.[SLRes2]
,sl.[SLRes3]
,sl.[SalesLedgerCode]
,sl.[CompanyID]
,sl.[PartitionKey]
,sl.[PaidInvoiceAmount]
,sl.[AccountingDate]
,sl.[AgingPeriod]
,sl.[AgingSort]
,sl.[VATCodeDesc]
,sl.[CustomerID]
,sl.[LinkToOriginalInvoice]
,sl.[SalesInvoiceDateID]
,sl.[PaymentStatus]
,sl.[WarehouseID]
  FROM [dm].[FactSalesLedger] as sl
  WHERE Company  IN ('OCSSE')
GO
