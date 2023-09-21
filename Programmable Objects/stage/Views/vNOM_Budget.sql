IF OBJECT_ID('[stage].[vNOM_Budget]') IS NOT NULL
	DROP VIEW [stage].[vNOM_Budget];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


/****** Script for SelectTopNRows command from SSMS  ******/

CREATE VIEW [stage].[vNOM_Budget] AS
WITH tmp AS (
SELECT 
	   CONVERT(varchar(50), getdate(), 112) AS PartitionKey --Temporary added
	  ,UPPER([Company]) AS Company
      ,DATEFROMPARTS( CAST(LEFT(TRIM([Period]),4)  AS int) --Year
					, CAST(RIGHT(TRIM([Period]),2) AS int) --Month
						, 1) AS PeriodDate
	  ,'Monthly' AS PeriodType
      ,COALESCE(NULLIF(TRIM([CustomerNum]),''), CONCAT('BUD','-' + NULLIF(TRIM(CustomerGroup),''),'-' + NULLIF(TRIM(SalesRepCode),''))) AS CustomerNum
	  ,IIF(NULLIF(TRIM(ProductGroup2),'') IS NOT NULL,  CONCAT('BUD','-' + NULLIF(TRIM(ProductGroup2),'')), '' ) AS PartNum
      ,[CustomerGroup]
      ,[SalesRepCode]
      ,[ProductGroup2]
      ,SUM([Sales]) AS Sales
      ,SUM([Cost]) AS Cost
	  
  FROM [stage].[NOM_Budget]
  GROUP BY Company, [Period],[CustomerNum], [CustomerGroup], [SalesRepCode], [ProductGroup2]
  )

SELECT
	 CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM(Company),'#', PeriodDate, '#', TRIM(CustomerNum), '#', TRIM(PartNum) )))) AS BudgetID
	 ,CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM(Company),'#',TRIM(CustomerNum))))) AS CustomerID
	 ,CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(TRIM([Company])))) AS CompanyID
	 ,CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM([Company]),'#',TRIM([PartNum]))))) AS PartID
	 ,CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM([Company]),'#','')))) AS WarehouseID
	 ,CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM([Company]),'#','')))) AS ProjectID
	 ,PartitionKey
	 ,YEAR(PeriodDate)*10000 + MONTH(PeriodDate)*100 + DAY(PeriodDate)	AS BudgetPeriodDateID

 	  ,[Company]
      ,PeriodDate
	  ,PeriodType
      ,CustomerNum
	  ,PartNum
	  ,[ProductGroup2]
      ,[CustomerGroup]
      ,[SalesRepCode]	AS SalesPersonCode
	  ,'' AS SalesPersonName
	  ,'Budget' AS BudgetType
	  ,'' AS BudgetName
      --,[ProductGroup2]	
      ,[Sales] AS SalesInvoiceAmount
      ,[Cost]	AS CostInvoiceAmount
	  ,Sales - Cost AS GrossProfitInvoiced
	  ,(Sales - Cost)/NULLIF(Sales,0) AS GrossMarginInvoicedPercent
	  ,0 AS SalesOrderAmount
	  ,'' AS WarehouseCode
	  ,'' AS CostBearerNum
	  ,'' AS CostUnitNum
	  ,'' AS ProjectNum
	  FROM tmp
GO
