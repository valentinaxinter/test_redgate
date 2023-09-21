﻿/*
    This script was generated by SQL Change Automation to help provide object-level history. This script should never be edited manually.
    For more information see: https://www.red-gate.com/sca/dev/offline-schema-model
*/

CREATE TABLE [stage].[FOR_SE_StockTransaction]
(
[PartitionKey] [nvarchar] (50) NOT NULL,
[Company] [nvarchar] (8) NOT NULL,
[SysRowID] [nvarchar] (50) NOT NULL,
[PartNum] [nvarchar] (50) NULL,
[SellingShipQty] [decimal] (18, 4) NULL,
[BinNum] [nvarchar] (50) NULL,
[BatchNum] [nvarchar] (50) NULL,
[TransactionDate] [date] NULL,
[CreateDate] [date] NULL,
[CreateTime] [nvarchar] (20) NULL,
[TranDT] [nvarchar] (50) NULL,
[WarehouseCode] [nvarchar] (50) NULL,
[PurchaseOrderNum] [nvarchar] (50) NULL,
[PurchaseOrderLine] [nvarchar] (50) NULL,
[OrderNum] [nvarchar] (50) NULL,
[InvoiceNum] [nvarchar] (50) NULL,
[InvoiceLine] [nvarchar] (50) NULL,
[CostPrice] [decimal] (18, 4) NULL,
[CostPrice1] [decimal] (18, 4) NULL,
[SellPrice] [decimal] (18, 4) NULL,
[TranType] [nchar] (10) NULL,
[BatchID] [nvarchar] (50) NULL,
[FifoBatchID] [nvarchar] (50) NULL,
[CurrencyCode] [nvarchar] (50) NULL,
[Exchangerate] [decimal] (18, 4) NULL,
[IssueRecCode] [nvarchar] (50) NULL,
[TranSource] [nvarchar] (50) NULL,
[TranValue] [decimal] (18, 4) NULL,
[TranValue1] [decimal] (18, 4) NULL,
[Reference] [nvarchar] (50) NULL
)
GO
