IF OBJECT_ID('[stage].[vMAK_NL_Budget]') IS NOT NULL
	DROP VIEW [stage].[vMAK_NL_Budget];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE view [stage].[vMAK_NL_Budget] as 

select 
	CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM(Company),'#', BudgetPeriodDate)))) AS BudgetID,
	CONVERT([binary](32),HASHBYTES('SHA2_256',Company)) AS CompanyID,
	CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM([Company]),'')))) AS ProjectID,
	CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM([Company]),'')))) AS WarehouseID,
	CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM([Company]),'')))) AS PartID,
	CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM([Company]),'')))) AS CustomerID,
	YEAR(BudgetPeriodDate)*10000 + MONTH(BudgetPeriodDate)*100 + DAY(BudgetPeriodDate)	AS BudgetPeriodDateID,
	PartitionKey,
	Company,
	BudgetPeriodDate,
	PeriodType,
	try_cast(replace(BudgetSales               ,',','.') as numeric(18,5)) as BudgetSales ,
	try_cast(replace(BudgetCost                ,',','.') as numeric(18,5)) as BudgetCost ,
	try_cast(replace(GrossProfitInvoiced       ,',','.') as numeric(18,5)) as GrossProfitInvoiced ,
	try_cast(replace(GrossMarginInvoicedPercent,',','.') as numeric(18,5)) as GrossMarginInvoicedPercent ,
	Currency
from [stage].[MAK_NL_Budget]
;
GO
