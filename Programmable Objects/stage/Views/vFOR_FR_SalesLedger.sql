IF OBJECT_ID('[stage].[vFOR_FR_SalesLedger]') IS NOT NULL
	DROP VIEW [stage].[vFOR_FR_SalesLedger];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [stage].[vFOR_FR_SalesLedger] AS 
--COMMENT EMPTY FIELDS / ADD UPPER()TRIM() INTO CustomerID 2022-12-13 VA
SELECt
	CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT(Company, '#', TRIM(CustomerNum), '#', TRIM(InvoiceNum)))) AS SalesLedgerID
	--CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT(Company, '#', TRIM(CustomerNum), '#', TRIM(InvoiceNum)))) AS SalesLedgerID --SOLine
	,CONCAT(Company, '#', TRIM(CustomerNum), '#', TRIM(InvoiceNum)) AS SalesLedgerCode
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM(Company), '#', TRIM(CustomerNum))))) AS CustomerID
	--,CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT(Company, '#', TRIM(CustomerNum)))) AS CustomerID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', Company)) AS CompanyID
	,PartitionKey

	,Company
	,TRIM(CustomerNum) AS CustomerNum
	,TRIM(InvoiceNum) AS SalesInvoiceNum
	,CONVERT(date, InvoiceDate) AS [SalesInvoiceDate]
	,CONVERT(date, DueDate) AS SalesDueDate
	,CONVERT(date, DueDate) AS SalesLastPaymentDate -- 20210906 /DZ. before CONVERT(date, LastPaymentDate) AS LastPaymentDate, if it is NULL, the in DM stage it gives bias results -- no LatPaymentdate, work around
	--,NULL AS [InvoiceAmount]
	--,NULL AS [RemainingInvoiceAmount]
	,1 AS [ExchangeRate]
	,'EUR' AS [Currency]
	--,NULL AS [VATAmount]
	--,'' AS [VATCode]
	--,'' AS [PayToName]
	--,'' AS [PayToCity]
	--,'' AS [PayToContact]
	--,'' AS [PaymentTerms]
	--,'' AS SLRes1
	--,'' AS SLRes2
	--,'' AS SLRes3
	--,NULL			AS PaidInvoiceAmount
	,'1900-01-01' AS AccountingDate
	--,'' AS AgingPeriod
	--,'' AS AgingSort
	--,'' AS VATCodeDesc
	--,'' AS LinkToOriginalInvoice
FROM 
	stage.FOR_FR_SalesLedger
GO
