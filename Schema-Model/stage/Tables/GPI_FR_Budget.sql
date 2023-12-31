﻿/*
    This script was generated by SQL Change Automation to help provide object-level history. This script should never be edited manually.
    For more information see: https://www.red-gate.com/sca/dev/offline-schema-model
*/

CREATE TABLE [stage].[GPI_FR_Budget]
(
[PartitionKey] [varchar] (50) NOT NULL,
[Company] [nvarchar] (8) NOT NULL,
[CustomerNum] [nvarchar] (50) NOT NULL,
[BudgetPeriod] [nvarchar] (50) NULL,
[BudgetPeriodDate] [date] NULL,
[PeriodType] [nvarchar] (50) NULL,
[ProjectNum] [nvarchar] (50) NULL,
[CustomerGroup] [nvarchar] (50) NULL,
[ProductGroup] [nvarchar] (50) NULL,
[SalesPersonCode] [nvarchar] (50) NULL,
[SalesPersonName] [nvarchar] (50) NULL,
[BudgetDescription] [nvarchar] (max) NULL,
[Currency] [nvarchar] (50) NULL,
[BudgetSales] [decimal] (18, 4) NULL,
[BudgetCost] [decimal] (18, 4) NULL,
[BRes1] [nvarchar] (50) NULL,
[BRes2] [nvarchar] (50) NULL,
[Bres3] [nvarchar] (50) NULL
)
GO
