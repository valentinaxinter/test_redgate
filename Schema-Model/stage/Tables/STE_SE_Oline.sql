﻿/*
    This script was generated by SQL Change Automation to help provide object-level history. This script should never be edited manually.
    For more information see: https://www.red-gate.com/sca/dev/offline-schema-model
*/

CREATE TABLE [stage].[STE_SE_Oline]
(
[PartitionKey] [varchar] (50) NOT NULL,
[Company] [nvarchar] (500) NULL,
[CustNum] [nvarchar] (500) NULL,
[OrderNum] [nvarchar] (500) NULL,
[SalesOrderType] [nvarchar] (500) NULL,
[OrderLine] [nvarchar] (500) NULL,
[IsOrderClosed] [nvarchar] (500) NULL,
[OrderDate] [nvarchar] (500) NULL,
[ReqDelivDate] [nvarchar] (500) NULL,
[ExpDelivDate] [nvarchar] (500) NULL,
[ExpShipDate] [nvarchar] (500) NULL,
[ActualShipDate] [nvarchar] (500) NULL,
[ActualDelivDate] [nvarchar] (500) NULL,
[InvoiceNum] [nvarchar] (500) NULL,
[OrderQty] [nvarchar] (500) NULL,
[SalesDelivQty] [nvarchar] (500) NULL,
[SalesInvoiceQty] [nvarchar] (500) NULL,
[SalesRemainingQty] [nvarchar] (500) NULL,
[UoM] [nvarchar] (500) NULL,
[UnitPrice] [nvarchar] (500) NULL,
[UnitCost] [nvarchar] (500) NULL,
[Currency] [nvarchar] (500) NULL,
[CurrExchRate] [nvarchar] (500) NULL,
[DiscountPercent] [nvarchar] (500) NULL,
[DiscountAmount] [nvarchar] (500) NULL,
[PartNum] [nvarchar] (500) NULL,
[PartType] [nvarchar] (500) NULL,
[PartStatus] [nvarchar] (500) NULL,
[SalesPersonName] [nvarchar] (500) NULL,
[WarehouseCode] [nvarchar] (500) NULL,
[IndexKey] [nvarchar] (500) NULL,
[Sales Channel] [nvarchar] (500) NULL,
[SORes1] [nvarchar] (500) NULL
)
GO
