IF OBJECT_ID('[stage].[vIOW_PL_SalesLedger]') IS NOT NULL
	DROP VIEW [stage].[vIOW_PL_SalesLedger];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [stage].[vIOW_PL_SalesLedger] AS

SELECT
	CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT((Company), '#', TRIM(CustomerNum), '#', TRIM(SalesInvoiceNum))))) AS SalesLedgerID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(Company))) AS CompanyID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(([Company]), '#', TRIM(CustomerNum))))) AS CustomerID
	,UPPER( CONCAT(Company, '#', TRIM(CustomerNum), '#', TRIM(SalesInvoiceNum)))  AS SalesLedgerCode
	,(PartitionKey) AS PartitionKey

	,UPPER(Company) AS Company
	,UPPER(TRIM(CustomerNum)) AS CustomerNum
	,TRIM(SalesInvoiceNum) AS SalesInvoiceNum
	,IIF([SalesInvoiceDate] is null, '1900-01-01', [SalesInvoiceDate]) AS [SalesInvoiceDate]
	,IIF(SalesDueDate is null, '1900-01-01', SalesDueDate) AS SalesDueDate
	,(IIF(SalesLastPaymentDate is null, '1900-01-01', SalesLastPaymentDate)) AS SalesLastPaymentDate --MAX
	,IIF(AccountingDate is null, '1900-01-01', AccountingDate) AS AccountingDate
	,CONVERT(decimal(18,4), REPLACE(InvoiceAmount, ',', '.')) AS InvoiceAmount --
	,(CONVERT(decimal(18,4), REPLACE(PaidInvoiceAmount, ',', '.'))) AS PaidInvoiceAmount  --MAX
	,(CONVERT(decimal(18,4), REPLACE(RemainingInvoiceAmount, ',', '.'))) AS RemainingInvoiceAmount --MIN
	,CONVERT(decimal(18,4), REPLACE(ExchangeRate, ',', '.')) AS ExchangeRate 
	,Currency
	,CONVERT(decimal(18,4), REPLACE(VATAmount, ',', '.')) AS VATAmount 
	,VATCode
	,VATCodeDesc
	,PayToName
	,PayToCity
	,PayToContact
	,LEFT(PaymentTerms, 50) AS PaymentTerms
	,'' AS SLRes1
	,'' AS SLRes2
	,'' AS SLRes3
	,[sysCurrency] AS SLRes6
	,AgingPeriod
	,NULL AS AgingSort
	,'' AS LinkToOriginalInvoice
FROM 
	axbus.IOW_PL_SalesLedger
--GROUP BY Company, CustomerNum, SalesInvoiceNum, [SalesInvoiceDate], SalesDueDate, AccountingDate, InvoiceAmount, ExchangeRate, Currency, VATAmount, VATCode, VATCodeDesc, PayToName, PayToCity, PayToContact, PaymentTerms, AgingPeriod, PaidInvoiceAmount, SalesLastPaymentDate, PartitionKey, RemainingInvoiceAmount
GO
