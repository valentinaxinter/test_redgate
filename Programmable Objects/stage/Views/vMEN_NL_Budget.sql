IF OBJECT_ID('[stage].[vMEN_NL_Budget]') IS NOT NULL
	DROP VIEW [stage].[vMEN_NL_Budget];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE view [stage].[vMEN_NL_Budget] as 

with company_correct as (
select
	CASE 
		WHEN Company = '14' THEN  CONCAT(N'MENBE',Company) 
		ELSE  CONCAT(N'MENNL',Company)  
	END AS CompanyCorrect,
	'' AS PartNum,
	[PartitionKey], [Company], [AccountNum], [BudgetPeriod], [BudgetPeriodDate], [PeriodType], [CustomerNum], [ProjectNum], [CustomerGroup], [ProductGroup], [SalesPersonCode], [SalesPersonName], [BudgetDescription], [Currency], [ExchangeRate], [BudgetSales], [BudgetCost], [BudgetGrossProfit], [BudgetGrossMargin], [BudgetType], [Department], [Bres3]
from stage.MEN_NL_Budget
)
select
	CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM(CompanyCorrect),'#', BudgetPeriodDate, '#', TRIM(BudgetType), '#', TRIM(Department))))) AS BudgetID
	,CONVERT([binary](32),HASHBYTES('SHA2_256',CONCAT(TRIM(CompanyCorrect),'#',TRIM(CustomerNum)))) AS CustomerID
	,CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(TRIM(CompanyCorrect)))) AS CompanyID
	,CONVERT([binary](32),HASHBYTES('SHA2_256',CONCAT(CompanyCorrect,'#',[PartNum]))) AS PartID
	,CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM(CompanyCorrect),'#',null)))) AS WarehouseID
	,CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM(CompanyCorrect),'#',null)))) AS ProjectID
	,CONVERT([binary](32),HASHBYTES('SHA2_256',CONCAT(CompanyCorrect,'#',trim(Department)))) AS DepartmentID
	,YEAR(BudgetPeriodDate)*10000 + MONTH(BudgetPeriodDate)*100 + DAY(BudgetPeriodDate)	AS BudgetPeriodDateID
	,PartitionKey
	,CompanyCorrect as Company
	,cast(BudgetPeriodDate as date) as BudgetPeriodDate
	,Currency
	,LTRIM(RTRIM(CASE 
        WHEN BudgetSales like '%E-%' THEN CAST(CAST(BudgetSales AS FLOAT) AS DECIMAL(22,4))
        WHEN BudgetSales like '%E+%' THEN CAST(CAST(BudgetSales AS FLOAT) AS DECIMAL)
        ELSE cast(BudgetSales  as decimal(22,4))
    END)) as BudgetSales
	,LTRIM(RTRIM(CASE 
        WHEN BudgetCost like '%E-%' THEN CAST(CAST(BudgetCost AS FLOAT) AS DECIMAL(22,4))
        WHEN BudgetCost like '%E+%' THEN CAST(CAST(BudgetCost AS FLOAT) AS DECIMAL)
        ELSE cast(BudgetCost as decimal(22,4))
    END)) as BudgetCost
	,BudgetCost as budget_cost_stage
	--the names in this fields are not using in the dwtable. VA
	,LTRIM(RTRIM(CASE 
        WHEN BudgetGrossProfit like '%E-%' THEN CAST(CAST(BudgetGrossProfit AS FLOAT) AS DECIMAL(22,4))
        WHEN BudgetGrossProfit like '%E+%' THEN CAST(CAST(BudgetGrossProfit AS FLOAT) AS DECIMAL)
        ELSE cast(BudgetGrossProfit as decimal(22,4))
    END)) as BudgetGrossProfit --the names in this fields are not using in the dwtable. VA
	,LTRIM(RTRIM(CASE 
        WHEN BudgetGrossMargin like '%E-%' THEN CAST(CAST(BudgetGrossMargin AS FLOAT) AS DECIMAL(18,4))
        WHEN BudgetGrossMargin like '%E+%' THEN CAST(CAST(BudgetGrossMargin AS FLOAT) AS DECIMAL)
        ELSE cast(BudgetGrossMargin as decimal(18,4))
    END)) as BudgetGrossMargin --the names in this fields are not using in the dwtable. VA
	,BudgetType
	,Department
from company_correct
GO
