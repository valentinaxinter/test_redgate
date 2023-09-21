IF OBJECT_ID('[stage].[vCER_EE_SalesLedger]') IS NOT NULL
	DROP VIEW [stage].[vCER_EE_SalesLedger];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [stage].[vCER_EE_SalesLedger] AS
--COMMENT EMPTY FIELDS // ADJUST CustomerID 2022-12-15 VA
SELECT
	CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT(Company, '#', CustNum, '#', InvoiceNum))) AS SalesLedgerID,
	CONVERT([binary](32), HASHBYTES('SHA2_256', Company)) AS CompanyID,
	CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM(Company), '#', TRIM(CustNum))))) AS CustomerID,
	--CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(Company, '#', TRIM(IIF(CustNum IS NULL OR CustNum = '', 'MISSINGCUSTOMER', CustNum) ))))) AS CustomerID,
	CONCAT(Company,'#',CustNum, '#', InvoiceNum) AS SalesLedgerCode,
	PartitionKey,

	UPPER(TRIM(Company)) AS Company,
	UPPER(TRIM(CustNum)) AS CustomerNum,
	TRIM(InvoiceNum) AS SalesInvoiceNum,
	InvoiceDate AS SalesInvoiceDate,
	CONVERT(date, DueDate) AS SalesDueDate,
	CONVERT(date, LastPaymentDate) AS SalesLastPaymentDate,
	InvoiceAmountOC AS InvoiceAmount,
	PaidAmountOC AS PaidInvoiceAmount,
	OpenAmountOC AS RemainingInvoiceAmount,
	ExchangeRate,
	Currency,
	VATAmount,
	VATCode,
	--'' AS PayToName,
	--'' AS PayToCity,
	--'' AS PayToContact,
	--'' AS PaymentTerms,
	--'' AS SLRes1,
	--'' AS SLRes2,
	--'' AS SLRes3
	'1900-01-01' AS AccountingDate
	--,NULL AS AgingPeriod
	--,NULL AS AgingSort
	--,NULL AS VATCodeDesc
	--,NULL AS LinkToOriginalInvoice
FROM 
	stage.CER_EE_SalesLedger
GO
