IF OBJECT_ID('[stage].[vATZ_UK_SalesLedger]') IS NOT NULL
	DROP VIEW [stage].[vATZ_UK_SalesLedger];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [stage].[vATZ_UK_SalesLedger] AS
--COMMENT EMPTY FIELDS // ADD UPPER() TRIM() INTO CustomerID 2022-12-27
--Problem with the group by clause,need to resolve. 2022-12-27 VA
SELECT
	CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT(Company, '#', TRIM(IIF(CustNum IS NULL OR CustNum = '', 'MISSINGCUSTOMER', CustNum) ), '#', TRIM(InvoiceNum)))) AS SalesLedgerID,  --, '#', DueDate, '#', LastPayDate
	CONVERT([binary](32), HASHBYTES('SHA2_256', Company)) AS CompanyID,
	CONVERT([binary](32), HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM(Company), '#', TRIM(IIF(CustNum IS NULL OR CustNum = '', 'MISSINGCUSTOMER', CustNum)))))) AS CustomerID,
	--CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT(Company, '#', TRIM(IIF(CustNum IS NULL OR CustNum = '', 'MISSINGCUSTOMER', CustNum) ) ))) AS CustomerID,
	CONCAT(Company, '#', TRIM(IIF(CustNum IS NULL OR CustNum = '', 'MISSINGCUSTOMER', CustNum) ), '#', TRIM(InvoiceNum)) AS SalesLedgerCode,
	PartitionKey,

	TRIM(Company) AS Company,
	TRIM(IIF(CustNum IS NULL OR CustNum = '', 'MISSINGCUSTOMER', CustNum) ) AS CustomerNum,
	TRIM(InvoiceNum) AS SalesInvoiceNum,  -- various blank spaces after InvoiceNum, it affects query results! data-Input quality should be improved!
	MIN(InvoiceDate) AS SalesInvoiceDate,
	CONVERT(date, MIN(DueDate)) AS SalesDueDate,
	CONVERT(date, MAX(LastPayDate)) AS SalesLastPaymentDate,
	NULL AS InvoiceAmount,
	NULL AS PaidInvoiceAmount,
	NULL AS RemainingInvoiceAmount,
	1 AS ExchangeRate,
	'EUR' AS Currency,
	NULL AS VATAmount,
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
	stage.ATZ_UK_SalesLedger
GROUP BY
	PartitionKey, Company, TRIM(IIF(CustNum IS NULL OR CustNum = '', 'MISSINGCUSTOMER', CustNum) ), TRIM(InvoiceNum)--, DueDate, LastPayDate
GO
