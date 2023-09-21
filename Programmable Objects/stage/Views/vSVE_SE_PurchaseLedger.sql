IF OBJECT_ID('[stage].[vSVE_SE_PurchaseLedger]') IS NOT NULL
	DROP VIEW [stage].[vSVE_SE_PurchaseLedger];

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE VIEW [stage].[vSVE_SE_PurchaseLedger] AS 

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
	,'' AS [PurchaseOrderNum]
	,IIF(TRIM(PLRES2) = 'L', CONCAT('L', TRIM([PurchaseInvoiceNum])), TRIM([PurchaseInvoiceNum])) AS [PurchaseInvoiceNum]
	,TRIM(SupplierInvoiceNum) AS SupplierInvoiceNum
	,CONVERT(date, PurchaseInvoiceDate) AS PurchaseInvoiceDate
	,CONVERT(date, PurchaseDueDate) AS PurchaseDueDate
	,CONVERT(date, PurchaseLastPaymentDate) AS PurchaseLastPaymentDate
	,(InvoiceAmount) AS [InvoiceLCYAmount] 
	,(InvoiceAmount) AS InvoiceAmount
	,IIF([Currency] = 'SEK', 1, CONVERT(decimal(18,4), ExchangeRate)) AS ExchangeRate
	,TRIM([Currency]) As [Currency]
	,VATAmount AS VATAmount
	,VATCode AS VATCode
	,[PayToName]
	,'' AS IsInvoiceClosed
	,[PayToCity]
	,[PayToContact]
	,PaymentTerms AS PaymentTerms
	--,'' AS [PrepaymentNum]
	--,'' AS LastPaymentNum
	,InvoiceAmount - RemainingInvoiceAmount AS PaidInvoiceAmount
	,RemainingInvoiceAmount AS RemainingInvoiceAmount
	,LinkToOriginalInvoice
	,CONVERT(date, AccountingDate) AS AccountingDate
	,ModifiedTimeStamp AS AgingPeriod 
	,CreatedTimeStamp AS AgingSort  
	,CostUnitNum
	,'' AS ProjectNum
	,VATCodeDesc AS VATCodeDesc
	,PLRES1 --[D4005_Status_reskont] AS 
	,PLRES2 --[D4003_Fakturatyp] AS 
	,[IsActiveRecord] AS PLRES3
FROM 
	[stage].[SVE_SE_PurchaseLedger]
GO
