﻿/*
    This script was generated by SQL Change Automation to help provide object-level history. This script should never be edited manually.
    For more information see: https://www.red-gate.com/sca/dev/offline-schema-model
*/

CREATE TABLE [stage].[SUM_UK_Customer]
(
[PartitionKey] [varchar] (50) NOT NULL,
[Company] [nvarchar] (12) NOT NULL,
[CustomerNum] [nvarchar] (50) NOT NULL,
[MainCustomerName] [nvarchar] (100) NULL,
[CustomerName] [nvarchar] (100) NULL,
[AddressLine1] [nvarchar] (100) NULL,
[AddressLine2] [nvarchar] (100) NULL,
[AddressLine3] [nvarchar] (100) NULL,
[TelephoneNumber1] [nvarchar] (50) NULL,
[PHONE2] [nvarchar] (50) NULL,
[ZipCode] [nvarchar] (50) NULL,
[CITY] [nvarchar] (50) NULL,
[STATE] [nvarchar] (50) NULL,
[District] [nvarchar] (50) NULL,
[Email] [nvarchar] (500) NULL,
[CCode] [nvarchar] (50) NULL,
[CountryName] [nvarchar] (100) NULL,
[Division] [nvarchar] (50) NULL,
[CustomerIndustry] [nvarchar] (50) NULL,
[CustomerSubIndustry] [nvarchar] (50) NULL,
[CustomerGroup] [nvarchar] (50) NULL,
[CustomerSubGroup] [nvarchar] (50) NULL,
[SalesRepCode] [nvarchar] (50) NULL,
[SalesPersonName] [nvarchar] (100) NULL,
[SalesPersonResponsible] [nvarchar] (100) NULL,
[VATRegNo] [nvarchar] (50) NULL,
[AccountString] [nvarchar] (50) NULL,
[InternalExternal] [nvarchar] (50) NULL,
[CustomerType] [nvarchar] (50) NULL,
[CustomerABC] [nvarchar] (50) NULL,
[Res1] [nvarchar] (100) NULL,
[Res2] [nvarchar] (100) NULL,
[Res3] [nvarchar] (100) NULL
)
GO
