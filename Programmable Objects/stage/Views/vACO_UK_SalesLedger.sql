IF OBJECT_ID('[stage].[vACO_UK_SalesLedger]') IS NOT NULL
	DROP VIEW [stage].[vACO_UK_SalesLedger];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [stage].[vACO_UK_SalesLedger] AS
--COMMENT empty fields / ADD UPPER() TRIM() INTO CustomerID  VA 13-12-2022
SELECT
	CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT(Company, '#', TRIM(CustNum), '#', TRIM(InvoiceNum) ))) AS SalesLedgerID,  --, '#', DueDate, '#', LastPayDate
	CONVERT([binary](32), HASHBYTES('SHA2_256', Company)) AS CompanyID,
	CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM(Company),'#',TRIM(CustNum))))) AS CustomerID,
	CONCAT(Company, '#', TRIM(CustNum), '#', TRIM(InvoiceNum) ) AS SalesLedgerCode,
	PartitionKey,

	Company,
	TRIM(CustNum) AS CustomerNum,
	TRIM(InvoiceNum) AS SalesInvoiceNum,  -- various blank spaces after InvoiceNum, it affects query results! data-Input quality should be improved!
	InvoiceDate	AS SalesInvoiceDate,
	CONVERT(date, MIN(DueDate)) AS SalesDueDate,
	CONVERT(date, MAX(LastPaymentDate)) AS SalesLastPaymentDate,
	--NULL AS InvoiceAmount,
	--NULL AS RemainingInvoiceAmount,
	1 AS ExchangeRate,
	'GBP' AS Currency,
	--NULL AS VATAmount,
	--'' AS VATCode,
	--'' AS PayToName,
	--'' AS PayToCity,
	--'' AS PayToContact,
	--'' AS PaymentTerms,
	--'' AS SLRes1,
	--'' AS SLRes2,
	--'' AS SLRes3
	--NULL AS PaidInvoiceAmount,
	'1900-01-01' AS AccountingDate
	--NULL AS AgingPeriod,
	--NULL AS AgingSort,
	--NULL AS VATCodeDesc,
	--NULL AS LinkToOriginalInvoice
FROM 
	stage.ACO_UK_SalesLedger
GROUP BY
	PartitionKey, Company, TRIM(CustNum), TRIM(InvoiceNum), InvoiceDate
GO
