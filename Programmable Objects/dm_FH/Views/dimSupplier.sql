IF OBJECT_ID('[dm_FH].[dimSupplier]') IS NOT NULL
	DROP VIEW [dm_FH].[dimSupplier];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [dm_FH].[dimSupplier] AS

SELECT 
 sup.[SupplierID]
,sup.[CompanyID]
,sup.[Company]
,sup.[SupplierNum]
,sup.[MainSupplierName]
,sup.[SupplierName]
,sup.[Supplier]
,sup.[TelephoneNum]
,sup.[Email]
,sup.[ZipCode]
,sup.[City]
,sup.[District]
,sup.[CountryCode]
,sup.[CountryName]
,sup.[Region]
,sup.[SupplierCategory]
,sup.[SupplierResponsible]
,sup.[AddressLine]
,sup.[FullAddressLine]
,sup.[AccountNum]
,sup.[OrganizationNum]
,sup.[VATNum]
,sup.[InternalExternal]
,sup.[CodeOfConduct]
,sup.[CustomerNum]
,sup.[SupplierScore]
,sup.[MinOrderQty]
,sup.[MinOrderValue]
,sup.[Website]
,sup.[Comments]
,sup.[IsMaterialSupplier]
,sup.[DUNS]
,sup.[DUNS_MatchScore]
,sup.[is_inferred]
,sup.[is_deleted]
,sup.[is_validCountryCode]
,sup.[DUNS_Status]
FROM [dm].[DimSupplier] sup
LEFT JOIN dbo.Company com ON sup.Company = com.Company
WHERE com.BusinessArea = 'Fluid Handling Solutions' AND com.[Status] = 'Active'
GO
