﻿/*
    This script was generated by SQL Change Automation to help provide object-level history. This script should never be edited manually.
    For more information see: https://www.red-gate.com/sca/dev/offline-schema-model
*/

CREATE TABLE [stage].[TRA_SE_Warehouse]
(
[PartitionKey] [varchar] (50) NOT NULL,
[Company] [nvarchar] (10) NOT NULL,
[WarehouseCode] [nvarchar] (50) NOT NULL,
[WarehouseName] [nvarchar] (100) NULL,
[WarehouseAddress] [nvarchar] (100) NULL,
[WarehouseCountry] [nvarchar] (50) NULL,
[Site] [nvarchar] (50) NULL
)
GO
