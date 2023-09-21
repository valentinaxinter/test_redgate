﻿/*
    This script was generated by SQL Change Automation to help provide object-level history. This script should never be edited manually.
    For more information see: https://www.red-gate.com/sca/dev/offline-schema-model
*/

CREATE TABLE [stage].[SVE_SE_Part]
(
[PartitionKey] [nvarchar] (50) NULL,
[Company] [nvarchar] (8) NULL,
[PartNum] [nvarchar] (50) NULL,
[PartName] [nvarchar] (max) NULL,
[PartDescription] [nvarchar] (max) NULL,
[PartDescription2] [nvarchar] (max) NULL,
[PartDescription3] [nvarchar] (max) NULL,
[ProductGroup] [nvarchar] (50) NULL,
[ProductGroup2] [nvarchar] (50) NULL,
[ProductGroup3] [nvarchar] (50) NULL,
[ProductGroup4] [nvarchar] (max) NULL,
[PrimarySupplier] [nvarchar] (50) NULL,
[Brand] [nvarchar] (50) NULL,
[CommodityCode] [nvarchar] (50) NULL,
[PartReplacementNum] [nvarchar] (max) NULL,
[PartStatus] [nvarchar] (50) NULL,
[CountryOfOrigin] [nvarchar] (max) NULL,
[NetWeight] [nvarchar] (50) NULL,
[UoM] [nvarchar] (50) NULL,
[Material] [nvarchar] (50) NULL,
[Barcode] [nvarchar] (50) NULL,
[ReOrderLevel] [nvarchar] (max) NULL,
[PartResponsible] [nvarchar] (max) NULL,
[StartDate] [nvarchar] (8) NULL,
[EndDate] [nvarchar] (max) NULL,
[PARes1] [nvarchar] (max) NULL,
[PARes2] [nvarchar] (max) NULL,
[PARes3] [nvarchar] (max) NULL
)
GO
CREATE NONCLUSTERED INDEX [IX_SVE_SE_Part] ON [stage].[SVE_SE_Part] ([PartNum])
GO