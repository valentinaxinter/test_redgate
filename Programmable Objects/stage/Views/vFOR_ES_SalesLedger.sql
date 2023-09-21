IF OBJECT_ID('[stage].[vFOR_ES_SalesLedger]') IS NOT NULL
	DROP VIEW [stage].[vFOR_ES_SalesLedger];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE view [stage].[vFOR_ES_SalesLedger] AS 
--COMMENT EMPTY FIELDS 2022-12-21 VA
SELECt
	CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM(Company),'#',TRIM(CustomerNum), '#', TRIM(SalesInvoiceNum))))) AS SalesLedgerID,
	CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(TRIM(Company)))) AS CompanyID,
	CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM(Company),'#',TRIM(CustomerNum))))) AS CustomerID,
	UPPER(CONCAT(TRIM(Company),'#',TRIM(CustomerNum), '#', TRIM(SalesInvoiceNum))) AS SalesLedgerCode,
	PartitionKey,

	Company,
	CustomerNum,
	SalesInvoiceNum as SalesInvoiceNum,
	SalesInvoiceDate,
	CONVERT(date, DueDate) AS SalesDueDate,
	--'' AS SalesLastPaymentDate,
	InvoiceAmount,
	--0 AS RemainingInvoiceAmount,
	ExchangeRate,
	Currency,
	VATAmount,
	VATCode,
	--'' AS PayToName,
	--'' AS PayToCity,
	--'' AS PayToContact,
	PaymentTerms,
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
	stage.FOR_ES_SalesLedger
--GROUP BY [PartitionKey],[Company],CustomerNum,SalesInvoiceNum,[DueDate],[LastPaymentDate]
GO
