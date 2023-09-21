IF OBJECT_ID('[prestage].[CYE_ES_Supplier_Load]') IS NOT NULL
	DROP PROCEDURE [prestage].[CYE_ES_Supplier_Load];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [prestage].[CYE_ES_Supplier_Load] AS

BEGIN

Truncate table stage.[CYE_ES_Supplier]

INSERT INTO 
	stage.CYE_ES_Supplier
	(
	[PartitionKey], [Company], [SupplierNum], MainSupplierName, SupplierName, AddressLine1, AddressLine2, AddressLine3, TelephoneNum, Email, ZipCode, City, District, CountryCode, CountryName, Region, SupplierCategory, SupplierResponsible, AccountNum, InternalExternal, VATNum, CodeOfConduct, SupplierScore, MinOrderQty, MinOrderValue, Website, Comments, SRes1, SRes2, SRes3
	)
SELECT 
	[PartitionKey], [Company], [SupplierNum], MainSupplierName, SupplierName, AddressLine1, AddressLine2, AddressLine3, TelephoneNum, Email, ZipCode, City, District, CountryCode, CountryName, Region, SupplierCategory, SupplierResponsible, AccountNum, InternalExternal, VATNum, CodeOfConduct, SupplierScore, MinOrderQty, MinOrderValue, Website, Comments, SRes1, SRes2, SRes3
FROM 
	[prestage].[vCYE_ES_Supplier]

End
GO
