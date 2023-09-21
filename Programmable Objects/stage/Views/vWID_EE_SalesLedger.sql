IF OBJECT_ID('[stage].[vWID_EE_SalesLedger]') IS NOT NULL
	DROP VIEW [stage].[vWID_EE_SalesLedger];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [stage].[vWID_EE_SalesLedger] AS
--COMMENT EMPTY FIELD // ADD TRIM() UPPEER() INTO CustomerID 2022-12-23 VA
--change salesledgercode / customernum 23-02-17 va
SELECT
	CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT(Company, '#', TRIM(CustNum), '#', TRIM(InvoiceNum)))) AS SalesLedgerID,
	--CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT(Company, '#', TRIM(IIF(CustNum IS NULL OR CustNum = '', 'MISSINGCUSTOMER', CustNum)), '#', TRIM(InvoiceNum)))) AS SalesLedgerID,
	CONVERT([binary](32), HASHBYTES('SHA2_256', Company)) AS CompanyID,
	CONVERT([binary](32), HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM(Company), '#', TRIM(CustNum))))) AS CustomerID,
	--CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT(Company, '#', TRIM(IIF(CustNum IS NULL OR CustNum = '', 'MISSINGCUSTOMER', CustNum))))) AS CustomerID,
	CONCAT(Company, '#', TRIM(CustNum), '#', TRIM(InvoiceNum)) AS SalesLedgerCode,
	PartitionKey,

	TRIM(Company) AS Company,
	TRIM(CustNum) AS CustomerNum,
	TRIM(InvoiceNum) AS SalesInvoiceNum,
	InvoiceDate AS SalesInvoiceDate,
	CONVERT(date, DueDate) AS SalesDueDate,
	CONVERT(date, LastPaymentDate) AS SalesLastPaymentDate,
	InvAmoLocCur AS InvoiceAmount, --local
	--NULL AS PaidInvoiceAmount,
	--NULL AS RemainingInvoiceAmount,
	ExchangeRate AS ExchangeRate,
	Currency AS Currency,
	VATAmount AS VATAmount,
	--'' AS VATCode,
	--'' AS PayToName,
	PayToCity AS PayToCity,
	--'' AS PayToContact,
	PaymentTerms AS PaymentTerms,
	--'' AS SLRes1,
	--'' AS SLRes2,
	--'' AS SLRes3
	'1900-01-01' AS AccountingDate
	--,'' AS AgingPeriod
	--,'' AS AgingSort
	--,'' AS VATCodeDesc
	--,'' AS LinkToOriginalInvoice
FROM 
	stage.WID_EE_SalesLedger
GO
