﻿/*
    This script was generated by SQL Change Automation to help provide object-level history. This script should never be edited manually.
    For more information see: https://www.red-gate.com/sca/dev/offline-schema-model
*/

CREATE TABLE [stage].[CER_LT_PurchaseInvoice]
(
[PartitionKey] [varchar] (50) NOT NULL,
[Company] [nvarchar] (8) NOT NULL,
[PurchaseOrderNum] [nvarchar] (50) NULL,
[PurchaseOrderLine] [nvarchar] (50) NULL,
[PurchaseOrderSubLine] [nvarchar] (50) NULL,
[PurchaseOrderType] [nvarchar] (50) NULL,
[PurchaseInvoiceNum] [nvarchar] (50) NULL,
[PurchaseInvoiceLine] [nvarchar] (50) NULL,
[PurchaseInvoiceDate] [date] NULL,
[ActualDelivDate] [date] NULL,
[SupplierNum] [nvarchar] (50) NULL,
[PartNum] [nvarchar] (50) NULL,
[PurchaserName] [nvarchar] (100) NULL,
[PurchaseInvoiceQty] [decimal] (18, 4) NULL,
[UnitPrice] [decimal] (18, 4) NULL,
[DiscountAmount] [decimal] (18, 4) NULL,
[TotalMiscChrg] [decimal] (18, 4) NULL,
[Currency] [nvarchar] (50) NULL,
[ExchangeRate] [decimal] (18, 4) NULL,
[WarehouseCode] [nvarchar] (50) NULL
)
GO
