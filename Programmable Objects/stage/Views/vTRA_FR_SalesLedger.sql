IF OBJECT_ID('[stage].[vTRA_FR_SalesLedger]') IS NOT NULL
	DROP VIEW [stage].[vTRA_FR_SalesLedger];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [stage].[vTRA_FR_SalesLedger] AS
--ADD UPPER() TRIM() INTO CustomerID 22-12-29 VA
SELECT
	CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT(UPPER(Company), '#', TRIM(CustomerNum), '#', TRIM(SalesInvoiceNum)))) AS SalesLedgerID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(Company))) AS CompanyID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM([Company]), '#', TRIM(CustomerNum))))) AS CustomerID
	--,CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT(UPPER([Company]), '#', TRIM(CustomerNum)))) AS CustomerID
	,CONCAT(UPPER(Company), '#', TRIM(CustomerNum), '#', TRIM(SalesInvoiceNum)) AS SalesLedgerCode
	,PartitionKey

	,UPPER(Company) AS Company
	,TRIM(CustomerNum) AS CustomerNum
	,TRIM(SalesInvoiceNum) AS SalesInvoiceNum
	,SalesInvoiceDate
	,DueDate As SalesDueDate
	,LastPaymentDate AS SalesLastPaymentDate
	,CAST('1900-01-01' AS date) AS AccountingDate
	,InvoiceAmount
	,InvoiceAmount - RemainingInvoiceAmount AS PaidInvoiceAmount
	,RemainingInvoiceAmount
	,ExchangeRate
	,Currency
	,VATAmount
	,VATCode
	,PayToName
	,PayToCity
	--,'' AS PayToContact
	,PaymentTerms
	--,'' AS SLRes1
	--,'' AS SLRes2
	--,'' AS SLRes3
	--,'' AS AgingPeriod
	--,'' AS AgingSort
	--,'' AS VATCodeDesc
	--,'' AS LinkToOriginalInvoice
FROM 
	stage.TRA_FR_SalesLedger
GO
