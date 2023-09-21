IF OBJECT_ID('[stage].[vCER_SE_SalesLedger]') IS NOT NULL
	DROP VIEW [stage].[vCER_SE_SalesLedger];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




CREATE VIEW [stage].[vCER_SE_SalesLedger] AS
--ADD TRIM() INTO SalesLedgerID 27-02-2023 VA
SELECT
	CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(Company, '#', TRIM(CustNum), '#', TRIM(InvoiceNum))))) AS SalesLedgerID,
--	CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(Company, '#', IIF(CustNum IS NULL OR CustNum = '', 'MISSINGCUSTOMER', CustNum), '#', InvoiceNum)))) AS SalesLedgerID,
	CONVERT([binary](32), HASHBYTES('SHA2_256', TRIM(Company))) AS CompanyID,
	CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(Company, '#', TRIM(CustNum))))) AS CustomerID,
	--CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(Company, '#', TRIM(IIF(CustNum IS NULL OR CustNum = '', 'MISSINGCUSTOMER', CustNum)))))) AS CustomerID,
	UPPER(CONCAT(Company,'#',CustNum, '#', InvoiceNum)) AS SalesLedgerCode, --Redundant?
	PartitionKey,

	UPPER(TRIM(Company)) AS Company,
	UPPER(TRIM(CustNum)) AS CustomerNum,
	--UPPER(TRIM(IIF(CustNum IS NULL OR CustNum = '', 'MISSINGCUSTOMER', CustNum) )) AS CustomerNum,
	UPPER(TRIM(InvoiceNum)) AS SalesInvoiceNum,
	InvoiceDate AS SalesInvoiceDate,
	CONVERT(date, DueDate) AS SalesDueDate,
	CONVERT(date, LastPaymentDate) AS SalesLastPaymentDate,
	InvoiceAmountOC AS InvoiceAmount,
	OpenAmountOC AS RemainingInvoiceAmount,
	ExchangeRate,
	Currency,
	VATAmount,
	VATCode,
	--'' AS PayToName,
	--'' AS PayToCity,
	--'' AS PayToContact,
	--'' AS PaymentTerms,
	--'' AS SLRes1,
	--'' AS SLRes2,
	--'' AS SLRes3
	PaidAmountLC AS PaidInvoiceAmount
	,'1900-01-01' AS AccountingDate
	--,'' AS AgingPeriod
	--,'' AS AgingSort
	--,'' AS VATCodeDesc
	--,'' AS LinkToOriginalInvoice
FROM 
	stage.CER_SE_SalesLedger
GO
