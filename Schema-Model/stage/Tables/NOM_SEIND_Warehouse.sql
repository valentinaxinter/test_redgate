﻿/*
    This script was generated by SQL Change Automation to help provide object-level history. This script should never be edited manually.
    For more information see: https://www.red-gate.com/sca/dev/offline-schema-model
*/

CREATE TABLE [stage].[NOM_SEIND_Warehouse]
(
[PartitionKey] [varchar] (50) NOT NULL,
[Company] [nvarchar] (8) NULL,
[WarehouseCode] [nvarchar] (10) NOT NULL,
[WarehouseName] [nvarchar] (100) NULL
)
GO
