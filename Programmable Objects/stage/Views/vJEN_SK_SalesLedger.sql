IF OBJECT_ID('[stage].[vJEN_SK_SalesLedger]') IS NOT NULL
	DROP VIEW [stage].[vJEN_SK_SalesLedger];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [stage].[vJEN_SK_SalesLedger] AS
--COMMENT empty fields // ADD UPPER() TRIM() INTO CustomerID 2023-12-14 VA
SELECT
	CONVERT([binary](32),HASHBYTES('SHA2_256',CONCAT(Company,'#', TRIM(IIF(CustNum IS NULL OR CustNum = '', 'MISSINGCUSTOMER', CustNum) ), '#', InvoiceNum))) AS SalesLedgerID,
	CONVERT([binary](32),HASHBYTES('SHA2_256', Company)) AS CompanyID,
	--CONVERT([binary](32),HASHBYTES('SHA2_256',CONCAT(Company,'#',TRIM(IIF(CustNum IS NULL OR CustNum = '', 'MISSINGCUSTOMER', CustNum) )))) AS CustomerID,
	CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM(Company),'#',TRIM(CustNum))))) AS CustomerID,
	CONCAT(Company,'#', TRIM(IIF(CustNum IS NULL OR CustNum = '', 'MISSINGCUSTOMER', CustNum) ), '#', InvoiceNum) AS SalesLedgerCode,
	PartitionKey,

	Company,
	TRIM(IIF(CustNum IS NULL OR CustNum = '', 'MISSINGCUSTOMER', CustNum) ) AS CustomerNum,
	InvoiceNum AS SalesInvoiceNum,
	InvoiceDate	AS SalesInvoiceDate,
	CONVERT(date, DueDate) AS SalesDueDate,
	CONVERT(date, LastPaymentDate) AS SalesLastPaymentDate,
	--NULL AS InvoiceAmount,
	--NULL AS PaidInvoiceAmount,
	--NULL AS RemainingInvoiceAmount,
	1 AS ExchangeRate,
	'SEK' AS Currency,
	--NULL AS VATAmount,
	--'' AS VATCode,
	--'' AS PayToName,
	--'' AS PayToCity,
	--'' AS PayToContact,
	--'' AS PaymentTerms,
	--'' AS SLRes1,
	--'' AS SLRes2,
	--'' AS SLRes3
	'1900-01-01' AS AccountingDate
	--,'' AS AgingPeriod
	--,'' AS AgingSort
	--,'' AS VATCodeDesc
	--,'' AS LinkToOriginalInvoice
FROM 
	stage.JEN_SK_SalesLedger
GO
