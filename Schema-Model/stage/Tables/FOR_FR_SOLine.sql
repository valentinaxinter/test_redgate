﻿/*
    This script was generated by SQL Change Automation to help provide object-level history. This script should never be edited manually.
    For more information see: https://www.red-gate.com/sca/dev/offline-schema-model
*/

CREATE TABLE [stage].[FOR_FR_SOLine]
(
[PartitionKey] [varchar] (50) NOT NULL,
[Company] [nvarchar] (8) NOT NULL,
[InvoiceDate] [date] NULL,
[ActualDeliveryDate] [date] NULL,
[SalesPersonName] [nvarchar] (50) NULL,
[CustomerNum] [nvarchar] (50) NULL,
[OrderNum] [nvarchar] (50) NULL,
[OrderLine] [nvarchar] (50) NULL,
[OrderSubLine] [nvarchar] (50) NULL,
[OrderRel] [nvarchar] (50) NULL,
[InvoiceNum] [nvarchar] (50) NULL,
[InvoiceLine] [nvarchar] (50) NULL,
[CreditMemo] [nvarchar] (50) NULL,
[PartNum] [nvarchar] (50) NULL,
[DelivQty] [decimal] (18, 4) NULL,
[SellingShipQty] [decimal] (18, 4) NULL,
[UnitPrice] [decimal] (22, 8) NULL,
[UnitCost] [decimal] (22, 8) NULL,
[DiscountAmount] [decimal] (18, 4) NULL,
[TotalMiscChrg] [decimal] (18, 4) NULL,
[WarehouseCode] [nvarchar] (50) NULL,
[Site] [nvarchar] (50) NULL,
[OrderType] [nvarchar] (50) NULL,
[IndexKey] [varchar] (10) NULL
)
GO