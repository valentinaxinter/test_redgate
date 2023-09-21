IF OBJECT_ID('[stage].[vROR_SE_PurchaseLedger]') IS NOT NULL
	DROP VIEW [stage].[vROR_SE_PurchaseLedger];

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE VIEW [stage].[vROR_SE_PurchaseLedger] AS 

SELECT 
	CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(Company, '#', TRIM(SupplierNum), '#', TRIM(PurchaseInvoiceNum)  )))) AS PurchaseLedgerID 
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(TRIM(Company)))) AS CompanyID 
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM(Company), '#', TRIM(SupplierNum))))) AS SupplierID 
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(Company, '#', TRIM(PurchaseInvoiceNum))))) AS PurchaseInvoiceID 
	,CONVERT([binary](32), HASHBYTES('SHA2_256',UPPER(CONCAT(Company, '#', TRIM(PurchaseOrderNum))))) AS PurchaseOrderNumID 
	,CONVERT([binary](32), HASHBYTES('SHA2_256',UPPER(TRIM(Currency)))) AS CurrencyID
	,CONVERT(int, replace(convert(date,PurchaseInvoiceDate),'-','')) AS PurchaseInvoiceDateID 
	,UPPER(CONCAT(Company, '#', TRIM(SupplierNum), '#', TRIM(PurchaseInvoiceNum))) AS PurchaseLedgerCode 
	,[PartitionKey]

	,UPPER([Company]) AS [Company]
	,UPPER(TRIM(SupplierNum)) AS SupplierNum
	,TRIM([PurchaseOrderNum]) AS [PurchaseOrderNum]
	,TRIM([PurchaseInvoiceNum]) AS [PurchaseInvoiceNum]
	,SupplierInvoiceNum
	,CONVERT(date, PurchaseInvoiceDate) AS PurchaseInvoiceDate
	,CONVERT(date, PurchaseDueDate) AS PurchaseDueDate
	,CONVERT(date, PurchaseLastPaymentDate) AS PurchaseLastPaymentDate
	,CONVERT(decimal(18,4), REPLACE(InvoiceAmount, ',', '.')) AS [InvoiceLCYAmount] 
	,CONVERT(decimal(18,4), REPLACE(InvoiceAmount, ',', '.')) AS InvoiceAmount
	,IIF([Currency] = 'SEK', 1, CONVERT(decimal(18,4), REPLACE(ExchangeRate, ',', '.'))) AS ExchangeRate 
	,IIF([Currency] = '€UR','EUR',trim([Currency])) As [Currency]
	,CONVERT(decimal(18,4), REPLACE(VATAmount, ',', '.')) AS VATAmount
	,TRIM(VATCode) AS VATCode
	,TRIM([PayToName]) AS [PayToName]
	,IsInvoiceClosed
	,[IsActiveRecord]
	,[PayToCity]
	,[PayToContact]
	,TRIM(PaymentTerms) AS PaymentTerms
	--,'' AS [PrepaymentNum]
	--,'' AS LastPaymentNum
	,CONVERT(decimal(18,4), REPLACE(PaidInvoiceAmount, ',', '.')) AS PaidInvoiceAmount
	,CONVERT(decimal(18,4), REPLACE(RemainingInvoiceAmount, ',', '.')) AS RemainingInvoiceAmount
	,LinkToOriginalInvoice
	,CONVERT(date, AccountingDate) AS AccountingDate
	--,NULL AS AgingPeriod
	--,NULL AS AgingSort
	,CostUnitNum
	,'' AS ProjectNum
	,VATCodeDesc AS VATCodeDesc
	,ModifiedTimeStamp AS PLRES1
	,CreatedTimeStamp AS PLRES2
	--,'' AS PLRES3
FROM 
	[stage].[ROR_SE_PurchaseLedger]
GO
