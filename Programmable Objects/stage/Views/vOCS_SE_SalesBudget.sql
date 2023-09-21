IF OBJECT_ID('[stage].[vOCS_SE_SalesBudget]') IS NOT NULL
	DROP VIEW [stage].[vOCS_SE_SalesBudget];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO














/****** Script for SelectTopNRows command from SSMS  ******/

CREATE VIEW [stage].[vOCS_SE_SalesBudget] AS
-- This view has proven to be problematic to find a reliable PK and since it's sort of a fact table it's not required to have a strong PK in the same way. But our current set up requires a PK due to using MERGE. 
-- I construct an artificial PK with ROW_NUMBER instead of including all t
WITH CTE AS (
SELECT distinct
	 PartitionKey
 	  ,[Company]
	  ,ProjectNum
	  ,AccountNum
      ,YearMonth
      ,CustomerNum
	  ,LEFT(YearMonth,4) + '-' + RIGHT(YearMonth,2) + '-' + '01'	as test
	  ,TRY_CAST(LEFT(YearMonth,4) + '-' + RIGHT(YearMonth,2) + '-' + '01' AS date) AS test2
	  ,[ProductGroup]
      ,[CustomerGroup]
	  ,SalesPersonName
	  ,[BudgetDescription]
      ,BudgetSales AS SalesInvoiceAmount
      ,BudgetCost	AS CostInvoiceAmount
	  ,BudgetGrossProfit AS GrossProfitInvoiced
	  ,BudgetGrossMargin AS [GrossMarginInvoiced%]
	  ,ROW_NUMBER() OVER (PARTITION BY [AccountNum], CustomerNum, YearMonth, ProjectNum, BudgetDescription ORDER BY BudgetSales, BudgetCost) AS RowNum
	   FROM [stage].[OCS_SE_SalesBudget]
	   WHERE YearMonth <> 0
)


SELECT 
	 CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(Company,'#', YearMonth, '#', TRIM(CustomerNum), '#', TRIM(ProjectNum), '#', TRIM(AccountNum), '#',  TRIM([BudgetDescription]), '#', RowNum )))) AS BudgetID
	 ,CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(TRIM([Company])))) AS CompanyID
	 ,PartitionKey
	  ,YearMonth AS BudgetPeriod
      ,CAST(LEFT(YearMonth,4) + '-' + RIGHT(YearMonth,2) + '-' + '01' AS date)	AS BudgetPeriodDate 
	  ,'YearMonth' AS PeriodType
		,LEFT(YearMonth,4) AS [YEAR]
		,RIGHT(YearMonth,2) AS [Month]

	  ,[Company]
      ,CustomerNum AS CustomerNum
	  ,ProjectNum
	  ,AccountNum
      ,[CustomerGroup]
	  ,[ProductGroup]
      , '' AS SalesPersonCode
	  ,SalesPersonName
	  ,[BudgetDescription]
      ,SalesInvoiceAmount	AS BudgetSales
      ,CostInvoiceAmount	AS BudgetCost
	  ,'SEK' AS Currency
	  ,GrossProfitInvoiced
	  ,[GrossMarginInvoiced%]	AS GrossMarginInvoiced
	  ,CONCAT(UPPER(Company), '.',CustomerNum ) AS [CustomerKey]
      ,CONCAT(UPPER(Company), '.',CustomerGroup) AS [CustomerGroupKey]
      ,CONCAT(UPPER(Company), '.',ProductGroup) AS[ProductGroupKey]
      ,CONCAT(UPPER(Company), '.','')	AS[SalesPersonCodeKey]
      ,CONCAT(UPPER(Company), '.',SalesPersonName)	AS [SalesPersonNameKey]
      ,CONCAT(UPPER(Company), '.',ProjectNum)	AS [ProjectKey]
      ,CONCAT(UPPER(Company), '.',AccountNum)	AS [AccountKey]
	   FROM CTE
GO
