IF OBJECT_ID('[stage].[vCER_NO_PurchaseLedger]') IS NOT NULL
	DROP VIEW [stage].[vCER_NO_PurchaseLedger];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO










CREATE VIEW [stage].[vCER_NO_PurchaseLedger] AS

SELECT
	CONVERT([binary](32),HASHBYTES('SHA2_256',CONCAT(Company, '#', SupplierNum, '#', InvoiceNum))) AS PurchaseLedgerID
	,CONCAT(Company,'#',SupplierNum, '#', InvoiceNum) AS PurchaseLedgerCode
	,CONVERT([binary](32),HASHBYTES('SHA2_256',Company)) AS CompanyID
	,CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM([Company]),'#',TRIM([SupplierNum]))))) AS SupplierID
	,CONVERT([binary](32),HASHBYTES('SHA2_256',CONCAT(Company,'#',InvoiceNum))) AS PurchaseInvoiceID
	,CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM(Company), '#', TRIM(''))))) AS PurchaseOrderNumID
	,CONVERT([binary](32), HASHBYTES('SHA2_256',UPPER(TRIM(Currency)))) AS CurrencyID --Redundant?
	,CONVERT(int, replace(convert(date,InvoiceDate),'-','')) AS PurchaseInvoiceDateID  --Redundant?
	,PartitionKey

	,Company
	,SupplierNum
	,CompanySupplier
	,'' AS PurchaseOrderNum
	,InvoiceNum	AS PurchaseInvoiceNum
	,SupplierInvoiceNum
	,CONVERT(date, [InvoiceDate]) AS [PurchaseInvoiceDate]
	,CONVERT(date, DueDate) AS PurchaseDueDate
	,CONVERT(date, LastPaymentDate) AS PurchaseLastPaymentDate
	,[OriginalAmount]	AS InvoiceAmount
	,[OriginalAmount] - RemainingAmount AS PaidInvoiceAmount
	,[RemainingAmount]	AS RemainingInvoiceAmount
	,DaysPastDue
	,[FiscalYear]
	,[FiscalPeriod]
	,[AgingPeriod]
	,AgingSort
	,[Currency]
	,ExchangeRate
	,0 AS VATAmount
	,[VATCode]
	,'' AS PayToName
	,'' AS PayToCity
	,'' AS PayToContact
	,'' AS PaymentTerms
	,'' AS PrePaymentNum
	,'' AS LastPaymentNum
	,[VATCodeDesc]
	,[LocalAmount]
	,[LocalRemainingAmount]
	,[LinktoOriginalInvoice]
	,'' AS PLRes1
	,'' AS PLRes2
	,'' AS PlRes3
	,'1900-01-01' AS AccountingDate
FROM 
	stage.CER_NO_PurchaseLedger
GROUP BY
	PartitionKey, Company, SupplierNum, CompanySupplier, ExchangeRate, InvoiceNum, SupplierInvoiceNum, [InvoiceDate], DueDate, LastPaymentDate, [Currency], [LocalAmount], [LocalRemainingAmount], [OriginalAmount], [RemainingAmount], [LinktoOriginalInvoice],[FiscalYear], [FiscalPeriod],[AgingPeriod], [VATCode], [VATCodeDesc], DaysPastDue, AgingSort
GO
