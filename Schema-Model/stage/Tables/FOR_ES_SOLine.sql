﻿/*
    This script was generated by SQL Change Automation to help provide object-level history. This script should never be edited manually.
    For more information see: https://www.red-gate.com/sca/dev/offline-schema-model
*/

CREATE TABLE [stage].[FOR_ES_SOLine]
(
[PartitionKey] [varchar] (50) NOT NULL,
[Company] [nvarchar] (8) NOT NULL,
[CustomerNum] [nvarchar] (50) NULL,
[PartNum] [nvarchar] (50) NULL,
[PartType] [nvarchar] (50) NULL,
[DocumentNum] [nvarchar] (50) NULL,
[DocumentLine] [nvarchar] (50) NULL,
[DOCUMENTKIND] [nvarchar] (50) NULL,
[OrderSaleNumber] [nvarchar] (50) NULL,
[OrderSaleLineNumber] [nvarchar] (50) NULL,
[SalesInvoiceNum] [nvarchar] (50) NULL,
[SalesInvoiceLine] [nvarchar] (50) NULL,
[SalesInvoiceDate] [date] NULL,
[ActualDelivDate] [date] NULL,
[SalesInvoiceQty] [decimal] (18, 8) NULL,
[UnitPrice] [decimal] (18, 8) NULL,
[UnitCost] [decimal] (18, 8) NULL,
[DiscountPercent] [decimal] (18, 8) NULL,
[DiscountAmount] [decimal] (18, 8) NULL,
[VATAmount] [decimal] (18, 8) NULL,
[Currency] [nvarchar] (50) NULL,
[ExchangeRate] [decimal] (18, 8) NULL,
[SalesPerson] [nvarchar] (50) NULL,
[CreditMemo] [int] NULL,
[DeliveryNoteNum] [nvarchar] (50) NULL,
[Warehouse] [nvarchar] (50) NULL
)
GO