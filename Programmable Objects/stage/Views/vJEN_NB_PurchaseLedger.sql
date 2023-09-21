IF OBJECT_ID('[stage].[vJEN_NB_PurchaseLedger]') IS NOT NULL
	DROP VIEW [stage].[vJEN_NB_PurchaseLedger];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [stage].[vJEN_NB_PurchaseLedger] AS 
--COMMENT EMPTY FIELDS 23-01-03 VA
--ADD TRIM() INTO SupplierID 23-01-24 VA
SELECT 
	CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(Company, '#', TRIM(SupplierCode), '#', TRIM(PurchaseInvoiceNum))))) AS PurchaseLedgerID -- shall = in Invoice
	,UPPER(CONCAT(Company, '#', TRIM(SupplierCode), '#', TRIM(PurchaseInvoiceNum))) AS PurchaseLedgerCode 
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(Company))) AS CompanyID 
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM(Company), '#', TRIM(SupplierCode))))) AS SupplierID 
	--,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(Company, '#', TRIM(SupplierCode))))) AS SupplierID 
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(Company, '#', TRIM(PurchaseInvoiceNum))))) AS PurchaseInvoiceID 
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(Company, '#', TRIM(PurchaseOrderNum))))) AS PurchaseOrderNumID 
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(TRIM(CurrencyCode)))) AS CurrencyID 
	,CONVERT(int, replace(InvoiceDate, '-', '') ) AS PurchaseInvoiceDateID  
	,[PartitionKey]

	,UPPER(Company) AS [Company]
	,UPPER(TRIM(SupplierCode)) AS SupplierNum
	,[PurchaseOrderNum]
	,[PurchaseInvoiceNum]
	,[InvoiceDate] AS PurchaseInvoiceDate --CONVERT(date, 
	,[DueDate] AS PurchaseDueDate --CONVERT(date, 
	,[LastPaymentDate] AS PurchaseLastPaymentDate --CONVERT(date, 
	,[InvoiceLCYAmount] 
	,[InvoiceCurrAmount] AS InvoiceAmount
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
	--,'' AS AccountingDate
	--,NULL AS AgingPeriod
	--,NULL AS AgingSort
	--,NULL AS VATCodeDesc
FROM 
	[stage].[JEN_NB_PurchaseLedger]
GO
