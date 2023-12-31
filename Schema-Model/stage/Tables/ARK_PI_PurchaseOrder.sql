﻿/*
    This script was generated by SQL Change Automation to help provide object-level history. This script should never be edited manually.
    For more information see: https://www.red-gate.com/sca/dev/offline-schema-model
*/

CREATE TABLE [stage].[ARK_PI_PurchaseOrder]
(
[PartitionKey] [varchar] (50) NOT NULL,
[Company] [nvarchar] (8) NOT NULL,
[PurchaseOrderNum] [varchar] (50) NULL,
[PurchaseOrderLine] [nvarchar] (50) NULL,
[PurchaseOrderSubLine] [nvarchar] (50) NULL,
[PurchaseOrderType] [nvarchar] (50) NULL,
[PurchaseOrderDate] [date] NULL,
[OrgReqDelivDate] [date] NULL,
[CommittedDelivDate] [date] NULL,
[ExpDelivDate] [date] NULL,
[ReqDelivDate] [date] NULL,
[PurchaseInvoiceNum] [nvarchar] (50) NULL,
[PartNum] [nvarchar] (50) NULL,
[SupplierNum] [nvarchar] (50) NULL,
[SupplierInvoiceNum] [nvarchar] (50) NULL,
[DelivCustomerNum] [nvarchar] (50) NULL,
[PartStatus] [nvarchar] (50) NULL,
[OrderQty] [decimal] (18, 4) NULL,
[ReceiveQty] [decimal] (18, 4) NULL,
[InvoiceQty] [decimal] (18, 4) NULL,
[UoM] [nvarchar] (50) NULL,
[UnitPrice] [decimal] (18, 4) NULL,
[DiscountPercent] [decimal] (18, 4) NULL,
[DiscountAmount] [decimal] (18, 4) NULL,
[ExchangeRate] [decimal] (18, 4) NULL,
[Currency] [nvarchar] (50) NULL,
[PurchaserName] [nvarchar] (50) NULL,
[WarehouseCode] [nvarchar] (50) NULL,
[ReceivingNum] [nvarchar] (50) NULL,
[DelivTime] [nvarchar] (50) NULL,
[PurchaseChannel] [nvarchar] (50) NULL,
[PORes1] [nvarchar] (50) NULL,
[Res2] [nvarchar] (50) NULL,
[Res3] [nvarchar] (50) NULL
)
GO
