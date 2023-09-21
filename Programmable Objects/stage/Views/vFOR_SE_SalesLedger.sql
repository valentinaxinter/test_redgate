IF OBJECT_ID('[stage].[vFOR_SE_SalesLedger]') IS NOT NULL
	DROP VIEW [stage].[vFOR_SE_SalesLedger];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE view [stage].[vFOR_SE_SalesLedger] AS 
--COMMENT EMPTY FIELDS / CustomerID 2022-12-20	VA
SELECt
	CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM(Company), '#', TRIM(IIF(CustNum IS NULL OR CustNum = '', 'MISSINGCUSTOMER', CustNum) ), '#', TRIM(InvoiceNum))))) AS SalesLedgerID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(TRIM(Company)))) AS CompanyID
	--,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM(Company), '#', TRIM(IIF(CustNum IS NULL OR CustNum = '', 'MISSINGCUSTOMER', CustNum) ))))) AS CustomerID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM(Company), '#', TRIM(CustNum))))) AS CustomerID
	,UPPER(CONCAT(TRIM(Company), '#', TRIM(IIF(CustNum IS NULL OR CustNum = '', 'MISSINGCUSTOMER', CustNum) ), '#', TRIM(InvoiceNum))) AS SalesLedgerCode
	,PartitionKey

	,UPPER(TRIM(Company)) AS Company
	,UPPER(TRIM(IIF(CustNum IS NULL OR CustNum = '', 'MISSINGCUSTOMER', CustNum) )) AS CustomerNum
	,TRIM(InvoiceNum) AS SalesInvoiceNum
	,InvoiceDate AS SalesInvoiceDate
	,CONVERT(date, DueDate) AS SalesDueDate
	,CONVERT(date, LastPaymentDate) AS SalesLastPaymentDate
	,OriginalAmount AS InvoiceAmount
	,RemainingAmount AS RemainingInvoiceAmount
	,OriginalAmount - RemainingAmount AS PaidInvoiceAmount
	,CONVERT(decimal(18,4), ExchangeRate) AS ExchangeRate   --local currency
	,UPPER(TRIM(CURRENCY)) AS Currency
	,VATAmount
	,trim(VATCode) AS VATCode
	,trim(VATCodeDesc) AS VATCodeDesc
	--,'' AS PayToName
	--,'' AS PayToCity
	--,'' AS PayToContact
	,trim(PaymentTerms) as PaymentTerms
	,FiscalYear AS SLRes1
	,FiscalPeriod AS SLRes2
	,Currency AS SLRes3 --original currency
	,IIF(ApplyDate is null or ApplyDate = '', convert(date,'1900-01-01'), convert(date,ApplyDate)) AS AccountingDate   
	,AgingPeriod AS AgingPeriod
	,DaysPastDue AS AgingSort
	--,'' AS LinkToOriginalInvoice
FROM 
	stage.FOR_SE_SalesLedger
--GROUP BY 
--      [PartitionKey],[Company],CustNum,InvoiceNum,[DueDate],[LastPaymentDate]
GO
