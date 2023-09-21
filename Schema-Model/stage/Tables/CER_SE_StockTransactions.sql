﻿/*
    This script was generated by SQL Change Automation to help provide object-level history. This script should never be edited manually.
    For more information see: https://www.red-gate.com/sca/dev/offline-schema-model
*/

CREATE TABLE [stage].[CER_SE_StockTransactions]
(
[PartitionKey] [nvarchar] (50) NOT NULL,
[Company] [nvarchar] (8) NOT NULL,
[SysRowID] [nchar] (8) NOT NULL,
[PartNum] [nvarchar] (35) NULL,
[OrderNum] [nchar] (30) NULL,
[InvoiceNum] [nvarchar] (30) NULL,
[WarehouseCode] [nvarchar] (6) NULL,
[BinNumber] [nvarchar] (6) NULL,
[BatchID] [nvarchar] (12) NULL,
[FIFOBatchID] [nvarchar] (12) NULL,
[SupplierBatchID] [nvarchar] (20) NULL,
[TranDate] [date] NULL,
[CreateDate] [date] NULL,
[CreateTime] [nvarchar] (10) NULL,
[TranDT] [nvarchar] (50) NULL,
[TranType] [nchar] (2) NULL,
[TranTypeDesc] [varchar] (80) NULL,
[TranSource] [nvarchar] (50) NULL,
[Reference] [nvarchar] (30) NULL,
[TranQty] [decimal] (18, 4) NULL,
[IssuerReceiverCode] [nvarchar] (30) NULL,
[CostPrice] [decimal] (18, 4) NULL,
[SellingPrice] [decimal] (18, 4) NULL,
[CurrencyCode] [nvarchar] (10) NULL,
[ExchangeRate] [decimal] (18, 4) NULL,
[TranValue] [decimal] (18, 4) NULL,
[InternalExternal] [nvarchar] (50) NULL
)
GO