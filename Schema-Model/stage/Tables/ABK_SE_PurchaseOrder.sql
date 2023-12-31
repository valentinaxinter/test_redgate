﻿/*
    This script was generated by SQL Change Automation to help provide object-level history. This script should never be edited manually.
    For more information see: https://www.red-gate.com/sca/dev/offline-schema-model
*/

CREATE TABLE [stage].[ABK_SE_PurchaseOrder]
(
[PartitionKey] [varchar] (50) NULL,
[Company] [nvarchar] (8) NOT NULL,
[PurchaseOrderNum] [varchar] (50) NULL,
[PurchaseOrderLine] [nvarchar] (50) NULL,
[OrderSubLine] [nvarchar] (50) NULL,
[PurchaseOrderDate] [nvarchar] (50) NULL,
[OrgReqDelivDate] [nvarchar] (50) NULL,
[OrgCommittedDelivDate] [nvarchar] (50) NULL,
[ActualDelivDate] [nvarchar] (50) NULL,
[PartNum] [nvarchar] (50) NULL,
[SupplierNum] [nvarchar] (50) NULL,
[PurchaseOrderQty] [decimal] (18, 4) NULL,
[PurchaseReceiveQty] [decimal] (18, 4) NULL,
[PurchaseInvoiceQty] [decimal] (18, 4) NULL,
[UnitPrice] [decimal] (18, 4) NULL,
[ExchangeRate] [decimal] (18, 4) NULL,
[Currency] [nvarchar] (50) NULL,
[PurchaserName] [nvarchar] (50) NULL,
[WarehouseCode] [nvarchar] (50) NULL,
[LandedCost] [decimal] (18, 4) NULL,
[IsClosed] [bit] NULL,
[IsActiveRecord] [bit] NULL,
[CreatedTimeStamp] [nvarchar] (50) NULL,
[ModifiedTimeStamp] [nvarchar] (50) NULL
)
GO
