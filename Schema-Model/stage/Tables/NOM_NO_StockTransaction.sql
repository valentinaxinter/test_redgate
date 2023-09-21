﻿/*
    This script was generated by SQL Change Automation to help provide object-level history. This script should never be edited manually.
    For more information see: https://www.red-gate.com/sca/dev/offline-schema-model
*/

CREATE TABLE [stage].[NOM_NO_StockTransaction]
(
[PartitionKey] [nvarchar] (50) NOT NULL,
[Company] [nvarchar] (8) NOT NULL,
[IndexKey] [nvarchar] (50) NOT NULL,
[WarehouseCode] [nvarchar] (50) NULL,
[TransactionCode] [nvarchar] (50) NULL,
[TransactionDescription] [varchar] (100) NULL,
[TransactionType] [nvarchar] (50) NULL,
[IssuerReceiverNum] [nvarchar] (50) NULL,
[OrderNum] [nchar] (50) NULL,
[OrderLine] [nchar] (50) NULL,
[InvoiceNum] [nvarchar] (50) NULL,
[InvoiceLine] [nvarchar] (50) NULL,
[PartNum] [nvarchar] (50) NULL,
[BinNum] [nvarchar] (50) NULL,
[BatchNum] [nvarchar] (50) NULL,
[TransactionDate] [date] NULL,
[TransactionTime] [nvarchar] (10) NULL,
[CreateDate] [date] NULL,
[FIFOBatchID] [nvarchar] (50) NULL,
[SupplierBatchID] [nvarchar] (50) NULL,
[TransactionQty] [decimal] (18, 4) NULL,
[TransactionValue] [decimal] (18, 4) NULL,
[CostPrice] [decimal] (18, 4) NULL,
[SalesUnitPrice] [decimal] (18, 4) NULL,
[Currency] [nvarchar] (10) NULL,
[Reference] [nvarchar] (50) NULL,
[AdjustmentDate] [date] NULL,
[InternalExternal] [nvarchar] (50) NULL
)
GO
