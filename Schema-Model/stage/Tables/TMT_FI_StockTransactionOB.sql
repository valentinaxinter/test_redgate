﻿/*
    This script was generated by SQL Change Automation to help provide object-level history. This script should never be edited manually.
    For more information see: https://www.red-gate.com/sca/dev/offline-schema-model
*/

CREATE TABLE [stage].[TMT_FI_StockTransactionOB]
(
[Company] [nvarchar] (50) NULL,
[IndexKey] [nvarchar] (50) NULL,
[PartNum] [nvarchar] (50) NULL,
[SalesOrderNum] [nvarchar] (50) NULL,
[SalesOrderLine] [nvarchar] (50) NULL,
[SalesInvoiceNum] [nvarchar] (50) NULL,
[SalesInvoiceLine] [nvarchar] (50) NULL,
[PurchaseOrderNum] [nvarchar] (50) NULL,
[PurchaseOrderLine] [nvarchar] (50) NULL,
[PurchaseInvoiceNum] [nvarchar] (50) NULL,
[PurchaseInvoiceLine] [nvarchar] (50) NULL,
[WarehouseCode] [nvarchar] (50) NULL,
[BinNum] [nvarchar] (50) NULL,
[BatchNum] [nvarchar] (50) NULL,
[Version] [nvarchar] (50) NULL,
[TransActionDate] [nvarchar] (50) NULL,
[AdjustmentDate] [nvarchar] (50) NULL,
[TransActionTime] [nvarchar] (50) NULL,
[TransactionType] [nvarchar] (50) NULL,
[TransactionCode] [nvarchar] (50) NULL,
[TransactionDescription] [nvarchar] (200) NULL,
[Reference] [nvarchar] (100) NULL,
[TransActionQty] [decimal] (18, 4) NULL,
[CustomerNum] [nvarchar] (50) NULL,
[SupplierNum] [nvarchar] (50) NULL,
[CostPrice] [decimal] (18, 4) NULL,
[SalesUnitPrice] [decimal] (18, 4) NULL,
[Currency] [nvarchar] (50) NULL,
[TransActionValue] [decimal] (18, 4) NULL,
[STRes1] [nvarchar] (100) NULL,
[STRes2] [nvarchar] (100) NULL,
[STRes3] [nvarchar] (100) NULL
)
GO