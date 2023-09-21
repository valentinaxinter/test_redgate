IF OBJECT_ID('[stage].[vSCM_FI_PurchaseLedger]') IS NOT NULL
	DROP VIEW [stage].[vSCM_FI_PurchaseLedger];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [stage].[vSCM_FI_PurchaseLedger] AS 
--ADD TRIM() UPPER() INTO SupplierID 23-01-24 VA
SELECT 
	CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT(Company, '#', TRIM(SupplierCode), '#', TRIM(PurchaseInvoiceNum), '#', TRIM(PurchaseOrderNum), '#', TRIM(LastPaymentNum)))) AS PurchaseLedgerID
	,CONCAT(Company, '#', TRIM(SupplierCode), '#', TRIM(PurchaseInvoiceNum)) AS PurchaseLedgerCode
	,CONVERT([binary](32), HASHBYTES('SHA2_256', TRIM(Company))) AS CompanyID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM(Company), '#', TRIM(SupplierCode))))) AS SupplierID
	--,CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT(Company, '#', TRIM(SupplierCode)))) AS SupplierID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT(Company, '#', TRIM(PurchaseInvoiceNum)))) AS PurchaseInvoiceID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT(Company, '#', TRIM(PurchaseOrderNum)))) AS PurchaseOrderNumID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', TRIM(CurrencyCode))) AS CurrencyID
	,CONVERT(int, replace(convert(date,InvoiceDate), '-', '')) AS PurchaseInvoiceDateID 
	,[PartitionKey]

	,[Company]
	,[SupplierCode] AS SupplierNum
	,[PurchaseOrderNum]
	,[PurchaseInvoiceNum]
	,CONVERT(date, [InvoiceDate]) AS [PurchaseInvoiceDate]
	,CONVERT(date, [DueDate]) AS PurchaseDueDate
	,CONVERT(date, [LastPaymentDate]) AS PurchaseLastPaymentDate
	,[InvoiceLCYAmount] AS [InvoiceAmount]
	,[ExchangeRate]
	,[CurrencyCode] AS [Currency]
--	,[InvoiceCurrAmount]
--	,IIF([InvoiceCurrAmount]=0, null, [InvoiceLCYAmount]/[InvoiceCurrAmount]) AS ExchangeRate
	,[VATPaid] AS [VATAmount]
	,[VATcode]
	,[PayToName]
	,[PayToCity]
	,MAX([PayToContact]) AS PayToContact
	,[PaymentTermsCode] AS [PaymentTerms]
	,[PrepaymentNum]
	,LastPaymentNum
	,'' AS PLRES1
	,'' AS PLRES2
	,'' AS PLRES3
	,NULL AS PaidInvoiceAmount
	,NULL AS RemainingInvoiceAmount
	,NULL AS LinkToOriginalInvoice
	,CAST ('1900-01-01'AS date) AS AccountingDate
	,NULL AS AgingPeriod
	,NULL AS AgingSort
	,NULL AS VATCodeDesc
FROM 
	[stage].[SCM_FI_PurchaseLedger]
WHERE [Company] = 'AFISCM'

GROUP BY
	[Company],[SupplierCode],[PurchaseInvoiceNum],[PurchaseOrderNum],InvoiceDate,DueDate,LastPaymentDate,[InvoiceLCYAmount],[InvoiceCurrAmount],[ExchangeRate],[CurrencyCode],[VATPaid],[VATcode],[PayToName],[PayToCity],[PaymentTermsCode],[PrepaymentNum],LastPaymentNum,[PartitionKey]
GO
