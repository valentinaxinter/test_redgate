IF OBJECT_ID('[stage].[vMAK_NL_SalesLedger]') IS NOT NULL
	DROP VIEW [stage].[vMAK_NL_SalesLedger];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [stage].[vMAK_NL_SalesLedger] AS
--COMMENT empty fields / ADD UPPER() TRIM() INTO CustomerID 13-12-2022 VA
SELECT
	CONVERT([binary](32),HASHBYTES('SHA2_256',CONCAT(Company, '#', TRIM(SalesInvoiceNum)))) AS SalesLedgerID,
	CONVERT([binary](32),HASHBYTES('SHA2_256', Company)) AS CompanyID,
	CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM(Company),'#',TRIM(CustomerNum))))) AS CustomerID,
	--CONVERT([binary](32),HASHBYTES('SHA2_256',CONCAT(Company,'#',TRIM(CustomerNum)))) AS CustomerID,
	CONCAT(Company,'#', SalesInvoiceNum) AS SalesLedgerCode,
	PartitionKey,

	Company,
	TRIM(CustomerNum) AS CustomerNum,
	TRIM(SalesInvoiceNum) AS SalesInvoiceNum,
	SalesInvoiceDate		AS SalesInvoiceDate,
	CONVERT(date, DueDate) AS SalesDueDate,
	CONVERT(date, LastPaymentDate) AS SalesLastPaymentDate,
	--0 AS InvoiceAmount,
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
	--,NULL			AS PaidInvoiceAmount
	'1900-01-01' AS AccountingDate
	--,NULL AS AgingPeriod
	--,NULL AS AgingSort
	--,NULL AS VATCodeDesc
	--,NULL AS LinkToOriginalInvoice

FROM 
	stage.MAK_NL_SalesLedger
	GROUP BY  PartitionKey, SalesInvoiceNum, CustomerNum, Company, SalesInvoiceDate, DueDate, LastPaymentDate
GO
