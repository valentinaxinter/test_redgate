﻿/*
    This script was generated by SQL Change Automation to help provide object-level history. This script should never be edited manually.
    For more information see: https://www.red-gate.com/sca/dev/offline-schema-model
*/

CREATE TABLE [dbo].[SourceTables_Company]
(
[SourceSystem] [nvarchar] (50) NULL,
[ServerName] [nvarchar] (100) NULL,
[DatabaseName] [varchar] (50) NULL,
[TableSchema] [varchar] (50) NULL,
[TableName] [varchar] (100) NULL,
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
[dwtablename] [nvarchar] (50) NULL
)
GO
