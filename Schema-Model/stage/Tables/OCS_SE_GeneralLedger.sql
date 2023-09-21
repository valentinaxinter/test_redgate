﻿/*
    This script was generated by SQL Change Automation to help provide object-level history. This script should never be edited manually.
    For more information see: https://www.red-gate.com/sca/dev/offline-schema-model
*/

CREATE TABLE [stage].[OCS_SE_GeneralLedger]
(
[PartitionKey] [varchar] (50) NOT NULL,
[Company] [nvarchar] (8) NULL,
[AccountNum] [nvarchar] (50) NULL,
[CostUnitNum] [nvarchar] (50) NULL,
[ProjectNum] [nvarchar] (50) NULL,
[JournalType] [nvarchar] (50) NULL,
[JournalDate] [nvarchar] (50) NULL,
[JournalNum] [nvarchar] (50) NULL,
[JournalLine] [nvarchar] (50) NULL,
[AccountingDate] [nvarchar] (50) NULL,
[Description] [nvarchar] (max) NULL,
[Currency] [nvarchar] (50) NULL,
[ExchangeRate] [nvarchar] (50) NULL,
[TransactionAmount] [nvarchar] (50) NULL,
[CustomerNum] [nvarchar] (50) NULL,
[SupplierNum] [nvarchar] (50) NULL,
[SalesInvoiceNum] [nvarchar] (50) NULL,
[PurchaseInvoiceNum] [nvarchar] (50) NULL,
[SupplierInvoiceNum] [nvarchar] (50) NULL,
[LinktoOriginalInvoice] [nvarchar] (500) NULL,
[TransactionNum] [nvarchar] (50) NULL,
[IsManual] [nvarchar] (50) NULL,
[CreatedTimeStamp] [nvarchar] (50) NULL,
[ModifiedTimeStamp] [nvarchar] (50) NULL,
[IndexKey] [nvarchar] (50) NULL,
[InvoiceAmountLC] [nvarchar] (50) NULL
)
GO