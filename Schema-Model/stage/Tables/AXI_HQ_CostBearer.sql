﻿/*
    This script was generated by SQL Change Automation to help provide object-level history. This script should never be edited manually.
    For more information see: https://www.red-gate.com/sca/dev/offline-schema-model
*/

CREATE TABLE [stage].[AXI_HQ_CostBearer]
(
[PartitionKey] [varchar] (50) NULL,
[Company] [nvarchar] (50) NOT NULL,
[CostBearerNum] [nvarchar] (50) NOT NULL,
[CostBearerName] [nvarchar] (100) NULL,
[CostBearerStatus] [nvarchar] (100) NULL,
[CostBearerGroup] [nvarchar] (100) NULL,
[CostBearerGroup2] [nvarchar] (100) NULL,
[CostBearerGroup3] [nvarchar] (100) NULL,
[CBRes1] [nvarchar] (100) NULL,
[CBRes2] [nvarchar] (100) NULL,
[CBRes3] [nvarchar] (100) NULL
)
GO