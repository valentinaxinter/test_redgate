IF OBJECT_ID('[dm_ALL].[dimSupplier]') IS NOT NULL
	DROP VIEW [dm_ALL].[dimSupplier];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [dm_ALL].[dimSupplier] AS 

SELECT 
 [SupplierID]
,[CompanyID]
,[Company]
,[SupplierNum]
,[MainSupplierName]
,[SupplierName]
,[Supplier]
,[TelephoneNum]
,[Email]
,[ZipCode]
,[City]
,[District]
,[CountryCode]
,[CountryName]
,[Region]
,[SupplierCategory]
,[SupplierResponsible]
,[AddressLine]
,[FullAddressLine]
,[AccountNum]
,[OrganizationNum]
,[VATNum]
,[InternalExternal]
,[CodeOfConduct]
,[CustomerNum]
,[SupplierScore]
,[MinOrderQty]
,[MinOrderValue]
,[Website]
,[Comments]
,[IsMaterialSupplier]
,[DUNS]
,[DUNS_MatchScore]
,[is_inferred]
,[is_deleted]
,[is_validCountryCode]
,[DUNS_Status]
FROM [dm].[DimSupplier]
GO
