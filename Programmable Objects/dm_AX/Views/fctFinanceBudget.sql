IF OBJECT_ID('[dm_AX].[fctFinanceBudget]') IS NOT NULL
	DROP VIEW [dm_AX].[fctFinanceBudget];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




/****** Script for SelectTopNRows command from SSMS  ******/
CREATE VIEW [dm_AX].[fctFinanceBudget]	AS

SELECT  [BudgetID]
,[CompanyID]
,[AccountID]
,[CostUnitID]
,[CostBearerID]
,[ProjectID]
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
  FROM [dm].[FactFinanceBudget]
WHERE [Company] in ('AXISE','AXHSE') -- HQ basket
GO
