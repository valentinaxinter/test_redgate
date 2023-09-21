﻿/*
    This script was generated by SQL Change Automation to help provide object-level history. This script should never be edited manually.
    For more information see: https://www.red-gate.com/sca/dev/offline-schema-model
*/

CREATE TABLE [stage].[OCS_SE_PurchaseLedger]
(
[PartitionKey] [nvarchar] (50) NOT NULL,
[Company] [nvarchar] (8) NOT NULL,
[SupplierNum] [nvarchar] (50) NOT NULL,
[PurchaseInvoiceNum] [nvarchar] (50) NOT NULL,
[PurchaseOrderNum] [nvarchar] (50) NULL,
[SupplierInvoiceNum] [nvarchar] (50) NOT NULL,
[InvoiceAmount] [decimal] (18, 4) NOT NULL,
[InvoiceAmountSEK] [decimal] (18, 4) NULL,
[PaidInvoiceAmount] [decimal] (18, 4) NULL,
[PaidInvoiceAmountSEK] [decimal] (18, 4) NULL,
[RemainingInvoiceAmount] [decimal] (18, 4) NULL,
[RemainingInvoiceAmountSEK] [decimal] (18, 4) NULL,
[PurchaseInvoiceDate] [nvarchar] (50) NULL,
[PurchaseDueDate] [nvarchar] (50) NULL,
[PurchaseLastPaymentDate] [nvarchar] (50) NULL,
[AccountingDate] [nvarchar] (50) NULL,
[Currency] [nvarchar] (10) NULL,
[ExchangeRate] [decimal] (18, 4) NULL,
[VATAmount] [decimal] (18, 4) NULL,
[PaymentTerms] [nvarchar] (50) NULL,
[LinktoOriginalInvoice] [nvarchar] (max) NULL,
[VATCode] [nvarchar] (50) NULL,
[VATCodeDesc] [nvarchar] (max) NULL,
[IsInvoiceClosed] [nvarchar] (50) NULL,
[CostUnitNum] [nvarchar] (50) NULL,
[ProjectNum] [nvarchar] (50) NULL,
[ModifiedTimeStamp] [nvarchar] (50) NULL,
[CreatedTimeStamp] [nvarchar] (50) NULL
)
GO