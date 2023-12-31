﻿/*
    This script was generated by SQL Change Automation to help provide object-level history. This script should never be edited manually.
    For more information see: https://www.red-gate.com/sca/dev/offline-schema-model
*/

CREATE TABLE [stage].[JEN_SK_Warehouse]
(
[PartitionKey] [varchar] (50) NOT NULL,
[Company] [nvarchar] (8) NOT NULL,
[WarehouseNum] [nvarchar] (50) NOT NULL,
[WarehouseName] [nvarchar] (100) NULL,
[Addressline1] [nvarchar] (200) NULL,
[Addressline2] [nvarchar] (200) NULL,
[Addressline3] [nvarchar] (200) NULL,
[City] [nvarchar] (100) NULL
)
GO
