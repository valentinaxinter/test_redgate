﻿/*
    This script was generated by SQL Change Automation to help provide object-level history. This script should never be edited manually.
    For more information see: https://www.red-gate.com/sca/dev/offline-schema-model
*/

CREATE TABLE [stage].[OCS_SE_SalesBudget]
(
[PartitionKey] [nvarchar] (50) NOT NULL,
[Company] [nvarchar] (50) NOT NULL,
[YearMonth] [nvarchar] (50) NOT NULL,
[CustomerNum] [nvarchar] (50) NULL,
[ProjectNum] [nvarchar] (50) NULL,
[CustomerGroup] [nvarchar] (50) NULL,
[ProductGroup] [nvarchar] (50) NULL,
[SalesPersonName] [nvarchar] (200) NULL,
[BudgetDescription] [nvarchar] (500) NULL,
[BudgetSales] [decimal] (18, 4) NULL,
[BudgetCost] [decimal] (18, 4) NULL,
[BudgetGrossProfit] [decimal] (18, 4) NULL,
[BudgetGrossMargin] [decimal] (18, 4) NULL,
[AccountNum] [nvarchar] (50) NULL,
[BudgetNo] [nvarchar] (50) NULL,
[LnNo] [nvarchar] (50) NULL
)
GO
