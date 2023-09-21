﻿/*
    This script was generated by SQL Change Automation to help provide object-level history. This script should never be edited manually.
    For more information see: https://www.red-gate.com/sca/dev/offline-schema-model
*/

CREATE TABLE [stage].[CER_NO_Supplier]
(
[PartitionKey] [varchar] (50) NOT NULL,
[Company] [nvarchar] (8) NOT NULL,
[SupplierNum] [nvarchar] (50) NOT NULL,
[MainSupplierName] [nvarchar] (100) NULL,
[SupplierName] [nvarchar] (100) NULL,
[AddressLine1] [nvarchar] (100) NULL,
[AddressLine2] [nvarchar] (100) NULL,
[AddressLine3] [nvarchar] (100) NULL,
[TelephoneNum] [nvarchar] (20) NULL,
[Email] [nvarchar] (100) NULL,
[City] [nvarchar] (50) NULL,
[ZipCode] [nvarchar] (50) NULL,
[District] [nvarchar] (50) NULL,
[CountryCode] [nvarchar] (50) NULL,
[CountryName] [nvarchar] (100) NULL,
[Region] [nvarchar] (50) NULL,
[SupplierCategory] [nvarchar] (50) NULL,
[SupplierResponsible] [nvarchar] (50) NULL,
[AccountNum] [nvarchar] (50) NULL,
[VATNum] [nvarchar] (50) NULL,
[InternalExternal] [nvarchar] (100) NULL,
[CodeOfConduct] [nvarchar] (2) NULL,
[CustomerNum] [nvarchar] (50) NULL,
[Reference] [nvarchar] (100) NULL,
[SupplierScore] [nvarchar] (50) NULL,
[MinOrderQty] [decimal] (18, 4) NULL,
[Website] [nvarchar] (100) NULL,
[Comments] [nvarchar] (max) NULL
)
GO
