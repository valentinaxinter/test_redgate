﻿/*
    This script was generated by SQL Change Automation to help provide object-level history. This script should never be edited manually.
    For more information see: https://www.red-gate.com/sca/dev/offline-schema-model
*/

CREATE TABLE [stage].[CYE_ES_SOLine]
(
[PartitionKey] [varchar] (50) NOT NULL,
[Company] [nvarchar] (8) NOT NULL,
[InvoiceDate] [datetime] NULL,
[SalesPerson] [nvarchar] (50) NULL,
[CustNum] [nvarchar] (50) NULL,
[OrderNum] [nvarchar] (50) NULL,
[OrderLine] [nvarchar] (50) NULL,
[OrderRel] [nvarchar] (50) NULL,
[InvoiceNum] [nvarchar] (50) NULL,
[InvoiceLine] [nvarchar] (50) NULL,
[InvoiceType] [nvarchar] (50) NULL,
[CreditMemo] [nvarchar] (50) NULL,
[PartNum] [nvarchar] (50) NULL,
[SellingShipQty] [decimal] (28, 8) NULL,
[UnitPrice] [decimal] (28, 8) NULL,
[UnitCost] [decimal] (28, 8) NULL,
[DiscountAmount] [decimal] (38, 8) NULL,
[TotalMiscChrg] [decimal] (28, 8) NULL,
[WarehouseCode] [nvarchar] (50) NULL,
[Indexkey] [nvarchar] (50) NULL,
[UnitCostEK02] [decimal] (28, 8) NULL,
[DiscountPercent] [decimal] (28, 8) NULL,
[SalesOfficeDescrip] [nvarchar] (max) NULL,
[SalesGroupCode] [nvarchar] (50) NULL,
[SalesGroupDescrip] [nvarchar] (max) NULL,
[ActualDeliveryDate] [date] NULL,
[ReturnNum] [nvarchar] (50) NULL,
[ReturnComment] [nvarchar] (max) NULL
)
GO