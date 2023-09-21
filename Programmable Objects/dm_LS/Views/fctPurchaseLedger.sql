IF OBJECT_ID('[dm_LS].[fctPurchaseLedger]') IS NOT NULL
	DROP VIEW [dm_LS].[fctPurchaseLedger];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [dm_LS].[fctPurchaseLedger] AS
SELECT 
 pl.[PurchaseLedgerID]
,pl.[Company]
,pl.[SupplierNum]
,pl.[PurchaseOrderNum]
,pl.[PurchaseInvoiceNum]
,pl.[PurchaseInvoiceDate]
,pl.[PurchaseDueDate]
,pl.[PurchaseLastPaymentDate]
,pl.[InvoiceAmount]
,pl.[ExchangeRate]
,pl.[Currency]
,pl.[VATAmount]
,pl.[VATCode]
,pl.[PayToName]
,pl.[PayToCity]
,pl.[PayToContact]
,pl.[PaymentTerms]
,pl.[PrePaymentNum]
,pl.[LastPaymentNum]
,pl.[PLRes1]
,pl.[PLRes2]
,pl.[PLRes3]
,pl.[PurchaseLedgerCode]
,pl.[CompanyID]
,pl.[SupplierID]
,pl.[PurchaseInvoiceID]
,pl.[PurchaseOrderNumID]
,pl.[CurrencyID]
,pl.[PurchaseInvoiceDateID]
,pl.[PartitionKey]
,pl.[PaidInvoiceAmount]
,pl.[RemainingInvoiceAmount]
,pl.[AccountingDate]
,pl.[AgingPeriod]
,pl.[AgingSort]
,pl.[VATCodeDesc]
,pl.[LinkToOriginalInvoice]
FROM [dm].[FactPurchaseLedger] pl
LEFT JOIN dbo.Company com ON pl.Company = com.Company
WHERE com.BusinessArea = 'Lifting Solutions' AND com.[Status] = 'Active'

  --WHERE Company IN ('CNOCERT', 'TRACLEV', 'CSECERT', 'CLVCERT', 'CLTCERT')
GO
