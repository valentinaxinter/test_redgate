﻿/*
    This script was generated by SQL Change Automation to help provide object-level history. This script should never be edited manually.
    For more information see: https://www.red-gate.com/sca/dev/offline-schema-model
*/

CREATE TABLE [stage].[OCS_SE_PurchaseClaims]
(
[PartitionKey] [nvarchar] (50) NOT NULL,
[Company] [nvarchar] (50) NOT NULL,
[SupplierNum] [nvarchar] (50) NULL,
[PurchaseOrderNum] [nvarchar] (50) NULL,
[PurchaseOrderLine] [nvarchar] (50) NULL,
[ClaimNum] [nvarchar] (50) NULL,
[ClaimDescription] [nvarchar] (50) NULL,
[ClaimType] [nvarchar] (50) NULL,
[PartNum] [nvarchar] (50) NULL,
[Comment] [nvarchar] (50) NULL,
[CLRes1] [nvarchar] (50) NULL,
[CreatedTimeStamp] [nvarchar] (50) NULL,
[ModifiedTimeStamp] [nvarchar] (50) NULL
)
GO
