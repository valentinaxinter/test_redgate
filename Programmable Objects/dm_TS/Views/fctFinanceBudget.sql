IF OBJECT_ID('[dm_TS].[fctFinanceBudget]') IS NOT NULL
	DROP VIEW [dm_TS].[fctFinanceBudget];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE   VIEW [dm_TS].[fctFinanceBudget]	AS
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
WHERE (com.BusinessArea = 'Transport Solutions' OR com.Company = 'CERPL') AND com.[Status] = 'Active'

--WHERE Company  IN ('FESFORA', 'FSEFORA', 'FFRFORA', 'FORPL', 'CERPL', 'FFRGPI', 'FFRLEX', 'IFIWIDN', 'IEEWIDN', 'TMTFI', 'TMTEE', 'FITMT', 'EETMT', 'ABKSE', 'ROROSE','STESE')
GO
