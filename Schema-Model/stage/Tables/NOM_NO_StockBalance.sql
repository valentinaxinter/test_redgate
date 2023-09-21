﻿/*
    This script was generated by SQL Change Automation to help provide object-level history. This script should never be edited manually.
    For more information see: https://www.red-gate.com/sca/dev/offline-schema-model
*/

CREATE TABLE [stage].[NOM_NO_StockBalance]
(
[PartitionKey] [nvarchar] (50) NOT NULL,
[Company] [nvarchar] (8) NOT NULL,
[WarehouseCode] [nvarchar] (50) NOT NULL,
[Currency] [nvarchar] (10) NULL,
[BinNum] [nvarchar] (12) NULL,
[BatchNum] [nvarchar] (50) NULL,
[SupplierNum] [nvarchar] (50) NULL,
[PartNum] [nvarchar] (70) NOT NULL,
[LastStockTakeDate] [nvarchar] (50) NULL,
[LastStdCostDate] [nvarchar] (50) NULL,
[MaxStockQty] [nvarchar] (50) NULL,
[StockBalance] [decimal] (18, 4) NULL,
[StockValue] [decimal] (18, 4) NULL,
[ManualReservations] [decimal] (18, 4) NULL,
[ReserveQty] [nvarchar] (50) NULL,
[BackOrderQty] [decimal] (18, 4) NULL,
[OrderQty] [decimal] (18, 4) NULL,
[StockTakeDiff] [decimal] (18, 4) NULL,
[ReOrderLevel] [decimal] (18, 4) NULL,
[SafetyStock] [decimal] (18, 4) NULL,
[OptimalOrderQty] [decimal] (18, 4) NULL,
[AvgCost] [decimal] (18, 4) NULL,
[DelivTime] [nvarchar] (50) NULL,
[SBRes1] [nvarchar] (50) NULL,
[SBRes2] [nvarchar] (50) NULL,
[SBRes3] [nvarchar] (50) NULL
)
GO
