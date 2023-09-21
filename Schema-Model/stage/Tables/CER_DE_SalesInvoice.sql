﻿/*
    This script was generated by SQL Change Automation to help provide object-level history. This script should never be edited manually.
    For more information see: https://www.red-gate.com/sca/dev/offline-schema-model
*/

CREATE TABLE [stage].[CER_DE_SalesInvoice]
(
[PartitionKey] [nvarchar] (40) NULL,
[Company] [nvarchar] (15) NULL,
[SalesInvoiceNum] [nvarchar] (30) NULL,
[SalesInvoiceLine] [nvarchar] (20) NULL,
[SalesInvoiceDate] [nvarchar] (35) NULL,
[ActualDelivDate] [nvarchar] (35) NULL,
[DeliveryAddress] [nvarchar] (120) NULL,
[DeliveryCity] [nvarchar] (50) NULL,
[DeliveryCountry] [nvarchar] (50) NULL,
[DeliveryZipCode] [nvarchar] (20) NULL,
[CustomerNum] [nvarchar] (35) NULL,
[PartNum] [nvarchar] (35) NULL,
[UnitPrice] [nvarchar] (25) NULL,
[UnitCost] [nvarchar] (25) NULL,
[VATAmount] [nvarchar] (25) NULL,
[SalesInvoiceQty] [nvarchar] (25) NULL,
[Currency] [nvarchar] (25) NULL,
[ExchangeRate] [nvarchar] (15) NULL,
[WarehouseCode] [nvarchar] (30) NULL,
[DiscountAmount] [nvarchar] (25) NULL,
[DiscountPercent] [nvarchar] (25) NULL,
[IsCreditMemo] [nvarchar] (15) NULL,
[SalesOrderNum] [nvarchar] (30) NULL,
[SalesPersonName] [nvarchar] (50) NULL,
[UoM] [nvarchar] (40) NULL,
[SalesOrderType] [nvarchar] (40) NULL
)
GO