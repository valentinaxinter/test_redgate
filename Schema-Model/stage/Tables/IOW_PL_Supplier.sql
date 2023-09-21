﻿/*
    This script was generated by SQL Change Automation to help provide object-level history. This script should never be edited manually.
    For more information see: https://www.red-gate.com/sca/dev/offline-schema-model
*/

CREATE TABLE [stage].[IOW_PL_Supplier]
(
[PartitionKey] [varchar] (50) NOT NULL,
[Company] [nvarchar] (8) NOT NULL,
[SupplierNum] [nvarchar] (50) NOT NULL,
[SupplierName] [nvarchar] (100) NULL,
[AddressLine1] [nvarchar] (100) NULL,
[AddressLine2] [nvarchar] (100) NULL,
[AddressLine3] [nvarchar] (100) NULL,
[City] [nvarchar] (50) NULL,
[State] [nvarchar] (50) NULL,
[ZipCode] [nvarchar] (50) NULL,
[CountryCode] [nvarchar] (50) NULL,
[CountryName] [nvarchar] (50) NULL,
[CodeOfConduct] [nvarchar] (50) NULL,
[SupplierGroup] [nvarchar] (50) NULL,
[SupplierIndustry] [nvarchar] (50) NULL,
[PrimaryPurchaser] [nvarchar] (50) NULL,
[CreatedTimeStamp] [nvarchar] (50) NULL,
[ModifiedTimeStamp] [nvarchar] (50) NULL,
[VATNum] [nvarchar] (50) NULL,
[OrgNum] [nvarchar] (50) NULL,
[TelephoneNumber1] [nvarchar] (50) NULL,
[TelephoneNumber2] [nvarchar] (50) NULL,
[Email] [nvarchar] (100) NULL,
[Website] [nvarchar] (500) NULL,
[MinOrderQty] [nvarchar] (50) NULL,
[IsAxInterInternal] [bit] NULL,
[SupplierScore] [nvarchar] (50) NULL,
[SupplierResponsible] [nvarchar] (50) NULL,
[RecordIsActive] [bit] NULL,
[IsMaterialSupplier] [bit] NULL,
[Comments] [nvarchar] (max) NULL,
[AccountNum] [nvarchar] (100) NULL,
[SRes1] [nvarchar] (500) NULL,
[SRes2] [nvarchar] (500) NULL,
[SRes3] [nvarchar] (500) NULL,
[SRes4] [nvarchar] (500) NULL,
[SRes5] [nvarchar] (500) NULL
)
GO