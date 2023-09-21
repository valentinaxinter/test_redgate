IF OBJECT_ID('[stage].[vWID_FI_PurchaseLedger]') IS NOT NULL
	DROP VIEW [stage].[vWID_FI_PurchaseLedger];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [stage].[vWID_FI_PurchaseLedger] AS 
--ADD TRIM() UPPER() INTO SupplierID 23-01-24 VA
SELECT 
	CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT(Company, '#', TRIM(SupplierCode), '#', TRIM(PurchaseInvoiceNum), TRIM(PurchaseOrderNum)))) AS PurchaseLedgerID

	,CONCAT(Company, '#', TRIM(SupplierCode), '#', TRIM(PurchaseInvoiceNum)) AS PurchaseLedgerCode
	,CONVERT([binary](32), HASHBYTES('SHA2_256', TRIM(Company))) AS CompanyID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM(Company), '#', TRIM(SupplierCode))))) AS SupplierID
	--,CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT(Company, '#', TRIM(SupplierCode)))) AS SupplierID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT(Company, '#', TRIM(PurchaseInvoiceNum)))) AS PurchaseInvoiceID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT(Company, '#', TRIM(PurchaseOrderNum)))) AS PurchaseOrderNumID
	,CONVERT(int, replace(convert(date,InvoiceDate), '-', '')) AS PurchaseInvoiceDateID 
	,CONVERT([binary](32), HASHBYTES('SHA2_256', TRIM(Currency))) AS CurrencyID
	,[PartitionKey]

	,[Company]
	,TRIM(SupplierCode) AS SupplierNum
	,TRIM(PurchaseInvoiceNum) AS [PurchaseInvoiceNum]
	,TRIM(PurchaseOrderNum) AS [PurchaseOrderNum]
	,CONVERT(date, [InvoiceDate]) AS PurchaseInvoiceDate
	,CONVERT(date, [DueDate]) AS PurchaseDueDate
	,CONVERT(date, [LastPaymentDate]) AS PurchaseLastPaymentDate
	,[InvoiceLCYAmount] AS InvoiceAmount
--	,IIF([InvoiceCurrAmount]=0, null, [InvoiceLCYAmount]/[InvoiceCurrAmount]) AS ExchangeRate
	,1 AS [ExchangeRate]
	,'EUR' AS [Currency]
	,[VATPaid] AS VATAmount
	,[VATcode]
	,[PayToName]
	,'' AS [PayToCity]
	,'' AS [PayToContact]
	,[PaymentTermsCode] AS PaymentTerms
	,[PrepaymentNum]
	,'' AS LastPaymentNum
	,'' AS PLRES1
	,'' AS PLRES2
	,'' AS PLRES3
	--,NULL AS PaidInvoiceAmount
	--,NULL AS RemainingInvoiceAmount
	--,NULL AS LinkToOriginalInvoice
	,CAST ('1900-01-01' AS DATE)AS AccountingDate
	--,NULL AS AgingPeriod
	--,NULL AS AgingSort
	--,NULL AS VATCodeDesc
FROM 
	[stage].[WID_FI_PurchaseLedger]
GO
