IF OBJECT_ID('[dm].[FactFinanceBudget]') IS NOT NULL
	DROP VIEW [dm].[FactFinanceBudget];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




CREATE VIEW [dm].[FactFinanceBudget]	AS
SELECT 
	  CONVERT(bigint,[BudgetID]) AS [BudgetID]
      , CONVERT(bigint,[CompanyID]) AS [CompanyID]
	  , CONVERT(bigint,[AccountID]) AS [AccountID]
	  , CONVERT(bigint,[CostUnitID]) AS [CostUnitID]
	  , CONVERT(bigint,[CostBearerID]) AS [CostBearerID]
	  , CONVERT(bigint,[ProjectID]) AS [ProjectID] -- added 2023-03-22 SB
      ,[PartitionKey]
      ,[BudgetType]
      ,[BudgetName]
      ,[BudgetDescription]
      ,[Company]
      ,[BudgetPeriod]
      ,[BudgetPeriodDate]
      ,[PeriodType]
      ,[Currency]
      ,[BudgetFinance]
      ,[CostBearerNum]
      ,[CostUnitNum]
      ,[AccountNum]
      ,[AccountGroup]
	  ,[ProjectNum]
      ,[BRes1]
      ,[BRes2]
      ,[BRes3]
      ,[ExchangeRate]
      ,[IsActiveRecord]
  FROM [dw].[FinanceBudget]
GO
