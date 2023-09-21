﻿/*
    This script was generated by SQL Change Automation to help provide object-level history. This script should never be edited manually.
    For more information see: https://www.red-gate.com/sca/dev/offline-schema-model
*/

CREATE TABLE [stage].[CER_DE_PurchaseInvoice]
(
[PartitionKey] [varchar] (50) NULL,
[Company] [nvarchar] (8) NULL,
[PurchaseOrderNum] [nvarchar] (20) NULL,
[PurchaseOrderLine] [int] NULL,
[PurchaseOrderSubLine] [int] NULL,
[PurchaseOrderType] [int] NULL,
[PurchaseInvoiceNum] [nvarchar] (20) NULL,
[PurchaseInvoiceLine] [int] NULL,
[PurchaseInvoiceType] [int] NULL,
[PurchaseInvoiceDate] [date] NULL,
[ActualDelivDate] [date] NULL,
[SupplierNum] [nvarchar] (20) NULL,
[PurchaseInvoiceQty] [decimal] (9, 2) NULL,
[UoM] [nvarchar] (10) NULL,
[UnitPrice] [decimal] (18, 4) NULL,
[DiscountPercent] [decimal] (9, 2) NULL,
[DiscountAmount] [decimal] (9, 2) NULL,
[TotalMiscChrg] [int] NULL,
[VATAmount] [decimal] (9, 2) NULL,
[ExchangeRate] [decimal] (9, 2) NULL,
[Currency] [nvarchar] (10) NULL,
[CreditMemo] [varchar] (1) NULL,
[WarehouseCode] [nvarchar] (10) NULL,
[PurchaseChannel] [int] NULL,
[Comments] [int] NULL,
[PIRes1] [int] NULL,
[PIRes2] [int] NULL,
[PIRes3] [int] NULL,
[PartNum] [nvarchar] (20) NULL
)
GO
