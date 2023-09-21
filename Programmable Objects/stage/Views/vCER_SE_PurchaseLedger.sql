IF OBJECT_ID('[stage].[vCER_SE_PurchaseLedger]') IS NOT NULL
	DROP VIEW [stage].[vCER_SE_PurchaseLedger];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [stage].[vCER_SE_PurchaseLedger] AS 
--ADD TRIM() INTO Supplier 23-01-23 VA COMMENT EMPTY FIELDS
SELECT 
	CONVERT([binary](32),HASHBYTES('SHA2_256',CONCAT(Company,'#',TRIM(SupplierCode), '#', TRIM(PurchaseInvoiceNum)))) AS PurchaseLedgerID -- shall = in Invoice
	,CONCAT(Company, '#', TRIM(SupplierCode), '#', TRIM(PurchaseInvoiceNum)) AS PurchaseLedgerCode --Redundant?
	,CONVERT([binary](32), HASHBYTES('SHA2_256',TRIM(Company))) AS CompanyID --Redundant?
	,CONVERT([binary](32), HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM(Company), '#', TRIM(SupplierCode))))) AS SupplierID --Redundant?
	--,CONVERT([binary](32), HASHBYTES('SHA2_256',UPPER(CONCAT(Company, '#', TRIM(UPPER(SupplierCode)))))) AS SupplierID --Redundant?
	,CONVERT([binary](32), HASHBYTES('SHA2_256',CONCAT(Company,'#',TRIM(PurchaseInvoiceNum)))) AS PurchaseInvoiceID --Redundant?
	,CONVERT([binary](32), HASHBYTES('SHA2_256',UPPER(CONCAT(Company,'#',TRIM(PurchaseOrderNum))))) AS PurchaseOrderNumID --Redundant?
	,CONVERT([binary](32), HASHBYTES('SHA2_256',UPPER(TRIM(CurrencyCode)))) AS CurrencyID --Redundant?
	,CONVERT(int, replace(convert(date,InvoiceDate),'-','')) AS PurchaseInvoiceDateID  --Redundant?
	,[PartitionKey]

	,[Company]
	,TRIM(UPPER(SupplierCode)) AS SupplierNum
	,[PurchaseOrderNum]
	,[PurchaseInvoiceNum]
	,CONVERT(date, [InvoiceDate]) AS PurchaseInvoiceDate
	,CONVERT(date, [DueDate]) AS PurchaseDueDate
	,CONVERT(date, [LastPaymentDate]) AS PurchaseLastPaymentDate
	,[InvoiceLCYAmount] 
	,[InvoiceCurrAmount] AS InvoiceAmount
--	,IIF([InvoiceCurrAmount]=0, null, [InvoiceLCYAmount]/[InvoiceCurrAmount]) AS ExchangeRate
	,[ExchangeRate]
	,[CurrencyCode] AS Currency
	,[VATPaid]	AS VATAmount
	,[VATcode]	AS VATCode
	,[PayToName]
	--,'' AS [PayToCity]
	--,'' AS [PayToContact]
	,[PaymentTermsCode]	AS PaymentTerms
	,[PrepaymentNum]
	--,'' AS LastPaymentNum
	--,'' AS PLRES1
	--,'' AS PLRES2
	--,'' AS PLRES3
	--,NULL AS PaidInvoiceAmount
	--,NULL AS RemainingInvoiceAmount
	--,NULL AS LinkToOriginalInvoice
	,CAST('1900-01-01' AS date) AS AccountingDate
	--,NULL AS AgingPeriod
	--,NULL AS AgingSort
	--,NULL AS VATCodeDesc
FROM 
	[stage].[CER_SE_PurchaseLedger]
GO
