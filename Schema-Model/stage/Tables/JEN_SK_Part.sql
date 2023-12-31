﻿/*
    This script was generated by SQL Change Automation to help provide object-level history. This script should never be edited manually.
    For more information see: https://www.red-gate.com/sca/dev/offline-schema-model
*/

CREATE TABLE [stage].[JEN_SK_Part]
(
[PartitionKey] [varchar] (50) NOT NULL,
[Company] [nvarchar] (8) NULL,
[PartNum] [nvarchar] (50) NULL,
[PartDescription] [nvarchar] (100) NULL,
[PartDescription2] [nvarchar] (200) NULL,
[ProductGroup] [nvarchar] (50) NULL,
[ProductGroup2] [nvarchar] (200) NULL,
[CommodityCode] [nvarchar] (50) NULL,
[CountryOfOrigin] [nvarchar] (50) NULL,
[NetWeight] [decimal] (18, 4) NULL,
[SupplierCode] [nvarchar] (50) NULL,
[ReorderLevel] [decimal] (18, 4) NULL,
[EAN] [nvarchar] (50) NULL,
[StockItemStatus] [nvarchar] (50) NULL
)
GO
