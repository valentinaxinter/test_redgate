﻿/*
    This script was generated by SQL Change Automation to help provide object-level history. This script should never be edited manually.
    For more information see: https://www.red-gate.com/sca/dev/offline-schema-model
*/

CREATE TABLE [stage].[SKS_FI_StockBalance]
(
[PartitionKey] [varchar] (50) NULL,
[MANDT] [nvarchar] (50) NULL,
[COMPANY] [nvarchar] (50) NULL,
[WAREHOUSECODE] [nvarchar] (50) NULL,
[PARTNUM] [nvarchar] (50) NULL,
[CURRENCY] [nvarchar] (50) NULL,
[DEFAULTBINNUM] [nvarchar] (50) NULL,
[SUPPLIERNUM] [nvarchar] (50) NULL,
[DELIVERYTIME] [decimal] (18, 4) NULL,
[STOCKTAKEDATE] [nvarchar] (50) NULL,
[STDCOSTLACAD] [nvarchar] (50) NULL,
[MAXSTOCKQTY] [nvarchar] (50) NULL,
[STOCKBALANCE] [decimal] (18, 4) NULL,
[STOCKVALUE] [decimal] (18, 4) NULL,
[RESERVEDQTY] [nvarchar] (50) NULL,
[BACKORDERQTY] [nvarchar] (50) NULL,
[ORDEREDQTY] [decimal] (18, 4) NULL,
[STOCKTAKDIFF] [nvarchar] (50) NULL,
[REORDERLEVEL] [decimal] (18, 4) NULL,
[OPTIMALORDERQTY] [decimal] (18, 4) NULL,
[SRES1] [nvarchar] (50) NULL,
[SRES2] [nvarchar] (50) NULL,
[SRES3] [nvarchar] (50) NULL
)
GO
