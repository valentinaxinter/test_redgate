IF OBJECT_ID('[stage].[vFOR_PL_SalesLedger]') IS NOT NULL
	DROP VIEW [stage].[vFOR_PL_SalesLedger];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [stage].[vFOR_PL_SalesLedger] AS 
--ADD UPPER() TRIM() INTO CustomerID 23-01-11 VA
SELECT
	CONVERT([binary](32),HASHBYTES('SHA2_256',CONCAT(Company,'#', TRIM(SalesInvoiceNum),'#', TRIM(CAST(ObjType AS VARCHAR(10)))))) AS SalesLedgerID,
	CONVERT([binary](32),HASHBYTES('SHA2_256',Company)) AS CompanyID,
	--CONVERT([binary](32),HASHBYTES('SHA2_256',CONCAT(Company,'#',TRIM(CustomerNum)))) AS CustomerID,
	CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM(Company),'#',TRIM(CustomerNum))))) AS CustomerID,
	CONCAT(Company,'#', TRIM(SalesInvoiceNum)) AS SalesLedgerCode,
	PartitionKey,
	Company,
	CustomerNum,
	SalesInvoiceNum,
	SalesInvoiceDate,
	SalesDueDate,
	SalesLastPaymentDate,
	InvoiceAmount,
	RemainingInvoiceAmount,
	ExchangeRate,
	Currency,
	VATAmount,
	VATCode,
	PaymentTerms,
	--ObjType AS SLRes1, -- I will use this field to map ObjType
	case when ObjType = '13'  THEN  'FA'
	     when ObjType = '14'  THEN  'AF'
	     when ObjType = '165' THEN 'FK'
	     when ObjType = '166' THEN 'SK'
	ELSE NULL end as SLRes1,
	InvoiceAmount - RemainingInvoiceAmount	AS PaidInvoiceAmount,
	'1900-01-01' AS AccountingDate,
	SalesPersonName
FROM 
	stage.FOR_PL_SalesLedger
--GROUP BY [PartitionKey],[Company],CustomerNum,SalesInvoiceNum,[DueDate],[LastPaymentDate]
GO
