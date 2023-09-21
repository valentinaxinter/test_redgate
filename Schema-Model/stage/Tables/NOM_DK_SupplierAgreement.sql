﻿/*
    This script was generated by SQL Change Automation to help provide object-level history. This script should never be edited manually.
    For more information see: https://www.red-gate.com/sca/dev/offline-schema-model
*/

CREATE TABLE [stage].[NOM_DK_SupplierAgreement]
(
[PartitionKey] [varchar] (50) NOT NULL,
[Company] [nvarchar] (8) NOT NULL,
[AgreementCode] [nvarchar] (50) NULL,
[AgreementDescription] [nvarchar] (50) NULL,
[SupplierNum] [nvarchar] (50) NOT NULL,
[PartNum] [nvarchar] (50) NULL,
[DiscountPercent] [nvarchar] (50) NULL,
[UnitPrice] [decimal] (18, 4) NULL,
[AgreementQty] [nvarchar] (50) NULL,
[UoM] [nvarchar] (50) NULL,
[DelivTime] [nvarchar] (50) NULL,
[Currency] [nvarchar] (50) NULL,
[SupplierTerms] [nvarchar] (100) NULL,
[AgreementStart] [nvarchar] (50) NULL,
[AgreementEnd] [nvarchar] (50) NULL,
[SARes1] [nvarchar] (50) NULL
)
GO
