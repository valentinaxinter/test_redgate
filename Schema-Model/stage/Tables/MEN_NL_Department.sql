﻿/*
    This script was generated by SQL Change Automation to help provide object-level history. This script should never be edited manually.
    For more information see: https://www.red-gate.com/sca/dev/offline-schema-model
*/

CREATE TABLE [stage].[MEN_NL_Department]
(
[PartitionKey] [varchar] (50) NOT NULL,
[Company] [nvarchar] (12) NOT NULL,
[Department] [nvarchar] (50) NULL,
[DepartmentText] [nvarchar] (50) NULL,
[DW_TimeStamp] [nvarchar] (30) NULL
)
GO
