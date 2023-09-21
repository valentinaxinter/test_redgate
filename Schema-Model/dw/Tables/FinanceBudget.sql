﻿/*
    This script was generated by SQL Change Automation to help provide object-level history. This script should never be edited manually.
    For more information see: https://www.red-gate.com/sca/dev/offline-schema-model
*/

CREATE TABLE [dw].[FinanceBudget]
(
[BudgetID] [binary] (32) NOT NULL,
[CompanyID] [binary] (32) NOT NULL,
[AccountID] [binary] (32) NULL,
[CostUnitID] [binary] (32) NULL,
[CostBearerID] [binary] (32) NULL,
[PartitionKey] [nvarchar] (50) NULL,
[BudgetType] [nvarchar] (50) NULL,
[BudgetName] [nvarchar] (100) NULL,
[BudgetDescription] [nvarchar] (500) NULL,
[Company] [nvarchar] (8) NULL,
[BudgetPeriod] [nvarchar] (100) NULL,
[BudgetPeriodDate] [date] NULL,
[PeriodType] [nvarchar] (100) NULL,
[Currency] [nvarchar] (50) NULL,
[BudgetFinance] [decimal] (18, 4) NULL,
[CostBearerNum] [nvarchar] (50) NULL,
[CostUnitNum] [nvarchar] (50) NULL,
[AccountNum] [nvarchar] (50) NULL,
[AccountGroup] [nvarchar] (100) NULL,
[BRes1] [nvarchar] (100) NULL,
[BRes2] [nvarchar] (100) NULL,
[BRes3] [nvarchar] (100) NULL,
[AccountGroupNum] [nvarchar] (50) NULL,
[ExchangeRate] [decimal] (18, 4) NULL,
[IsActiveRecord] [bit] NULL,
[ProjectNum] [nvarchar] (50) NULL,
[ProjectID] [binary] (32) NULL,
[is_deleted] [bit] NULL
)
GO
ALTER TABLE [dw].[FinanceBudget] ADD CONSTRAINT [PK__FinanceB__E38E79C42395773F] PRIMARY KEY CLUSTERED ([BudgetID])
GO
