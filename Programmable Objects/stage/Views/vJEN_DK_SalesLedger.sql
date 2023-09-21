IF OBJECT_ID('[stage].[vJEN_DK_SalesLedger]') IS NOT NULL
	DROP VIEW [stage].[vJEN_DK_SalesLedger];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [stage].[vJEN_DK_SalesLedger] AS
--COMMENT EMPTY FIELDS // ADD TRIM() INTO CustomerID 22-12-29 VA
SELECT
	CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(Company, '#', TRIM(IIF(CustNum IS NULL OR CustNum = '', 'MISSINGCUSTOMER', CustNum) ), '#', TRIM(InvoiceNum))))) AS SalesLedgerID,
	CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(Company))) AS CompanyID,
	UPPER(CONCAT(Company, '#', TRIM(IIF(CustNum IS NULL OR CustNum = '', 'MISSINGCUSTOMER', CustNum) ), '#', InvoiceNum)) AS SalesLedgerCode,
	CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM(Company), '#', TRIM(CustNum))))) AS CustomerID,
	--CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(Company, '#', TRIM(IIF(CustNum IS NULL OR CustNum = '', 'MISSINGCUSTOMER', CustNum) ))))) AS CustomerID,
	PartitionKey,

	UPPER(Company) AS Company,
	TRIM(IIF(CustNum IS NULL OR CustNum = '', 'MISSINGCUSTOMER', CustNum) ) AS CustomerNum,
	TRIM(InvoiceNum) AS SalesInvoiceNum,
	InvoiceDate		AS SalesInvoiceDate,
	CONVERT(date, DueDate) AS SalesDueDate,
	CONVERT(date, LastPaymentDate) AS SalesLastPaymentDate,
	--NULL AS InvoiceAmount,
	--NULL AS RemainingInvoiceAmount,
	--NULL AS PaidInvoiceAmount,
	1 AS ExchangeRate,
	'DKK' AS Currency,
	VATPaidInvoiceLCU AS VATAmount,  --request by CE & Sam 2023-03-28
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
	stage.JEN_DK_SalesLedger
GO
