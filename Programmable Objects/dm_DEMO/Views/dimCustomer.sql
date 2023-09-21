IF OBJECT_ID('[dm_DEMO].[dimCustomer]') IS NOT NULL
	DROP VIEW [dm_DEMO].[dimCustomer];

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE VIEW [dm_DEMO].[dimCustomer] AS

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

FROM [dm].[DimCustomer] /*temp putting (CERPL) Certex PL here such that they see the data in same company*/
WHERE [Company] in ('DEMO')
GO
