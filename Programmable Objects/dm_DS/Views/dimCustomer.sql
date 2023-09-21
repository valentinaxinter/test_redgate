IF OBJECT_ID('[dm_DS].[dimCustomer]') IS NOT NULL
	DROP VIEW [dm_DS].[dimCustomer];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




CREATE VIEW [dm_DS].[dimCustomer] AS

SELECT 
	   cust.[CustomerID]
      ,cust.[CompanyID]
      ,cust.[Company]
      ,cust.[CustomerNum]
      ,cust.[MainCustomerName]
      ,cust.[CustomerName]
      ,cust.[Customer]
      ,cust.[AddressLine1]
      ,cust.[AddressLine2]
      ,cust.[AddressLine3]
      ,cust.[TelephoneNum1]
      ,cust.[TelephoneNum2]
      ,cust.[Email]
      ,cust.[ZipCode]
      ,cust.[City]
      ,cust.[State]
      ,cust.[SalesDistrict]
      ,cust.[CountryCode]
      ,cust.[CountryName]
      ,cust.[Division]
      ,cust.[CustomerIndustry]
      ,cust.[CustomerSubIndustry]
      ,cust.[AddressLine]
      ,cust.[FullAddressLine]
      ,cust.[CustomerGroup]
      ,cust.[CustomerSubGroup]
      ,cust.[SalesPersonCode]
      ,cust.[SalesPersonName]
      ,cust.[SalesPersonResponsible]
      ,cust.[VATNum]
      ,cust.[OrganizationNum]
      ,cust.[AccountNum]
      ,cust.[InternalExternal]
      ,cust.[CustomerScore]
      ,cust.[CustomerType]
      ,cust.[CustomerCode]
      ,cust.[CustomerStatus]
      ,cust.[DUNS]
      ,cust.[DUNS_MatchScore]
      ,cust.[CRes1]
      ,cust.[CRes2]
      ,cust.[CRes3]
      ,cust.[is_inferred]
      ,cust.[is_deleted]
      ,cust.[is_validCountryCode]
      ,cust.[DUNS_Status]

FROM [dm].[DimCustomer] cust
LEFT JOIN dbo.Company com ON cust.Company = com.Company
WHERE com.BusinessArea = 'Driveline Solutions' AND com.[Status] = 'Active' 

--WHERE [Company] in ('MIT', 'ATZ', 'Transaut', 'IPLIOWTR')
GO
