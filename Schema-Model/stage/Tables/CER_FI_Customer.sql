﻿/*
    This script was generated by SQL Change Automation to help provide object-level history. This script should never be edited manually.
    For more information see: https://www.red-gate.com/sca/dev/offline-schema-model
*/

CREATE TABLE [stage].[CER_FI_Customer]
(
[PartitionKey] [varchar] (50) NOT NULL,
[Company] [nvarchar] (8) NOT NULL,
[CustomerNum] [nvarchar] (50) NOT NULL,
[CustomerName] [nvarchar] (50) NULL,
[MainCustomerNum] [nvarchar] (50) NULL,
[AddressLine1] [nvarchar] (50) NULL,
[AddressLine2] [nvarchar] (50) NULL,
[AddressLine3] [nvarchar] (50) NULL,
[TelephoneNumber1] [nvarchar] (50) NULL,
[TelephoneNumber2] [nvarchar] (50) NULL,
[Email] [nvarchar] (100) NULL,
[ABCCode] [nchar] (10) NULL,
[City] [nvarchar] (50) NULL,
[ZIP] [nvarchar] (50) NULL,
[State] [nvarchar] (50) NULL,
[CountryCode] [nvarchar] (50) NULL,
[CountryName] [nvarchar] (50) NULL,
[CustomerGroup] [nvarchar] (50) NULL,
[SalesRepCode] [nvarchar] (50) NULL,
[VATRegNr] [nvarchar] (20) NULL,
[OrganizationNum] [nvarchar] (100) NULL,
[AccountString] [nvarchar] (50) NULL,
[District] [nvarchar] (50) NULL,
[InternalExternal] [nvarchar] (2) NULL,
[SalesPersonName] [nvarchar] (30) NULL,
[CustomerType] [nvarchar] (50) NULL
)
GO
