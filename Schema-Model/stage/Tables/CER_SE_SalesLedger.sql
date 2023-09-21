﻿/*
    This script was generated by SQL Change Automation to help provide object-level history. This script should never be edited manually.
    For more information see: https://www.red-gate.com/sca/dev/offline-schema-model
*/

CREATE TABLE [stage].[CER_SE_SalesLedger]
(
[PartitionKey] [varchar] (50) NOT NULL,
[Company] [nvarchar] (8) NULL,
[CustNum] [nvarchar] (10) NULL,
[InvoiceNum] [nvarchar] (25) NULL,
[InvoiceDate] [datetime] NULL,
[DueDate] [datetime] NULL,
[LastPaymentDate] [datetime] NULL,
[InvoiceAmountOC] [decimal] (18, 8) NULL,
[PaidAmountLC] [decimal] (18, 8) NULL,
[OpenAmountOC] [decimal] (18, 8) NULL,
[ExchangeRate] [decimal] (18, 8) NULL,
[Currency] [nvarchar] (10) NULL,
[VATAmount] [decimal] (18, 8) NULL,
[VATCode] [nvarchar] (25) NULL,
[VATPaidAmountLCU] [decimal] (18, 8) NULL
)
GO
