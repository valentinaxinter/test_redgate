﻿/*
    This script was generated by SQL Change Automation to help provide object-level history. This script should never be edited manually.
    For more information see: https://www.red-gate.com/sca/dev/offline-schema-model
*/

CREATE TABLE [stage].[Financials]
(
[duns] [int] NULL,
[organization.financials.financialStatementToDate] [nvarchar] (100) NULL,
[organization.financials.yearlyRevenue.value] [nvarchar] (100) NULL,
[organization.financials.yearlyRevenue.currency] [nvarchar] (100) NULL
)
GO
