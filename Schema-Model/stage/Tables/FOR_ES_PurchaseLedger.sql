﻿/*
    This script was generated by SQL Change Automation to help provide object-level history. This script should never be edited manually.
    For more information see: https://www.red-gate.com/sca/dev/offline-schema-model
*/

CREATE TABLE [stage].[FOR_ES_PurchaseLedger]
(
[PartitionKey] [varchar] (50) NOT NULL,
[Company] [nvarchar] (8) NOT NULL,
[SupplierNum] [nvarchar] (50) NULL,
[PurchaseOrderNum] [nvarchar] (50) NULL,
[PurchaseInvoiceNum] [nvarchar] (50) NULL,
[SupplierInvoiceNum] [nvarchar] (50) NULL,
[PurchaseInvoiceDate] [date] NULL,
[PurchaseDueDate] [date] NULL,
[PurchaseLastPaymentDate] [date] NULL,
[InvoiceAmount] [decimal] (18, 4) NULL,
[PaidInvoiceAmount] [decimal] (18, 4) NULL,
[RemainingInvoiceAmount] [decimal] (18, 4) NULL,
[AccountingDate] [date] NULL,
[Currency] [nvarchar] (10) NULL,
[VATAmount] [decimal] (18, 4) NULL,
[VATCode] [nvarchar] (10) NULL,
[VATCodeDesc] [nvarchar] (300) NULL,
[PayToName] [nvarchar] (100) NULL,
[PayToCity] [nvarchar] (50) NULL,
[PayToContact] [nvarchar] (50) NULL,
[PaymentTerms] [nvarchar] (10) NULL,
[PrePaymentNum] [nvarchar] (50) NULL,
[LastPaymentNum] [nvarchar] (50) NULL,
[ExchangeRate] [decimal] (18, 8) NULL,
[AgingPeriod] [nvarchar] (50) NULL
)
GO