﻿/*
    This script was generated by SQL Change Automation to help provide object-level history. This script should never be edited manually.
    For more information see: https://www.red-gate.com/sca/dev/offline-schema-model
*/

CREATE TABLE [stage].[OCS_SE_OpenBalance]
(
[PartitionKey] [nvarchar] (50) NOT NULL,
[Company] [nvarchar] (8) NOT NULL,
[AccountNum] [nvarchar] (50) NOT NULL,
[AccountingDate] [nvarchar] (50) NOT NULL,
[Currency] [nvarchar] (50) NOT NULL,
[ExchangeRate] [nvarchar] (50) NULL,
[OpeningBalance] [nvarchar] (50) NULL,
[CreatedTimeStamp] [nvarchar] (50) NULL,
[ModifiedTimeStamp] [nvarchar] (50) NULL
)
GO
