﻿/*
    This script was generated by SQL Change Automation to help provide object-level history. This script should never be edited manually.
    For more information see: https://www.red-gate.com/sca/dev/offline-schema-model
*/

CREATE TABLE [stage].[PAS_PL_Part]
(
[PartitionKey] [varchar] (50) NOT NULL,
[company] [nvarchar] (8) NULL,
[partnum] [nvarchar] (50) NULL,
[partname] [nvarchar] (200) NULL,
[partdescription] [nvarchar] (max) NULL,
[partdescription2] [nvarchar] (max) NULL,
[productgroup] [nvarchar] (50) NULL,
[productgroup2] [nvarchar] (50) NULL,
[productgroup3] [nvarchar] (50) NULL,
[brand] [nvarchar] (50) NULL,
[model] [nvarchar] (50) NULL,
[commoditycode] [nvarchar] (50) NULL,
[partstatus] [nvarchar] (50) NULL,
[countryoforigin] [nvarchar] (50) NULL,
[netweight] [decimal] (18, 4) NULL,
[volume] [decimal] (18, 4) NULL,
[material] [nvarchar] (50) NULL,
[barcode] [nvarchar] (50) NULL,
[reorderlevel] [decimal] (18, 4) NULL,
[startdate] [date] NULL,
[enddate] [date] NULL,
[res1] [nvarchar] (50) NULL,
[res2] [nvarchar] (50) NULL,
[res3] [nvarchar] (50) NULL
)
GO
