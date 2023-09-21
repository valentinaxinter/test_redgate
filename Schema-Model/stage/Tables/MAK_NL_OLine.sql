﻿/*
    This script was generated by SQL Change Automation to help provide object-level history. This script should never be edited manually.
    For more information see: https://www.red-gate.com/sca/dev/offline-schema-model
*/

CREATE TABLE [stage].[MAK_NL_OLine]
(
[Company] [nvarchar] (8) NOT NULL,
[CustomerNum] [nvarchar] (50) NULL,
[SalesOrderNum] [nvarchar] (50) NULL,
[SalesOrderLine] [nvarchar] (50) NULL,
[SalesOrderType] [nvarchar] (50) NULL,
[SalesOrderDate] [date] NULL,
[InvoiceNum] [nvarchar] (50) NULL,
[NeedbyDate] [date] NULL,
[ExpDelivDate] [date] NULL,
[ActualDelivDate] [date] NULL,
[CommittedDelivDate] [date] NULL,
[SalesOrderQty] [decimal] (18, 8) NULL,
[DelivQty] [decimal] (18, 8) NULL,
[RemainingQty] [decimal] (18, 8) NULL,
[UoM] [nvarchar] (50) NULL,
[UnitPrice] [decimal] (18, 8) NULL,
[UnitCost] [decimal] (18, 8) NULL,
[Currency] [nvarchar] (50) NULL,
[IsOrderClosed] [nvarchar] (50) NULL,
[DiscountPercent] [decimal] (18, 8) NULL,
[DiscountAmountCalc] [decimal] (18, 8) NULL,
[NetLineAmount] [decimal] (18, 8) NULL,
[PartNum] [nvarchar] (100) NULL,
[PartStatus] [nvarchar] (50) NULL,
[SalesPersonName] [nvarchar] (100) NULL,
[ReturnComment] [nvarchar] (max) NULL,
[SalesReturnInvoiceNum] [nvarchar] (50) NULL,
[WarehouseCode] [nvarchar] (50) NULL,
[Ordersort] [nvarchar] (50) NULL,
[CustomerOrderNum] [nvarchar] (50) NULL,
[CustomerItemID] [nvarchar] (50) NULL,
[DCPAGMP] [nvarchar] (100) NULL,
[MainItem] [nvarchar] (100) NULL,
[PartitionKey] [nvarchar] (50) NULL,
[Cancellation] [nvarchar] (50) NULL
)
GO