﻿/*
    This script was generated by SQL Change Automation to help provide object-level history. This script should never be edited manually.
    For more information see: https://www.red-gate.com/sca/dev/offline-schema-model
*/

CREATE TABLE [dbo].[LSSourceTables_CERTEX_newiScala34_dev]
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
[SourceSelectStatement] [nvarchar] (max) NULL,
[blobfilepath] [nvarchar] (100) NULL,
[blobfilename] [nvarchar] (50) NULL,
[Stagetablename] [nvarchar] (50) NULL,
[StoredProcedureViewName] [nvarchar] (100) NULL,
[StoredProcedure] [nvarchar] (50) NULL,
[dwtablename] [nvarchar] (50) NULL,
[Company] [nvarchar] (50) NULL,
[dwFilterColumnName] [varchar] (50) NULL,
[dwtablename_schema] [varchar] (8) NULL,
[sourceFilterColumnName] [varchar] (30) NULL,
[dailyDatePart] [varchar] (30) NULL,
[weeklyDatePart] [varchar] (30) NULL,
[dailyNumber] [varchar] (30) NULL,
[weeklyNumber] [varchar] (30) NULL
)
GO
