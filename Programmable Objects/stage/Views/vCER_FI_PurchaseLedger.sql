IF OBJECT_ID('[stage].[vCER_FI_PurchaseLedger]') IS NOT NULL
	DROP VIEW [stage].[vCER_FI_PurchaseLedger];

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE VIEW [stage].[vCER_FI_PurchaseLedger] AS 

SELECT 
	CONVERT([binary](32),HASHBYTES('SHA2_256',CONCAT(Company,'#',TRIM(SupplierCode), '#', TRIM(PurchaseInvoiceNum)))) AS PurchaseLedgerID 
	,CONCAT(Company, '#', TRIM(SupplierCode), '#', TRIM(PurchaseInvoiceNum)) AS PurchaseLedgerCode
	,CONVERT([binary](32), HASHBYTES('SHA2_256',TRIM(Company))) AS CompanyID 
	,CONVERT([binary](32), HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM(Company), '#', TRIM(SupplierCode))))) AS SupplierID 
	,CONVERT([binary](32), HASHBYTES('SHA2_256',CONCAT(Company,'#',TRIM(PurchaseInvoiceNum)))) AS PurchaseInvoiceID 
	,CONVERT([binary](32), HASHBYTES('SHA2_256',UPPER(CONCAT(Company,'#',TRIM(PurchaseOrderNum))))) AS PurchaseOrderNumID 
	,CONVERT([binary](32), HASHBYTES('SHA2_256',UPPER(TRIM(CurrencyCode)))) AS CurrencyID 
	,CONVERT(int, replace(convert(date,InvoiceDate),'-','')) AS PurchaseInvoiceDateID  
	,[PartitionKey]

	,TRIM(UPPER([Company])) AS [Company]
	,TRIM(UPPER(SupplierCode)) AS SupplierNum
	,TRIM(UPPER([PurchaseOrderNum])) AS [PurchaseOrderNum]
	,TRIM(UPPER([PurchaseInvoiceNum])) AS [PurchaseInvoiceNum]
	,CONVERT(date, [InvoiceDate]) AS PurchaseInvoiceDate
	,CONVERT(date, [DueDate]) AS PurchaseDueDate
	,CONVERT(date, [LastPaymentDate]) AS PurchaseLastPaymentDate
	,[InvoiceLCYAmount] 
	,[InvoiceCurrAmount] AS InvoiceAmount
--	,IIF([InvoiceCurrAmount]=0, null, [InvoiceLCYAmount]/[InvoiceCurrAmount]) AS ExchangeRate
	,[ExchangeRate]
	,TRIM(UPPER([CurrencyCode])) AS Currency
	,[VATPaid]	AS VATAmount
	,[VATcode]	AS VATCode
	,[PayToName]
	--,'' AS [PayToCity]
	--,'' AS [PayToContact]
	,TRIM(UPPER([PaymentTermsCode])) AS PaymentTerms
	,[PrepaymentNum]
	--,'' AS LastPaymentNum
	--,'' AS PLRES1
	--,'' AS PLRES2
	--,'' AS PLRES3
	--,NULL AS PaidInvoiceAmount
	--,NULL AS RemainingInvoiceAmount
	--,NULL AS LinkToOriginalInvoice
	,'' AS AccountingDate
	--,NULL AS AgingPeriod
	--,NULL AS AgingSort
	--,NULL AS VATCodeDesc
FROM 
	[stage].[CER_FI_PurchaseLedger]
GO
