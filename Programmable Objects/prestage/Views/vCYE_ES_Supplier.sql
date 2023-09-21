IF OBJECT_ID('[prestage].[vCYE_ES_Supplier]') IS NOT NULL
	DROP VIEW [prestage].[vCYE_ES_Supplier];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE view [prestage].[vCYE_ES_Supplier] AS

SELECT 
	concat(CONVERT (date, SYSDATETIME()), ' 00:00:00') AS [PartitionKey]
	,'CYESA' AS [Company]
	,[SupplierNum]
	,MainSupplierName
	,SupplierName
	,AddressLine1
	,AddressLine2
	,AddressLine3
	,TelephoneNum
	,Email
	,ZipCode
	,City
	,District
	,CountryCode
	,CountryName
	,Region
	,SupplierCategory
	,SupplierResponsible
	,AccountNum
	,InternalExternal
	,VATNum
	,CodeOfConduct
	,SupplierScore
	,MinOrderQty
	,MinOrderValue
	,Website
	,Comments
	,SRes1
	,SRes2
	,SRes3
FROM [prestage].[CYE_ES_Supplier]
GO
