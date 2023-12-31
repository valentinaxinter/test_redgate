﻿/*
    This script was generated by SQL Change Automation to help provide object-level history. This script should never be edited manually.
    For more information see: https://www.red-gate.com/sca/dev/offline-schema-model
*/

CREATE TABLE [dw].[RLS]
(
[id] [binary] (32) NULL,
[Company] [nvarchar] (50) NOT NULL,
[Email] [nvarchar] (50) NOT NULL,
[RLSTable] [nvarchar] (50) NOT NULL,
[RLSField] [nvarchar] (50) NOT NULL,
[RLSValue] [nvarchar] (50) NOT NULL,
[AccessType] [nvarchar] (50) NOT NULL,
[SourceList] [nvarchar] (100) NOT NULL,
[Modified_at] [datetime] NOT NULL,
[Author] [nvarchar] (50) NOT NULL
)
GO
ALTER TABLE [dw].[RLS] ADD CONSTRAINT [UC_Company_Email] UNIQUE NONCLUSTERED ([Company], [Email], [RLSTable], [RLSField], [RLSValue])
GO
