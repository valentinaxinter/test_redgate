IF OBJECT_ID('[dm_AX].[dimSupplier]') IS NOT NULL
	DROP VIEW [dm_AX].[dimSupplier];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




CREATE VIEW [dm_AX].[dimSupplier] AS

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
WHERE [Company] in ('AXISE','AXHSE') -- HQ basket
GO
