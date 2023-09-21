IF OBJECT_ID('[dm_IN].[fctBudget]') IS NOT NULL
	DROP VIEW [dm_IN].[fctBudget];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE VIEW [dm_IN].[fctBudget] AS

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
FROM dm.FactBudget as bdg
WHERE bdg.Company in ('OCSSE')

--GROUP BY   -- Aggregate those fields in dw.FactOrder which have more than one values, such as different NeedbyDate & DelivDate and different discountPercent, left over fields should by in GROUP BY
GO
