IF OBJECT_ID('[stage].[vSCM_FI_Budget]') IS NOT NULL
	DROP VIEW [stage].[vSCM_FI_Budget];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create view [stage].[vSCM_FI_Budget]  as

select 
 
	CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM(Company),'#', cast(CONCAT(BudgetPeriod,'-01') as date))))) AS BudgetID,
	CONVERT([binary](32),HASHBYTES('SHA2_256',Company)) AS CompanyID,
	CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM([Company]),'#',null)))) AS ProjectID,
	CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM([Company]),'#',null)))) AS WarehouseID,
	CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM([Company]),'#',null)))) AS PartID,
	CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM([Company]),'#',null)))) AS CustomerID,
	YEAR(cast(CONCAT(BudgetPeriod,'-01') as date))*10000 + MONTH(cast(CONCAT(BudgetPeriod,'-01') as date))*100 + DAY(cast(CONCAT(BudgetPeriod,'-01') as date))	AS BudgetPeriodDateID,
	PartitionKey,
	Company,
	cast(CONCAT(BudgetPeriod,'-01') as date) AS BudgetPeriodDate,
	PeriodType,
	try_cast(replace(BudgetSales               ,',','.') as numeric(18,5)) as BudgetSales ,
	try_cast(replace(BudgetCost                ,',','.') as numeric(18,5)) as BudgetCost 
from stage.SCM_FI_Budget
;
GO
