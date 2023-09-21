IF OBJECT_ID('[stage].[vCER_NO_SalesLedger]') IS NOT NULL
	DROP VIEW [stage].[vCER_NO_SalesLedger];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [stage].[vCER_NO_SalesLedger] AS
--change ledger id  23-02-27 VA
SELECT
	CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT(Company, '#', CustNum, '#', InvoiceNum))) AS SalesLedgerID,
	CONVERT([binary](32), HASHBYTES('SHA2_256', Company)) AS CompanyID,
	CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(Company, '#', TRIM(CustNum))))) AS CustomerID,
	--CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(Company, '#', TRIM(IIF(CustNum IS NULL OR CustNum = '', 'MISSINGCUSTOMER', CustNum) ))))) AS CustomerID,
	CONCAT(Company,'#',CustNum, '#', InvoiceNum) AS SalesLedgerCode,
	PartitionKey,

	UPPER(TRIM(Company)) AS Company,
	UPPER(TRIM(CustNum)) AS CustomerNum,
	TRIM(InvoiceNum) AS SalesInvoiceNum,
	InvoiceDate AS SalesInvoiceDate,
	CONVERT(date, DueDate) AS SalesDueDate,
	CONVERT(date, LastPaymentDate) AS SalesLastPaymentDate,
	OriginalAmount AS InvoiceAmount,
	OriginalAmount - RemainingAmount AS PaidInvoiceAmount,
	RemainingAmount AS RemainingInvoiceAmount,
	ExchangeRate,
	Currency,
	NULL AS VATAmount,
	VATCode,
	--'' AS PayToName,
	--'' AS PayToCity,
	--'' AS PayToContact,
	--'' AS PaymentTerms,
	--'' AS SLRes1,
	--'' AS SLRes2,
	--'' AS SLRes3
	'1900-01-01' AS AccountingDate
	,AgingPeriod
	,AgingSort
	,VATCodeDesc
	--,'' AS LinkToOriginalInvoice
FROM 
	stage.CER_NO_SalesLedger
GO
