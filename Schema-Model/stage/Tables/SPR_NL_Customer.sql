﻿/*
    This script was generated by SQL Change Automation to help provide object-level history. This script should never be edited manually.
    For more information see: https://www.red-gate.com/sca/dev/offline-schema-model
*/

CREATE TABLE [stage].[SPR_NL_Customer]
(
[PartitionKey] [nvarchar] (50) NULL,
[Company] [nvarchar] (8) NULL,
[CustomerNum] [nvarchar] (50) NULL,
[MainCustomerName] [nvarchar] (max) NULL,
[CustomerName] [nvarchar] (100) NULL,
[AddressLine1] [nvarchar] (max) NULL,
[AddressLine2] [nvarchar] (max) NULL,
[AddressLine3] [nvarchar] (max) NULL,
[TelephoneNum1] [nvarchar] (50) NULL,
[TelephoneNum2] [nvarchar] (50) NULL,
[Email] [nvarchar] (100) NULL,
[Email2] [nvarchar] (100) NULL,
[ZipCode] [nvarchar] (50) NULL,
[City] [nvarchar] (100) NULL,
[State] [nvarchar] (max) NULL,
[SalesDistrict] [nvarchar] (50) NULL,
[CountryName] [nvarchar] (50) NULL,
[Division] [nvarchar] (max) NULL,
[CustomerIndustry] [nvarchar] (50) NULL,
[CustomerSubIndustry] [nvarchar] (max) NULL,
[CustomerGroup] [nvarchar] (50) NULL,
[CustomerSubGroup] [nvarchar] (max) NULL,
[SalesPersonCode] [nvarchar] (50) NULL,
[SalesPersonName] [nvarchar] (50) NULL,
[SalesPersonResponsible] [nvarchar] (50) NULL,
[VATNum] [nvarchar] (50) NULL,
[AccountNum] [nvarchar] (max) NULL,
[InternalExternal] [nvarchar] (max) NULL,
[CustomerScore] [nvarchar] (50) NULL,
[CustomerType] [nvarchar] (50) NULL,
[CRes1] [nvarchar] (max) NULL,
[CRes2] [nvarchar] (max) NULL,
[CRes3] [nvarchar] (max) NULL
)
GO
