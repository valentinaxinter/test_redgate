﻿/*
    This script was generated by SQL Change Automation to help provide object-level history. This script should never be edited manually.
    For more information see: https://www.red-gate.com/sca/dev/offline-schema-model
*/

CREATE TABLE [stage].[Nom_NO_StockTransactionOB]
(
[Company] [nvarchar] (50) NULL,
[IndexKey] [nvarchar] (50) NULL,
[WarehouseCode] [nvarchar] (50) NULL,
[TransactionCode] [nvarchar] (50) NULL,
[TransactionDescription] [nvarchar] (50) NULL,
[IssuerReceiverNum] [nvarchar] (50) NULL,
[OrderNum] [nvarchar] (50) NULL,
[OrderLine] [nvarchar] (50) NULL,
[InvoiceNum] [nvarchar] (50) NULL,
[InvoiceLine] [nvarchar] (50) NULL,
[PartNum] [nvarchar] (50) NULL,
[BinNum] [nvarchar] (50) NULL,
[BatchNum] [nvarchar] (50) NULL,
[TransactionDate] [nvarchar] (50) NULL,
[TransactionTime] [nvarchar] (50) NULL,
[TransactionQty] [nvarchar] (50) NULL,
[TransactionValue] [nvarchar] (50) NULL,
[CostPrice] [nvarchar] (50) NULL,
[SalesUnitPrice] [nvarchar] (50) NULL,
[Currency] [nvarchar] (50) NULL,
[Reference] [nvarchar] (50) NULL,
[AdjustmentDate] [nvarchar] (50) NULL
)
GO