﻿/*
    This script was generated by SQL Change Automation to help provide object-level history. This script should never be edited manually.
    For more information see: https://www.red-gate.com/sca/dev/offline-schema-model
*/

CREATE TABLE [stage].[UnspscCodes]
(
[duns] [int] NULL,
[organization.unspscCodes.code] [nvarchar] (20) NULL,
[organization.unspscCodes.description] [nvarchar] (250) NULL,
[organization.unspscCodes.priority] [nvarchar] (10) NULL
)
GO
