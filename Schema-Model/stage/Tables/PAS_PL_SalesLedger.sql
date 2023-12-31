﻿/*
    This script was generated by SQL Change Automation to help provide object-level history. This script should never be edited manually.
    For more information see: https://www.red-gate.com/sca/dev/offline-schema-model
*/

CREATE TABLE [stage].[PAS_PL_SalesLedger]
(
[PartitionKey] [varchar] (50) NOT NULL,
[company] [nvarchar] (8) NULL,
[customernum] [nvarchar] (50) NULL,
[invoicenum] [nvarchar] (50) NULL,
[invoicedate] [date] NULL,
[duedate] [date] NULL,
[lastpaymentdate] [date] NULL,
[res1] [nvarchar] (50) NULL,
[res2] [nvarchar] (50) NULL,
[res3] [nvarchar] (50) NULL
)
GO
