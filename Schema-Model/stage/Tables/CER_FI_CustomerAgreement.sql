﻿/*
    This script was generated by SQL Change Automation to help provide object-level history. This script should never be edited manually.
    For more information see: https://www.red-gate.com/sca/dev/offline-schema-model
*/

CREATE TABLE [stage].[CER_FI_CustomerAgreement]
(
[AgreementCode] [nvarchar] (50) NULL,
[AgreementDescription] [nvarchar] (50) NULL,
[CustomerNum] [nvarchar] (50) NOT NULL,
[DiscountPercent1] [decimal] (18, 4) NULL,
[DiscountPercent2] [decimal] (18, 4) NULL,
[DiscountPercent3] [decimal] (18, 4) NULL,
[DiscountPercent4] [decimal] (18, 4) NULL,
[DiscountPercent5] [decimal] (18, 4) NULL,
[UnitPrice] [decimal] (18, 4) NULL,
[DelivTime ] [nvarchar] (10) NULL,
[Currency] [nvarchar] (10) NULL,
[AgreementStart] [date] NULL,
[AgreementEnd] [date] NULL,
[CustomerTerms] [nvarchar] (50) NULL,
[AgreementQty] [decimal] (18, 4) NULL,
[UoM] [nvarchar] (50) NULL,
[FulfilledQty] [decimal] (18, 4) NULL,
[RemainingQty] [decimal] (18, 4) NULL
)
GO
