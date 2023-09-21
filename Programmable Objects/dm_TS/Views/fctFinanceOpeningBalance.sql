IF OBJECT_ID('[dm_TS].[fctFinanceOpeningBalance]') IS NOT NULL
	DROP VIEW [dm_TS].[fctFinanceOpeningBalance];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE   VIEW [dm_TS].[fctFinanceOpeningBalance] AS
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
WHERE Company  IN ('FESFORA', 'FSEFORA', 'FFRFORA', 'FORPL', 'CERPL', 'FFRGPI', 'FFRLEX', 'IFIWIDN', 'IEEWIDN', 'TMTFI', 'TMTEE', 'FITMT', 'EETMT', 'ABKSE', 'ROROSE','STESE')
GO
