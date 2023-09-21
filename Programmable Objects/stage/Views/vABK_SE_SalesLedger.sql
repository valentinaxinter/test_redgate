IF OBJECT_ID('[stage].[vABK_SE_SalesLedger]') IS NOT NULL
	DROP VIEW [stage].[vABK_SE_SalesLedger];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [stage].[vABK_SE_SalesLedger] AS
	-- An invoice can have multiple SalesDueDate and SalesLastPaymentDate. We have for now chosen to pick max dates and sum of amounts, which works. But we have also temporarily chosen to pick max of ExchangeRate despite it not being correct. This is due to that all the troublesome invoices are in SEK (local currency)
	-- But in the future, this could become incorrect for some invoice /SM 2021-12-13
	--COMMENT EMPTY FIELDS 2022-12-21 VA
SELECT
	CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT(Company, '#', InvoiceID ))) AS SalesLedgerID
	,CONVERT([binary](32), HASHBYTES('SHA2_256',Company)) AS CompanyID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM(Company), '#', TRIM(CustomerID))))) AS CustomerID
	,CONCAT(Company, '#', TRIM(UPPER(CustomerID)), '#', TRIM(UPPER(InvoiceID)) ) AS SalesLedgerCode
	,PartitionKey

	,Company
	,TRIM(UPPER(CustomerID)) AS CustomerNum
	,TRIM(UPPER(InvoiceID)) AS SalesInvoiceNum
	,[InvoDate] AS SalesInvoiceDate
	,CONVERT(date, Min(DueDate)) AS SalesDueDate
	,CONVERT(date, MAX(LastPayment)) AS SalesLastPaymentDate
	,SUM([AmountCur]) AS InvoiceAmount
	,SUM([OutstandingAmountCur]) AS RemainingInvoiceAmount
	,CASE WHEN ISOCode IN ('SEK', 'NOK', 'DKK') THEN MAX(ExchangeRate)/100 ELSE MAX(ExchangeRate) END AS ExchangeRate
	,ISOCode AS Currency
	,SUM(VatAmCur) AS VATAmount
	--,'' AS VATCode
	--,'' AS PayToName
	--,'' AS PayToCity
	--,'' AS PayToContact
	--,'' AS PaymentTerms
	--,'' AS SLRes1
	--,'' AS SLRes2
	--,'' AS SLRes3
	--,NULL			AS PaidInvoiceAmount
	,'1900-01-01' AS AccountingDate
	--,NULL AS AgingPeriod
	--,NULL AS AgingSort
	--,NULL AS VATCodeDesc
	--,NULL AS LinkToOriginalInvoice
FROM 
	stage.ABK_SE_SalesLedger


	GROUP BY PartitionKey, Company, CustomerID, InvoiceID, [InvoDate], ISOCode	
HAVING SUM([AmountCur]) != 0  --added 2023-05-24 otherwise one duplication with invoicenum = 54018679 to two customers! one is amt = 0 /DZ
GO
