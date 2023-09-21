IF OBJECT_ID('[stage].[vJEN_NB_SalesLedger]') IS NOT NULL
	DROP VIEW [stage].[vJEN_NB_SalesLedger];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [stage].[vJEN_NB_SalesLedger] AS
--COMMENT EMPTY FIELDS // ADD TRIM() INTO CustomerID 23-01-03 VA
SELECT
	CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(Company,'#', TRIM(IIF(CustNum IS NULL OR CustNum = '', 'MISSINGCUSTOMER', CustNum) ), '#', InvoiceNum)))) AS SalesLedgerID,
	--CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(Company, '#', TRIM(IIF(CustNum IS NULL OR CustNum = '', 'MISSINGCUSTOMER', CustNum) ), '#', InvoiceNum)))) AS SalesLedgerID
	CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(Company))) AS CompanyID,
	CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM(Company), '#', TRIM(CustNum))))) AS CustomerID,
	--CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(Company, '#', TRIM(IIF(CustNum IS NULL OR CustNum = '', 'MISSINGCUSTOMER', CustNum) ))))) AS CustomerID,
	CONCAT(Company,'#', TRIM(IIF(CustNum IS NULL OR CustNum = '', 'MISSINGCUSTOMER', CustNum) ), '#', InvoiceNum) AS SalesLedgerCode,
	PartitionKey,

	UPPER(Company) AS Company,
	UPPER(TRIM(IIF(CustNum IS NULL OR CustNum = '', 'MISSINGCUSTOMER', CustNum) )) AS CustomerNum,
	TRIM(InvoiceNum) AS SalesInvoiceNum,
	CONVERT(date, InvoiceDate) AS SalesInvoiceDate,
	CONVERT(date, DueDate) AS SalesDueDate,
	CONVERT(date, LastPaymentDate) AS SalesLastPaymentDate,
	--NULL AS InvoiceAmount,
	--NULL AS PaidInvoiceAmount,
	--NULL AS RemainingInvoiceAmount,
	1 AS ExchangeRate,
	'NOK' AS Currency
	--NULL AS VATAmount,
	--'' AS VATCode,
	--'' AS PayToName,
	--'' AS PayToCity,
	--'' AS PayToContact,
	--'' AS PaymentTerms,
	--'' AS SLRes1,
	--'' AS SLRes2,
	--'' AS SLRes3
	--,'' AS AccountingDate
	--,'' AS AgingPeriod
	--,'' AS AgingSort
	--,'' AS VATCodeDesc
	--,'' AS LinkToOriginalInvoice
FROM 
	stage.JEN_NB_SalesLedger
GO
