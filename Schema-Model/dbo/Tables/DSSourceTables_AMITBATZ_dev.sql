﻿/*
    This script was generated by SQL Change Automation to help provide object-level history. This script should never be edited manually.
    For more information see: https://www.red-gate.com/sca/dev/offline-schema-model
*/

CREATE TABLE [dbo].[DSSourceTables_AMITBATZ_dev]
(
[SourceSystem] [nvarchar] (50) NULL,
[ServerName] [nvarchar] (50) NULL,
[DatabaseName] [nvarchar] (50) NULL,
[TableSchema] [nvarchar] (50) NULL,
[TableName] [nvarchar] (50) NULL,
[TableLoadOrder] [int] NULL,
[DeltaLoadStatement] [nvarchar] (max) NULL,
[DeltaLoadValue] [nvarchar] (50) NULL,
[DeltaLoadGetNewValue] [nvarchar] (max) NULL,
[IsActive] [int] NULL,
[SourceSelectStatement] [varchar] (max) NULL,
[blobfilepath] [nvarchar] (50) NULL,
[blobfilename] [nvarchar] (50) NULL,
[Stagetablename] [nvarchar] (50) NULL,
[StoredProcedure] [nvarchar] (50) NULL,
[dwtablename] [nvarchar] (50) NULL,
[dwFilterColumnName] [varchar] (50) NULL,
[dwtablename_schema] [varchar] (8) NULL,
[Company] [varchar] (20) NULL,
[sourceFilterColumnName] [varchar] (20) NULL,
[dailyDatePart] [varchar] (20) NULL,
[weeklyDatePart] [varchar] (20) NULL,
[dailyNumber] [varchar] (20) NULL,
[weeklyNumber] [varchar] (20) NULL
)
GO