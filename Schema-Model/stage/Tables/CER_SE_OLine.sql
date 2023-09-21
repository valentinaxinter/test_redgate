﻿/*
    This script was generated by SQL Change Automation to help provide object-level history. This script should never be edited manually.
    For more information see: https://www.red-gate.com/sca/dev/offline-schema-model
*/

CREATE TABLE [stage].[CER_SE_OLine]
(
[PartitionKey] [varchar] (50) NOT NULL,
[Company] [nvarchar] (8) NOT NULL,
[CustNum] [nvarchar] (50) NULL,
[OrderNum] [nvarchar] (50) NULL,
[OrderLine] [nvarchar] (50) NULL,
[OrderSubLine] [nvarchar] (50) NULL,
[OrderRelNum] [nvarchar] (50) NULL,
[OrderType] [nvarchar] (50) NULL,
[OrderDate] [date] NULL,
[DelivDate] [date] NULL,
[InvoiceNum] [nvarchar] (50) NULL,
[OrderQty] [decimal] (38, 8) NULL,
[DelivQty] [decimal] (38, 8) NULL,
[RemainingQty] [decimal] (38, 8) NULL,
[UnitPrice] [numeric] (28, 8) NULL,
[UnitCost] [numeric] (28, 8) NULL,
[CurrencyCode] [nchar] (10) NULL,
[CurrExchRate] [decimal] (28, 8) NULL,
[OpenRelease] [nvarchar] (1) NULL,
[DiscountPercent] [decimal] (38, 6) NULL,
[DiscountAmount] [numeric] (38, 6) NULL,
[PartNum] [nvarchar] (50) NULL,
[PartStatus] [nvarchar] (50) NULL,
[NeedbyDate] [date] NULL,
[SalesPerson] [nvarchar] (50) NULL,
[ReturnComment] [nvarchar] (100) NULL,
[SalesReturnOrderNum] [nvarchar] (50) NULL,
[SalesReturnInvoiceNum] [nvarchar] (50) NULL,
[WarehouseCode] [nvarchar] (50) NULL
)
GO
