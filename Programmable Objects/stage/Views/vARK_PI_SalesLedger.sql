IF OBJECT_ID('[stage].[vARK_PI_SalesLedger]') IS NOT NULL
	DROP VIEW [stage].[vARK_PI_SalesLedger];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [stage].[vARK_PI_SalesLedger] AS
--COMMENT EMPTY FIELDS // ADD UPPER()TRIM() INTO CustomerID
SELECT
	CONVERT([binary](32), HASHBYTES('SHA2_256',CONCAT(Company, '#', CustomerNum, '#', InvoiceNum))) AS SalesLedgerID
	,CONCAT(Company,'#',CustomerNum, '#', InvoiceNum) AS SalesLedgerCode
	,CONVERT([binary](32),HASHBYTES('SHA2_256',Company)) AS CompanyID
	--,CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT(Company, '#' ,TRIM(CustomerNum)))) AS CustomerID
	,CONVERT([binary](32), HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM(Company), '#' ,TRIM(CustomerNum))))) AS CustomerID
	,PartitionKey

	,Company
	,[CustomerNum]
	,InvoiceNum AS [SalesInvoiceNum]
	,[InvoiceDate] AS [SalesInvoiceDate]
	,CONVERT(date, DueDate) AS SalesDueDate
	,CONVERT(date, LastPaymentDate) AS SalesLastPaymentDate
	--,0 AS [InvoiceAmount]
	--,0 AS [RemainingInvoiceAmount]
	--,0 AS [ExchangeRate]
	--,0 AS [VATAmount]
	--,'' AS [Currency]
	--,'' AS [VATCode]
	--,'' AS [PayToName]
	--,'' AS [PayToCity]
	--,'' AS [PayToContact]
	--,'' AS [PaymentTerms]

	--,[Res1] AS SLRes1
	--,[Res2] AS SLRes2
	--,[Res3] AS SLRes3
	--,NULL			AS PaidInvoiceAmount
	,'1900-01-01' AS AccountingDate
	--,NULL AS AgingPeriod
	--,NULL AS AgingSort
	--,NULL AS VATCodeDesc
	--,NULL AS LinkToOriginalInvoice

FROM 
	stage.ARK_PI_SalesLedger
--WHERE [DueDate] >= DATEADD(year, -1, GETDATE()) --Added this where clause as semi-incremental load functinoality since it doesn't work easily on meta-param table. /SM 2021-10-01	
--GROUP BY
--	PartitionKey, Company, CustomerNum, InvoiceNum, DueDate, LastPaymentDate, [InvoiceDate], [Res1], [Res2], [Res3]
GO
