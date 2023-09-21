﻿/*
    This script was generated by SQL Change Automation to help provide object-level history. This script should never be edited manually.
    For more information see: https://www.red-gate.com/sca/dev/offline-schema-model
*/

CREATE TABLE [dw].[SalesOrder]
(
[SalesOrderID] [binary] (32) NOT NULL,
[Company] [nvarchar] (8) NOT NULL,
[CustomerNum] [nvarchar] (50) NULL,
[SalesOrderNum] [nvarchar] (50) NOT NULL,
[SalesOrderLine] [nvarchar] (50) NULL,
[SalesOrderSubLine] [nvarchar] (50) NULL,
[SalesOrderType] [nvarchar] (50) NULL,
[SalesOrderCategory] [nvarchar] (50) NULL,
[SalesOrderDate] [date] NULL,
[NeedbyDate] [date] NULL,
[ExpDelivDate] [date] NULL,
[ActualDelivDate] [date] NULL,
[SalesInvoiceNum] [nvarchar] (50) NULL,
[SalesOrderQty] [decimal] (18, 4) NULL,
[DelivQty] [decimal] (18, 4) NULL,
[RemainingQty] [decimal] (18, 4) NULL,
[UoM] [nvarchar] (50) NULL,
[UnitPrice] [decimal] (18, 4) NULL,
[UnitCost] [decimal] (18, 4) NULL,
[Currency] [nvarchar] (50) NULL,
[ExchangeRate] [decimal] (18, 4) NULL,
[OpenRelease] [nvarchar] (20) NULL,
[DiscountAmount] [decimal] (18, 4) NULL,
[DiscountPercent] [decimal] (18, 4) NULL,
[PartNum] [nvarchar] (50) NULL,
[PartType] [nvarchar] (50) NULL,
[PartStatus] [nvarchar] (100) NULL,
[SalesPersonName] [nvarchar] (100) NULL,
[WarehouseCode] [nvarchar] (50) NULL,
[SalesChannel] [nvarchar] (50) NULL,
[Department] [nvarchar] (50) NULL,
[ProjectNum] [nvarchar] (50) NULL,
[IndexKey] [nvarchar] (50) NULL,
[Cancellation] [nvarchar] (50) NULL,
[SORes1] [nvarchar] (100) NULL,
[SORes2] [nvarchar] (100) NULL,
[SORes3] [nvarchar] (100) NULL,
[CompanyID] [binary] (32) NULL,
[CustomerID] [binary] (32) NULL,
[PartID] [binary] (32) NULL,
[WarehouseID] [binary] (32) NULL,
[SalesOrderNumID] [binary] (32) NULL,
[SalesOrderCode] [nvarchar] (300) NULL,
[SalesOrderDateID] [int] NULL,
[PartitionKey] [varchar] (50) NOT NULL,
[ConfirmedDelivDate] [date] NULL CONSTRAINT [DF__SalesOrde__Confi__0559BDD1] DEFAULT ('1900-01-01'),
[ProjectID] [binary] (32) NULL,
[AxInterSalesChannel] [nvarchar] (50) NULL,
[SalesInvoiceQty] [decimal] (18, 4) NULL,
[TotalMiscChrg] [decimal] (18, 4) NULL,
[IsUpdatingStock] [nvarchar] (50) NULL,
[SORes4] [decimal] (18, 4) NULL,
[SORes5] [decimal] (18, 4) NULL,
[SORes6] [decimal] (18, 4) NULL,
[is_deleted] [bit] NULL,
[DepartmentID] [binary] (32) NULL,
[ActualShipDate] [date] NULL,
[CommittedDelivDate] [date] NULL,
[DepartmentCode] [nvarchar] (50) NULL,
[ExpShipDate] [date] NULL,
[IsActiveRecord] [bit] NULL,
[IsOrderClosed] [bit] NULL,
[OrderHandler] [nvarchar] (100) NULL,
[OrgCommittedDelivDate] [date] NULL,
[OrgExpDelivDate] [date] NULL,
[OrgExpShipDate] [date] NULL,
[OrgReqDelivDate] [date] NULL,
[ReqDelivDate] [date] NULL
)
GO
ALTER TABLE [dw].[SalesOrder] ADD CONSTRAINT [PK_SalesOrder] PRIMARY KEY CLUSTERED ([SalesOrderID])
GO
CREATE NONCLUSTERED INDEX [IX_Company] ON [dw].[SalesOrder] ([Company])
GO
CREATE NONCLUSTERED INDEX [IX_Company_SalesOrderDate] ON [dw].[SalesOrder] ([Company], [SalesOrderDate] DESC)
GO
CREATE NONCLUSTERED INDEX [nci_wi_SalesOrder_PartitionKey] ON [dw].[SalesOrder] ([PartitionKey])
GO
