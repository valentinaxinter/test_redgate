﻿/*
    This script was generated by SQL Change Automation to help provide object-level history. This script should never be edited manually.
    For more information see: https://www.red-gate.com/sca/dev/offline-schema-model
*/

CREATE TABLE [stage].[TMT_FI_ProductionOrder]
(
[PartitionKey] [varchar] (50) NULL,
[Company] [nvarchar] (50) NULL,
[ProductionOrderNum] [nvarchar] (50) NULL,
[ProductionOrderLineNum] [nvarchar] (50) NULL,
[PartNum] [nvarchar] (50) NULL,
[Version] [nvarchar] (50) NULL,
[UoM] [nvarchar] (50) NULL,
[PartType] [nvarchar] (50) NULL,
[ProductionOrderQty] [nvarchar] (50) NULL,
[CompletedQuantity] [nvarchar] (50) NULL,
[RemainingQty] [nvarchar] (50) NULL,
[Status] [nvarchar] (50) NULL,
[ProductionOrderCreateDate] [nvarchar] (50) NULL,
[ProductionStartDate] [nvarchar] (50) NULL,
[ProductionEndDate] [nvarchar] (50) NULL,
[ProductionOrderType] [nvarchar] (50) NULL,
[CostUnitNum] [nvarchar] (50) NULL,
[WarehouseCode] [nvarchar] (50) NULL,
[BinNum] [nvarchar] (50) NULL,
[BatchNum] [nvarchar] (50) NULL,
[SalesOrderNum] [nvarchar] (50) NULL,
[CustomerNum] [nvarchar] (50) NULL,
[ProductionOrderCreaterName] [nvarchar] (50) NULL,
[CreatedTimeStamp] [nvarchar] (50) NULL,
[ModifiedTimeStamp] [nvarchar] (50) NULL
)
GO