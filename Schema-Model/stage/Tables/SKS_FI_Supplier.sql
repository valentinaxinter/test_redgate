﻿/*
    This script was generated by SQL Change Automation to help provide object-level history. This script should never be edited manually.
    For more information see: https://www.red-gate.com/sca/dev/offline-schema-model
*/

CREATE TABLE [stage].[SKS_FI_Supplier]
(
[PartitionKey] [varchar] (50) NOT NULL,
[EKORG] [nvarchar] (50) NOT NULL,
[SUPPLIERNUM] [nvarchar] (50) NOT NULL,
[MAINSUPPLIERNAME] [nvarchar] (100) NULL,
[SUPPLIERNAME] [nvarchar] (100) NULL,
[ADDRESSLINE1] [nvarchar] (100) NULL,
[ADDRESSLINE2] [nvarchar] (100) NULL,
[ADDRESSLINE3] [nvarchar] (100) NULL,
[TELEPHONENUM] [nvarchar] (20) NULL,
[EMAIL] [nvarchar] (200) NULL,
[CITY] [nvarchar] (50) NULL,
[ZIP] [nvarchar] (50) NULL,
[DISTRICT] [nvarchar] (50) NULL,
[COUNTRYNAME] [nvarchar] (100) NULL,
[REGION] [nvarchar] (50) NULL,
[SUPPLIERCATEGORY] [nvarchar] (50) NULL,
[SUPPLIERRESPONSIBLE] [nvarchar] (50) NULL,
[BANKACCOUNTNUM] [nvarchar] (50) NULL,
[VATNUM] [nvarchar] (50) NULL,
[INTERNALEXTERNAL] [nvarchar] (100) NULL,
[CUSTOMERNUM] [nvarchar] (50) NULL,
[CODEOFCONDUCT] [nvarchar] (200) NULL,
[SUPPLIERABC] [nvarchar] (50) NULL,
[MINORDERQTY] [nvarchar] (50) NULL,
[WEBSITE] [nvarchar] (100) NULL,
[COMMENTS] [nvarchar] (max) NULL,
[SRES1] [nvarchar] (100) NULL,
[SRES2] [nvarchar] (100) NULL,
[SRES3] [nvarchar] (100) NULL,
[MANDT] [nvarchar] (50) NULL,
[BUKRS] [nvarchar] (100) NULL,
[INTCA] [nvarchar] (12) NULL
)
GO