IF OBJECT_ID('[stage].[vNOM_DK_PurchaseLedger]') IS NOT NULL
	DROP VIEW [stage].[vNOM_DK_PurchaseLedger];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [stage].[vNOM_DK_PurchaseLedger] AS 
--ADD TRIM() INTO SupplierID 23-01-24 VA
SELECT 
	CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(Company,'#',TRIM(SupplierNum), '#', TRIM(PurchaseInvoiceNum))))) AS PurchaseLedgerID -- shall = in Invoice
	,UPPER(CONCAT(Company, '#', TRIM(SupplierNum), '#', TRIM(PurchaseInvoiceNum))) AS PurchaseLedgerCode --Redundant?
	,CONVERT([binary](32), HASHBYTES('SHA2_256',UPPER(TRIM(Company)))) AS CompanyID 
	,CONVERT([binary](32), HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM(Company), '#', TRIM(SupplierNum))))) AS SupplierID 
	--,CONVERT([binary](32), HASHBYTES('SHA2_256',UPPER(CONCAT(Company, '#', TRIM(SupplierNum))))) AS SupplierID 
	,CONVERT([binary](32), HASHBYTES('SHA2_256',UPPER(CONCAT(Company,'#',TRIM(PurchaseInvoiceNum))))) AS PurchaseInvoiceID --Redundant?
	,CONVERT([binary](32), HASHBYTES('SHA2_256',UPPER(CONCAT(Company,'#',TRIM(PurchaseOrderNum))))) AS PurchaseOrderNumID --Redundant?
	,CONVERT([binary](32), HASHBYTES('SHA2_256',UPPER(TRIM(Currency)))) AS CurrencyID --Redundant?
	,CONVERT(int, replace(convert(date,PurchaseInvoiceDate),'-','')) AS PurchaseInvoiceDateID  --Redundant?
	,[PartitionKey]

	,TRIM(UPPER([Company])) AS [Company]
	,TRIM(UPPER(SupplierNum)) AS SupplierNum
	,UPPER(TRIM([PurchaseOrderNum])) AS [PurchaseOrderNum]
	,UPPER(TRIM([PurchaseInvoiceNum])) AS  [PurchaseInvoiceNum]
	,CONVERT(date, PurchaseInvoiceDate) AS PurchaseInvoiceDate
	,CONVERT(date, [DueDate]) AS PurchaseDueDate
	,CONVERT(date, [LastPaymentDate]) AS PurchaseLastPaymentDate
	,RemainingInvoiceAmount 
	,InvoiceAmount
	,[ExchangeRate]
	,Currency
	,VATAmount
	,VATCode
	,[PayToName]
	,[PayToCity]
	,[PayToContact]
	,PaymentTerms
	,UPPER(TRIM([PrepaymentNum])) AS [PrepaymentNum]
	,UPPER(TRIM(LastPaymentNum)) AS LastPaymentNum
	,'' AS PLRES1
	,'' AS PLRES2
	,'' AS PLRES3
	,NULL AS PaidInvoiceAmount
	,NULL AS LinkToOriginalInvoice
	,CAST ('1900-01-01'AS date) AS AccountingDate
	,NULL AS AgingPeriod
	,NULL AS AgingSort
	,NULL AS VATCodeDesc
FROM 
	[stage].[NOM_DK_PurchaseLedger]
GO
