IF OBJECT_ID('[dm_LS].[fctSalesLedger]') IS NOT NULL
	DROP VIEW [dm_LS].[fctSalesLedger];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [dm_LS].[fctSalesLedger] AS 

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
FROM [dm].[FactSalesLedger] sl
LEFT JOIN dbo.Company com ON sl.Company = com.Company
WHERE com.BusinessArea = 'Lifting Solutions' AND com.[Status] = 'Active'

  --WHERE Company  IN ('AFISCM', 'CDKCERT', 'CEECERT', 'CFICERT', 'CLTCERT', 'CLVCERT', 'CSECERT', 'CUKCERT', 'CNOEHAU', 'CNOCERT', 'CERPL', 'CyESA', 'HFIHAKL', 'TRACLEV'
		--,'MENBE14','MENNL01','MENNL02','MENNL03','MENNL04','MENNL07','MENNL11')
GO
