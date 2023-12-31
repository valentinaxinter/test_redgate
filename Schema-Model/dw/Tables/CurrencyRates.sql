﻿/*
    This script was generated by SQL Change Automation to help provide object-level history. This script should never be edited manually.
    For more information see: https://www.red-gate.com/sca/dev/offline-schema-model
*/

CREATE TABLE [dw].[CurrencyRates]
(
[period] [nvarchar] (50) NULL,
[actuality] [nvarchar] (50) NULL,
[currency_code] [nvarchar] (50) NULL,
[currency_type] [nvarchar] (50) NULL,
[unit] [decimal] (18, 6) NULL,
[currency_rate] [decimal] (18, 6) NULL
)
GO
