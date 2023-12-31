﻿/*
    This script was generated by SQL Change Automation to help provide object-level history. This script should never be edited manually.
    For more information see: https://www.red-gate.com/sca/dev/offline-schema-model
*/

CREATE TABLE [stage].[OCS_SE_FinanceBudget]
(
[PartitionKey] [nvarchar] (50) NULL,
[Company] [nvarchar] (8) NULL,
[ID] [nvarchar] (50) NULL,
[BudgetNo] [nvarchar] (50) NULL,
[LineNo] [nvarchar] (50) NULL,
[AccountNum] [nvarchar] (50) NULL,
[AccountGroupNum] [nvarchar] (200) NULL,
[CostUnitNum] [nvarchar] (50) NULL,
[BudgetPeriod] [nvarchar] (50) NULL,
[BudgetPeriodDate] [nvarchar] (50) NULL,
[BudgetFinance] [decimal] (18, 4) NULL,
[ExchangeRate] [decimal] (18, 4) NULL,
[Currency] [nvarchar] (50) NULL,
[BudgetName] [nvarchar] (50) NULL,
[BudgetDescription] [nvarchar] (max) NULL,
[ProjectNum] [nvarchar] (50) NULL,
[CreatedTimeStamp] [nvarchar] (50) NULL,
[ModifiedTimeStamp] [nvarchar] (50) NULL
)
GO
