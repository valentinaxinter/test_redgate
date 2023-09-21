﻿/*
    This script was generated by SQL Change Automation to help provide object-level history. This script should never be edited manually.
    For more information see: https://www.red-gate.com/sca/dev/offline-schema-model
*/

CREATE TABLE [stage].[NOM_FI_PurchaseLedger]
(
[PartitionKey] [nvarchar] (50) NOT NULL,
[Company] [nvarchar] (8) NOT NULL,
[SupplierNum] [nvarchar] (50) NOT NULL,
[PurchaseOrderNum] [nvarchar] (50) NULL,
[PurchaseInvoiceNum] [nvarchar] (50) NOT NULL,
[PurchaseInvoiceDate] [date] NULL,
[DueDate] [date] NULL,
[LastPaymentDate] [date] NULL,
[InvoiceAmount] [decimal] (18, 4) NOT NULL,
[RemainingInvoiceAmount] [decimal] (18, 4) NULL,
[ExchangeRate] [decimal] (18, 4) NULL,
[Currency] [nvarchar] (10) NULL,
[VATAmount] [decimal] (18, 4) NULL,
[VATCode] [nvarchar] (10) NULL,
[PayToName] [nvarchar] (50) NULL,
[PayToCity] [nvarchar] (50) NULL,
[PayToContact] [nvarchar] (50) NULL,
[PaymentTerms] [nvarchar] (50) NULL,
[PrePaymentNum] [nvarchar] (50) NULL,
[LastPaymentNum] [nvarchar] (50) NULL,
[PLRes1] [nchar] (10) NULL,
[PLRes2] [nchar] (10) NULL,
[PLRes3] [nchar] (10) NULL
)
GO
