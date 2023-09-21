﻿/*
    This script was generated by SQL Change Automation to help provide object-level history. This script should never be edited manually.
    For more information see: https://www.red-gate.com/sca/dev/offline-schema-model
*/

CREATE TABLE [stage].[OCS_SE_SalesLedgerFin]
(
[PartitionKey] [varchar] (50) NOT NULL,
[Company] [nvarchar] (8) NULL,
[CustomerNum] [nvarchar] (50) NULL,
[SalesInvoiceNum] [nvarchar] (50) NULL,
[SalesOrderNum] [nvarchar] (50) NULL,
[SalesInvoiceDate] [date] NULL,
[SalesInvoiceDueDate] [date] NULL,
[SalesInvoiceLastPaymentDate] [date] NULL,
[AccountingDate] [date] NULL,
[InvoiceAmount] [decimal] (18, 8) NULL,
[PaidInvoiceAmount] [decimal] (18, 8) NULL,
[RemainingInvoiceAmount] [decimal] (18, 8) NULL,
[VATAmount] [decimal] (18, 8) NULL,
[VATCode] [nvarchar] (50) NULL,
[VATCodeDesc] [nvarchar] (50) NULL,
[ProjectNum] [nvarchar] (50) NULL,
[PaymentEvents] [nvarchar] (50) NULL,
[Currency] [nvarchar] (50) NULL,
[ExchangeRate] [decimal] (18, 8) NULL,
[IsInvoiceClosed] [nvarchar] (50) NULL,
[CreatedTimeStamp] [nvarchar] (50) NULL,
[ModifiedTimeStamp] [nvarchar] (50) NULL
)
GO
