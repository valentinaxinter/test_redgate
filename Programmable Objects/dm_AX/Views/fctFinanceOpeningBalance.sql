IF OBJECT_ID('[dm_AX].[fctFinanceOpeningBalance]') IS NOT NULL
	DROP VIEW [dm_AX].[fctFinanceOpeningBalance];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO





CREATE VIEW [dm_AX].[fctFinanceOpeningBalance] AS
SELECT  [OpenBalanceID]
,[AccountID]
,[CostUnitID]
,[CostBearerID]
,[ProjectID]
,[CompanyID]
,[PartitionKey]
,[Company]
,[AccountNum]
,[CostUnitNum]
,[CostBearerNum]
,[ProjectNum]
,[JournalType]
,[JournalDate]
,[Description]
,[OpeningBalance]
,[AccountingDate]
  FROM [dm].[FactFinanceOpeningBalance]
WHERE [Company] in ('AXISE','AXHSE') -- HQ basket
GO
