IF OBJECT_ID('[dm_LS].[fctFinanceOpeningBalance]') IS NOT NULL
	DROP VIEW [dm_LS].[fctFinanceOpeningBalance];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


/****** Script for SelectTopNRows command from SSMS  ******/
CREATE VIEW [dm_LS].[fctFinanceOpeningBalance] AS
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
 WHERE Company IN ('CNOCERT')
GO
