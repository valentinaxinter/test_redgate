﻿/*
    This script was generated by SQL Change Automation to help provide object-level history. This script should never be edited manually.
    For more information see: https://www.red-gate.com/sca/dev/offline-schema-model
*/

CREATE TABLE [stage].[FOR_ES_StockTransaction]
(
[PartitionKey] [varchar] (50) NOT NULL,
[Company] [nvarchar] (8) NOT NULL,
[CostPrice] [nvarchar] (80) NULL,
[Currency] [nvarchar] (80) NULL,
[CustomerNum] [nvarchar] (80) NULL,
[IndexKey] [int] NULL,
[PartNum] [nvarchar] (80) NULL,
[Reference] [nvarchar] (80) NULL,
[SupplierNum] [nvarchar] (80) NULL,
[TransactionCode] [nvarchar] (80) NULL,
[TransactionDate] [nvarchar] (80) NULL,
[TransactionDescription] [nvarchar] (80) NULL,
[TransactionQty] [decimal] (18, 4) NULL,
[TransactionType] [nvarchar] (80) NULL,
[TransactionValue] [decimal] (18, 4) NULL,
[WarehouseCode] [nvarchar] (80) NULL
)
GO
