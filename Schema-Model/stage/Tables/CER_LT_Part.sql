﻿/*
    This script was generated by SQL Change Automation to help provide object-level history. This script should never be edited manually.
    For more information see: https://www.red-gate.com/sca/dev/offline-schema-model
*/

CREATE TABLE [stage].[CER_LT_Part]
(
[PartitionKey] [varchar] (50) NOT NULL,
[Company] [nvarchar] (8) NULL,
[PartNum] [nvarchar] (50) NULL,
[PartDescription] [nvarchar] (max) NULL,
[PartDescription2] [nvarchar] (max) NULL,
[ProductGroup] [nvarchar] (50) NULL,
[ProductGroup2] [nvarchar] (50) NULL,
[ProductGroup3] [nvarchar] (50) NULL,
[ProductGroup4] [nvarchar] (50) NULL,
[CommodityCode] [nvarchar] (50) NULL,
[CountryOfOrigin] [nvarchar] (50) NULL,
[NetWeight] [decimal] (18, 4) NULL,
[SupplierCode] [nvarchar] (50) NULL,
[ReorderLevel] [decimal] (18, 4) NULL,
[EAN] [nvarchar] (50) NULL
)
GO
