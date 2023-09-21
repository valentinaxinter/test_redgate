IF OBJECT_ID('[dm].[FactBudget]') IS NOT NULL
	DROP VIEW [dm].[FactBudget];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO








/****** Script for SelectTopNRows command from SSMS  ******/

CREATE   VIEW [dm].[FactBudget] AS


SELECT CONVERT(bigint, [BudgetID]) AS [BudgetID]
      ,CONVERT(bigint, [CustomerID]) AS [CustomerID]
      ,CONVERT(bigint, [CompanyID]) AS [CompanyID]
      ,CONVERT(bigint, [PartID]) AS [PartID]
      ,CONVERT(bigint, [WarehouseID]) AS [WarehouseID]
      ,CONVERT(bigint, [ProjectID]) AS [ProjectID]
	  ,CONVERT(bigint, [DepartmentID]) AS [DepartmentID]
      ,[BudgetPeriodDateID]
      ,[PartitionKey]
      ,[BudgetType]
      ,[BudgetName]
      ,[BudgetDescription]
      ,[Company]
      ,[BudgetPeriod]
      ,[BudgetPeriodDate]
      ,[PeriodType]
      ,[CustomerNum]
      ,[PartNum]
      ,[SalesPersonCode]
      ,[SalesPersonName]
      ,[BudgetSales]
      ,[BudgetCost]
      ,[GrossProfitInvoiced]
      ,[GrossMarginInvoicedPercent]
      ,[BudgetFinance]
      ,[WarehouseCode]
      ,[CostBearerNum]
      ,[CostUnitNum]
      ,[ProjectNum]
	  ,AccountNum
	  ,AccountGroupNum
  FROM [dw].[Budget]
GO
