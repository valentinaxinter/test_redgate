IF OBJECT_ID('[dm].[FactFinanceOpeningBalance]') IS NOT NULL
	DROP VIEW [dm].[FactFinanceOpeningBalance];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




/****** Script for SelectTopNRows command from SSMS  ******/

CREATE VIEW [dm].[FactFinanceOpeningBalance] AS
SELECT CONVERT(bigint, [OpenBalanceID]) AS [OpenBalanceID]
	  ,CONVERT(bigint, [AccountID]) AS [AccountID]
      ,CONVERT(bigint, [CostUnitID]) AS [CostUnitID]
      ,CONVERT(bigint, [CostBearerID]) AS [CostBearerID]
      ,CONVERT(bigint, [ProjectID]) AS [ProjectID]
      ,CONVERT(bigint, [CompanyID]) AS [CompanyID]
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
  FROM [dw].[OpenBalance]  -- was [fnc].
GO
