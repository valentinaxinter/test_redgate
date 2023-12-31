﻿/*
    This script was generated by SQL Change Automation to help provide object-level history. This script should never be edited manually.
    For more information see: https://www.red-gate.com/sca/dev/offline-schema-model
*/

CREATE TABLE [stage].[JEN_NO_SupplierAgreement]
(
[PartitionKey] [varchar] (50) NOT NULL,
[Company] [nvarchar] (8) NOT NULL,
[RecordType] [nvarchar] (50) NULL,
[RecordTypeDesc] [nvarchar] (50) NULL,
[SupplierNum] [nvarchar] (50) NOT NULL,
[PartNum] [nvarchar] (50) NULL,
[Discount] [nvarchar] (50) NULL,
[UnitPrice] [decimal] (18, 4) NULL,
[Qty] [decimal] (18, 4) NULL,
[DelivTimeWeeks] [nvarchar] (10) NULL,
[CurrencyCode] [nvarchar] (10) NULL
)
GO
