﻿/*
    This script was generated by SQL Change Automation to help provide object-level history. This script should never be edited manually.
    For more information see: https://www.red-gate.com/sca/dev/offline-schema-model
*/

CREATE TABLE [dw].[Project]
(
[ProjectID] [binary] (32) NOT NULL,
[ProjectCode] [nvarchar] (200) NOT NULL,
[PartitionKey] [varchar] (50) NOT NULL,
[Company] [nvarchar] (8) NOT NULL,
[MainProjectNum] [nvarchar] (50) NULL,
[ProjectNum] [nvarchar] (50) NOT NULL,
[ProjectDescription] [nvarchar] (max) NULL,
[Organisation] [nvarchar] (50) NULL,
[ProjectStatus] [nvarchar] (50) NULL,
[ProjectCategory] [nvarchar] (50) NULL,
[WBSElement] [nvarchar] (50) NULL,
[ObjectNum] [nvarchar] (50) NULL,
[Level] [nvarchar] (50) NULL,
[Currency] [nvarchar] (50) NULL,
[WarehouseCode] [nvarchar] (50) NULL,
[ProjectResponsible] [nvarchar] (50) NULL,
[Comments] [nvarchar] (max) NULL,
[StartDate] [date] NULL,
[EndDate] [date] NULL,
[EstEndDate] [date] NULL,
[ProjectCompletion] [decimal] (18, 4) NULL,
[ActualCost] [decimal] (18, 4) NULL,
[is_deleted] [bit] NULL,
[IsActiveRecord] [bit] NULL,
[PJRes1] [nvarchar] (100) NULL,
[PJRes2] [nvarchar] (100) NULL,
[PJRes3] [nvarchar] (100) NULL,
[ProjectNumLine] [nvarchar] (50) NULL
)
GO
ALTER TABLE [dw].[Project] ADD CONSTRAINT [PK_Project] PRIMARY KEY CLUSTERED ([ProjectID])
GO
