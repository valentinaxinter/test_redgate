IF OBJECT_ID('[dm_IN].[fctFinanceBudget]') IS NOT NULL
	DROP VIEW [dm_IN].[fctFinanceBudget];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE VIEW [dm_IN].[fctFinanceBudget]	AS

SELECT fb.[BudgetID]
,fb.[CompanyID]
,fb.[AccountID]
,fb.[CostUnitID]
,fb.[CostBearerID]
,fb.[ProjectID]
,fb.[PartitionKey]
,fb.[BudgetType]
,fb.[BudgetName]
,fb.[BudgetDescription]
,fb.[Company]
,fb.[BudgetPeriod]
,fb.[BudgetPeriodDate]
,fb.[PeriodType]
,fb.[Currency]
,fb.[BudgetFinance]
,fb.[CostBearerNum]
,fb.[CostUnitNum]
,fb.[AccountNum]
,fb.[AccountGroup]
,fb.[ProjectNum]
,fb.[BRes1]
,fb.[BRes2]
,fb.[BRes3]
,fb.[ExchangeRate]
,fb.[IsActiveRecord]
FROM [dm].[FactFinanceBudget] fb
LEFT JOIN dbo.Company com ON fb.Company = com.Company
WHERE com.BusinessArea = 'Industrial Solutions' AND com.[Status] = 'Active'

--WHERE Company IN ('CNOCERT')
GO
