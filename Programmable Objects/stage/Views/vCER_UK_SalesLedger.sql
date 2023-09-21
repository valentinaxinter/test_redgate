IF OBJECT_ID('[stage].[vCER_UK_SalesLedger]') IS NOT NULL
	DROP VIEW [stage].[vCER_UK_SalesLedger];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [stage].[vCER_UK_SalesLedger] AS
--COMMENT EMPTY FIELD // ADD UPPER() TRIM() INTO CustomerID 2022-12-19 VA
SELECT
	CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT(Company, '#', CustNum, '#', InvoiceNum))) AS SalesLedgerID
	,CONCAT(Company, '#', CustNum, '#', InvoiceNum) AS SalesLedgerCode
	--,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(Company, '#', TRIM(IIF(CustNum IS NULL OR CustNum = '', 'MISSINGCUSTOMER', CustNum) ))))) AS CustomerID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM(Company), '#', TRIM(CustNum))))) AS CustomerID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', Company)) AS CompanyID
	,PartitionKey

	,UPPER(TRIM(Company)) AS Company
	,UPPER(TRIM(CustNum)) AS CustomerNum
	,InvoiceNum AS [SalesInvoiceNum]
	,[InvoiceDate] AS [SalesInvoiceDate]
	,CONVERT(date, DueDate) AS SalesDueDate
	,CONVERT(date, LastPaymentDate) AS SalesLastPaymentDate
	--,NULL AS [InvoiceAmount]
	--,NULL AS [RemainingInvoiceAmount]
	,1 AS [ExchangeRate]
	,'GBP' AS [Currency]
	--,NULL AS [VATAmount]
	--,'' AS [VATCode]
	--,'' AS [PayToName]
	--,'' AS [PayToCity]
	--,'' AS [PayToContact]
	--,'' AS [PaymentTerms]
	--,'' AS SLRes1
	--,'' AS SLRes2
	--,'' AS SLRes3
	--,NULL AS PaidInvoiceAmount
	,'1900-01-01' AS AccountingDate
	--,'' AS AgingPeriod
	--,'' AS AgingSort
	--,'' AS VATCodeDesc
	--,'' AS LinkToOriginalInvoice

FROM 
	stage.CER_UK_SalesLedger
GO
