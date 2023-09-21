﻿/*
    This script was generated by SQL Change Automation to help provide object-level history. This script should never be edited manually.
    For more information see: https://www.red-gate.com/sca/dev/offline-schema-model
*/

CREATE TABLE [stage].[NOM_FI_PurchaseInvoice]
(
[PartitionKey] [varchar] (50) NOT NULL,
[Company] [nvarchar] (8) NOT NULL,
[PurchaseOrderNum] [nvarchar] (50) NULL,
[PurchaseOrderLine] [nvarchar] (50) NULL,
[PurchaseOrderSubLine] [nvarchar] (50) NULL,
[PurchaseOrderType] [nvarchar] (50) NULL,
[PurchaseInvoiceNum] [nvarchar] (50) NULL,
[PurchaseInvoiceLine] [nvarchar] (50) NULL,
[PurchaseInvoiceType] [nvarchar] (50) NULL,
[PurchaseInvoiceDate] [date] NULL,
[ActualDelivDate] [date] NULL,
[SupplierNum] [nvarchar] (50) NULL,
[PartNum] [nvarchar] (50) NULL,
[PurchaseInvoiceQty] [decimal] (18, 4) NULL,
[UoM] [nvarchar] (50) NULL,
[UnitPrice] [decimal] (18, 4) NULL,
[DiscountPercent] [decimal] (18, 4) NULL,
[DiscountAmount] [decimal] (18, 4) NULL,
[TotalMiscChrg] [decimal] (18, 4) NULL,
[Currency] [nvarchar] (50) NULL,
[ExchangeRate] [decimal] (18, 4) NULL,
[VATAmount] [decimal] (18, 4) NULL,
[CreditMemo] [nvarchar] (1) NULL,
[PurchaserName] [nvarchar] (100) NULL,
[WarehouseCode] [nvarchar] (50) NULL,
[PurchaseChannel] [nvarchar] (50) NULL,
[Comment] [nvarchar] (max) NULL
)
GO
