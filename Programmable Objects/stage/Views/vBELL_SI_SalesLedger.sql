IF OBJECT_ID('[stage].[vBELL_SI_SalesLedger]') IS NOT NULL
	DROP VIEW [stage].[vBELL_SI_SalesLedger];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [stage].[vBELL_SI_SalesLedger] AS 
--COMMENT EMPTY FIELD // ADD TRIM()UPPER() INTO CustomerID 2022-12-27 VA
SELECT
	DISTINCT(MAX(CONVERT([binary](32),HASHBYTES('SHA2_256', CONCAT(Company,'#', CustNum, '#', InvoiceNum) ) ))) AS SalesLedgerID, --, '#', DueDate, '#', LastPaymentDate
	--CONVERT([binary](32),HASHBYTES('SHA2_256',CONCAT(Company,'#',CustNum, '#', InvoiceNum))) AS SalesLedgerID, -- In Bell, this combi is not unique
	CONVERT([binary](32),HASHBYTES('SHA2_256', Company)) AS CompanyID,
	CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM(Company),'#',TRIM(CustNum))))) AS CustomerID,
	--CONVERT([binary](32),HASHBYTES('SHA2_256',CONCAT(Company,'#',TRIM(CustNum)))) AS CustomerID,
	CONCAT(Company,'#', CustNum, '#', InvoiceNum) AS SalesLedgerCode,
	PartitionKey,

	Company,
	CustNum AS CustomerNum,
	MAX(InvoiceNum) AS SalesInvoiceNum,
	InvoiceDate AS SalesInvoiceDate,
	CONVERT(date, DueDate) AS SalesDueDate,
	CONVERT(date, LastPaymentDate) AS SalesLastPaymentDate,
	--0 AS InvoiceAmount,
	--0 AS RemainingInvoiceAmount,
	1 AS ExchangeRate,
	--'' AS Currency,
	--0 AS VATAmount,
	--'' AS VATCode,
	--'' AS PayToName,
	--'' AS PayToCity,
	--'' AS PayToContact,
	--'' AS PaymentTerms,
	--'' AS SLRes1,
	--'' AS SLRes2,
	--'' AS SLRes3
	--,NULL			AS PaidInvoiceAmount
	'1900-01-01' AS AccountingDate
	--,NULL AS AgingPeriod
	--,NULL AS AgingSort
	--,NULL AS VATCodeDesc
	--,NULL AS LinkToOriginalInvoice
FROM stage.BELL_SI_SalesLedger
GROUP BY Company, CustNum, InvoiceNum, PartitionKey, DueDate, LastPaymentDate, InvoiceDate
GO
