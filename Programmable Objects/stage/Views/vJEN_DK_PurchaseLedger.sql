IF OBJECT_ID('[stage].[vJEN_DK_PurchaseLedger]') IS NOT NULL
	DROP VIEW [stage].[vJEN_DK_PurchaseLedger];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [stage].[vJEN_DK_PurchaseLedger] AS 
--ADD TRIM() INTO SupplierID 23-01-23 VA
SELECT 
	CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(Company, '#', TRIM(SupplierCode), '#', TRIM(PurchaseInvoiceNum))))) AS PurchaseLedgerID
	,UPPER(CONCAT(Company, '#', TRIM(SupplierCode), '#', TRIM(PurchaseInvoiceNum))) AS PurchaseLedgerCode
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(Company))) AS CompanyID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM(Company), '#', TRIM(SupplierCode))))) AS SupplierID
	--,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(Company, '#', TRIM(SupplierCode))))) AS SupplierID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(Company, '#', TRIM(PurchaseInvoiceNum))))) AS PurchaseInvoiceID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(Company, '#', TRIM(PurchaseOrderNum))))) AS PurchaseOrderNumID
	,CONVERT(int, replace(convert(date,InvoiceDate),'-','')) AS InvoiceDateID 
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(TRIM(CurrencyCode)))) AS CurrencyID
	,[PartitionKey]

	,UPPER(Company) AS [Company]
	,TRIM([SupplierCode]) AS SupplierNum
	,TRIM([PurchaseInvoiceNum]) AS [PurchaseInvoiceNum]
	,TRIM([PurchaseOrderNum]) AS [PurchaseOrderNum]
	,CONVERT(date, [InvoiceDate]) AS InvoiceDate
	,CONVERT(date, [DueDate]) AS PurchaseDueDate
	,CONVERT(date, [LastPaymentDate]) AS PurchaseLastPaymentDate
	,[InvoiceLCYAmount]
	,[InvoiceCurrAmount]
--	,IIF([InvoiceCurrAmount]=0, null, [InvoiceLCYAmount]/[InvoiceCurrAmount]) AS ExchangeRate
	,[ExchangeRate]
	,IIF([CurrencyCode] is null, 'DKK', TRIM([CurrencyCode])) AS Currency
	,[VATPaid]
	,[VATcode]
	,[PayToName]
	--,'' AS [PayToCity]
	--,'' AS [PayToContact]
	,[PaymentTermsCode]
	,[PrepaymentNum]
	--,'' AS LastPaymentNum
	--,'' AS PLRES1
	--,'' AS PLRES2
	--,'' AS PLRES3
	--,NULL AS PaidInvoiceAmount
	--,NULL AS RemainingInvoiceAmount
	--,NULL AS LinkToOriginalInvoice
	,CAST ('1900-01-01'AS date) AS AccountingDate
	--,NULL AS AgingPeriod
	--,NULL AS AgingSort
	--,NULL AS VATCodeDesc
FROM 
	[stage].[JEN_DK_PurchaseLedger]
GO
