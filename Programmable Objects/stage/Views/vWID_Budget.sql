IF OBJECT_ID('[stage].[vWID_Budget]') IS NOT NULL
	DROP VIEW [stage].[vWID_Budget];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

/****** Script for SelectTopNRows command from SSMS  ******/
CREATE VIEW [stage].[vWID_Budget] AS

SELECT 	
	CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM(Company),'#', [YearMonth], '#', TRIM([CustomerGroup]), '#', TRIM([ProductGroup]) )))) AS BudgetID
	,CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM(Company),'#',TRIM([CustomerGroup]))))) AS CustomerID
	,CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(TRIM([Company])))) AS CompanyID
	,CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM([Company]),'#',TRIM([ProductGroup]))))) AS PartID
	,CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM([Company]),'#','')))) AS WarehouseID
	,CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM([Company]),'#','')))) AS ProjectID
	,YEAR([YearMonth])*10000 + MONTH([YearMonth])*100 + DAY([YearMonth])	AS BudgetPeriodDateID
	,CONVERT(varchar(50), getdate(), 23) AS PartitionKey --Temporary added

	,NULL AS [BudgetType]
      ,NULL AS [BudgetName]
      ,NULL AS[BudgetDescription]
      ,[Company]
      ,LEFT(CAST([YearMonth] AS varchar(50)), 6)	AS	[BudgetPeriod]
      ,[YearMonth]	AS [BudgetPeriodDate]
      ,'Monthly'	AS [PeriodType]
      ,CONCAT('BUD','-' + CustomerGroup) AS [CustomerNum]
      ,[CustomerGroup]
      ,CONCAT('BUD','-' + ProductGroup) AS [PartNum]
      ,[ProductGroup]
      ,NULL AS [SalesPersonCode]
      ,[SalesPersonName]
      ,[BudgetSales]
      ,[BudgetSales] - BudgetProfit AS [BudgetCost]
      ,'EUR' AS [Currency]
      ,BudgetProfit AS [GrossProfitInvoiced]
      ,BudgetProfit/[BudgetSales] AS [GrossMarginInvoicedPercent]
      ,NULL AS [BudgetFinance]
      ,NULL AS [WarehouseCode]
      ,NULL AS [CostBearerNum]
      ,NULL AS [CostUnitNum]
      ,NULL AS [ProjectNum]
      ,NULL AS [AccountNum]
      ,NULL AS [AccountGroupNum]
      ,NULL AS [BRes1]
      ,NULL AS [BRes2]
      ,NULL AS [BRes3]
  FROM [dbo].[SalesBudget_Widni]
GO
