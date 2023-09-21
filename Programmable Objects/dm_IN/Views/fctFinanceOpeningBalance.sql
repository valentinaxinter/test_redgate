IF OBJECT_ID('[dm_IN].[fctFinanceOpeningBalance]') IS NOT NULL
	DROP VIEW [dm_IN].[fctFinanceOpeningBalance];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



/****** Script for SelectTopNRows command from SSMS  ******/
CREATE VIEW [dm_IN].[fctFinanceOpeningBalance] AS
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
 WHERE Company IN ('OCS')
GO
