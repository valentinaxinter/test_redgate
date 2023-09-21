﻿/*
    This script was generated by SQL Change Automation to help provide object-level history. This script should never be edited manually.
    For more information see: https://www.red-gate.com/sca/dev/offline-schema-model
*/

CREATE TABLE [stage].[TRA_SE_CustomerAgreement]
(
[PartitionKey] [nvarchar] (25) NULL,
[Company] [nvarchar] (8) NULL,
[CustomerNum] [nvarchar] (20) NULL,
[PartNum] [nvarchar] (30) NULL,
[AgreementCode] [nvarchar] (10) NULL,
[AgreementDescription] [nvarchar] (50) NULL,
[DiscountPercent] [nvarchar] (60) NULL,
[UnitPrice] [nvarchar] (60) NULL,
[AgreementQty] [nvarchar] (60) NULL,
[FulfilledQty] [nvarchar] (60) NULL,
[RemainingQty] [nvarchar] (60) NULL,
[UoM] [nvarchar] (4) NULL,
[Currency] [nvarchar] (3) NULL,
[DelivTime] [nvarchar] (60) NULL,
[AgreementStart] [nvarchar] (60) NULL,
[AgreementEnd] [nvarchar] (60) NULL,
[AgreementResponsible] [nvarchar] (50) NULL,
[CreatedTimeStamp] [nvarchar] (60) NULL,
[ModifiedTimeStamp] [nvarchar] (60) NULL,
[RecordIsActive] [nvarchar] (1) NULL
)
GO