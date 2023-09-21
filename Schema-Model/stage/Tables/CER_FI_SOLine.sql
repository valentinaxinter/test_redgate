﻿/*
    This script was generated by SQL Change Automation to help provide object-level history. This script should never be edited manually.
    For more information see: https://www.red-gate.com/sca/dev/offline-schema-model
*/

CREATE TABLE [stage].[CER_FI_SOLine]
(
[PartitionKey] [varchar] (50) NOT NULL,
[Company] [nvarchar] (8) NOT NULL,
[InvoiceDate] [date] NULL,
[ActualDeliveryDate] [date] NULL,
[SalesPerson] [nvarchar] (100) NULL,
[CustNum] [nvarchar] (50) NULL,
[OrderNum] [varchar] (50) NULL,
[OrderLine] [varchar] (50) NULL,
[OrderSubLine] [varchar] (50) NULL,
[InvoiceNum] [varchar] (50) NULL,
[InvoiceLine] [varchar] (50) NULL,
[CreditMemo] [varchar] (50) NULL,
[PartNum] [varchar] (50) NULL,
[SellingShipQty] [decimal] (18, 4) NULL,
[UnitPrice] [decimal] (18, 4) NULL,
[UnitCost] [decimal] (18, 4) NULL,
[CostCenter] [nvarchar] (50) NULL,
[DiscountAmount] [decimal] (18, 4) NULL,
[TotalMiscChrg] [decimal] (18, 4) NULL,
[WarehouseCode] [varchar] (50) NULL,
[Indexkey] [varchar] (50) NULL,
[Site] [nvarchar] (50) NULL,
[OrderType] [nvarchar] (50) NULL,
[Currency] [nvarchar] (50) NULL,
[ExchangeRate] [decimal] (18, 4) NULL,
[ReturnComment] [nvarchar] (max) NULL,
[ReturnNum] [nvarchar] (50) NULL
)
GO
