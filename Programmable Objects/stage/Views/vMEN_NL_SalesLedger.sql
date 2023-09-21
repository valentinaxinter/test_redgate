IF OBJECT_ID('[stage].[vMEN_NL_SalesLedger]') IS NOT NULL
	DROP VIEW [stage].[vMEN_NL_SalesLedger];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO








/****** Script for SelectTopNRows command from SSMS  ******/

CREATE VIEW [stage].[vMEN_NL_SalesLedger] AS
WITH CTE AS (
SELECT	
		CASE WHEN Company = '14' THEN  CONCAT(N'MENBE',Company) 
			ELSE  CONCAT(N'MENNL',Company)  END AS CompanyCode	
	  ,[PartitionKey], [Company], [CustomerNum], [SalesInvoiceNum], [SalesInvoiceDate], [SalesDueDate], [SalesLastPaymentDate], [InvoiceAmount], [PaidInvoiceAmount], [RemainingInvoiceAmount], [AccountingDate], [Currency], [VATAmount], [VATCode], [PayToName], [PayToCity], [PayToContact], [ExchangeRate], [Agingperiod], [AgingSort], [VATCodeDesc], [PaymentTerms], [SLRes1], [SLRes2], [SLRes3], [AmountExclVAT], [DebiteurKey], [DW_TimeStamp]
	  ,ROW_NUMBER() OVER (PARTITION BY Company, SalesInvoiceNum ORDER BY SalesLastPaymentDate) AS rownum
  FROM [stage].[MEN_NL_SalesLedger]
)
SELECT
	CONVERT([binary](32),HASHBYTES('SHA2_256',CONCAT(CompanyCode, '#', TRIM(SalesInvoiceNum)))) AS SalesLedgerID,
	CONVERT([binary](32),HASHBYTES('SHA2_256', CompanyCode)) AS CompanyID,
	CONVERT([binary](32),HASHBYTES('SHA2_256',CONCAT(CompanyCode,'#',CustomerNum))) AS CustomerID,
	CONCAT(CompanyCode,'#', SalesInvoiceNum) AS SalesLedgerCode,
	PartitionKey,

	CompanyCode	AS Company,
	TRIM(CustomerNum) AS CustomerNum,
	TRIM(SalesInvoiceNum) AS SalesInvoiceNum,
	SalesInvoiceDate		AS SalesInvoiceDate,
	SalesDueDate,
	SalesLastPaymentDate,
	InvoiceAmount,
	RemainingInvoiceAmount,
    ExchangeRate,
	case when currency is null 
	         then 'EUR'
		 ELSE Currency 
		 END AS Currency,
	VATAmount,
	''AS VATCode,
	PayToName,
	PayToCity,
	PayToContact,
	PaymentTerms,
	'' AS SLRes1,
	'' AS SLRes2,
	'' AS SLRes3,
	PaidInvoiceAmount,
	AccountingDate
	,NULL AS AgingPeriod
	,NULL AS AgingSort
	,NULL AS VATCodeDesc
	,NULL AS LinkToOriginalInvoice
FROM CTE
where rownum = 1
GO
