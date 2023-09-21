﻿/*
    This script was generated by SQL Change Automation to help provide object-level history. This script should never be edited manually.
    For more information see: https://www.red-gate.com/sca/dev/offline-schema-model
*/

CREATE TABLE [stage].[JEN_NB_StockBalance]
(
[PartitionKey] [nvarchar] (50) NOT NULL,
[Company] [nvarchar] (8) NOT NULL,
[PartNum] [nvarchar] (70) NOT NULL,
[WarehouseCode] [nvarchar] (50) NOT NULL,
[FIFOValue] [decimal] (18, 4) NULL,
[StockBalance] [decimal] (18, 4) NULL,
[ReservedQty] [decimal] (18, 4) NULL,
[OptimalOrderQty] [decimal] (18, 4) NULL,
[BackOrderQty] [decimal] (18, 4) NULL,
[QtyOrdered] [decimal] (18, 4) NULL,
[StockTakDiff] [decimal] (18, 4) NULL,
[ReOrderLevel] [decimal] (18, 4) NULL,
[AvgWeightedCost] [decimal] (18, 4) NULL,
[AvgCost] [decimal] (18, 4) NULL,
[LandedCost] [decimal] (18, 4) NULL,
[DelivTimeDesc] [nvarchar] (50) NULL,
[DelivTimeUnit] [int] NULL,
[DelivTimeToWHS] [int] NULL,
[SupplierNum] [nvarchar] (50) NULL,
[DefaultBinNo] [nvarchar] (12) NULL,
[BatchNumber] [nvarchar] (50) NULL,
[StockTakDate] [date] NULL,
[StdCostLaCaD] [date] NULL,
[DelivDateSupplier] [date] NULL,
[DelivDateCust] [date] NULL,
[OrderDateSupplier] [date] NULL,
[CurrencyCode] [nvarchar] (50) NULL,
[MaxStockQty] [decimal] (18, 4) NULL
)
GO
