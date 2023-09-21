﻿/*
    This script was generated by SQL Change Automation to help provide object-level history. This script should never be edited manually.
    For more information see: https://www.red-gate.com/sca/dev/offline-schema-model
*/

CREATE TABLE [stage].[CER_DK_SOLine]
(
[PartitionKey] [varchar] (50) NOT NULL,
[Company] [nvarchar] (8) NOT NULL,
[InvoiceDate] [date] NULL,
[ActualDeliveryDate] [date] NULL,
[SalesPersonName] [nvarchar] (100) NULL,
[CustNum] [nvarchar] (50) NULL,
[OrderNum] [nvarchar] (50) NULL,
[OrderLine] [nvarchar] (50) NULL,
[OrderSubLine] [nvarchar] (50) NULL,
[OrderRel] [nvarchar] (50) NULL,
[InvoiceNum] [nvarchar] (50) NULL,
[InvoiceLine] [nvarchar] (50) NULL,
[CreditMemo] [nvarchar] (50) NULL,
[PartNum] [nvarchar] (50) NULL,
[SellingShipQty] [decimal] (18, 4) NULL,
[UnitPrice] [decimal] (18, 4) NULL,
[PrePostUnitCost] [decimal] (18, 4) NULL,
[UnitCost] [decimal] (18, 4) NULL,
[DiscountAmount] [decimal] (18, 4) NULL,
[TotalMiscChrg] [decimal] (18, 4) NULL,
[VAT] [decimal] (18, 4) NULL,
[Currency] [nvarchar] (50) NULL,
[ExchangeRate] [decimal] (18, 4) NULL,
[SalesChannel] [nvarchar] (50) NULL,
[WarehouseCode] [nvarchar] (50) NULL,
[Indexkey] [nvarchar] (50) NULL,
[Site] [nvarchar] (50) NULL,
[ReturnNum] [nvarchar] (50) NULL,
[ReturnComment] [nvarchar] (max) NULL,
[ProjectNum] [nvarchar] (50) NULL
)
GO
