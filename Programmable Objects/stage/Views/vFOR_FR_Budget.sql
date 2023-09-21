IF OBJECT_ID('[stage].[vFOR_FR_Budget]') IS NOT NULL
	DROP VIEW [stage].[vFOR_FR_Budget];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



/****** Script for SelectTopNRows command from SSMS  ******/

CREATE VIEW [stage].[vFOR_FR_Budget] AS
WITH tmp AS (
SELECT 
	   CONVERT(varchar(50), getdate(), 112) AS PartitionKey --Temporary added
	  ,UPPER([Company]) AS Company
      ,DATEFROMPARTS( CAST(2022 AS int) --Year
					, CAST(01 AS int) --Month
						, 1) AS PeriodDate
	  ,'Yearly' AS PeriodType
      ,COALESCE(NULLIF(TRIM([CustomerNum]),''), CONCAT('BUD','-' + NULLIF(TRIM(CustomerGroup),''),'-' + NULLIF(TRIM(SalesPersonCode),''))) AS CustomerNum
	  ,IIF(NULLIF(TRIM(ProductGroup),'') IS NOT NULL,  CONCAT('BUD','-' + NULLIF(TRIM(ProductGroup),'')), '' ) AS PartNum
      ,[CustomerGroup]
      ,[SalesPersonCode]
      ,[ProductGroup]
      ,SUM(CAST([BudgetSales] AS decimal(18,0))) AS Sales
      ,NULL AS Cost --SUM([BudgetCost])
	  
  FROM [stage].[FOR_FR_Budget]
  GROUP BY Company, [CustomerNum], [CustomerGroup], SalesPersonCode, [ProductGroup]
  )

SELECT
	 CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM(Company),'#', PeriodDate, '#', TRIM(CustomerNum), '#', TRIM(PartNum) )))) AS BudgetID
	 ,CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM(Company),'#',TRIM(CustomerNum))))) AS CustomerID
	 ,CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(TRIM([Company])))) AS CompanyID
	 ,CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM([Company]),'#',TRIM([PartNum]))))) AS PartID
	 ,CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM([Company]),'#',null)))) AS WarehouseID
	 ,CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM([Company]),'#',null)))) AS ProjectID
	 ,YEAR(PeriodDate)*10000 + MONTH(PeriodDate)*100 + DAY(PeriodDate)	AS BudgetPeriodDateID
	 ,PartitionKey
	  ,'Yearly' AS BudgetType
	  --,'' AS BudgetName
	  --,'' AS [BudgetDescription]
 	  ,[Company]
	  ,'2022' AS [BudgetPeriod]
      ,PeriodDate AS [BudgetPeriodDate]
	  ,PeriodType
      ,CustomerNum
      ,[CustomerGroup]
	  ,PartNum
 	  ,[ProductGroup]
      --,'' AS SalesPersonCode
	  --,'' AS SalesPersonName
      ,[Sales] AS [BudgetSales]
      ,NULL AS [BudgetCost]
	  ,'EUR' AS [Currency]
	  ,NULL AS GrossProfitInvoiced
	  ,NULL AS [GrossMarginInvoicedPercent] --(Sales - Cost)/NULLIF(Sales, 0)
	  ,NULL AS [BudgetFinance]
	  --,'' AS WarehouseCode
	  --,'' AS CostBearerNum
	  --,'' AS CostUnitNum
	  --,'' AS ProjectNum
	  --,'' AS AccountNum
	  --,'' AS [AccountGroupNum]
--	  ,NULL AS SalesOrderAmount
      --,'' AS [BRes1]
      --,'' AS [BRes2]
      --,'' AS [BRes3]
	  FROM tmp
GO
