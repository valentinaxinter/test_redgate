﻿/*
    This script was generated by SQL Change Automation to help provide object-level history. This script should never be edited manually.
    For more information see: https://www.red-gate.com/sca/dev/offline-schema-model
*/

CREATE TABLE [stage].[IndustryCodes]
(
[duns] [int] NULL,
[organization.industryCodes.code] [nvarchar] (100) NULL,
[organization.industryCodes.description] [nvarchar] (300) NULL,
[organization.industryCodes.priority] [nvarchar] (100) NULL,
[organization.industryCodes.typeDescription] [nvarchar] (100) NULL,
[organization.industryCodes.typeDnBCode] [nvarchar] (100) NULL
)
GO
