IF OBJECT_ID('[stage].[vCER_DK_SalesLedger]') IS NOT NULL
	DROP VIEW [stage].[vCER_DK_SalesLedger];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [stage].[vCER_DK_SalesLedger] AS
--COMMENT EMPTY FIELDS / ADJUST CustomerID and Groupby 2022-12-14
SELECT
	CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(Company, '#', TRIM(IIF(CustNum IS NULL OR CustNum = '', 'MISSINGCUSTOMER', CustNum) ), '#', TRIM(InvoiceNum))))) AS SalesLedgerID 
	,UPPER(CONCAT(Company, '#', TRIM(IIF(CustNum IS NULL OR CustNum = '', 'MISSINGCUSTOMER', CustNum) ), '#', TRIM(InvoiceNum))) AS SalesLedgerCode    
	,CONVERT([binary](32), HASHBYTES('SHA2_256', Company)) AS CompanyID
	--,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM(Company), '#', TRIM(IIF(CustNum IS NULL OR CustNum = '', 'MISSINGCUSTOMER', CustNum) ))))) AS CustomerID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM(Company), '#', TRIM(CustNum))))) AS CustomerID
	,PartitionKey

	,UPPER(Company) AS Company
	,UPPER(TRIM(CustNum)) AS CustomerNum
	--,UPPER(TRIM(IIF(CustNum IS NULL OR CustNum = '', 'MISSINGCUSTOMER', CustNum) )) AS CustomerNum
	,UPPER(TRIM(InvoiceNum)) AS SalesInvoiceNum
	,MAX(CONVERT(date, InvoiceDate)) AS SalesInvoiceDate
	,MAX(CONVERT(date, DueDate)) AS SalesDueDate
	,MAX(CONVERT(date, LastPaymentDate)) AS SalesLastPaymentDate --IIF(MAX(CONVERT(date, LastPaymentDate)) = '1753-01-01', '1900-01-01', 
	--,NULL AS [InvoiceAmount]
	--,NULL AS PaidInvoiceAmount
	--,NULL AS [RemainingInvoiceAmount]
	,1 AS [ExchangeRate]
	,'DKK' AS [Currency]
	--,NULL AS [VATAmount]
	--,'' AS [VATCode]
	--,'' AS [PayToName]
	--,'' AS [PayToCity]
	--,'' AS [PayToContact]
	--,'' AS [PaymentTerms]
	--,'' AS SLRes1
	--,'' AS SLRes2
	--,'' AS SLRes3
	,'1900-01-01' AS AccountingDate
	--,'' AS AgingPeriod
	--,'' AS AgingSort
	--,'' AS VATCodeDesc
	--,'' AS LinkToOriginalInvoice
FROM
	stage.CER_DK_SalesLedger
GROUP BY
	PartitionKey, Company, CustNum, InvoiceNum--, InvoiceDate, LastPaymentDate --, DueDate
GO
