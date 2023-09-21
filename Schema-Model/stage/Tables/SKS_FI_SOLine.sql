﻿/*
    This script was generated by SQL Change Automation to help provide object-level history. This script should never be edited manually.
    For more information see: https://www.red-gate.com/sca/dev/offline-schema-model
*/

CREATE TABLE [stage].[SKS_FI_SOLine]
(
[PartitionKey] [varchar] (50) NOT NULL,
[MANDT] [nvarchar] (3) NOT NULL,
[COMPANY] [nvarchar] (8) NOT NULL,
[INVOICENUM] [nvarchar] (50) NULL,
[INVOICELINE] [nvarchar] (50) NULL,
[FKART] [nvarchar] (4) NULL,
[INVOICETYPE] [nvarchar] (5) NULL,
[VBTYP] [nvarchar] (1) NULL,
[VKORG] [nvarchar] (4) NULL,
[CUSTNUM] [nvarchar] (50) NULL,
[INVOICEDATE] [nvarchar] (8) NULL,
[ERNAM] [nvarchar] (12) NULL,
[SALESPERSON] [nvarchar] (50) NULL,
[PARTNUM] [nvarchar] (50) NULL,
[ARKTX] [nvarchar] (40) NULL,
[MATKL] [nvarchar] (50) NULL,
[ORDERNUM] [nvarchar] (50) NULL,
[SELLINGSHIPQTY] [decimal] (18, 3) NULL,
[UNITPRICE] [decimal] (18, 4) NULL,
[CURRENCY] [nvarchar] (5) NULL,
[UNITCOST] [decimal] (18, 4) NULL,
[WAREHOUSECODE] [nvarchar] (50) NULL,
[DISCOUNTAMOUNT] [decimal] (18, 4) NULL,
[ACTUALDELIVERYDATE] [nvarchar] (8) NULL,
[VRKME] [nvarchar] (3) NULL,
[ORDERLINE] [nvarchar] (50) NULL,
[ORDERSUBLINE] [nvarchar] (50) NULL,
[ORDERREL] [nvarchar] (50) NULL,
[CREDITMEMO] [nvarchar] (50) NULL,
[KNUMV] [nvarchar] (10) NULL,
[DUEDATE] [nvarchar] (8) NULL,
[LASTPAYMENTDATE] [nvarchar] (8) NULL,
[ZTERM] [nvarchar] (4) NULL,
[ORDERTYPE] [nvarchar] (5) NULL,
[SITE] [nvarchar] (50) NULL,
[INDEXKEY] [nvarchar] (50) NULL,
[FAREG] [nvarchar] (50) NULL,
[EXCHANGERATE] [decimal] (18, 4) NULL,
[MINORDERVALUEFEE] [decimal] (18, 4) NULL,
[FREIGHTINSURANCE] [decimal] (18, 4) NULL,
[PROJECTNUM] [nvarchar] (50) NULL,
[WBS_ELEMENT] [nvarchar] (50) NULL,
[SALESPERSONINVOICE] [nvarchar] (50) NULL,
[SALESPERSONORDER] [nvarchar] (50) NULL
)
GO