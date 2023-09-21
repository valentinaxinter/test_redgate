IF OBJECT_ID('[stage].[vJEN_NO_SalesLedger]') IS NOT NULL
	DROP VIEW [stage].[vJEN_NO_SalesLedger];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE VIEW [stage].[vJEN_NO_SalesLedger] AS
--COMMENT EMPTY FIELDS 2022-12-22 VA
--ADD UPPER()TRIM() INTO SalesLedgerID CUSTOMER_ID / SalesLedgerCode /   23-02-17 VA
SELECT
	CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(Company, '#', TRIM(CustNum), '#', TRIM(InvoiceNum))))) AS SalesLedgerID,
	CONVERT([binary](32), HASHBYTES('SHA2_256', Company)) AS CompanyID,
	CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(trim(Company), '#', TRIM(CustNum))))) AS CustomerID,
	CONCAT(Company,'#', TRIM(CustNum), '#', TRIM(InvoiceNum)) AS SalesLedgerCode,
	PartitionKey,

	Company,
	TRIM(CustNum) AS CustomerNum,
	InvoiceNum AS SalesInvoiceNum,
	InvoiceDate		AS SalesInvoiceDate,
	CONVERT(date, DueDate) AS SalesDueDate,
	CONVERT(date, LastPaymentDate) AS SalesLastPaymentDate,
	--NULL AS InvoiceAmount,
	--NULL AS PaidInvoiceAmount,
	--NULL AS RemainingInvoiceAmount,
	1 AS ExchangeRate,
	'NOK' AS Currency,
	VATPaidInvoiceLCU AS VATAmount,
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
	stage.JEN_NO_SalesLedger
GO
