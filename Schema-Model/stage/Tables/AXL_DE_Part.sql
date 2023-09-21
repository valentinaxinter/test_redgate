﻿/*
    This script was generated by SQL Change Automation to help provide object-level history. This script should never be edited manually.
    For more information see: https://www.red-gate.com/sca/dev/offline-schema-model
*/

CREATE TABLE [stage].[AXL_DE_Part]
(
[PartitionKey] [varchar] (50) NOT NULL,
[Company] [nvarchar] (8) NULL,
[PartNum] [nvarchar] (50) NULL,
[PartName] [nvarchar] (100) NULL,
[PartDescription] [nvarchar] (max) NULL,
[PartDescription2] [nvarchar] (max) NULL,
[PartDescription3] [nvarchar] (max) NULL,
[ProductGroup] [nvarchar] (50) NULL,
[ProductGroup2] [nvarchar] (50) NULL,
[ProductGroup3] [nvarchar] (50) NULL,
[ProductGroup4] [nvarchar] (50) NULL,
[CountryOfOrigin] [nvarchar] (50) NULL,
[Brand] [nvarchar] (50) NULL,
[CommodityCode] [nvarchar] (50) NULL,
[PartNumReplacement] [nvarchar] (50) NULL,
[NetWeight] [decimal] (18, 4) NULL,
[Volume] [decimal] (18, 4) NULL,
[Material] [nvarchar] (50) NULL,
[Barcode] [nvarchar] (50) NULL,
[Reorderlevel] [decimal] (18, 4) NULL,
[MinOrderQty] [decimal] (18, 4) NULL,
[StartDate] [date] NULL,
[EndDate] [date] NULL,
[ItemStatus] [nvarchar] (50) NULL,
[Res1] [nvarchar] (100) NULL,
[Res2] [nvarchar] (100) NULL,
[Res3] [nvarchar] (100) NULL
)
GO
