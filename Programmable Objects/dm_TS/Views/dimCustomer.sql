IF OBJECT_ID('[dm_TS].[dimCustomer]') IS NOT NULL
	DROP VIEW [dm_TS].[dimCustomer];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
















CREATE VIEW [dm_TS].[dimCustomer] AS

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
WHERE [Company] in (
'FESFORA'
, 'FSEFORA'
, 'FFRFORA'
, 'FORPL'
, 'CERPL'
, 'FFRGPI'
, 'FFRLEX'
, 'IFIWIDN'
, 'IEEWIDN'
, 'TMTFI'
, 'TMTEE'
, 'FITMT'
, 'EETMT'
, 'ABKSE'
, 'ROROSE'
,'STESE'
,'CERBG'
,'FORBG'
)
GO
