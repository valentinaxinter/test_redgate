IF OBJECT_ID('[stage].[vOCS_SE_FinanceBudget]') IS NOT NULL
	DROP VIEW [stage].[vOCS_SE_FinanceBudget];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO





CREATE VIEW [stage].[vOCS_SE_FinanceBudget] AS 

SELECT
	CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM(b.Company),'#', TRIM(b.[AccountNum]), '#', TRIM(ID), '#', TRIM(ProjectNum), '#', TRIM([BudgetPeriod]), '#', TRIM(BudgetName), '#', TRIM([BudgetDescription]))))) AS BudgetID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(TRIM(b.[Company])))) AS CompanyID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM(b.Company), '#', TRIM(b.AccountNum))))) AS AccountID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM(b.[Company]), '#', TRIM(CostUnitNum))))) AS CostUnitID
	--,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM(b.[Company]), '#', TRIM(ProjectNum))))) AS CostBearerID removed 2023-03-22 SB
	,CONVERT([binary](32),HASHBYTES('SHA2_256',CONCAT(TRIM([COMPANY]),'#',[ProjectNum]))) AS ProjectID -- added 2023-03-22 SB
	,b.PartitionKey AS PartitionKey

	,UPPER(b.Company) AS Company
	,CASE WHEN left(AccountNum,1) IN ('3','4','5','6','7','8','9') then BudgetFinance * -1 
	      ELSE BudgetFinance END AS BudgetFinance -- case logic added 2023-04-19 SB. Revenue account budget amounts need to be flipped
	,BudgetName AS [PeriodType]
	,IIF([Currency] = '€UR','EUR',trim([Currency])) As [Currency]
	,IIF([Currency] = 'SEK',1, ExchangeRate) AS ExchangeRate
	,[BudgetPeriod] 
	,IIF(BudgetPeriodDate = 0, '1900-01-01', CONVERT(date, CONCAT(LEFT(BudgetPeriodDate, 4), '-', Substring(BudgetPeriodDate, 5,2), '-', RIGHT(BudgetPeriodDate, 2)))) AS BudgetPeriodDate
	,IIF(BudgetPeriodDate = 0, 'Year', 'Month') AS BudgetType
	,[BudgetName]
	,[BudgetDescription]
	,trim([ProjectNum]) as ProjectNum -- added 2023-03-22 SB
	,'' AS [CostBearerNum]
	,ID AS [CostUnitNum]
	,b.[AccountNum] AS [AccountNum]
	,'' AS [AccountGroup]
	,IIF(trim(BudgetNo) IN ('5','6','50'), 'Project Budget', 'Account Budget')      AS BRes1
	,BudgetNo AS BRes2
	,[LineNo] AS BRes3
FROM stage.OCS_SE_FinanceBudget b
--where trim(BudgetNo) NOT IN ('5','6','50') OR (trim(BudgetNo)  IN ('5','6','50') and (BudgetFinance > 0 OR left(trim(accountnum),1) = '3')) removed 2023-05-09 SB

--  LEFT JOIN stage.vOCS_SE_Account a ON a.AccountNum = b.AccountNum  -- copied from AXISE script, added 2023-01-31 by SB
--where LEFT(BudgetPeriod, 4) > '2022' --and BudgetPeriodDate != 0
GO
