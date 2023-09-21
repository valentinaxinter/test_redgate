IF OBJECT_ID('[stage].[vCER_LV_SalesLedger]') IS NOT NULL
	DROP VIEW [stage].[vCER_LV_SalesLedger];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [stage].[vCER_LV_SalesLedger] AS
--COMMENT EMPTY FIELDS // ADD UPPER() TRIM() INTO CustomerID 2022-12-21 VA
SELECT
	CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT(Company, '#', TRIM(IIF(CustNum IS NULL OR CustNum = '', 'MISSINGCUSTOMER', CustNum) ), '#', InvoiceNum))) AS SalesLedgerID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', Company)) AS CompanyID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM(Company), '#', TRIM(CustNum))))) AS CustomerID
	--,CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT(Company, '#', TRIM(IIF(CustNum IS NULL OR CustNum = '', 'MISSINGCUSTOMER', CustNum) )))) AS CustomerID
	,CONCAT(Company, '#', TRIM(IIF(CustNum IS NULL OR CustNum = '', 'MISSINGCUSTOMER', CustNum) ), '#', TRIM(InvoiceNum)) AS SalesLedgerCode
	,PartitionKey

	,TRIM(Company) AS Company
	,TRIM(IIF(CustNum IS NULL OR CustNum = '', 'MISSINGCUSTOMER', CustNum) ) AS CustomerNum
	,TRIM(InvoiceNum) AS SalesInvoiceNum
	,InvoiceDate AS SalesInvoiceDate
	,CONVERT(date, DueDate) AS SalesDueDate
	,CONVERT(date, LastPaymentDate) AS SalesLastPaymentDate
	,InvoiceAmountOC AS InvoiceAmount
	,PaidAmountOC AS PaidInvoiceAmount
	,OpenAmountOC AS RemainingInvoiceAmount
	,ExchangeRate
	,Currency
	,VATAmount
	,VATCode
	--,'' AS PayToName
	--,'' AS PayToCity
	--,'' AS PayToContact
	--,'' AS PaymentTerms
	--,'' AS SLRes1
	--,'' AS SLRes2
	--,'' AS SLRes3
	,'1900-01-01' AS AccountingDate
	--,'' AS AgingPeriod
	--,'' AS AgingSort
	--,'' AS VATCodeDesc
	--,'' AS LinkToOriginalInvoice
FROM 
	stage.CER_LV_SalesLedger
GO
