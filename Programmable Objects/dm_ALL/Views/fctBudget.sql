IF OBJECT_ID('[dm_ALL].[fctBudget]') IS NOT NULL
	DROP VIEW [dm_ALL].[fctBudget];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [dm_ALL].[fctBudget] AS

SELECT  [BudgetID]
,[CustomerID]
,[CompanyID]
,[PartID]
,[WarehouseID]
,[ProjectID]
,[DepartmentID]
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
,[AccountNum]
,[AccountGroupNum]
FROM dm.FactBudget
GO
