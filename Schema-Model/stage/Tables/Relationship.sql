﻿/*
    This script was generated by SQL Change Automation to help provide object-level history. This script should never be edited manually.
    For more information see: https://www.red-gate.com/sca/dev/offline-schema-model
*/

CREATE TABLE [stage].[Relationship]
(
[customerReference] [nvarchar] (60) NOT NULL,
[duns] [int] NULL,
[organization.confidenceCode] [int] NULL,
[match_status] [nvarchar] (15) NULL,
[error_detail] [nvarchar] (300) NULL,
[enrich_status] [nvarchar] (15) NULL
)
GO