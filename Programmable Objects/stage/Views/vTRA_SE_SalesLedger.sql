IF OBJECT_ID('[stage].[vTRA_SE_SalesLedger]') IS NOT NULL
	DROP VIEW [stage].[vTRA_SE_SalesLedger];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [stage].[vTRA_SE_SalesLedger] AS
--COMMENT EMPTY FIELDS // ADD UPPER()TRIM() INTO CustomerID 2022-12-27 VA
SELECT
	CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT(UPPER(Company), '#', TRIM(CustomerNum), '#', TRIM(SalesInvoiceNum)))) AS SalesLedgerID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(Company))) AS CompanyID
	--,CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT(UPPER([Company]), '#', TRIM(CustomerNum)))) AS CustomerID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM([Company]), '#', TRIM(CustomerNum))))) AS CustomerID
	,CONCAT(UPPER(Company), '#', TRIM(CustomerNum), '#', TRIM(SalesInvoiceNum)) AS SalesLedgerCode
	,PartitionKey

	,UPPER(Company) AS Company
	,TRIM(CustomerNum) AS CustomerNum
	,TRIM(SalesInvoiceNum) AS SalesInvoiceNum
	,CONVERT(date, SalesInvoiceDate) AS SalesInvoiceDate
	,CONVERT(date, DueDate) AS SalesDueDate
	,CONVERT(date, LastPaymentDate) AS SalesLastPaymentDate
	,InvoiceAmount
	,RemainingInvoiceAmount
	,ExchangeRate
	,Currency
	,VATAmount
	,momsbeskrivning AS VATCode
	--,'' AS PayToName
	--,'' AS PayToCity
	--,'' AS PayToContact
	,PaymentTerms
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
	stage.TRA_SE_SalesLedger
GO
