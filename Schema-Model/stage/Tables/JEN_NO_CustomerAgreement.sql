﻿/*
    This script was generated by SQL Change Automation to help provide object-level history. This script should never be edited manually.
    For more information see: https://www.red-gate.com/sca/dev/offline-schema-model
*/

CREATE TABLE [stage].[JEN_NO_CustomerAgreement]
(
[PartitionKey] [varchar] (50) NOT NULL,
[Company] [nvarchar] (8) NOT NULL,
[AgreementCode] [nvarchar] (50) NULL,
[AgreementDescription] [nvarchar] (max) NULL,
[CustomerNum] [nvarchar] (50) NOT NULL,
[PartNum] [nvarchar] (50) NULL,
[DiscountPercent] [decimal] (18, 4) NULL,
[UnitPrice] [decimal] (18, 4) NULL,
[DelivTime] [nvarchar] (10) NULL,
[Currency] [nvarchar] (10) NULL,
[AgreementStart] [date] NULL,
[AgreementEnd] [date] NULL
)
GO
