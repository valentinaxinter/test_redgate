IF OBJECT_ID('[stage].[vROR_SE_SalesLedger]') IS NOT NULL
	DROP VIEW [stage].[vROR_SE_SalesLedger];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE VIEW [stage].[vROR_SE_SalesLedger] AS
--COMMENT EMPTY FIELDS // ADD UPPER() TRIM() CustomerID 2022-12-21 VA
--CUSTOMER NUM 23-02-17 VA
SELECT
	CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT(CAST('ROROSE' AS NVARCHAR(6)), '#', TRIM(SalesInvoiceNum)))) AS SalesLedgerID --, '#', TRIM(CustomerNum)
	,CONVERT([binary](32), HASHBYTES('SHA2_256', CAST('ROROSE' AS NVARCHAR(6)))) AS CompanyID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM(CAST('ROROSE' AS NVARCHAR(6))), '#', TRIM(CustomerNum))))) AS CustomerID
	--,CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT(CAST('ROROSE' AS NVARCHAR(6)), '#', TRIM(IIF(CustomerNum IS NULL OR CustomerNum = '', 'MISSINGCUSTOMER', CustomerNum))))) AS CustomerID
	,CONCAT(CAST('ROROSE' AS NVARCHAR(6)), '#', TRIM(CustomerNum), '#', TRIM(SalesInvoiceNum)) AS SalesLedgerCode
	,PartitionKey

	,CAST('ROROSE' AS NVARCHAR(6)) AS Company
	,TRIM(CustomerNum) AS CustomerNum
	,TRIM(SalesInvoiceNum) AS SalesInvoiceNum
	,SalesInvoiceDate
	,SalesDueDate
	,SalesLastPaymentDate
	,InvoiceAmount
	,RemainingInvoiceAmount
	,PaidInvoiceAmount
	,CONVERT(decimal(18,5), LEFT(ExchangeRate, 7)) AS ExchangeRate
	,Currency
	,VATAmount
	,VATCode
	,PayToName
	,PayToCity
	,PayToContact
	,PaymentTerms
	--,'' AS SLRes1
	--,'' AS SLRes2
	--,'' AS SLRes3
	,AccountingDate
	--,'' AS AgingPeriod
	--,'' AS AgingSort
	--,'' AS VATCodeDesc
	--,'' AS LinkToOriginalInvoice
FROM 
	stage.ROR_SE_SalesLedger
GO
