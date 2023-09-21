IF OBJECT_ID('[stage].[vFOR_FR_BudgetOld]') IS NOT NULL
	DROP VIEW [stage].[vFOR_FR_BudgetOld];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [stage].[vFOR_FR_BudgetOld] AS

-- this budget is in use!!!
SELECT 

	  CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM(Company),'#', '2022', '#', TRIM(CustomerNum), '#', '', '#', '', '#', TRIM(CustomerGroup) )))) AS BudgetID
	  ,CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(TRIM([Company])))) AS CompanyID
	  ,CONVERT(varchar(50), getdate(), 23) AS PartitionKey --Temporary added
	  ,'2022'	AS BudgetPeriod
	  ,DATEFROMPARTS( CAST('2022' AS int) --Year
					, CAST('01' AS int) --Month
						, 1) AS BudgetPeriodDate
		,'2022' AS [YEAR]
		,'01' AS [Month]

	  ,UPPER([Company]) AS Company
      ,CustomerNum
	  ,'' AS ProjectNum
	  ,'' AS AccountNum
	  ,'Yearly' AS PeriodType
--      ,COALESCE(NULLIF(TRIM([CustomerNum]),''), CONCAT('BUD','-' + NULLIF(TRIM(CustomerGroup),''),'-' + NULLIF(TRIM(SalesRepCode),''))) AS CustomerNum
	  ,'' AS ProductGroup
--	  ,IIF(NULLIF(TRIM(ProductGroup2),'') IS NOT NULL,  CONCAT('BUD','-' + NULLIF(TRIM(ProductGroup2),'')), '' ) AS PartNum
	  ,''	AS [SalesPersonCode]
	  ,''				AS [SalesPersonName]
      ,[CustomerGroup]
	  ,'' AS BudgetDescription
      ,'' AS [SalesRepCode]
      ,SUM([BudgetSales]) AS BudgetSales
      ,SUM([BudgetCost]) AS BudgetCost
	  ,SUM([BudgetSales]) - SUM([BudgetCost]) AS GrossProfitInvoiced
	  ,(SUM([BudgetSales]) - SUM([BudgetCost]))/SUM([BudgetSales]) AS GrossMarginInvoiced
	  ,CASE WHEN Company = 'NomoSE' THEN 'SEK'
			WHEN Company = 'NomoFI' THEN 'EUR'
			WHEN Company = 'NomoDK' THEN 'DKK'
			WHEN Company = 'NomoNO' THEN 'NOK'
			ELSE '' END AS Currency
	  ,CONCAT(UPPER(Company), '.', CustomerNum ) AS [CustomerKey]
      ,CONCAT(UPPER(Company), '.', CustomerGroup) AS [CustomerGroupKey]
      ,CONCAT(UPPER(Company), '.', '') AS[ProductGroupKey]
      ,CONCAT(UPPER(Company), '.', '')	AS[SalesPersonCodeKey]
      ,CONCAT(UPPER(Company), '.', '')	AS [SalesPersonNameKey]
      ,CONCAT(UPPER(Company), '.', '')	AS [ProjectKey]
      ,CONCAT(UPPER(Company), '.', '')	AS [AccountKey]
  FROM [stage].[FOR_FR_Budget]
  GROUP BY Company, [CustomerNum], [CustomerGroup]
GO
