﻿/*
    This script was generated by SQL Change Automation to help provide object-level history. This script should never be edited manually.
    For more information see: https://www.red-gate.com/sca/dev/offline-schema-model
*/

CREATE TABLE [prestage].[CYE_ES_PurchaseInvoice]
(
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
[PurchaseInvoiceQty] [nvarchar] (50) NULL,
[UoM] [nvarchar] (50) NULL,
[UnitPrice] [nvarchar] (50) NULL,
[DiscountPercent] [nvarchar] (50) NULL,
[DiscountAmount] [nvarchar] (50) NULL,
[TotalMiscChrg] [nvarchar] (50) NULL,
[VATAmount] [nvarchar] (50) NULL,
[ExchangeRate] [nvarchar] (50) NULL,
[Currency] [nvarchar] (50) NULL,
[CreditMemo] [nvarchar] (max) NULL,
[PurchaserName] [nvarchar] (100) NULL,
[WarehouseCode] [nvarchar] (50) NULL,
[PurchaseChannel] [nvarchar] (50) NULL,
[Comment] [nvarchar] (max) NULL,
[PIRes1] [nvarchar] (50) NULL,
[PIRes2] [nvarchar] (50) NULL,
[PIRes3] [nvarchar] (50) NULL
)
GO
