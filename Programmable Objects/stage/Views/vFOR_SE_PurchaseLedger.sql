IF OBJECT_ID('[stage].[vFOR_SE_PurchaseLedger]') IS NOT NULL
	DROP VIEW [stage].[vFOR_SE_PurchaseLedger];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [stage].[vFOR_SE_PurchaseLedger] AS 

SELECT 
	CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM(Company), '#', TRIM(SupplierCode), '#', TRIM(PurchaseInvoiceNum), '#', TRIM(PurchaseOrderNum), '#', TRIM(LastPaymentNum))))) AS PurchaseLedgerID 
	,UPPER(CONCAT(TRIM(Company), '#', TRIM(SupplierCode), '#', TRIM(PurchaseInvoiceNum))) AS PurchaseLedgerCode
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(TRIM(Company)))) AS CompanyID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM(Company), '#', TRIM(SupplierCode))))) AS SupplierID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM(Company), '#', TRIM(PurchaseInvoiceNum))))) AS PurchaseInvoiceID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM(Company), '#', TRIM(PurchaseOrderNum))))) AS PurchaseOrderNumID
	,CONVERT(int, replace(convert(date,InvoiceDate),'-','')) AS PurchaseInvoiceDateID 
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(TRIM(CurrencyCode)))) AS CurrencyID
	,[PartitionKey]

	,UPPER(TRIM(Company)) AS [Company]
	,UPPER(TRIM([SupplierCode])) AS SupplierNum
	,TRIM([PurchaseOrderNum]) AS [PurchaseOrderNum]
	,TRIM([PurchaseInvoiceNum]) AS [PurchaseInvoiceNum]
	,CONVERT(date, [InvoiceDate]) AS PurchaseInvoiceDate
	,CONVERT(date, [DueDate]) AS PurchaseDueDate
	,CONVERT(date, [LastPaymentDate]) AS PurchaseLastPaymentDate
	,[InvoiceLCYAmount]
	,[InvoiceCurrAmount] AS InvoiceAmount
	,[ExchangeRate]
	,[CurrencyCode] AS Currency
	,[VATPaid] AS VATAmount
	,[VATcode] AS VATCode
	,[VATCodeDesc]
	,[PayToName]
	,[PayToCity]
	,([PayToContact]) AS PayToContact --MAX
	,[PaymentTermsCode] AS PaymentTerms
	,[PrePaymentNum]
	,MAX(LastPaymentNum) AS LastPaymentNum
	,PurchaseInvoiceDesc AS PLRES1
	,DaysPastDue AS PLRES2
	,'' AS PLRES3
	,OriginalAmount - RemainingAmount AS PaidInvoiceAmount
	,RemainingAmount AS RemainingInvoiceAmount
	,LinkToOriginalInvoice
	,CONVERT(date, ApplyDate) AS AccountingDate
	,AgingPeriod
	,NULL AS AgingSort

FROM 
	[stage].[FOR_SE_PurchaseLedger]
WHERE [Company] = 'FSEFORA'

GROUP BY
	[Company],[SupplierCode],[PurchaseInvoiceNum],[PurchaseOrderNum],InvoiceDate,DueDate,LastPaymentDate,[InvoiceLCYAmount],[InvoiceCurrAmount],[ExchangeRate],[CurrencyCode],[VATPaid],[VATcode],[PayToName],[PayToCity],[PaymentTermsCode],[PrepaymentNum],LastPaymentNum,[PartitionKey], PayToContact, VATCodeDesc, PurchaseInvoiceDesc, DaysPastDue, OriginalAmount, RemainingAmount, LinktoOriginalInvoice, AgingPeriod, ApplyDate
GO
