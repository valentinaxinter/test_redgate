﻿/*
    This script was generated by SQL Change Automation to help provide object-level history. This script should never be edited manually.
    For more information see: https://www.red-gate.com/sca/dev/offline-schema-model
*/

CREATE TABLE [stage].[JEN_SE_PurchaseInvoice]
(
[PartitionKey] [varchar] (50) NOT NULL,
[Company] [nvarchar] (8) NOT NULL,
[PurchaseOrderNum] [nvarchar] (50) NULL,
[InvoiceNum] [nvarchar] (50) NULL,
[SupplierNum] [nvarchar] (50) NULL,
[PartNum] [nvarchar] (50) NULL,
[LineType] [nvarchar] (50) NULL,
[PurchaseOrderLine] [nvarchar] (50) NULL,
[PurchaseOrderSubLine] [nvarchar] (50) NULL,
[PurchaserName] [nvarchar] (100) NULL,
[OrderType] [nvarchar] (50) NULL,
[InvoiceLine] [nvarchar] (50) NULL,
[InvoiceType] [nvarchar] (50) NULL,
[InvoiceDate] [date] NULL,
[ActualDeliveryDate] [date] NULL,
[DiscountAmount] [decimal] (18, 4) NULL,
[UnitPrice] [decimal] (18, 4) NULL,
[PurchaseInvoiceQty] [decimal] (18, 4) NULL,
[TotalMiscChrg] [decimal] (18, 4) NULL,
[CurrencyCode] [nvarchar] (50) NULL,
[ExchangeRate] [decimal] (18, 4) NULL,
[CreditMemo] [nvarchar] (1) NULL,
[WarehouseCode] [nvarchar] (50) NULL
)
GO
