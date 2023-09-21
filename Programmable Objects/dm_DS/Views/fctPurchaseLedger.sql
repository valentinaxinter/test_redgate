IF OBJECT_ID('[dm_DS].[fctPurchaseLedger]') IS NOT NULL
	DROP VIEW [dm_DS].[fctPurchaseLedger];

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE VIEW [dm_DS].[fctPurchaseLedger]
	AS 

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
LEFT JOIN dbo.Company com ON pl.Company = com.Company
WHERE com.BusinessArea = 'Driveline Solutions' AND com.[Status] = 'Active'
GO
