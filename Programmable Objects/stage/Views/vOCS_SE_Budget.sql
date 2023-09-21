IF OBJECT_ID('[stage].[vOCS_SE_Budget]') IS NOT NULL
	DROP VIEW [stage].[vOCS_SE_Budget];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [stage].[vOCS_SE_Budget] AS
--Some troubles with finding a column combination for PK
WITH CTE AS (
SELECT distinct
	 PartitionKey
 	  ,[Company]
	  ,ProjectNum
	  ,AccountNum
      ,YearMonth
      ,CustomerNum
	  ,[ProductGroup]
      ,[CustomerGroup]
	  ,SalesPersonName
	  ,[BudgetDescription]
      ,BudgetSales 
      ,BudgetCost
	  ,BudgetGrossProfit AS GrossProfitInvoiced
	  ,BudgetGrossMargin AS [GrossMarginInvoicedPercent]
	  ,BudgetNo
	  ,ROW_NUMBER() OVER (PARTITION BY [AccountNum], CustomerNum, YearMonth, ProjectNum, BudgetDescription ORDER BY BudgetSales, BudgetCost) AS RowNum
	   FROM [stage].[OCS_SE_Budget]
	   WHERE YearMonth <> 0 AND AccountNum >= '3000'
)

--COMMENT EMPTY FIELDS // ADD TRIM() INTO CustomerID 2022-12-21 VA
SELECT 
	 CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(Company,'#', YearMonth, '#', TRIM(CustomerNum), '#', TRIM(ProjectNum), '#', TRIM(AccountNum), '#',  TRIM([BudgetDescription]), '#', RowNum )))) AS BudgetID
	 ,CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM(Company),'#',TRIM(CustomerNum))))) AS CustomerID
	 --,CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(Company,'#',TRIM(CustomerNum))))) AS CustomerID
	 ,CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(TRIM([Company])))) AS CompanyID
	 ,CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM([Company]),'#',TRIM([ProductGroup]))))) AS PartID
	 ,CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM([Company]),'#',null)))) AS WarehouseID
	 ,CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM([Company]),'#',ProjectNum)))) AS ProjectID
	 ,PartitionKey
	 ,CAST(YearMonth AS int)*100 + 1	AS BudgetPeriodDateID
 	  ,[Company]
	  ,YearMonth AS BudgetPeriod
      ,CAST(LEFT(YearMonth,4) + '-' + RIGHT(YearMonth,2) + '-' + '01' AS date)	AS BudgetPeriodDate 
	  ,'Monthly' AS PeriodType
      ,CustomerNum AS CustomerNum
	  ,[ProductGroup] AS  PartNum
	  ,[ProductGroup]
      ,[CustomerGroup]
      --, '' AS SalesPersonCode
	  ,SalesPersonName
	  ,CASE WHEN BudgetNo = '5' THEN '5 Calculation'
			WHEN BudgetNo = '6' THEN '6 CR'
			WHEN BudgetNo = '50' THEN '50 Additional costs'
			END AS BudgetType
	  ,LEFT([BudgetDescription],100) AS BudgetName
	  ,[BudgetDescription]
      ,CASE WHEN CAST(AccountNum as int) BETWEEN 3000 and 3999 THEN  BudgetSales - BudgetCost ELSE 0 END	AS BudgetSales
      ,CASE WHEN CAST(AccountNum as int) >= 4000 THEN  BudgetCost - BudgetSales ELSE 0 END	AS BudgetCost
	  ,'SEK' AS Currency
	  --,0	AS BudgetFinance
	  ,GrossProfitInvoiced
	  ,[GrossMarginInvoicedPercent]
	  --,'' AS WarehouseCode
	  --,'' AS CostBearerNum
	  --,'' AS CostUnitNum
	  ,ProjectNum
	  ,AccountNum
	  --,'' AS AccountGroupNum
	  --,'' AS BRes1
	  --,'' AS BRes2
	  --,'' AS BRes3
	   FROM CTE
GO
