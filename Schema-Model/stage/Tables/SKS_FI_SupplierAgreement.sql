﻿/*
    This script was generated by SQL Change Automation to help provide object-level history. This script should never be edited manually.
    For more information see: https://www.red-gate.com/sca/dev/offline-schema-model
*/

CREATE TABLE [stage].[SKS_FI_SupplierAgreement]
(
[PartitionKey] [varchar] (50) NOT NULL,
[COMPANY] [nvarchar] (8) NOT NULL,
[MANDT] [nvarchar] (50) NULL,
[SUPPLIER] [nvarchar] (50) NOT NULL,
[PRODUCT] [nvarchar] (50) NULL,
[REC_TYPE] [nvarchar] (50) NULL,
[REC_TYPE_DESC] [nvarchar] (50) NULL,
[DISCOUNT_PRC] [decimal] (18, 4) NULL,
[UNIT_PRICE] [decimal] (18, 4) NULL,
[QUANTITY] [decimal] (18, 4) NULL,
[CURRENCY] [nvarchar] (10) NULL,
[DELIVERY_TIME] [nvarchar] (10) NULL,
[AGREEMENT_START] [nvarchar] (50) NULL,
[AGREEMENT_END] [nvarchar] (50) NULL,
[SUPPLIER_TERMS] [nvarchar] (50) NULL,
[UNIT] [nvarchar] (50) NULL,
[SRES1] [nvarchar] (50) NULL,
[SRES2] [nvarchar] (50) NULL,
[SRES3] [nvarchar] (50) NULL,
[EKORG] [nvarchar] (50) NULL,
[INFNR] [nvarchar] (50) NULL
)
GO
