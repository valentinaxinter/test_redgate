IF OBJECT_ID('[dm_DEMO].[dimSupplier]') IS NOT NULL
	DROP VIEW [dm_DEMO].[dimSupplier];

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE VIEW [dm_DEMO].[dimSupplier] AS

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
WHERE [Company] = 'DEMO'
GO
