﻿/*
    This script was generated by SQL Change Automation to help provide object-level history. This script should never be edited manually.
    For more information see: https://www.red-gate.com/sca/dev/offline-schema-model
*/

CREATE TABLE [stage].[ACO_UK_OLine]
(
[PartitionKey] [varchar] (50) NOT NULL,
[Company] [nvarchar] (8) NOT NULL,
[CustNum] [nvarchar] (50) NULL,
[OrderNum] [nvarchar] (50) NULL,
[OrderLine] [nvarchar] (50) NULL,
[OrderSubLine] [nvarchar] (50) NULL,
[OrderType] [nvarchar] (50) NULL,
[OrderDate] [date] NULL,
[NeedByDate] [date] NULL,
[Delivdate] [date] NULL,
[InvoiceNum] [nvarchar] (50) NULL,
[OrderQty] [decimal] (18, 4) NULL,
[DelivQty] [decimal] (18, 4) NULL,
[RemainingQty] [decimal] (18, 4) NULL,
[Unit] [nvarchar] (50) NULL,
[UnitPrice] [decimal] (18, 4) NULL,
[UnitCost] [decimal] (18, 4) NULL,
[Currency] [nvarchar] (50) NULL,
[ExchangeRate] [decimal] (18, 4) NULL,
[OpenRelease] [nvarchar] (10) NULL,
[DiscountPercent] [decimal] (18, 4) NULL,
[DiscountAmount] [decimal] (18, 4) NULL,
[PartNum] [nvarchar] (50) NULL,
[PartStatus] [nvarchar] (50) NULL,
[Site] [nvarchar] (50) NULL,
[SalesPerson] [nvarchar] (50) NULL,
[WarehouseCode] [nvarchar] (50) NULL,
[SalesChannel] [nvarchar] (50) NULL,
[BusinessChain] [nvarchar] (50) NULL,
[Res1] [nvarchar] (100) NULL,
[Res2] [nvarchar] (100) NULL,
[Res3] [nvarchar] (100) NULL
)
GO
