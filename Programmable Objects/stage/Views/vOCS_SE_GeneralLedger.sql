IF OBJECT_ID('[stage].[vOCS_SE_GeneralLedger]') IS NOT NULL
	DROP VIEW [stage].[vOCS_SE_GeneralLedger];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [stage].[vOCS_SE_GeneralLedger] AS
SELECT
	CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(Company, '#', TRIM([ProjectNum]), '#', TRIM([AccountNum]), '#', TRIM([JournalNum]), '#', TRIM([JournalLine]), '#', TRIM([CostUnitNum]))))) AS GeneralLedgerID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(Company))) AS CompanyID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(Company, '#', TRIM([AccountNum]))))) AS AccountID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(Company, '#', TRIM(SupplierNum))))) AS SupplierID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(Company, '#', TRIM(CustomerNum))))) AS CustomerID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(Company, '#', TRIM(ProjectNum))))) AS ProjectID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(Company, '#', TRIM([CostUnitNum]))))) AS CostUnitID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(Company, '#', '')))) AS CostBearerID
	,PartitionKey

	,Company
	,TRIM([AccountNum]) AS [AccountNum]
	,TRIM([JournalNum]) AS [JournalNum]
	,TRIM([JournalLine]) AS [JournalLine]
	,TRIM([ProjectNum]) AS [ProjectNum]
	,CASE WHEN TRIM([Description]) IN ('justering IB', 'ingående balans','ingående balans 1110','ingående balans 1130', 'Korr IB konto 1229', 'Korr för IB-bokn')  THEN 'Opening Balance'
	      ELSE TRIM([JournalType]) END AS [JournalType]
	,TRIM([Description]) AS [Description]
	,'' AS [CostBearerNum]
	,CASE WHEN TRIM([Description]) IN ('justering IB', 'ingående balans','ingående balans 1110','ingående balans 1130', 'Korr IB konto 1229', 'Korr för IB-bokn')  THEN CONVERT(date, '2016-01-01')
	      ELSE CONVERT(date, CONCAT(LEFT([AccountingDate], 4), '-', SUBSTRING([AccountingDate], 5, 2), '-', RIGHT([AccountingDate],2))) END AS AccountingDate 
	,CASE WHEN TRIM([Description]) IN('justering IB', 'ingående balans','ingående balans 1110','ingående balans 1130', 'Korr IB konto 1229', 'Korr för IB-bokn')  THEN CONVERT(date, '2016-01-01')
	      ELSE CONVERT(date, [JournalDate]) END AS JournalDate 
	,IIF([Currency] = '€UR','EUR',trim([Currency])) As [Currency]
	,IIF([Currency] = 'SEK', 1, CONVERT(decimal(18,4), ExchangeRate)) AS ExchangeRate
	,CONVERT(decimal(18,4), TransactionAmount) AS InvoiceAmount
	,CONVERT(decimal(18,4),InvoiceAmountLC) AS InvoiceAmountLC
	,TRIM([CostUnitNum]) AS [CostUnitNum]
	,TRIM(CustomerNum) AS CustomerNum
	,TRIM(SupplierNum) AS SupplierNum
	,TRIM(SalesInvoiceNum) AS SalesInvoiceNum
	,TRIM(PurchaseInvoiceNum) AS PurchaseInvoiceNum
	,TRIM(SupplierInvoiceNum) AS SupplierInvoiceNum
	,TRIM([TransactionNum])	AS [TransactionNum]
	,'' AS DeliveryCountry
	,'' AS [VATCode]
	,'' AS [VATCodeDesc]
	,'' AS UserIDApproved
	,'' AS IsActiveRecord
	,IsManual
	,[LinktoOriginalInvoice] AS [LinkToOriginalInvoice]
	,IndexKey AS GLRes1
	,ModifiedTimeStamp AS GLRes2
	,CreatedTimeStamp AS GlRes3

FROM 
	stage.OCS_SE_GeneralLedger
	where (AccountingDate = '20151231' AND JournalType not IN ('40','91')) OR AccountingDate >= '20160101'  -- added 2023-04-19 SB, to include OB for 2016-01 (org acc.date 2015-12-31), but exclude random depreciation transaction from before 2016.

/*GROUP BY
	PartitionKey, SysRowID, Company, [SupplierNum], [CustomerNum], [CostUnitNum], [CostBearerNum], [SupplierInvoiceNum], [JournalDate], [AccountingDate], [Currency], [AmountSystemCurrency], [AccountNum], [JournalType], [TransactionNum], [JournalNum], [JournalLine], [Description], [VATCode], [LinktoOriginalInvoice], [APInvoiceNum], [ARInvoiceNum], [FiscalPeriod], [VATCodeDesc],[FiscalYear]
	*/

UNION ALL

SELECT
	CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT('OCSSE', '#', TRIM([Projekt]), '#', TRIM(Konto))))) AS GeneralLedgerID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(N'OCSSE'))) AS CompanyID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT('OCSSE', '#', TRIM(Konto))))) AS AccountID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT('OCSSE', '#', '')))) AS SupplierID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT('OCSSE', '#', '')))) AS CustomerID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT('OCSSE', '#', TRIM([Projekt]))))) AS ProjectID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT('OCSSE', '#', '')))) AS CostUnitID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT('OCSSE', '#', '')))) AS CostBearerID
	,CONVERT(date, GETDATE()) AS PartitionKey

	,'OCSSE' AS Company
	,TRIM(Konto) AS [AccountNum]
	,'' AS [JournalNum]
	,'' AS [JournalLine]
	,TRIM([Projekt]) AS [ProjectNum]
	,'AxInterBI' AS [JournalType]
	,'OCS Current Month Salary Costs' AS [Description]
	,'' AS [CostBearerNum]
	,CONVERT(date, GETDATE()-1) AS AccountingDate
	,CONVERT(date, GETDATE()-1) AS JournalDate 
	,'SEK' As [Currency]
	,1 AS ExchangeRate
	,CONVERT(decimal(18,4), REPLACE([Belopp], ',', '.')) AS InvoiceAmount
	,CONVERT(decimal(18,4), REPLACE([Belopp], ',', '.')) AS InvoiceAmountLC
	,'' AS [CostUnitNum]
	,'' AS CustomerNum
	,'' AS SupplierNum
	,'' AS SalesInvoiceNum
	,'' AS PurchaseInvoiceNum
	,'' AS SupplierInvoiceNum
	,''	AS [TransactionNum]
	,'' AS DeliveryCountry
	,'' AS [VATCode]
	,'' AS [VATCodeDesc]
	,'' AS UserIDApproved
	,1 AS IsActiveRecord
	,1 AS IsManual
	,'' AS [LinkToOriginalInvoice]
	,'' AS GLRes1
	,'' AS GLRes2
	,'' AS GlRes3

FROM 
	stage.OCS_SE_GeneralLedgerTimeCost
--where (AccountingDate = '20151231' AND JournalType not IN ('40','91')) OR AccountingDate >= '20160101'
GO
