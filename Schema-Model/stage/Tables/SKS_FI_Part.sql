﻿/*
    This script was generated by SQL Change Automation to help provide object-level history. This script should never be edited manually.
    For more information see: https://www.red-gate.com/sca/dev/offline-schema-model
*/

CREATE TABLE [stage].[SKS_FI_Part]
(
[PartitionKey] [varchar] (50) NOT NULL,
[MANDT] [nvarchar] (3) NOT NULL,
[VKORG] [nvarchar] (4) NOT NULL,
[COMPANY] [nvarchar] (8) NOT NULL,
[PARTNUM] [nvarchar] (50) NOT NULL,
[PARTDESCRIPTION] [nvarchar] (max) NULL,
[PARTDESCRIPTION2] [nvarchar] (max) NULL,
[PRODUCTGROUP] [nvarchar] (100) NULL,
[PRODUCTGROUP2] [nvarchar] (100) NULL,
[PRODUCTGROUP4] [nvarchar] (100) NULL,
[COMMODITYCODE] [nvarchar] (50) NULL,
[COUNTRYOFORIGIN] [nvarchar] (50) NULL,
[NETWEIGHT] [decimal] (18, 4) NULL,
[SUPPLIERCODE] [nvarchar] (50) NULL,
[REORDERLEVEL] [decimal] (18, 4) NULL,
[WAREHOUSECODE] [nvarchar] (50) NULL,
[MEINS] [nvarchar] (3) NULL,
[PRODUCTGROUPTXT] [nvarchar] (50) NULL,
[PRODUCTGROUP2TXT] [nvarchar] (50) NULL,
[PARTNAME] [nvarchar] (50) NULL,
[PRODUCTGROUP3] [nvarchar] (50) NULL,
[BRAND] [nvarchar] (50) NULL,
[MODEL] [nvarchar] (50) NULL,
[VOLUME] [nvarchar] (50) NULL,
[MATERIAL] [nvarchar] (50) NULL,
[SUPPLIERNAME] [nvarchar] (200) NULL,
[SUPPLIERPRICE] [decimal] (18, 4) NULL,
[STARTDATE] [nvarchar] (8) NULL,
[ENDDATE] [nvarchar] (8) NULL,
[MATKL] [nvarchar] (20) NULL,
[PARTSTATUS] [nvarchar] (100) NULL,
[PRCTR] [nvarchar] (50) NULL
)
GO