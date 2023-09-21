IF OBJECT_ID('[stage].[vNOM_SEIND_SalesLedger]') IS NOT NULL
	DROP VIEW [stage].[vNOM_SEIND_SalesLedger];

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE VIEW [stage].[vNOM_SEIND_SalesLedger] AS
--COMMENT EMPTY FIELD 2022-12-19 VA
SELECT
	CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM(Company), '#', TRIM(CustNum), '#', TRIM(InvoiceNum))))) AS SalesLedgerID,
	CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(TRIM(Company)))) AS CompanyID,
	CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM(Company),'#',TRIM(CustNum))))) AS CustomerID,
	UPPER(CONCAT(TRIM(Company), '#', TRIM(CustNum), '#', TRIM(InvoiceNum))) AS SalesLedgerCode,
	PartitionKey,

	UPPER(TRIM(Company)) AS Company,
	UPPER(TRIM(CustNum)) as CustomerNum,
	UPPER(TRIM(InvoiceNum)) as SalesInvoiceNum,
	CONVERT(DATE, InvoiceDate) AS SalesInvoiceDate,
	CONVERT(date, DueDate) AS SalesDueDate,
	CONVERT(date, LastPaymentDate) AS SalesLastPaymentDate,
	'1900-01-01' AS AccountingDate
	--0 AS InvoiceAmount,
	--0 AS RemainingInvoiceAmount,
	--0 AS ExchangeRate,
	--'' AS Currency,
	--0 AS VATAmount,
	--'' AS VATCode,
	--'' AS PayToName,
	--'' AS PayToCity,
	--'' AS PayToContact,
	--'' AS PaymentTerms,
	--'' AS SLRes1,
	--'' AS SLRes2,
	--'' AS SLRes3
	--,NULL	AS PaidInvoiceAmount
	--,NULL AS AgingPeriod
	--,NULL AS AgingSort
	--,NULL AS VATCodeDesc
	--,NULL AS LinkToOriginalInvoice
FROM 
	stage.NOM_SEIND_SalesLedger
GO
