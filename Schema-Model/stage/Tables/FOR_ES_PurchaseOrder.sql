﻿/*
    This script was generated by SQL Change Automation to help provide object-level history. This script should never be edited manually.
    For more information see: https://www.red-gate.com/sca/dev/offline-schema-model
*/

CREATE TABLE [stage].[FOR_ES_PurchaseOrder]
(
[PartitionKey] [varchar] (50) NOT NULL,
[Company] [nvarchar] (8) NOT NULL,
[PurchaseOrderNum] [nvarchar] (50) NULL,
[PurchaseOrderLine] [nvarchar] (50) NULL,
[PurchaseOrderDate] [datetime] NULL,
[OpenRelease] [varchar] (3) NULL,
[OrgCommittedDelivDate] [datetime] NULL,
[PartNum] [nvarchar] (50) NULL,
[SupplierNum] [nvarchar] (50) NULL,
[SupplierPartNum] [nvarchar] (50) NULL,
[PurchaseOrderQty] [decimal] (18, 4) NULL,
[UnitPrice] [decimal] (18, 4) NULL,
[DiscountPercent] [decimal] (18, 4) NULL,
[Currency] [nvarchar] (10) NULL,
[PurchaserName] [nvarchar] (100) NULL,
[WarehouseCode] [nvarchar] (50) NULL,
[PORes1] [nvarchar] (100) NULL,
[PORes2] [nvarchar] (100) NULL,
[ReqDelivDate] [date] NULL,
[ActualDelivDate] [nvarchar] (60) NULL,
[PurchaseInvoiceNum] [nvarchar] (60) NULL,
[DiscountAmount] [nvarchar] (60) NULL,
[ExchangeRate] [nvarchar] (60) NULL,
[PurchaseOrderSubLine] [nvarchar] (100) NULL,
[IsClosed] [bit] NULL,
[SupplierInvoiceNum] [nvarchar] (100) NULL,
[PartStatus] [nvarchar] (100) NULL,
[ReceiveQty] [decimal] (18, 4) NULL,
[InvoiceQty] [decimal] (18, 4) NULL,
[UoM] [nvarchar] (100) NULL,
[LandedCost] [decimal] (18, 4) NULL,
[Comments] [nvarchar] (max) NULL,
[datetime_created_at] [datetime] NULL,
[datetime_modified_at] [datetime] NULL
)
GO