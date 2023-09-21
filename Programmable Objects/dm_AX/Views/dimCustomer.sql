IF OBJECT_ID('[dm_AX].[dimCustomer]') IS NOT NULL
	DROP VIEW [dm_AX].[dimCustomer];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



--CREATE SCHEMA dm_AX

CREATE VIEW [dm_AX].[dimCustomer] AS

SELECT 
	   [CustomerID]
      ,[CompanyID]
      ,[Company]
      ,[CustomerNum]
      ,[MainCustomerName]
      ,[CustomerName]
      ,[Customer]
      ,[AddressLine1]
      ,[AddressLine2]
      ,[AddressLine3]
      ,[TelephoneNum1]
      ,[TelephoneNum2]
      ,[Email]
      ,[ZipCode]
      ,[City]
      ,[State]
      ,[SalesDistrict]
      ,[CountryCode]
      ,[CountryName]
      ,[Division]
      ,[CustomerIndustry]
      ,[CustomerSubIndustry]
      ,[AddressLine]
      ,[FullAddressLine]
      ,[CustomerGroup]
      ,[CustomerSubGroup]
      ,[SalesPersonCode]
      ,[SalesPersonName]
      ,[SalesPersonResponsible]
      ,[VATNum]
      ,[OrganizationNum]
      ,[AccountNum]
      ,[InternalExternal]
      ,[CustomerScore]
      ,[CustomerType]
      ,[CustomerCode]
      ,[CustomerStatus]
      ,[DUNS]
      ,[DUNS_MatchScore]
      ,[CRes1]
      ,[CRes2]
      ,[CRes3]
      ,[is_inferred]
      ,[is_deleted]
      ,[is_validCountryCode]
      ,[DUNS_Status]

FROM [dm].[DimCustomer]
WHERE [Company] in ('AXISE','AXHSE')  -- HQ basket
GO
