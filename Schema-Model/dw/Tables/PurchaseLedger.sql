﻿/*
    This script was generated by SQL Change Automation to help provide object-level history. This script should never be edited manually.
    For more information see: https://www.red-gate.com/sca/dev/offline-schema-model
*/

CREATE TABLE [dw].[PurchaseLedger]
(
[PurchaseLedgerID] [binary] (32) NOT NULL,
[Company] [nvarchar] (8) NOT NULL,
[SupplierNum] [nvarchar] (50) NOT NULL,
[PurchaseOrderNum] [nvarchar] (50) NULL,
[PurchaseInvoiceNum] [nvarchar] (50) NOT NULL,
[PurchaseInvoiceDate] [date] NULL,
[PurchaseDueDate] [date] NULL,
[PurchaseLastPaymentDate] [date] NULL,
[InvoiceAmount] [decimal] (18, 4) NULL,
[ExchangeRate] [decimal] (18, 8) NULL,
[Currency] [nvarchar] (10) NOT NULL,
[VATAmount] [decimal] (18, 4) NULL,
[VATCode] [nvarchar] (10) NULL,
[PayToName] [nvarchar] (100) NULL,
[PayToCity] [nvarchar] (50) NULL,
[PayToContact] [nvarchar] (50) NULL,
[PaymentTerms] [nvarchar] (100) NULL,
[PrePaymentNum] [nvarchar] (50) NULL,
[LastPaymentNum] [nvarchar] (50) NULL,
[PLRes1] [nvarchar] (100) NULL,
[PLRes2] [nvarchar] (100) NULL,
[PLRes3] [nvarchar] (100) NULL,
[PurchaseLedgerCode] [nvarchar] (500) NULL,
[CompanyID] [binary] (32) NULL,
[SupplierID] [binary] (32) NULL,
[PurchaseInvoiceID] [binary] (32) NULL,
[PurchaseOrderNumID] [binary] (32) NULL,
[CurrencyID] [binary] (32) NULL,
[PurchaseInvoiceDateID] [nvarchar] (50) NULL,
[PartitionKey] [varchar] (50) NOT NULL,
[PaidInvoiceAmount] [decimal] (18, 4) NULL,
[AccountingDate] [date] NULL,
[AgingPeriod] [nvarchar] (50) NULL,
[VATCodeDesc] [nvarchar] (300) NULL,
[RemainingInvoiceAmount] [decimal] (18, 4) NULL,
[AgingSort] [int] NULL,
[LinkToOriginalInvoice] [nvarchar] (500) NULL,
[is_deleted] [bit] NULL,
[SupplierInvoiceNum] [nvarchar] (50) NULL,
[IsInvoiceClosed] [bit] NULL,
[CostUnitNum] [nvarchar] (50) NULL,
[PaymentEvents] [int] NULL,
[IsActiveRecord] [bit] NULL
)
GO
ALTER TABLE [dw].[PurchaseLedger] ADD CONSTRAINT [PK_PurchaseLedger] PRIMARY KEY CLUSTERED ([PurchaseLedgerID])
GO
CREATE NONCLUSTERED INDEX [IX_Company_PurchaseDueDate] ON [dw].[PurchaseLedger] ([Company], [PurchaseDueDate] DESC)
GO
CREATE NONCLUSTERED INDEX [IX_Company_PurchaseInvoiceDate] ON [dw].[PurchaseLedger] ([Company], [PurchaseInvoiceDate] DESC)
GO
