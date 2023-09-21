IF OBJECT_ID('[stage].[vSCM_FI_SalesLedger]') IS NOT NULL
	DROP VIEW [stage].[vSCM_FI_SalesLedger];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [stage].[vSCM_FI_SalesLedger] AS
--COMMENT EMPTY FIELD // ADD UPPER() TRIM() 20221-12-21 VA
SELECT
	CONVERT([binary](32),HASHBYTES('SHA2_256',CONCAT(Company, '#', TRIM(IIF(CustNum = '' OR CustNum IS NULL, 'MISSINGCUSTOMER', CustNum)), '#', InvoiceNum))) AS SalesLedgerID,
	CONVERT([binary](32),HASHBYTES('SHA2_256',Company)) AS CompanyID,
	CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM(Company),'#',TRIM(CustNum))))) AS CustomerID,
	--CONVERT([binary](32),HASHBYTES('SHA2_256',CONCAT(Company,'#',TRIM(IIF(CustNum = '' OR CustNum IS NULL, 'MISSINGCUSTOMER', CustNum))))) AS CustomerID,
	CONCAT(Company,'#',TRIM(IIF(CustNum = '' OR CustNum IS NULL, 'MISSINGCUSTOMER', CustNum)), '#', InvoiceNum) AS SalesLedgerCode,
	PartitionKey,

	TRIM(Company) AS Company,
	TRIM(CustNum) AS CustomerNum,
	TRIM(InvoiceNum) AS SalesInvoiceNum,
	InvoiceDate AS SalesInvoiceDate,
	CONVERT(date, DueDate) AS SalesDueDate,
	CONVERT(date, LastPaymentDate) AS SalesLastPaymentDate,
	--NULL AS InvoiceAmount,
	--NULL AS PaidInvoiceAmount,
	--NULL AS RemainingInvoiceAmount,
	1 AS ExchangeRate,
	'EUR' AS Currency,
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
	stage.SCM_FI_SalesLedger
GO
