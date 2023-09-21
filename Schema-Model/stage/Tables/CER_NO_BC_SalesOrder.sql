﻿/*
    This script was generated by SQL Change Automation to help provide object-level history. This script should never be edited manually.
    For more information see: https://www.red-gate.com/sca/dev/offline-schema-model
*/

CREATE TABLE [stage].[CER_NO_BC_SalesOrder]
(
[PartitionKey] [nvarchar] (50) NOT NULL,
[Company] [nvarchar] (8) NOT NULL,
[CustNum] [nvarchar] (50) NULL,
[OrderNum] [nvarchar] (60) NULL,
[OrderLine] [nvarchar] (60) NULL,
[OrderDate] [nvarchar] (60) NULL,
[DelivDate] [nvarchar] (60) NULL,
[OrderQty] [nvarchar] (60) NULL,
[DelivQty] [nvarchar] (60) NULL,
[RemainingQty] [nvarchar] (60) NULL,
[UnitPrice] [nvarchar] (60) NULL,
[UnitCost] [nvarchar] (60) NULL,
[SumUnitCost] [nvarchar] (60) NULL,
[SumUnitPrice] [nvarchar] (60) NULL,
[Currency] [nvarchar] (60) NULL,
[CurrExchRate] [nvarchar] (60) NULL,
[OpenRelease] [nvarchar] (60) NULL,
[DiscountPercent] [nvarchar] (60) NULL,
[DiscountAmount] [nvarchar] (60) NULL,
[PartNum] [nvarchar] (60) NULL,
[NeedbyDate] [nvarchar] (60) NULL,
[SalesPersonName] [nvarchar] (100) NULL,
[WarehouseCode] [nvarchar] (60) NULL,
[systemCreatedAt] [nvarchar] (50) NULL,
[systemModifiedAt] [nvarchar] (50) NULL,
[DocumentType] [nvarchar] (60) NULL,
[Department] [nvarchar] (40) NULL,
[WarehouseCodeLines] [nvarchar] (5) NULL
)
GO
