IF OBJECT_ID('[stage].[vAXI_HQ_FinanceBudget]') IS NOT NULL
	DROP VIEW [stage].[vAXI_HQ_FinanceBudget];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO







/****** Script for SelectTopNRows command from SSMS  ******/
CREATE VIEW [stage].[vAXI_HQ_FinanceBudget] AS
SELECT  
		CONVERT(binary(32), HASHBYTES('SHA2_256',CONCAT(b.Company,'#',FiscalPeriod,'#', b.AccountNum,'#',CostUnitNum ))) AS BudgetID
		,CONVERT(binary(32), HASHBYTES('SHA2_256',b.Company)) AS CompanyID
		,CONVERT(binary(32), HASHBYTES('SHA2_256',CONCAT(b.Company, '#', b.[AccountNum]))) AS AccountID
		,CONVERT(binary(32), HASHBYTES('SHA2_256',CONCAT(b.Company,'#', IIF(CostUnitNum='000---',N'000000',RIGHT(N'000000' + CostUnitNum,6)))) ) AS CostUnitID
		,CONVERT(binary(32), HASHBYTES('SHA2_256',CONCAT(b.Company,'#', CostBearerNum)) ) AS CostBearerID
	  ,CONVERT(varchar, GETDATE(), 23) AS PartitionKey

      ,[BudgetType]
      ,[BudgetName]
      ,[BudgetDescription]
      ,b.[Company]
      ,[FiscalPeriod]	AS BudgetPeriod
      ,[FiscalPeriodDate]	AS BudgetPeriodDate
      ,[PeriodType]
	  ,'SEK'	AS Currency
      ,CASE WHEN a.AccountType = 'R' AND a.Revenue = '1' THEN ABS([Budget])
			WHEN a.AccountType = 'R' AND COALESCE(a.Revenue,'0') <> '1' THEN ABS([Budget])*-1 
			ELSE Budget	END	AS BudgetFinance	
      ,[CostBearerNum]
      ,RIGHT('000000' + CostUnitNum,6)	AS [CostUnitNum]
      ,b.[AccountNum]
      ,b.[AccountGroupNum]	AS AccountGroup
	  ,'' AS BRes1
	  ,'' AS BRes2
	  ,'' AS BRes3
  FROM [stage].[AXI_HQ_Budget] b
  LEFT JOIN stage.vAXI_HQ_Account_excel a ON a.AccountNum = b.AccountNum 
  where upper(b.Company) = 'AXISE'
/*  GROUP BY b.[PartitionKey]
      ,[BudgetType],[BudgetName],[BudgetDescription],[Company],[FiscalPeriod],[FiscalPeriodDate],[PeriodType],[CostBearerNum],[CostUnitNum],b.[AccountNum],b.[AccountGroupNum]
	  */
GO
