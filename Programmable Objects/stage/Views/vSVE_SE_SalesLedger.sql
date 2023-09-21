IF OBJECT_ID('[stage].[vSVE_SE_SalesLedger]') IS NOT NULL
	DROP VIEW [stage].[vSVE_SE_SalesLedger];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [stage].[vSVE_SE_SalesLedger] AS

SELECT
	CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT(Company, '#', TRIM(SalesInvoiceNum)))) AS SalesLedgerID --, '#', TRIM(CustomerNum)
	,CONVERT([binary](32), HASHBYTES('SHA2_256', Company)) AS CompanyID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT(Company, '#', TRIM(IIF(CustomerNum IS NULL OR CustomerNum = '', 'MISSINGCUSTOMER', CustomerNum))))) AS CustomerID
	,CONCAT(Company, '#', TRIM(CustomerNum), '#', TRIM(SalesInvoiceNum)) AS SalesLedgerCode
	,PartitionKey

	,TRIM(Company) AS Company
	,TRIM(IIF(CustomerNum IS NULL OR CustomerNum = '', 'MISSINGCUSTOMER', CustomerNum)) AS CustomerNum
	,TRIM(SalesInvoiceNum) AS SalesInvoiceNum
	,TRY_CONVERT(date, SalesInvoiceDate) AS SalesInvoiceDate
	,IIF(LEFT(TRIM(SalesInvoiceNum), 1) = 'Q', TRY_CONVERT(date, SalesInvoiceDate), TRY_CONVERT(date, DueDate)) AS SalesDueDate
	,IIF(LEFT(TRIM(SalesInvoiceNum), 1) = 'Q', TRY_CONVERT(date, SalesInvoiceDate), TRY_CONVERT(date, LastPaymentDate)) AS SalesLastPaymentDate
	,InvoiceAmount
	,RemainingInvoiceAmount
	,NULL AS PaidInvoiceAmount
	,ExchangeRate
	,Currency
	,VATAmount
	,VATCode
	,PayToName
	,PayToCity
	,PayToContact
	,PaymentTerms
	,'' AS SLRes1
	,'' AS SLRes2
	,'' AS SLRes3
	,'1900-01-01' AS AccountingDate
	,'' AS AgingPeriod
	,'' AS AgingSort
	,'' AS VATCodeDesc
	,'' AS LinkToOriginalInvoice
FROM 
	stage.SVE_SE_SalesLedger
GO
