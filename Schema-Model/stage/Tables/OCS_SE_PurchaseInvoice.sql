﻿/*
    This script was generated by SQL Change Automation to help provide object-level history. This script should never be edited manually.
    For more information see: https://www.red-gate.com/sca/dev/offline-schema-model
*/

CREATE TABLE [stage].[OCS_SE_PurchaseInvoice]
(
[PartitionKey] [nvarchar] (50) NOT NULL,
[Company] [nvarchar] (50) NOT NULL,
[PurchaseInvoiceNum] [nvarchar] (50) NOT NULL,
[PurchaseInvoiceLine] [nvarchar] (50) NULL,
[PurchaseOrderNum] [nvarchar] (50) NULL,
[PurchaseOrderLine] [nvarchar] (50) NULL,
[PurchaseOrderType] [nvarchar] (50) NULL,
[PurchaseInvoiceDate] [nvarchar] (50) NULL,
[ActualShipDate] [nvarchar] (50) NULL,
[ActualRecieveDate] [nvarchar] (50) NULL,
[IsInvoiceClosed] [nvarchar] (50) NULL,
[SupplierNum] [nvarchar] (50) NULL,
[PartNum] [nvarchar] (50) NULL,
[PurchaseInvoiceQty] [nvarchar] (50) NULL,
[UoM] [nvarchar] (50) NULL,
[UnitPrice] [nvarchar] (50) NULL,
[DiscountPercent] [nvarchar] (50) NULL,
[DiscountAmount] [nvarchar] (50) NULL,
[VATAmount] [nvarchar] (50) NULL,
[Currency] [nvarchar] (50) NULL,
[ExchangeRate] [nvarchar] (50) NULL,
[PurchaserName] [nvarchar] (50) NULL,
[WarehouseCode] [nvarchar] (50) NULL,
[CreatedTimeStamp] [nvarchar] (50) NULL,
[ModifiedTimeStamp] [nvarchar] (50) NULL,
[IndexKey] [nvarchar] (50) NULL,
[IsCreditMemo] [nvarchar] (50) NULL
)
GO
