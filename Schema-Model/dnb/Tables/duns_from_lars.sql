﻿/*
    This script was generated by SQL Change Automation to help provide object-level history. This script should never be edited manually.
    For more information see: https://www.red-gate.com/sca/dev/offline-schema-model
*/

CREATE TABLE [dnb].[duns_from_lars]
(
[id] [nvarchar] (100) NOT NULL,
[is_customer] [nvarchar] (6) NOT NULL,
[duns] [int] NOT NULL,
[conf_code] [tinyint] NOT NULL,
[id_binary] [binary] (32) NULL
)
GO
