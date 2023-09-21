IF OBJECT_ID('[stage].[vTMT_FI_SalesLedger]') IS NOT NULL
	DROP VIEW [stage].[vTMT_FI_SalesLedger];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [stage].[vTMT_FI_SalesLedger] AS
--COMMENT EMPTY FIELDS // ADD TRIM() INTO CustomerID 23-01-09 VA
SELECT
	CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(Company, '#', CustNum, '#', InvoiceNum)))) AS SalesLedgerID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(Company))) AS CompanyID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM(Company), '#', TRIM(CustNum))))) AS CustomerID
	--,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(Company, '#', TRIM(CustNum))))) AS CustomerID
	,UPPER(CONCAT(Company, '#', CustNum, '#', InvoiceNum)) AS SalesLedgerCode
	,PartitionKey

	,UPPER(Company) AS Company
	,TRIM(CustNum) AS CustomerNum
	,TRIM(InvoiceNum) AS SalesInvoiceNum
	,InvoiceDate AS SalesInvoiceDate
	,CONVERT(date, DueDate) AS SalesDueDate
	,'1900-01-01' AS SalesLastPaymentDate --CASE WHEN CONVERT(date, LastPaymentDate) = Null THEN '1900-01-01'  ELSE CONVERT(date, LastPaymentDate) END AS LastPaymentDate -- When TMT has values for this field then change back to the values
	--,0 AS InvoiceAmount
	--,0 AS RemainingInvoiceAmount
	,1 AS ExchangeRate
	--,'' AS Currency
	--,0 AS VATAmount
	--,'' AS VATCode
	--,'' AS PayToName
	--,'' AS PayToCity
	--,'' AS PayToContact
	--,'' AS PaymentTerms
	--,'' AS SLRes1
	--,'' AS SLRes2
	--,'' AS SLRes3
	--,NULL AS PaidInvoiceAmount
	,'1900-01-01' AS AccountingDate
	--,NULL AS AgingPeriod
	--,NULL AS AgingSort
	--,NULL AS VATCodeDesc
	--,NULL AS LinkToOriginalInvoice

FROM 
	stage.TMT_FI_SalesLedger
GO
