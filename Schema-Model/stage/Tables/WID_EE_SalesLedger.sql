﻿/*
    This script was generated by SQL Change Automation to help provide object-level history. This script should never be edited manually.
    For more information see: https://www.red-gate.com/sca/dev/offline-schema-model
*/

CREATE TABLE [stage].[WID_EE_SalesLedger]
(
[PartitionKey] [varchar] (50) NOT NULL,
[Company] [nvarchar] (8) NULL,
[CustNum] [nvarchar] (50) NULL,
[InvoiceNum] [nvarchar] (50) NULL,
[InvoiceDate] [date] NULL,
[DueDate] [date] NULL,
[LastPaymentDate] [date] NULL,
[InvAmoLocCur] [decimal] (18, 4) NULL,
[InvAmoOriCur] [decimal] (18, 4) NULL,
[ExchangeRate] [decimal] (18, 4) NULL,
[Currency] [nvarchar] (50) NULL,
[VATAmount] [decimal] (18, 4) NULL,
[PayToCity] [nvarchar] (50) NULL,
[PaymentTerms] [nvarchar] (50) NULL
)
GO
