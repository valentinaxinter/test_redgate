﻿/*
    This script was generated by SQL Change Automation to help provide object-level history. This script should never be edited manually.
    For more information see: https://www.red-gate.com/sca/dev/offline-schema-model
*/

CREATE TABLE [dbo].[test_fields]
(
[new_fields] [varchar] (50) NOT NULL,
[sourceFilterColumnName] [varchar] (20) NULL,
[dailyDatePart] [varchar] (20) NULL,
[weeklyDatePart] [varchar] (20) NULL,
[dailyNumber] [varchar] (20) NULL,
[weeklyNumber] [varchar] (20) NULL,
[is_inferred] [bit] NULL
)
GO