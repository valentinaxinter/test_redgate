﻿/*
    This script was generated by SQL Change Automation to help provide object-level history. This script should never be edited manually.
    For more information see: https://www.red-gate.com/sca/dev/offline-schema-model
*/

CREATE TABLE [stage].[CER_EE_StockBalance]
(
[PartitionKey] [nvarchar] (50) NOT NULL,
[Company] [nvarchar] (8) NOT NULL,
[WarehouseCode] [nvarchar] (50) NOT NULL,
[Currency] [nvarchar] (50) NULL,
[BinNum] [nvarchar] (50) NULL,
[BatchNum] [nvarchar] (50) NULL,
[SupplierNum] [nvarchar] (50) NULL,
[PartNum] [nvarchar] (70) NOT NULL,
[DelivTime] [int] NULL,
[LastStockTakeDate] [date] NULL,
[LastStdCostCalDate] [date] NULL,
[MaxStockQty] [decimal] (18, 4) NULL,
[StockBalance] [decimal] (18, 4) NULL,
[StockValue] [decimal] (18, 4) NULL,
[ReserveQty] [decimal] (18, 4) NULL,
[BackOrderQty] [decimal] (18, 4) NULL,
[OrderQty] [decimal] (18, 4) NULL,
[StockTakeDiff] [decimal] (18, 4) NULL,
[ReOrderLevel] [decimal] (18, 4) NULL,
[OptimalOrderQty] [decimal] (18, 4) NULL
)
GO
