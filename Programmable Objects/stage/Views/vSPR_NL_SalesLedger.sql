IF OBJECT_ID('[stage].[vSPR_NL_SalesLedger]') IS NOT NULL
	DROP VIEW [stage].[vSPR_NL_SalesLedger];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE VIEW [stage].[vSPR_NL_SalesLedger] AS

SELECT
	CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT(Company, '#', TRIM(CustomerNum), '#', TRIM(SalesInvoiceNum)))) AS SalesLedgerID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', Company)) AS CompanyID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT(Company, '#', TRIM(CustomerNum)))) AS CustomerID
	,CONCAT(Company, '#', TRIM(CustomerNum), '#', TRIM(SalesInvoiceNum)) AS SalesLedgerCode
	,PartitionKey

	,Company
	,TRIM(CustomerNum) AS CustomerNum
	,TRIM(SalesInvoiceNum) AS SalesInvoiceNum
	,CONCAT('20', SUBSTRING([SalesInvoiceDate], 7,2), '-', SUBSTRING([SalesInvoiceDate], 4,2), '-', SUBSTRING([SalesInvoiceDate], 1,2)) AS SalesInvoiceDate
	,CONCAT('20', SUBSTRING(SalesDueDate, 7,2), '-', SUBSTRING(SalesDueDate, 4,2), '-', SUBSTRING(SalesDueDate, 1,2)) AS SalesDueDate
	,MAX(CONCAT('20', SUBSTRING(SalesLastPaymentDate, 7,2), '-', SUBSTRING(SalesLastPaymentDate, 4,2), '-', SUBSTRING(SalesLastPaymentDate, 1,2))) AS SalesLastPaymentDate
	,IIF(InvoiceAmount = 'na', NULL, TRY_CONVERT(decimal(18,4), InvoiceAmount)) AS InvoiceAmount
	,IIF(PaidInvoiceAmount = 'na', NULL, TRY_CONVERT(decimal(18,4), PaidInvoiceAmount)) AS PaidInvoiceAmount
	,IIF(RemainingInvoiceAmount = 'na', NULL, TRY_CONVERT(decimal(18,4), RemainingInvoiceAmount)) AS RemainingInvoiceAmount
	,1 AS ExchangeRate
	,'EUR' AS Currency
	,IIF(VATAmount = 'na', NULL, TRY_CONVERT(decimal(18,4), VATAmount)) AS VATAmount
	,VATCode
	,PayToName
	,PayToCity
	,PayToContact
	,PaymentTerms
	,SLRes1
	,SLRes2
	,SLRes3
	,TRY_CONVERT(date, '1900-01-01') AS AccountingDate
	,'' AS AgingPeriod
	,'' AS VATCodeDesc
	,'' AS LinkToOriginalInvoice
	,'' AS AgingSort
FROM 
	stage.SPR_NL_SalesLedger
GROUP BY

	PartitionKey, Company, CustomerNum, SalesInvoiceNum, SalesInvoiceDate, [SalesDueDate], InvoiceAmount, PaidInvoiceAmount, RemainingInvoiceAmount, VATAmount, VATCode, PayToName, PayToCity, PayToContact, PaymentTerms, SLRes1, SLRes2, SLRes3
GO
