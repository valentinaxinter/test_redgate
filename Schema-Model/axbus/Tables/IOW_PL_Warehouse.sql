﻿/*
    This script was generated by SQL Change Automation to help provide object-level history. This script should never be edited manually.
    For more information see: https://www.red-gate.com/sca/dev/offline-schema-model
*/

CREATE TABLE [axbus].[IOW_PL_Warehouse]
(
[PartitionKey] [nvarchar] (50) NULL,
[Company] [nvarchar] (50) NOT NULL,
[WarehouseCode] [nvarchar] (50) NOT NULL,
[WarehouseName] [nvarchar] (100) NULL,
[WarehouseDistrict] [nvarchar] (100) NULL,
[WarehouseAddress] [nvarchar] (100) NULL,
[WarehouseDescription] [nvarchar] (100) NULL,
[WarehouseType] [nvarchar] (50) NULL,
[WarehouseCountry] [nvarchar] (100) NULL,
[Site] [nvarchar] (100) NULL
)
GO