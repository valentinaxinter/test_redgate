IF OBJECT_ID('[stage].[vFOR_SE_FinanceBudget]') IS NOT NULL
	DROP VIEW [stage].[vFOR_SE_FinanceBudget];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO








CREATE VIEW [stage].[vFOR_SE_FinanceBudget] AS 

select
	CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM(b.Company),'#', TRIM(b.[AccountNum]), '#', TRIM(b.AccountGroup), '#', TRIM(CostUnitNum), '#', TRIM([YEAR]))))) AS BudgetID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(TRIM(b.[Company])))) AS CompanyID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM(b.Company), '#', TRIM(b.AccountNum))))) AS AccountID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM(b.[Company]), '#', TRIM(CostUnitNum))))) AS CostUnitID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM(b.[Company]), '#', TRIM(CostBearerNum))))) AS CostBearerID
	,'2023-02-13' AS PartitionKey
	,UPPER(b.Company) AS Company
	,CASE WHEN a.AccountType = 'R' AND a.Revenue = '1' THEN ABS(CAST(REPLACE(BudgetFinance, ',', '.') AS decimal(18,2)))
			WHEN a.AccountType = 'R' AND COALESCE(a.Revenue,'0') <> '1' THEN ABS(CAST(REPLACE(BudgetFinance, ',', '.') AS decimal(18,2)))*-1 
			ELSE CAST(REPLACE(BudgetFinance, ',', '.') AS decimal(18,2))	END	AS BudgetFinance	--CAST(REPLACE(BudgetFinance, ',', '.')*-1 AS decimal(18,2)) AS BudgetFinance
	,[PeriodType]
	,[Currency]
	,[Year] as [BudgetPeriod] 
--	,CAST(CONCAT(LEFT([Year], 4), '-', RIGHT([Year],2), '-01') AS DATE) AS BudgetPeriodDate
	,BudgetType
	,[BudgetName]
	,[BudgetDescription]
	,[CostBearerNum]
	,[CostUnitNum]
	,b.[AccountNum]
	,b.[AccountGroup]
	,[CreatedTimeStamp] AS BRes1
	,[ModifiedTimeStamp] AS BRes2
	,ModifiedTimeStamp AS BRes3
from stage.FOR_SE_Budget b
  LEFT JOIN stage.vFOR_SE_Account a ON a.AccountNum = b.AccountNum  -- copied from AXISE script, added 2023-01-31 by SB
  where upper(b.Company) = 'FSEFORA' and [Year] = '2023'
GO
