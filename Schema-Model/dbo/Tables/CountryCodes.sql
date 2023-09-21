﻿/*
    This script was generated by SQL Change Automation to help provide object-level history. This script should never be edited manually.
    For more information see: https://www.red-gate.com/sca/dev/offline-schema-model
*/

CREATE TABLE [dbo].[CountryCodes]
(
[CountryName] [nvarchar] (100) NOT NULL,
[Alpha-2 code] [char] (2) NULL,
[Alpha-3 code] [char] (3) NULL,
[ISO Numeric code] [int] NULL,
[WorldBase-2 code] [char] (2) NULL,
[WorldBase Numeric Code] [int] NULL,
[WorldBase CountryName] [nvarchar] (100) NULL,
[Comments] [nvarchar] (200) NULL
)
GO
