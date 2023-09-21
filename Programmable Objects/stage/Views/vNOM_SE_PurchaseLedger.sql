IF OBJECT_ID('[stage].[vNOM_SE_PurchaseLedger]') IS NOT NULL
	DROP VIEW [stage].[vNOM_SE_PurchaseLedger];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [stage].[vNOM_SE_PurchaseLedger] AS 
--ADD TRIM() INTO SupplierID 23-01-24 VA
SELECT 
	CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(Company, '#', TRIM(SupplierNum), '#', TRIM(PurchaseInvoiceNum))))) AS PurchaseLedgerID -- shall = in Invoice
	,UPPER(CONCAT(Company, '#', TRIM(SupplierNum), '#', TRIM(PurchaseInvoiceNum))) AS PurchaseLedgerCode  
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(TRIM(Company)))) AS CompanyID 
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM(Company), '#', TRIM(SupplierNum))))) AS SupplierID 
	--,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(Company, '#', TRIM(SupplierNum))))) AS SupplierID 
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(Company, '#', TRIM(PurchaseInvoiceNum))))) AS PurchaseInvoiceID  
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(Company, '#', TRIM(PurchaseOrderNum))))) AS PurchaseOrderNumID  
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(TRIM(Currency)))) AS CurrencyID  
	,CONVERT(int, replace(convert(date,PurchaseInvoiceDate),'-','')) AS PurchaseInvoiceDateID   
	,[PartitionKey]

	,UPPER(TRIM([Company])) AS [Company]
	,UPPER(TRIM(SupplierNum)) AS SupplierNum
	,UPPER(TRIM([PurchaseOrderNum])) AS [PurchaseOrderNum]
	,UPPER(TRIM([PurchaseInvoiceNum])) AS  [PurchaseInvoiceNum]
	,UPPER(TRIM([PrepaymentNum])) AS [PrepaymentNum]
	,UPPER(TRIM(LastPaymentNum)) AS LastPaymentNum
	,CONVERT(date, PurchaseInvoiceDate) AS PurchaseInvoiceDate
	,CONVERT(date, [DueDate]) AS PurchaseDueDate
	,CONVERT(date, [LastPaymentDate]) AS PurchaseLastPaymentDate
	,RemainingInvoiceAmount 
	,InvoiceAmount
	,IIF(TRIM(PurchaseInvoiceNum) = '174224', 10.64, ExchangeRate) AS ExchangeRate  --special case correction of wrong rate in erp
	,Currency
	,VATAmount
	,VATCode
	,[PayToName]
	,[PayToCity]
	,[PayToContact]
	,PaymentTerms
	,cast ('1900-01-01' as date) AS AccountingDate
	,'' AS PLRES1
	,'' AS PLRES2
	,'' AS PLRES3
	--,NULL AS PaidInvoiceAmount
	--,NULL AS LinkToOriginalInvoice
	--,NULL AS AgingPeriod
	--,NULL AS AgingSort
	--,NULL AS VATCodeDesc
FROM 
	[stage].[NOM_SE_PurchaseLedger]
GO
