﻿/*
    This script was generated by SQL Change Automation to help provide object-level history. This script should never be edited manually.
    For more information see: https://www.red-gate.com/sca/dev/offline-schema-model
*/

CREATE TABLE [audit].[CompanyLinePipelinesLog]
(
[PipelineRunID] [varchar] (100) NULL,
[Company] [varchar] (40) NULL,
[StartTime] [datetime] NULL,
[EndTime] [datetime] NULL,
[Status] [varchar] (25) NULL,
[Date] [date] NULL,
[Triggered] [bit] NULL
)
GO
