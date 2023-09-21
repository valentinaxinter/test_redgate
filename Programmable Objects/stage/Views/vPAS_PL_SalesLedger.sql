IF OBJECT_ID('[stage].[vPAS_PL_SalesLedger]') IS NOT NULL
	DROP VIEW [stage].[vPAS_PL_SalesLedger];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [stage].[vPAS_PL_SalesLedger] AS
--COMMENT EMPTY FIELD // ADD TRIM() INTO CustomerID 23-01-05 VA
SELECT
	CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT(company, '#', TRIM(UPPER(customernum)), '#', TRIM(UPPER(invoicenum))))) AS SalesLedgerID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', company)) AS CompanyID
	--,CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT(Company, '#', TRIM(UPPER(CustomerNum))))) AS CustomerID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM(Company), '#', TRIM(CustomerNum))))) AS CustomerID
	,CONCAT(company, '#', TRIM(UPPER(customernum)), '#', TRIM(UPPER(invoicenum))) AS SalesLedgerCode
	,PartitionKey

	,company AS Company
	,TRIM(UPPER(customernum)) AS CustomerNum
	,TRIM(UPPER(invoicenum)) AS SalesInvoiceNum
	,invoicedate AS SalesInvoiceDate
	,CONVERT(date, duedate) AS SalesDueDate
	,CONVERT(date, lastpaymentdate) AS SalesLastPaymentDate
	--,NULL AS InvoiceAmount
	--,NULL AS RemainingInvoiceAmount
	,1 AS ExchangeRate
	,'PLN' AS Currency
	--,NULL AS VATAmount
	--,'' AS VATCode
	--,'' AS PayToName
	--,'' AS PayToCity
	--,'' AS PayToContact
	--,'' AS PaymentTerms
	,res1 AS SLRes1
	,res2 AS SLRes2
	,res3 AS SLRes3
	--,NULL			AS PaidInvoiceAmount
	,'1900-01-01' AS AccountingDate
	--,NULL AS AgingPeriod
	--,NULL AS AgingSort
	--,NULL AS VATCodeDesc
	--,NULL AS LinkToOriginalInvoice
FROM 
	stage.PAS_PL_SalesLedger

GROUP BY PartitionKey, company, customernum, invoicedate, invoicenum, duedate, lastpaymentdate, res1, res2, res3
GO
