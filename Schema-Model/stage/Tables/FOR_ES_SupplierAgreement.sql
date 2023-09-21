﻿/*
    This script was generated by SQL Change Automation to help provide object-level history. This script should never be edited manually.
    For more information see: https://www.red-gate.com/sca/dev/offline-schema-model
*/

CREATE TABLE [stage].[FOR_ES_SupplierAgreement]
(
[PartitionKey] [varchar] (50) NOT NULL,
[Company] [nvarchar] (8) NOT NULL,
[AgreementCode] [nvarchar] (20) NULL,
[AgreementDescription] [nvarchar] (50) NULL,
[SupplierNum] [nvarchar] (50) NOT NULL,
[PartNum] [nvarchar] (50) NULL,
[DiscountPercent] [decimal] (9, 2) NULL,
[UnitPrice] [decimal] (9, 2) NULL,
[AgreementQty] [decimal] (9, 2) NULL,
[Currency] [nvarchar] (10) NULL,
[AgreementStart] [date] NULL,
[AgreementEnd] [date] NULL,
[SupplierTerms] [nvarchar] (100) NULL,
[SARes1] [nvarchar] (100) NULL
)
GO
