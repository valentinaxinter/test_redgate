﻿/*
    This script was generated by SQL Change Automation to help provide object-level history. This script should never be edited manually.
    For more information see: https://www.red-gate.com/sca/dev/offline-schema-model
*/

CREATE TABLE [stage].[ROR_SE_StockTransaction]
(
[PartitionKey] [nvarchar] (50) NULL,
[Company] [nvarchar] (8) NULL,
[WarehouseCode] [nvarchar] (50) NULL,
[CustomerNum] [nvarchar] (50) NULL,
[PartNum] [nvarchar] (50) NULL,
[SalesOrderNum] [nvarchar] (50) NULL,
[SalesOrderLine] [nvarchar] (50) NULL,
[SalesInvoiceNum] [nvarchar] (50) NULL,
[SalesInvoiceLine] [nvarchar] (50) NULL,
[Currency] [nvarchar] (50) NULL,
[ExchangeRate] [nvarchar] (50) NULL,
[IndexKey] [nvarchar] (50) NULL,
[TransactionCode] [nvarchar] (50) NULL,
[TransactionCodeDescription] [nvarchar] (max) NULL,
[IsInternalTransaction] [nvarchar] (50) NULL,
[SupplierNum] [nvarchar] (50) NULL,
[PurchaseOrderNum] [nvarchar] (50) NULL,
[PurchaseOrderLine] [nvarchar] (50) NULL,
[PurchaseInvoiceNum] [nvarchar] (50) NULL,
[PurchaseInvoiceLine] [nvarchar] (50) NULL,
[BinNum] [nvarchar] (50) NULL,
[BatchNum] [nvarchar] (50) NULL,
[TransactionDate] [nvarchar] (50) NULL,
[TransactionTime] [nvarchar] (50) NULL,
[TransactionQty] [nvarchar] (50) NULL,
[TransactionValue] [nvarchar] (50) NULL,
[Reference] [nvarchar] (50) NULL,
[CreatedTimeStamp] [nvarchar] (50) NULL,
[ModifiedTimeStamp] [nvarchar] (50) NULL,
[IsActiveRecord] [nvarchar] (50) NULL,
[STRes1] [nvarchar] (50) NULL,
[STRes2] [nvarchar] (50) NULL
)
GO
