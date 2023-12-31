﻿/*
    This script was generated by SQL Change Automation to help provide object-level history. This script should never be edited manually.
    For more information see: https://www.red-gate.com/sca/dev/offline-schema-model
*/

CREATE TABLE [stage].[MEN_NL_SOLine]
(
[PartitionKey] [varchar] (50) NOT NULL,
[Company] [nvarchar] (50) NOT NULL,
[InvoiceHandler] [nvarchar] (200) NULL,
[CustomerNum] [nvarchar] (50) NULL,
[PartNum] [nvarchar] (50) NULL,
[PartType] [nvarchar] (50) NULL,
[SalesOrderNum] [nvarchar] (50) NULL,
[SalesOrderLine] [nvarchar] (50) NULL,
[SalesOrderSubLine] [nvarchar] (50) NULL,
[SalesOrderType] [nvarchar] (50) NULL,
[SalesInvoiceNum] [nvarchar] (50) NOT NULL,
[SalesInvoiceLine] [nvarchar] (50) NULL,
[SalesInvoiceType] [nvarchar] (50) NULL,
[SalesInvoiceDate] [date] NULL,
[ActualDelivDate] [date] NULL,
[SalesInvoiceQty] [decimal] (18, 8) NULL,
[UoM] [nvarchar] (50) NULL,
[UnitPrice] [decimal] (18, 8) NULL,
[UnitCost] [decimal] (18, 8) NULL,
[DiscountPercent] [decimal] (18, 8) NULL,
[DiscountAmount] [decimal] (18, 8) NULL,
[CashDiscountOffered] [decimal] (18, 8) NULL,
[CashDiscountUsed] [decimal] (18, 8) NULL,
[TotalMiscChrg] [decimal] (18, 8) NULL,
[VATAmount] [decimal] (18, 8) NULL,
[Currency] [nvarchar] (50) NULL,
[ExchangeRate] [decimal] (18, 8) NULL,
[CreditMemo] [nvarchar] (50) NULL,
[SalesChanel] [nvarchar] (50) NULL,
[Department] [nvarchar] (50) NULL,
[WarehouseCode] [nvarchar] (50) NULL,
[CostBearerNum] [nvarchar] (50) NULL,
[CostUnitNum] [nvarchar] (50) NULL,
[ReturnComment] [nvarchar] (500) NULL,
[ReturnNum] [nvarchar] (50) NULL,
[ProjectNum] [nvarchar] (50) NULL,
[Indexkey] [nvarchar] (50) NULL,
[SIRes1] [nvarchar] (100) NULL,
[SIRes2] [nvarchar] (100) NULL,
[SIRes3] [nvarchar] (100) NULL,
[DebiteurKey] [nvarchar] (50) NULL,
[ProductKey] [nvarchar] (50) NULL,
[DW_TimeStamp] [date] NULL,
[SalesAmount] [decimal] (18, 8) NULL,
[SalesInvoiceQty_2] [decimal] (18, 8) NULL,
[CustomerNumPayer] [nvarchar] (50) NULL,
[InternalSalesIdentifier] [bit] NULL
)
GO
