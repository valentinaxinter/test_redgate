﻿/*
    This script was generated by SQL Change Automation to help provide object-level history. This script should never be edited manually.
    For more information see: https://www.red-gate.com/sca/dev/offline-schema-model
*/

CREATE TABLE [stage].[MEN_NL_SalesLedger]
(
[PartitionKey] [varchar] (50) NOT NULL,
[Company] [nvarchar] (50) NOT NULL,
[CustomerNum] [nvarchar] (50) NULL,
[SalesInvoiceNum] [nvarchar] (50) NULL,
[SalesInvoiceDate] [date] NULL,
[SalesDueDate] [date] NULL,
[SalesLastPaymentDate] [date] NULL,
[InvoiceAmount] [decimal] (18, 8) NULL,
[PaidInvoiceAmount] [decimal] (18, 8) NULL,
[RemainingInvoiceAmount] [decimal] (18, 8) NULL,
[AccountingDate] [date] NULL,
[Currency] [nvarchar] (50) NULL,
[VATAmount] [decimal] (18, 8) NULL,
[VATCode] [nvarchar] (50) NULL,
[PayToName] [nvarchar] (50) NULL,
[PayToCity] [nvarchar] (50) NULL,
[PayToContact] [nvarchar] (50) NULL,
[ExchangeRate] [decimal] (18, 8) NULL,
[Agingperiod] [nvarchar] (50) NULL,
[AgingSort] [nvarchar] (50) NULL,
[VATCodeDesc] [nvarchar] (200) NULL,
[PaymentTerms] [nvarchar] (100) NULL,
[SLRes1] [nvarchar] (100) NULL,
[SLRes2] [nvarchar] (100) NULL,
[SLRes3] [nvarchar] (100) NULL,
[AmountExclVAT] [decimal] (18, 8) NULL,
[DebiteurKey] [nvarchar] (50) NULL,
[DW_TimeStamp] [date] NULL
)
GO