IF OBJECT_ID('[stage].[vWID_FI_SalesLedger]') IS NOT NULL
	DROP VIEW [stage].[vWID_FI_SalesLedger];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [stage].[vWID_FI_SalesLedger] AS
--COMMENT EMPTY FIELDS // ADD TRIM() UPPER() INTO CustomerID 2022-12-15 VA
--salesledgerid / CUSTNUM 23-02-17 VA
SELECT
	CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT(Company, '#', TRIM(CustNum), '#', TRIM(InvoiceNum)))) AS SalesLedgerID,
	CONVERT([binary](32), HASHBYTES('SHA2_256', Company)) AS CompanyID,
	CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM(Company), '#', TRIM(CustNum))))) AS CustomerID,
	--CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT(Company, '#', TRIM(IIF(CustNum IS NULL OR CustNum = '', 'MISSINGCUSTOMER', CustNum))))) AS CustomerID,
	CONCAT(Company, '#', TRIM(CustNum), '#', TRIM(InvoiceNum)) AS SalesLedgerCode,
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
	--,NULL AS AgingPeriod
	--,NULL AS AgingSort
	--,NULL AS VATCodeDesc
	--,NULL AS LinkToOriginalInvoice
FROM 
	stage.WID_FI_SalesLedger
GO
