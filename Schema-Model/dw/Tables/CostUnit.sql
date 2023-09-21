﻿/*
    This script was generated by SQL Change Automation to help provide object-level history. This script should never be edited manually.
    For more information see: https://www.red-gate.com/sca/dev/offline-schema-model
*/

CREATE TABLE [dw].[CostUnit]
(
[CostUnitID] [binary] (32) NOT NULL,
[CostUnitCode] [nvarchar] (200) NULL,
[CompanyID] [binary] (32) NOT NULL,
[PartitionKey] [varchar] (50) NULL,
[Company] [nvarchar] (8) NOT NULL,
[CostUnitNum] [nvarchar] (50) NOT NULL,
[CostUnitName] [nvarchar] (100) NULL,
[CostUnitStatus] [nvarchar] (100) NULL,
[CostUnitGroup] [nvarchar] (100) NULL,
[CostUnitGroup2] [nvarchar] (100) NULL,
[CostUnitGroup3] [nvarchar] (100) NULL,
[CURes1] [nvarchar] (100) NULL,
[CURes2] [nvarchar] (100) NULL,
[CURes3] [nvarchar] (100) NULL,
[is_deleted] [bit] NULL,
[is_inferred] [bit] NULL,
[CostUnitGroup1] [nvarchar] (100) NULL,
[IsActiveRecord] [bit] NULL
)
GO
ALTER TABLE [dw].[CostUnit] ADD CONSTRAINT [PK_CostUnit] PRIMARY KEY CLUSTERED ([CostUnitID])
GO