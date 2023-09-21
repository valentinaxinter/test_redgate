IF OBJECT_ID('[dm_PT].[dimCustomer]') IS NOT NULL
	DROP VIEW [dm_PT].[dimCustomer];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE VIEW [dm_PT].[dimCustomer] AS
-- AS decided by Ian & Random Forest AB on the 7th May 2020, the data is spliting after data-warehouse for each Business Group
SELECT cust.[CustomerID]
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
WHERE com.BusinessArea = 'Power Transmission Solutions' AND com.[Status] = 'Active'
--It is a dynamic Company addition in the sub-dataset in a way that so long a company is added in its parent dataset, this company will automatically appear in its assigend Business Area sub-dataset.
--This company addtion should in its first hand appear in the dbo.Company with correct attributes.


--WHERE [Company] in ('ACZARKOV', 'AcornUK', 'BSIBELL', 'JDKJENSS', 'JDKKALTE', 'JFIJENSS', 'MNLMAK', 'JNOJENSS', 'NORNO', 'JSEJENSS', 'SSWSE', 'NomoSE', 'NomoDK', 'NomoFI', 'NomoNo', 'PASSEROT', 'SKSSCOFI', 'SCOFI', 'SMKFI', 'SNLSPRUI', 'SPRUITNL', 'SVESE')  -- The PT basket
GO
