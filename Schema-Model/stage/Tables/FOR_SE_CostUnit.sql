﻿/*
    This script was generated by SQL Change Automation to help provide object-level history. This script should never be edited manually.
    For more information see: https://www.red-gate.com/sca/dev/offline-schema-model
*/

CREATE TABLE [stage].[FOR_SE_CostUnit]
(
[PartitionKey] [varchar] (50) NOT NULL,
[Company] [nvarchar] (8) NULL,
[CostUnitNum] [nvarchar] (50) NULL,
[CostUnitName] [nvarchar] (100) NULL,
[CostUnitStatus] [nvarchar] (50) NULL,
[CostUnitGroup] [nvarchar] (50) NULL,
[CostUnitGroup2] [nvarchar] (50) NULL,
[CostUnitGroup3] [nvarchar] (50) NULL,
[RecordIsActive] [nvarchar] (50) NULL
)
GO