﻿/*
    This script was generated by SQL Change Automation to help provide object-level history. This script should never be edited manually.
    For more information see: https://www.red-gate.com/sca/dev/offline-schema-model
*/

CREATE TABLE [axbus].[IOW_PL_SOLine]
(
[PartitionKey] [nvarchar] (50) NULL,
[Company] [nvarchar] (50) NOT NULL,
[InvoiceHandler] [nvarchar] (max) NULL,
[CustomerNum] [nvarchar] (max) NULL,
[PartNum] [nvarchar] (max) NULL,
[PartType] [nvarchar] (max) NULL,
[SalesOrderNum] [nvarchar] (max) NULL,
[SalesOrderLine] [nvarchar] (max) NULL,
[SalesOrderSubLine] [nvarchar] (max) NULL,
[SalesOrderType] [nvarchar] (max) NULL,
[SalesInvoiceNum] [nvarchar] (max) NULL,
[SalesInvoiceLine] [nvarchar] (max) NULL,
[SalesInvoiceType] [nvarchar] (max) NULL,
[SalesInvoiceDate] [nvarchar] (max) NULL,
[ActualDelivDate] [nvarchar] (max) NULL,
[SalesInvoiceQty] [nvarchar] (max) NULL,
[UoM] [nvarchar] (max) NULL,
[UnitPrice] [nvarchar] (max) NULL,
[UnitCost] [nvarchar] (max) NULL,
[DiscountPercent] [nvarchar] (max) NULL,
[DiscountAmount] [nvarchar] (max) NULL,
[CashDiscountOffered] [nvarchar] (max) NULL,
[CashDiscountUsed] [nvarchar] (max) NULL,
[TotalMiscChrg] [nvarchar] (max) NULL,
[VATAmount] [nvarchar] (max) NULL,
[UnitCost2] [nvarchar] (max) NULL,
[Currency] [nvarchar] (max) NULL,
[ExchangeRate] [nvarchar] (max) NULL,
[CreditMemo] [nvarchar] (max) NULL,
[SalesChannel] [nvarchar] (max) NULL,
[Department] [nvarchar] (max) NULL,
[WarehouseCode] [nvarchar] (max) NULL,
[CostBearerNum] [nvarchar] (max) NULL,
[CostUnitNum] [nvarchar] (max) NULL,
[ReturnComment] [nvarchar] (max) NULL,
[ReturnNum] [nvarchar] (max) NULL,
[ProjectNum] [nvarchar] (max) NULL,
[IndexKey] [nvarchar] (max) NULL,
[SIRes1] [nvarchar] (max) NULL,
[SIRes2] [nvarchar] (max) NULL,
[SIRes3] [nvarchar] (max) NULL,
[AddressLine] [nvarchar] (max) NULL,
[ZipCode] [nvarchar] (max) NULL,
[City] [nvarchar] (max) NULL,
[Country] [nvarchar] (max) NULL,
[UnitCost2Curr] [nvarchar] (max) NULL,
[ExchangeRate2] [nvarchar] (max) NULL,
[sysCurrency] [nvarchar] (max) NULL,
[CreatedTimeStamp] [nvarchar] (max) NULL,
[ModifiedTimeStamp] [nvarchar] (max) NULL
)
GO
