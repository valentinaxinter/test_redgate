﻿/*
    This script was generated by SQL Change Automation to help provide object-level history. This script should never be edited manually.
    For more information see: https://www.red-gate.com/sca/dev/offline-schema-model
*/

CREATE TABLE [stage].[OCS_SE_Customer]
(
[PartitionKey] [varchar] (50) NOT NULL,
[Company] [nvarchar] (8) NULL,
[CustomerNum] [nvarchar] (50) NOT NULL,
[MainCustomerName] [nvarchar] (100) NULL,
[CustomerName] [nvarchar] (100) NULL,
[AddressLine1] [nvarchar] (50) NULL,
[AddressLine2] [nvarchar] (50) NULL,
[AddressLine3] [nvarchar] (50) NULL,
[TelephoneNumber1] [nvarchar] (50) NULL,
[ZipCode] [nvarchar] (50) NULL,
[City] [nvarchar] (50) NULL,
[State] [nvarchar] (50) NULL,
[Email] [nvarchar] (100) NULL,
[District] [nvarchar] (50) NULL,
[CountryCode] [nvarchar] (50) NULL,
[CountryName] [nvarchar] (50) NULL,
[Division] [nvarchar] (50) NULL,
[CustomerIndustry] [nvarchar] (50) NULL,
[CustomerSubIndustry] [nvarchar] (50) NULL,
[CustomerGroup] [nvarchar] (50) NULL,
[CustomerSubGroup] [nvarchar] (50) NULL,
[SalesRepCode] [nvarchar] (50) NULL,
[SalesPersonName] [nvarchar] (100) NULL,
[SalesPersonResponsible] [nvarchar] (100) NULL,
[VATRegNo] [nvarchar] (50) NULL,
[Res1_SellerCode] [nvarchar] (100) NULL,
[Res2_SalesChannel] [nvarchar] (100) NULL,
[Res3] [nvarchar] (100) NULL
)
GO
