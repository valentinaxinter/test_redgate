﻿/*
    This script was generated by SQL Change Automation to help provide object-level history. This script should never be edited manually.
    For more information see: https://www.red-gate.com/sca/dev/offline-schema-model
*/

CREATE TABLE [dw].[PIM]
(
[PimID] [binary] (32) NOT NULL,
[PartID] [binary] (32) NULL,
[CompanyID] [binary] (32) NULL,
[ProductID] [nvarchar] (50) NULL,
[Manufacturer_Id] [nvarchar] (50) NULL,
[Brand] [nvarchar] (50) NULL,
[Heading] [nvarchar] (50) NULL,
[Original_Description] [nvarchar] (max) NULL,
[Last_category_name] [nvarchar] (500) NULL,
[Category_name] [nvarchar] (500) NULL,
[Category_name2] [nvarchar] (500) NULL,
[Category_name3] [nvarchar] (500) NULL,
[Category_name4] [nvarchar] (500) NULL,
[Category_name5] [nvarchar] (500) NULL,
[Category_name6] [nvarchar] (500) NULL,
[PartNum] [nvarchar] (50) NULL,
[Company] [nvarchar] (50) NULL,
[PartitionKey] [nvarchar] (50) NULL,
[is_deleted] [bit] NULL,
[is_inferred] [bit] NULL
)
GO
ALTER TABLE [dw].[PIM] ADD CONSTRAINT [PK_PIM] PRIMARY KEY CLUSTERED ([PimID])
GO
