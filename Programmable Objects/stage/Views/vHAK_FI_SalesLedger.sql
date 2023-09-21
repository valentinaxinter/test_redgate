IF OBJECT_ID('[stage].[vHAK_FI_SalesLedger]') IS NOT NULL
	DROP VIEW [stage].[vHAK_FI_SalesLedger];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE VIEW [stage].[vHAK_FI_SalesLedger] AS
--COMMENT EMPTY FIELDS 2022-12-21 VA
SELECT
	CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(Company, '#', TRIM(CustNum), '#', TRIM(InvoiceNum))))) AS SalesLedgerID,
	CONVERT([binary](32), HASHBYTES('SHA2_256', Company)) AS CompanyID,
	CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(Company, '#', TRIM(CustNum))))) AS CustomerID,
	UPPER(CONCAT(Company, '#', TRIM(CustNum), '#', TRIM(InvoiceNum))) AS SalesLedgerCode,
	PartitionKey,

	TRIM(Company) AS Company,
	UPPER(TRIM(CustNum)) AS CustomerNum,
	UPPER(TRIM(InvoiceNum)) AS SalesInvoiceNum,
	InvoiceDate AS SalesInvoiceDate,
	CONVERT(date, Min(DueDate)) AS SalesDueDate,
	CONVERT(date, MAX(LastPaymentDate)) AS SalesLastPaymentDate,
	--0 AS InvoiceAmount,
	--NULL AS PaidInvoiceAmount,
	--0 AS RemainingInvoiceAmount,
	1 AS ExchangeRate,
	'EUR' AS Currency,
	--0 AS VATAmount,
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
	stage.HAk_FI_SalesLedger
GROUP BY
	PartitionKey, Company, CustNum, InvoiceDate, InvoiceNum
GO
