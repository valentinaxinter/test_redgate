IF OBJECT_ID('[dm_PT].[fctBudget]') IS NOT NULL
	DROP VIEW [dm_PT].[fctBudget];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [dm_PT].[fctBudget] AS

SELECT [bdg].[BudgetID], [bdg].[CustomerID], [bdg].[CompanyID], [bdg].[PartID], [bdg].[WarehouseID], [bdg].[ProjectID], [bdg].[DepartmentID], [bdg].[BudgetPeriodDateID], [bdg].[PartitionKey], [bdg].[BudgetType], [bdg].[BudgetName], [bdg].[BudgetDescription], [bdg].[Company], [bdg].[BudgetPeriod], [bdg].[BudgetPeriodDate], [bdg].[PeriodType], [bdg].[CustomerNum], [bdg].[PartNum], [bdg].[SalesPersonCode], [bdg].[SalesPersonName], [bdg].[BudgetSales], [bdg].[BudgetCost], [bdg].[GrossProfitInvoiced], [bdg].[GrossMarginInvoicedPercent], [bdg].[BudgetFinance], [bdg].[WarehouseCode], [bdg].[CostBearerNum], [bdg].[CostUnitNum], [bdg].[ProjectNum], [bdg].[AccountNum], [bdg].[AccountGroupNum]
FROM dm.FactBudget bdg
LEFT JOIN dbo.Company com ON bdg.Company = com.Company
WHERE com.BusinessArea = 'Power Transmission Solutions' AND com.[Status] = 'Active'

--WHERE [Company] in ('ACZARKOV', 'AcornUK', 'BSIBELL', 'JDKJENSS', 'JDKKALTE', 'JFIJENSS', 'MNLMAK', 'JNOJENSS', 'JNOORBEL', 'JSEJENSS', 'JSESKSSW', 'NomoSE', 'NomoDK', 'NomoFI', 'NomoNo', 'PASSEROT', 'SKSSCOFI', 'SCOFI', 'SMKFI', 'SNLSPRUI', 'SVESE')  -- The PT basket


--GROUP BY   -- Aggregate those fields in dw.FactOrder which have more than one values, such as different NeedbyDate & DelivDate and different discountPercent, left over fields should by in GROUP BY
GO
