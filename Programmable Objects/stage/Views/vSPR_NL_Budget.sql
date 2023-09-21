IF OBJECT_ID('[stage].[vSPR_NL_Budget]') IS NOT NULL
	DROP VIEW [stage].[vSPR_NL_Budget];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create view [stage].[vSPR_NL_Budget] as
select 
	CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM(Company),'#', cast(BudgetPeriodDate as date))))) AS BudgetID,
	CONVERT([binary](32),HASHBYTES('SHA2_256',upper(trim(Company)))) AS CompanyID,
	CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM([Company]),'#',null)))) AS ProjectID,
	CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM([Company]),'#',null)))) AS WarehouseID,
	CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM([Company]),'#',null)))) AS PartID,
	CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM([Company]),'#',null)))) AS CustomerID,
	YEAR(cast(BudgetPeriodDate as date))*10000 + MONTH(cast(BudgetPeriodDate as date))*100 + DAY(cast(BudgetPeriodDate as date))	AS BudgetPeriodDateID,
	PartitionKey,
	Company,
	cast(BudgetPeriodDate as date) AS BudgetPeriodDate,
	PeriodType,
	try_cast(replace(BudgetSales               ,',','.') as numeric(18,5)) as BudgetSales 
from stage.SPR_NL_Budget
;
GO
