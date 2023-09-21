﻿/*
    This script was generated by SQL Change Automation to help provide object-level history. This script should never be edited manually.
    For more information see: https://www.red-gate.com/sca/dev/offline-schema-model
*/

CREATE TABLE [stage].[NOM_NO_PurchaseOrder]
(
[PartitionKey] [varchar] (50) NOT NULL,
[Company] [nvarchar] (8) NOT NULL,
[PurchaseOrderNum] [varchar] (50) NULL,
[PurchaseOrderLine] [nvarchar] (50) NULL,
[PurchaseOrderSubLine] [nvarchar] (50) NULL,
[PurchaseOrderType] [nvarchar] (50) NULL,
[PurchaseOrderDate] [date] NULL,
[PurchaseOrderStatus] [nvarchar] (50) NULL,
[OpenRelease] [nvarchar] (50) NULL,
[OrgReqDelivDate] [date] NULL,
[CommittedDelivDate] [date] NULL,
[ActualDelivDate] [date] NULL,
[ReqDelivDate] [date] NULL,
[PurchaseInvoiceNum] [nvarchar] (50) NULL,
[PartNum] [nvarchar] (50) NULL,
[SupplierNum] [nvarchar] (50) NULL,
[SupplierPartNum] [nvarchar] (50) NULL,
[SupplierInvoiceNum] [nvarchar] (50) NULL,
[DelivCustomerNum] [nvarchar] (50) NULL,
[PartStatus] [nvarchar] (50) NULL,
[PurchaseOrderQty] [decimal] (18, 4) NULL,
[ReceiveQty] [decimal] (18, 4) NULL,
[PurchaseInvoiceQty] [decimal] (18, 4) NULL,
[MinOrderQty] [decimal] (18, 4) NULL,
[UoM] [nvarchar] (50) NULL,
[UnitPrice] [decimal] (18, 4) NULL,
[LandedCost] [decimal] (18, 4) NULL,
[DiscountPercent] [decimal] (18, 4) NULL,
[DiscountAmount] [decimal] (18, 4) NULL,
[ExchangeRate] [decimal] (18, 4) NULL,
[Currency] [nvarchar] (50) NULL,
[PurchaserName] [nvarchar] (50) NULL,
[WarehouseCode] [nvarchar] (50) NULL,
[RecievingNum] [nvarchar] (50) NULL,
[DelivTimeWorkDays] [nvarchar] (50) NULL,
[DelivTime] [nvarchar] (50) NULL,
[PurchaseChannel] [nvarchar] (50) NULL,
[Documents] [nvarchar] (50) NULL,
[Comments] [nvarchar] (max) NULL,
[PORes1] [nvarchar] (50) NULL,
[PORes2] [nvarchar] (50) NULL,
[PORes3] [nvarchar] (50) NULL
)
GO