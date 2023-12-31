﻿/*
    This script was generated by SQL Change Automation to help provide object-level history. This script should never be edited manually.
    For more information see: https://www.red-gate.com/sca/dev/offline-schema-model
*/

CREATE TABLE [stage].[CER_NO_BC_PurchaseOrder]
(
[PartitionKey] [nvarchar] (50) NOT NULL,
[Company] [nvarchar] (50) NOT NULL,
[PurchaseOrderNum] [nvarchar] (50) NULL,
[PurchaseOrderLine] [nvarchar] (50) NULL,
[PurchaseInvoiceNum] [nvarchar] (50) NULL,
[PurchaseOrderType] [nvarchar] (50) NULL,
[PurchaseOrderDate] [nvarchar] (50) NULL,
[IsOrderClosed] [nvarchar] (50) NULL,
[ActualDelivDate] [nvarchar] (50) NULL,
[PartNum] [nvarchar] (50) NULL,
[SupplierNum] [nvarchar] (50) NULL,
[SupplierPartNum] [nvarchar] (50) NULL,
[PurchaseOrderQty] [nvarchar] (50) NULL,
[PurchaseReceiveQty] [nvarchar] (50) NULL,
[PurchaseInvoiceQty] [nvarchar] (50) NULL,
[UoM] [nvarchar] (50) NULL,
[UnitPrice] [nvarchar] (50) NULL,
[DiscountPercent] [nvarchar] (50) NULL,
[Currency] [nvarchar] (50) NULL,
[PurchaserName] [nvarchar] (50) NULL,
[WarehouseCode] [nvarchar] (50) NULL,
[LandedCost] [nvarchar] (50) NULL,
[PurchaseOrderStatus] [nvarchar] (50) NULL,
[CreatedTimeStamp] [nvarchar] (50) NULL,
[ModifiedTimeStamp] [nvarchar] (50) NULL,
[ExchangeRate] [nvarchar] (50) NULL,
[DiscountAmount] [nvarchar] (50) NULL,
[ReceivingNum] [nvarchar] (50) NULL,
[PORes1] [nvarchar] (50) NULL,
[Comments] [nvarchar] (max) NULL,
[ReqDelivDate] [date] NULL,
[CommittedDelivDate] [date] NULL,
[PartStatus] [nvarchar] (50) NULL
)
GO
