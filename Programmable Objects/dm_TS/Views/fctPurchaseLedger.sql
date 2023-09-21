IF OBJECT_ID('[dm_TS].[fctPurchaseLedger]') IS NOT NULL
	DROP VIEW [dm_TS].[fctPurchaseLedger];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE   VIEW [dm_TS].[fctPurchaseLedger] AS
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
FROM [dm].[FactPurchaseLedger]  as pl
WHERE pl.Company  IN ('FESFORA', 'FSEFORA', 'FFRFORA', 'FORPL', 'CERPL', 'FFRGPI', 'FFRLEX', 'IFIWIDN', 'IEEWIDN', 'TMTFI', 'TMTEE', 'FITMT', 'EETMT', 'ABKSE', 'ROROSE','STESE')
GO
