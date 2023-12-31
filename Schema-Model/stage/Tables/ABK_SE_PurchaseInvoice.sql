﻿/*
    This script was generated by SQL Change Automation to help provide object-level history. This script should never be edited manually.
    For more information see: https://www.red-gate.com/sca/dev/offline-schema-model
*/

CREATE TABLE [stage].[ABK_SE_PurchaseInvoice]
(
[PartitionKey] [varchar] (50) NULL,
[Company] [nvarchar] (8) NOT NULL,
[PurchaseOrderNum] [nvarchar] (50) NULL,
[PurchaseOrderLine] [nvarchar] (50) NULL,
[PurchaseOrderSubLine] [nvarchar] (50) NULL,
[PurchaseInvoiceNum] [nvarchar] (50) NULL,
[PurchaseInvoiceLine] [nvarchar] (50) NULL,
[PurchaseInvoiceDate] [nvarchar] (50) NULL,
[ActualDelivDate] [nvarchar] (50) NULL,
[SupplierNum] [nvarchar] (50) NULL,
[PartNum] [nvarchar] (50) NULL,
[PurchaseInvoiceQty] [nvarchar] (50) NULL,
[UnitPrice] [nvarchar] (50) NULL,
[ExchangeRate] [nvarchar] (50) NULL,
[DiscountPercent] [nvarchar] (50) NULL,
[ISOCode] [nvarchar] (50) NULL,
[CreditMemo] [nvarchar] (50) NULL,
[PurchaserName] [nvarchar] (100) NULL,
[WarehouseCode] [nvarchar] (50) NULL,
[CreatedTimeStamp] [nvarchar] (50) NULL,
[ModifiedTimeStamp] [nvarchar] (50) NULL
)
GO
