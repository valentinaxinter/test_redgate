﻿/*
    This script was generated by SQL Change Automation to help provide object-level history. This script should never be edited manually.
    For more information see: https://www.red-gate.com/sca/dev/offline-schema-model
*/

CREATE TABLE [dbo].[LSSourceTables_CERTEXDK_dev]
(
[SourceSystem] [nvarchar] (50) NULL,
[ServerName] [nvarchar] (50) NULL,
[DatabaseName] [nvarchar] (50) NULL,
[TableSchema] [nvarchar] (50) NULL,
[TableName] [nvarchar] (100) NULL,
[TableLoadOrder] [nvarchar] (50) NULL,
[DeltaLoadStatement] [nvarchar] (500) NULL,
[DeltaLoadValue] [nvarchar] (50) NULL,
[DeltaLoadGetNewValue] [nvarchar] (500) NULL,
[IsActive] [int] NULL,
[SourceSelectStatement] [nvarchar] (1000) NULL,
[blobfilepath] [nvarchar] (50) NULL,
[blobfilename] [nvarchar] (50) NULL,
[Stagetablename] [nvarchar] (50) NULL,
[StoredProcedure] [nvarchar] (50) NULL,
[dwtablename] [nvarchar] (50) NULL,
[dwtablename_schema] [varchar] (8) NULL,
[dwFilterColumnName] [varchar] (50) NULL,
[Company] [varchar] (20) NULL,
[sourceFilterColumnName] [varchar] (30) NULL,
[dailyDatePart] [varchar] (30) NULL,
[weeklyDatePart] [varchar] (30) NULL,
[dailyNumber] [varchar] (30) NULL,
[weeklyNumber] [varchar] (30) NULL
)
GO
