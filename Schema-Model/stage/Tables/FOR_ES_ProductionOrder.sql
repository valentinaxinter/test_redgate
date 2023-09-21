﻿/*
    This script was generated by SQL Change Automation to help provide object-level history. This script should never be edited manually.
    For more information see: https://www.red-gate.com/sca/dev/offline-schema-model
*/

CREATE TABLE [stage].[FOR_ES_ProductionOrder]
(
[PartitionKey] [varchar] (50) NOT NULL,
[Company] [nvarchar] (50) NOT NULL,
[ProductionOrderNum] [nvarchar] (50) NOT NULL,
[ProductionOrderLineNum] [nvarchar] (50) NULL,
[PartNum] [nvarchar] (50) NULL,
[Uom] [nvarchar] (50) NULL,
[PartType] [nvarchar] (50) NULL,
[OrderQty] [nvarchar] (50) NULL,
[ScrappedQty Assembled Item] [nvarchar] (50) NULL,
[CompletedQty Assembled Item] [nvarchar] (50) NULL,
[RemainingQty] [nvarchar] (50) NULL,
[Status] [nvarchar] (50) NULL,
[CurrentOperationStage_Preparado] [nvarchar] (50) NULL,
[CurrentOperationStage_Cosido] [nvarchar] (50) NULL,
[CurrentOpeartionStage_Empaquetado] [nvarchar] (50) NULL,
[OrderCreateDate] [nvarchar] (50) NULL,
[RequestedEndDate] [nvarchar] (50) NULL,
[StartDate] [nvarchar] (50) NULL,
[EndDate] [nvarchar] (50) NULL,
[OrderType] [nvarchar] (50) NULL,
[Warehouse] [nvarchar] (50) NULL,
[SalesOrderNum] [nvarchar] (50) NULL,
[CustomerNum] [nvarchar] (50) NULL,
[ ProductionOrderCreaterName] [nvarchar] (50) NULL,
[CurrentResourceGroup] [nvarchar] (50) NULL,
[Currency] [nvarchar] (50) NULL,
[ExchangeRate] [nvarchar] (50) NULL,
[PlannedEndDate] [nvarchar] (50) NULL,
[CreatedTimeStamp] [nvarchar] (50) NULL,
[ModifiedTimeStamp] [nvarchar] (50) NULL
)
GO