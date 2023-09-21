﻿/*
    This script was generated by SQL Change Automation to help provide object-level history. This script should never be edited manually.
    For more information see: https://www.red-gate.com/sca/dev/offline-schema-model
*/

CREATE TABLE [stage].[SVE_SE_SOLine]
(
[PartitionKey] [varchar] (50) NOT NULL,
[Company] [nvarchar] (8) NOT NULL,
[SalesPersonName] [nvarchar] (100) NULL,
[CustomerNum] [nvarchar] (50) NULL,
[PartNum] [nvarchar] (50) NULL,
[PartType] [nvarchar] (50) NULL,
[SalesOrderNum] [nvarchar] (50) NULL,
[SalesOrderLine] [nvarchar] (50) NULL,
[SalesOrderSubLine] [nvarchar] (50) NULL,
[SalesOrderType] [nvarchar] (50) NULL,
[SalesInvoiceNum] [nvarchar] (50) NULL,
[SalesInvoiceDate] [nvarchar] (50) NULL,
[ActualDelivDate] [nvarchar] (50) NULL,
[SalesInvoiceQty] [decimal] (18, 4) NULL,
[UoM] [nvarchar] (50) NULL,
[LinePrice] [decimal] (18, 4) NULL,
[UnitCost] [decimal] (18, 4) NULL,
[DiscountPercent] [decimal] (18, 4) NULL,
[DiscountAmount] [decimal] (18, 4) NULL,
[TotalMiscChrg] [decimal] (18, 4) NULL,
[VATAmount] [decimal] (18, 4) NULL,
[Currency] [nvarchar] (50) NULL,
[ExchangeRate] [decimal] (18, 4) NULL,
[CreditMemo] [nvarchar] (50) NULL,
[SalesChannel] [nvarchar] (50) NULL,
[Department] [nvarchar] (50) NULL,
[WarehouseCode] [nvarchar] (50) NULL,
[CostBearerNum] [nvarchar] (50) NULL,
[CostUnitNum] [nvarchar] (50) NULL,
[ReturnComment] [nvarchar] (max) NULL,
[ReturnNum] [nvarchar] (50) NULL,
[ProjectNum] [nvarchar] (50) NULL,
[IndexKey] [nvarchar] (50) NULL,
[SIRes1] [nvarchar] (100) NULL,
[SIRes2] [nvarchar] (100) NULL,
[SIRes3] [nvarchar] (100) NULL
)
GO
CREATE NONCLUSTERED INDEX [IX_SVE_SE_SOLine_1] ON [stage].[SVE_SE_SOLine] ([SalesInvoiceNum])
GO