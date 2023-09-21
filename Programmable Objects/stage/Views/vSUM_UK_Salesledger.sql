IF OBJECT_ID('[stage].[vSUM_UK_Salesledger]') IS NOT NULL
	DROP VIEW [stage].[vSUM_UK_Salesledger];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [stage].[vSUM_UK_Salesledger] AS
SELECT
	CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT(UPPER(TRIM(dbo.summers())), '#', UPPER(TRIM(CustNum)), '#', UPPER(TRIM(InvoiceNum)) ))) AS SalesLedgerID  --, '#', DueDate, '#', LastPayDate *This should be add in the id? VA
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(TRIM(dbo.summers())))) AS CompanyID
	,CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM(dbo.summers()),'#',TRIM(CustNum))))) AS CustomerID
	,CONCAT(UPPER(TRIM(dbo.summers())), '#', UPPER(TRIM(CustNum)), '#', UPPER(TRIM(InvoiceNum))) AS SalesLedgerCode
	,PartitionKey

	,UPPER(TRIM(dbo.summers())) AS Company
	,TRIM(CustNum) AS CustomerNum
	,TRIM(InvoiceNum) AS SalesInvoiceNum  -- various blank spaces after InvoiceNum, it affects query results! data-Input quality should be improved!
	,isnull(nullif(InvoiceDate,''),'1900-01-01') AS SalesInvoiceDate
	,CONVERT(date, MIN(DueDate)) AS SalesDueDate
	,CONVERT(date, MAX(LastPaymentDate)) AS SalesLastPaymentDate
	--NULL AS InvoiceAmount,
	--NULL AS RemainingInvoiceAmount,
	,1 AS ExchangeRate
	,'GBP' AS Currency
	--NULL AS VATAmount,
	--'' AS VATCode,
	--'' AS PayToName,
	--'' AS PayToCity,
	--'' AS PayToContact,
	--'' AS PaymentTerms,
	--'' AS SLRes1
	--'' AS SLRes2,
	--'' AS SLRes3
	--NULL AS PaidInvoiceAmount,
	--'1900-01-01' AS AccountingDate,
	--NULL AS AgingPeriod,
	--NULL AS AgingSort,
	--NULL AS VATCodeDesc,
	--NULL AS LinkToOriginalInvoice
FROM 
	stage.SUM_UK_Salesledger
GROUP BY
	PartitionKey, Company, TRIM(CustNum), TRIM(InvoiceNum), InvoiceDate
GO
