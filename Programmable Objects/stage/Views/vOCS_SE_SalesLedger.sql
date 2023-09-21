IF OBJECT_ID('[stage].[vOCS_SE_SalesLedger]') IS NOT NULL
	DROP VIEW [stage].[vOCS_SE_SalesLedger];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE VIEW [stage].[vOCS_SE_SalesLedger] AS
--COMMENT EMPTY FIELDS // ADD UPPER() TRIM() INTO CustomerID 2022-12-21 VA
SELECT
	CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT(Company, '#', TRIM(UPPER(CustomerNum)), '#', TRIM(UPPER(SalesInvoiceNum)) ))) AS SalesLedgerID
	,CONVERT([binary](32), HASHBYTES('SHA2_256',Company)) AS CompanyID
	,CONVERT([binary](32), HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM(Company), '#', TRIM(CustomerNum))))) AS CustomerID
	--,CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT(Company, '#', TRIM(CustomerID)))) AS CustomerID
	,CONCAT(Company, '#', TRIM(UPPER(CustomerNum)), '#', TRIM(UPPER(SalesInvoiceNum)) ) AS SalesLedgerCode
	,PartitionKey

	,Company
	,TRIM(UPPER(CustomerNum)) AS CustomerNum
	,TRIM(UPPER(SalesInvoiceNum)) AS SalesInvoiceNum
	,CONVERT(date,SalesInvoiceDate)  AS SalesInvoiceDate
	,CONVERT(date,SalesInvoiceDueDate) AS SalesDueDate --,CONVERT(date, Min(SalesInvoiceDueDate)) 2023-04-04
	,CONVERT(date, SalesInvoiceLastPaymentDate) AS SalesLastPaymentDate -- min
	,TRIM(SalesOrderNum) as SalesOrderNum
	,InvoiceAmount 
	,PaidInvoiceAmount -- max(PaidInvoiceAmount)	
	,RemainingInvoiceAmount --MIN(RemainingInvoiceAmount)
	,IIF(Currency = 'SEK', 1, CONVERT(decimal(18,4), Replace(ExchangeRate, ',', '.'))) AS ExchangeRate
	,IIF(Currency = '€UR','EUR', Currency) AS Currency
	,VATAmount -- max
	,PaymentEvents
	,IsInvoiceClosed
	,VATCode
	,VatCodeDesc
	--,'' AS PayToName
	--,'' AS PayToCity
	--,'' AS PayToContact
	--,'' AS PaymentTerms
	--,'' AS SLRes1
	--,'' AS SLRes2
	--,'' AS SLRes3
	,CONVERT(date, AccountingDate) AS AccountingDate 
	--,NULL AS AgingPeriod
	--,NULL AS AgingSort
	,LinktoOriginalInvoice AS LinkToOriginalInvoice
FROM 
	stage.OCS_SE_SalesLedger
--GROUP BY PartitionKey, Company, CustomerNum, TRIM(UPPER(SalesInvoiceNum))
GO
