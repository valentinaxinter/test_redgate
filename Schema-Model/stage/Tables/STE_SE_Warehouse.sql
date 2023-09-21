﻿/*
    This script was generated by SQL Change Automation to help provide object-level history. This script should never be edited manually.
    For more information see: https://www.red-gate.com/sca/dev/offline-schema-model
*/

CREATE TABLE [stage].[STE_SE_Warehouse]
(
[PartitionKey] [varchar] (50) NOT NULL,
[Company] [nvarchar] (12) NOT NULL,
[WarehouseCode] [nvarchar] (50) NOT NULL,
[WarehouseName] [nvarchar] (100) NULL,
[WarehouseDistrict] [nvarchar] (50) NULL,
[WarehouseAddress] [nvarchar] (100) NULL,
[WarehouseDescription] [nvarchar] (100) NULL,
[WarehouseType] [nvarchar] (50) NULL,
[WarehouseCountry] [nvarchar] (50) NULL,
[Site] [nvarchar] (50) NULL,
[ZipCode] [nvarchar] (50) NULL,
[City] [nvarchar] (50) NULL,
[CountryOfOriginname] [nvarchar] (50) NULL
)
GO
