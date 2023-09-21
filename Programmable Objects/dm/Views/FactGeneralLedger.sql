IF OBJECT_ID('[dm].[FactGeneralLedger]') IS NOT NULL
	DROP VIEW [dm].[FactGeneralLedger];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO








CREATE VIEW [dm].[FactGeneralLedger] AS 
--change the logic in this DM, because we need only the oldest/first open balance from the OPENBALANCE table and also we only pick the row from G/L account
--that goes from that date to the newest. VA 23-03-08 VA
WITH SE AS (
SELECT Company
,AccountingDate
,AccountNum
,ROW_NUMBER() OVER (
	PARTITION BY Company,AccountNum
	ORDER BY AccountingDate
   ) row_num
FROM [dw].[OpenBalance] 
)SELECT CONVERT(bigint, GL.[GeneralLedgerID]) AS [GeneralLedgerID]
      ,CONVERT(bigint, GL.[AccountID]) AS [AccountID]
      ,CONVERT(bigint, GL.[CustomerID]) AS [CustomerID]
      ,CONVERT(bigint, GL.[SupplierID]) AS [SupplierID]
      ,CONVERT(bigint, GL.[CompanyID]) AS [CompanyID]
      ,CONVERT(bigint, GL.[ProjectID]) AS [ProjectID]
      ,CONVERT(bigint, GL.[CostUnitID]) AS [CostUnitID]
      ,CONVERT(bigint, GL.[CostBearerID]) AS [CostBearerID]
      ,GL.[PartitionKey]
      ,GL.[Company]
      ,GL.[AccountNum]
      ,GL.[CostUnitNum]
      ,GL.[CostBearerNum]
      ,GL.[JournalType]
      ,GL.[JournalDate]
      ,GL.[JournalNum]
      ,GL.[JournalLine]
      ,GL.[AccountingDate]
      ,GL.[Description]
      ,GL.[Currency]
      ,GL.[ExchangeRate]
      ,GL.[InvoiceAmount]
	  ,GL.[InvoiceAmountLC]
      ,GL.[CustomerNum]
      ,GL.[SupplierNum]
      ,GL.[SalesInvoiceNum]
      ,GL.[PurchaseInvoiceNum]
      ,GL.[SupplierInvoiceNum]
      ,GL.[LinkToOriginalInvoice]
      ,GL.[DeliveryCountry]
      ,GL.[TransactionNum]
      ,GL.[VATCode]
      ,GL.[VATCodeDesc]
      ,GL.[GLRes1]
      ,GL.[GLRes2]
      ,GL.[GLRes3]
  FROM [dw].[GeneralLedger] AS GL --  -- was [fnc].
	LEFT JOIN  SE ON GL.Company = SE.Company and SE.row_num = 1 and GL.AccountNum = SE.AccountNum
  --WHERE  GL.AccountingDate >= SE.AccountingDate
  
  UNION ALL

  SELECT CONVERT(bigint, OB.OpenBalanceID) AS [GeneralLedgerID]
      ,CONVERT(bigint, OB.[AccountID]) AS [AccountID]
      ,CONVERT(bigint, HASHBYTES('SHA2_256',CONCAT(OB.Company, '#', ''))) AS [CustomerID]
      ,CONVERT(bigint, HASHBYTES('SHA2_256',CONCAT(OB.Company, '#', ''))) AS [SupplierID]
      ,CONVERT(bigint, OB.[CompanyID]) AS [CompanyID]
      ,CONVERT(bigint, OB.[ProjectID]) AS [ProjectID]
      ,CONVERT(bigint, OB.[CostUnitID]) AS [CostUnitID]
      ,CONVERT(bigint, OB.[CostBearerID]) AS [CostBearerID]
      ,OB.[PartitionKey]
      ,OB.[Company]
      ,OB.[AccountNum]
      ,OB.[CostUnitNum]
      ,OB.[CostBearerNum]
      ,'Opening Balance' as [JournalType]
      ,OB.[JournalDate]
      ,''	AS [JournalNum]
      ,''	AS	[JournalLine]
      ,OB.AccountingDate
      ,OB.[Description]
      ,OB.[Currency]
      ,OB.[ExchangeRate]
      ,OB.[OpeningBalance]	AS InvoiceAmount
	  ,OB.[OpeningBalance]	AS InvoiceAmountLC
      ,''	AS [CustomerNum]
      ,''	AS [SupplierNum]
      ,''	AS [SalesInvoiceNum]
      ,''	AS [PurchaseInvoiceNum]
      ,''	AS [SupplierInvoiceNum]
      ,''	AS [LinkToOriginalInvoice]
      ,''	AS [DeliveryCountry]
      ,''	AS [TransactionNum]
      ,''	AS [VATCode]
      ,''	AS [VATCodeDesc]
      ,OB.OBRes1 AS [GLRes1]
      ,OB.OBRes2 AS [GLRes2]
      ,OB.OBRes3 AS [GLRes3]
    FROM [dw].[OpenBalance] as OB  -- was [fnc].
		LEFT JOIN  SE ON OB.Company = SE.Company and SE.row_num = 1 and OB.AccountNum = SE.AccountNum
	--WHERE  AND OB.AccountingDate = SE.AccountingDate
GO
