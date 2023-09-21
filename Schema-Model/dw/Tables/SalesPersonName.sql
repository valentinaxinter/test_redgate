﻿/*
    This script was generated by SQL Change Automation to help provide object-level history. This script should never be edited manually.
    For more information see: https://www.red-gate.com/sca/dev/offline-schema-model
*/

CREATE TABLE [dw].[SalesPersonName]
(
[SalesPersonNameID] [binary] (32) NOT NULL,
[Company] [nvarchar] (8) NOT NULL,
[SalesPersonName] [nvarchar] (100) NULL
)
GO
ALTER TABLE [dw].[SalesPersonName] ADD CONSTRAINT [PK__SalesPer__E5AA2C108D2F5219] PRIMARY KEY CLUSTERED ([SalesPersonNameID])
GO