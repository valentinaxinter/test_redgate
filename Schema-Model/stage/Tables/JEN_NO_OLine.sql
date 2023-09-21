﻿/*
    This script was generated by SQL Change Automation to help provide object-level history. This script should never be edited manually.
    For more information see: https://www.red-gate.com/sca/dev/offline-schema-model
*/

CREATE TABLE [stage].[JEN_NO_OLine]
(
[PartitionKey] [varchar] (50) NOT NULL,
[Company] [nvarchar] (8) NOT NULL,
[CustNum] [nvarchar] (50) NULL,
[OrderNum] [nvarchar] (50) NULL,
[OrderLine] [nvarchar] (50) NULL,
[OrderSubLine] [nvarchar] (50) NULL,
[OrderRelNum] [nvarchar] (50) NULL,
[OrderType] [nvarchar] (50) NULL,
[ERPOrderStatus] [nvarchar] (50) NULL,
[OrderDate] [date] NULL,
[NeedbyDate] [date] NULL,
[DelivDate] [date] NULL,
[ConfirmedDelivDate] [date] NULL,
[InvoiceNum] [nvarchar] (50) NULL,
[OrderQty] [decimal] (18, 4) NULL,
[DelivQty] [decimal] (18, 4) NULL,
[RemainingQty] [decimal] (18, 4) NULL,
[UnitPrice] [decimal] (18, 4) NULL,
[UnitCost] [decimal] (18, 4) NULL,
[SumUnitCost] [decimal] (18, 4) NULL,
[SumUnitPrice] [decimal] (18, 4) NULL,
[CurrencyCode] [nvarchar] (50) NULL,
[CurrExchRate] [decimal] (18, 4) NULL,
[OpenRelease] [nvarchar] (1) NULL,
[DiscountPercent] [decimal] (18, 4) NULL,
[DiscountAmount] [decimal] (18, 4) NULL,
[Site] [nvarchar] (50) NULL,
[PartNum] [nvarchar] (50) NULL,
[PartStatus] [nvarchar] (50) NULL,
[SalesPerson] [nvarchar] (50) NULL,
[ReturnComment] [nvarchar] (500) NULL,
[SalesReturnOrderNum] [nvarchar] (50) NULL,
[SalesReturnInvoiceNum] [nvarchar] (50) NULL,
[WarehouseCode] [nvarchar] (50) NULL
)
GO
