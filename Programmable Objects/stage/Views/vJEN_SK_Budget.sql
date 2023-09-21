IF OBJECT_ID('[stage].[vJEN_SK_Budget]') IS NOT NULL
	DROP VIEW [stage].[vJEN_SK_Budget];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE view [stage].[vJEN_SK_Budget] as
select 
 
	CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM(Company),'#', cast(BudgetPeriod as date),TRIM(CustomerNum))))) AS BudgetID,
	CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(trim(Company)))) AS CompanyID,
	CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM([Company]),'#',null)))) AS ProjectID,
	CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM([Company]),'#',null)))) AS WarehouseID,
	CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM([Company]),'#',null)))) AS PartID,
	CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM([Company]),'#',TRIM(CustomerNum))))) AS CustomerID,
	YEAR(cast(BudgetPeriod as date))*10000 + MONTH(cast(BudgetPeriod as date))*100 + DAY(cast(BudgetPeriod as date))	AS BudgetPeriodDateID,
	PartitionKey,
	Company,
	cast(BudgetPeriod as date) AS BudgetPeriodDate,
	PeriodType,
	try_cast(replace(BudgetSales               ,',','.') as numeric(18,5)) as BudgetSales ,
	try_cast(replace(BudgetCost                ,',','.') as numeric(18,5)) as BudgetCost 
from stage.JEN_SK_Budget
;
GO
