﻿/*
    This script was generated by SQL Change Automation to help provide object-level history. This script should never be edited manually.
    For more information see: https://www.red-gate.com/sca/dev/offline-schema-model
*/

CREATE TABLE [stage].[FOR_SE_OpenBalance]
(
[PartitionKey] [varchar] (50) NOT NULL,
[Company] [nvarchar] (8) NULL,
[AccountNum] [nvarchar] (50) NULL,
[CostUnitNum] [nvarchar] (50) NULL,
[JournalDate] [date] NULL,
[Description] [nvarchar] (500) NULL,
[FiscalYear] [nvarchar] (50) NULL,
[FiscalPeriod] [nvarchar] (50) NULL,
[AmountSystemCurrency] [decimal] (18, 4) NULL,
[Currency] [nvarchar] (50) NULL,
[ExchangeRate] [decimal] (18, 4) NULL
)
GO