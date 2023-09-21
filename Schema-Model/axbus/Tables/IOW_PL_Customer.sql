﻿/*
    This script was generated by SQL Change Automation to help provide object-level history. This script should never be edited manually.
    For more information see: https://www.red-gate.com/sca/dev/offline-schema-model
*/

CREATE TABLE [axbus].[IOW_PL_Customer]
(
[PartitionKey] [nvarchar] (50) NULL,
[Company] [nvarchar] (50) NULL,
[CustomerNum] [nvarchar] (50) NULL,
[MainCustomerName] [nvarchar] (max) NULL,
[CustomerName] [nvarchar] (max) NULL,
[AddressLine1] [nvarchar] (max) NULL,
[AddressLine2] [nvarchar] (max) NULL,
[AddressLine3] [nvarchar] (max) NULL,
[TelephoneNum1] [nvarchar] (max) NULL,
[TelephoneNum2] [nvarchar] (max) NULL,
[Email] [nvarchar] (max) NULL,
[ZipCode] [nvarchar] (50) NULL,
[City] [nvarchar] (max) NULL,
[State] [nvarchar] (max) NULL,
[CountryName] [nvarchar] (max) NULL,
[CountryCode] [nvarchar] (max) NULL,
[Division] [nvarchar] (max) NULL,
[CustomerIndustry] [nvarchar] (max) NULL,
[CustomerSubIndustry] [nvarchar] (max) NULL,
[CustomerGroup] [nvarchar] (max) NULL,
[CustomerSubGroup] [nvarchar] (max) NULL,
[SalesPersonCode] [nvarchar] (max) NULL,
[SalesPersonName] [nvarchar] (max) NULL,
[SalesPersonResponsible] [nvarchar] (max) NULL,
[CustomerScore] [nvarchar] (max) NULL,
[CustomerType] [nvarchar] (max) NULL,
[VATNum] [nvarchar] (50) NULL,
[AccountNum] [nvarchar] (50) NULL,
[InternalExternal] [nvarchar] (50) NULL,
[SalesDistrict] [nvarchar] (max) NULL,
[CRes1] [nvarchar] (max) NULL,
[CRes2] [nvarchar] (max) NULL,
[CRes3] [nvarchar] (max) NULL,
[CreatedTimeStamp] [nvarchar] (max) NULL,
[ModifiedTimeStamp] [nvarchar] (max) NULL
)
GO