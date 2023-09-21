IF OBJECT_ID('[stage].[vAXL_PT_SalesLedger]') IS NOT NULL
	DROP VIEW [stage].[vAXL_PT_SalesLedger];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [stage].[vAXL_PT_SalesLedger] AS

SELECT
	CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(sl.Company, '#', TRIM(sl.CustNum), '#', TRIM(sl.InvoiceNum))))) AS SalesLedgerID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(sl.Company))) AS CompanyID
	,UPPER(CONCAT(sl.Company, '#', TRIM(sl.CustNum), '#', TRIM(sl.InvoiceNum))) AS SalesLedgerCode
	,sl.PartitionKey

	,UPPER(sl.Company) AS Company
	,UPPER(TRIM(sl.CustNum)) AS CustomerNum
	,TRIM(sl.InvoiceNum) AS [SalesInvoiceNum]
	,IIF(so.InvoiceDate = '' OR so.InvoiceDate IS NULL, '1900-01-01', so.InvoiceDate) AS [SalesInvoiceDate] --
	,CONVERT(date, DueDate) AS SalesDueDate
	,CONVERT(date, LastPaymentDate) AS LastPaymentDate
	,[InvoiceAmount]
	,[RemainAmount] AS [RemainingInvoiceAmount]
	,NULL AS CashDiscOffered
	,NULL AS CashDiscUsed
	,NULL AS [ExchangeRate]
	,NULL AS [Currency]
	,NULL AS [VATAmount]
	,NULL AS [VATCode]
	,NULL AS [PayToName]
	,NULL AS [PayToCity]
	,NULL AS [PayToContact]
	,NULL AS [PaymentTerms]
	,sl.Res1 AS SLRes1
	,sl.Res2 AS SLRes2
	,sl.Res3 AS SLRes3
FROM stage.AXL_PT_SalesLedger sl
	LEFT JOIN stage.AXL_CZ_SOLine so ON TRIM(sl.InvoiceNum) = TRIM(so.InvoiceNum)
WHERE DueDate > '2015-01-01'
GROUP BY
	sl.PartitionKey, sl.Company, sl.CustNum, sl.InvoiceNum, sl.Res2, sl.Res1, sl.Res3, sl.[InvoiceAmount], sl.[RemainAmount], so.InvoiceDate, DueDate, LastPaymentDate
GO
