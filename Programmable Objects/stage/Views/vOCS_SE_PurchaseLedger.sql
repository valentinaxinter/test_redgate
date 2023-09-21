IF OBJECT_ID('[stage].[vOCS_SE_PurchaseLedger]') IS NOT NULL
	DROP VIEW [stage].[vOCS_SE_PurchaseLedger];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE VIEW [stage].[vOCS_SE_PurchaseLedger] AS 
--ADD TRIM() INTO SupplierID 23-01-24 VA
SELECT 
	CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(Company, '#', TRIM(SupplierNum), '#', TRIM(PurchaseInvoiceNum)  )))) AS PurchaseLedgerID 
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(TRIM(Company)))) AS CompanyID 
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM(Company), '#', TRIM(SupplierNum))))) AS SupplierID 
	--,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(Company, '#', TRIM(SupplierNum))))) AS SupplierID 
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
	,InvoiceAmountSEK * -1 AS [InvoiceLCYAmount] 
	,InvoiceAmount  * -1 AS InvoiceAmount
	,IIF([Currency] = 'SEK', 1, CONVERT(decimal(18,4), ExchangeRate)) AS ExchangeRate --IIF(Currency IN ('SEK', 'DKK', 'NOK'), (CONVERT(decimal(18,4), ExchangeRate))/100, (CONVERT(decimal(18,4), ExchangeRate))) AS [ExchangeRate]
	,IIF([Currency] = '€UR','EUR',trim([Currency])) As [Currency]
	,VATAmount * -1	AS VATAmount
	,VATCode AS VATCode
	--,[PayToName]
	,IsInvoiceClosed
	--,'' AS [PayToCity]
	--,'' AS [PayToContact]
	,PaymentTerms AS PaymentTerms
	--,'' AS [PrepaymentNum]
	--,'' AS LastPaymentNum
	,PaidInvoiceAmount * -1 AS PaidInvoiceAmount
	,RemainingInvoiceAmount * -1 AS RemainingInvoiceAmount
	,LinkToOriginalInvoice
	,CONVERT(date, AccountingDate) AS AccountingDate
	--,NULL AS AgingPeriod
	--,NULL AS AgingSort
	,CostUnitNum
	,ProjectNum
	,VATCodeDesc AS VATCodeDesc
	,ModifiedTimeStamp AS PLRES1
	,CreatedTimeStamp AS PLRES2
	--,'' AS PLRES3
FROM 
	[stage].[OCS_SE_PurchaseLedger]
GO
