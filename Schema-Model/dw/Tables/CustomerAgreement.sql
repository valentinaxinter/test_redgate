﻿/*
    This script was generated by SQL Change Automation to help provide object-level history. This script should never be edited manually.
    For more information see: https://www.red-gate.com/sca/dev/offline-schema-model
*/

CREATE TABLE [dw].[CustomerAgreement]
(
[CustomerAgreementID] [binary] (32) NOT NULL,
[Company] [nvarchar] (8) NOT NULL,
[CustomerNum] [nvarchar] (50) NOT NULL,
[PartNum] [nvarchar] (50) NOT NULL,
[AgreementCode] [nvarchar] (50) NULL,
[AgreementDescription] [nvarchar] (max) NULL,
[DiscountPercent] [decimal] (18, 4) NULL,
[UnitPrice] [decimal] (18, 4) NULL,
[AgreementQty] [decimal] (18, 4) NULL,
[FulfilledQty] [decimal] (18, 4) NULL,
[RemainingQty] [decimal] (18, 4) NULL,
[Currency] [nvarchar] (10) NULL,
[DelivTime] [smallint] NULL,
[AgreementStart] [date] NULL,
[AgreementEnd] [date] NULL,
[CustomerTerms] [nvarchar] (max) NULL,
[CompanyID] [binary] (32) NULL,
[CustomerID] [binary] (32) NULL,
[CurrencyID] [binary] (32) NULL,
[PartID] [binary] (32) NULL,
[PartitionKey] [nvarchar] (50) NULL,
[CARes1] [nvarchar] (100) NULL,
[CARes2] [nvarchar] (100) NULL,
[CARes3] [nvarchar] (100) NULL,
[UoM] [nvarchar] (50) NULL,
[is_deleted] [bit] NULL,
[is_inferred] [bit] NULL,
[AgreementResponsible] [nvarchar] (100) NULL,
[IsActiveRecord] [bit] NULL
)
GO
ALTER TABLE [dw].[CustomerAgreement] ADD CONSTRAINT [PK_CustomerAgreement] PRIMARY KEY CLUSTERED ([CustomerAgreementID])
GO
