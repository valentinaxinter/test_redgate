﻿/*
    This script was generated by SQL Change Automation to help provide object-level history. This script should never be edited manually.
    For more information see: https://www.red-gate.com/sca/dev/offline-schema-model
*/

CREATE TABLE [dbo].[TSSourceTables_FORANKRASE_dev]
(
[SourceSystem] [varchar] (50) NOT NULL,
[ServerName] [nvarchar] (100) NULL,
[DatabaseName] [varchar] (50) NULL,
[TableSchema] [varchar] (50) NOT NULL,
[TableName] [varchar] (100) NOT NULL,
[TableLoadOrder] [int] NULL,
[DeltaLoadStatement] [varchar] (500) NULL,
[DeltaLoadValue] [varchar] (50) NULL,
[DeltaLoadGetNewValue] [varchar] (500) NULL,
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
[sourceFilterColumnName] [varchar] (30) NULL,
[dailyDatePart] [varchar] (30) NULL,
[weeklyDatePart] [varchar] (30) NULL,
[dailyNumber] [varchar] (30) NULL,
[weeklyNumber] [varchar] (30) NULL
)
GO