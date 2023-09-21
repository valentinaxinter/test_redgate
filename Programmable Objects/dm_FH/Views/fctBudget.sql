IF OBJECT_ID('[dm_FH].[fctBudget]') IS NOT NULL
	DROP VIEW [dm_FH].[fctBudget];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [dm_FH].[fctBudget] AS

SELECT bdg.[BudgetID]
,bdg.[CustomerID]
,bdg.[CompanyID]
,bdg.[PartID]
,bdg.[WarehouseID]
,bdg.[ProjectID]
,bdg.[DepartmentID]
,bdg.[BudgetPeriodDateID]
,bdg.[PartitionKey]
,bdg.[BudgetType]
,bdg.[BudgetName]
,bdg.[BudgetDescription]
,bdg.[Company]
,bdg.[BudgetPeriod]
,bdg.[BudgetPeriodDate]
,bdg.[PeriodType]
,bdg.[CustomerNum]
,bdg.[PartNum]
,bdg.[SalesPersonCode]
,bdg.[SalesPersonName]
,bdg.[BudgetSales]
,bdg.[BudgetCost]
,bdg.[GrossProfitInvoiced]
,bdg.[GrossMarginInvoicedPercent]
,bdg.[BudgetFinance]
,bdg.[WarehouseCode]
,bdg.[CostBearerNum]
,bdg.[CostUnitNum]
,bdg.[ProjectNum]
,bdg.[AccountNum]
,bdg.[AccountGroupNum]
FROM dm.FactBudget as  bdg
LEFT JOIN dbo.Company com ON bdg.Company = com.Company
WHERE com.BusinessArea = 'Fluid Handling Solutions' AND com.[Status] = 'Active'
GO
