﻿/*
    This script was generated by SQL Change Automation to help provide object-level history. This script should never be edited manually.
    For more information see: https://www.red-gate.com/sca/dev/offline-schema-model
*/

CREATE TABLE [stage].[FOR_SE_SalesLedger]
(
[PartitionKey] [varchar] (50) NOT NULL,
[Company] [nvarchar] (8) NULL,
[CustNum] [nvarchar] (50) NULL,
[InvoiceNum] [nvarchar] (50) NULL,
[InvoiceDate] [date] NULL,
[DueDate] [date] NULL,
[LastPaymentDate] [date] NULL,
[FiscalYear] [nvarchar] (50) NULL,
[FiscalPeriod] [nvarchar] (50) NULL,
[Currency] [nvarchar] (50) NULL,
[ExchangeRate] [numeric] (18, 4) NULL,
[VATAmount] [numeric] (18, 4) NULL,
[VATCode] [nvarchar] (50) NULL,
[VATCodeDesc] [nvarchar] (50) NULL,
[OriginalAmount] [numeric] (18, 4) NULL,
[RemainingAmount] [numeric] (18, 4) NULL,
[LocalAmount] [numeric] (18, 4) NULL,
[LocalRemainingAmount] [numeric] (18, 4) NULL,
[AgingPeriod] [nvarchar] (50) NULL,
[PaymentTerms] [nvarchar] (50) NULL,
[DaysPastDue] [int] NULL,
[ApplyDate] [date] NULL,
[ChangeDate] [date] NULL,
[IsOpenInvoice] [bit] NULL
)
GO