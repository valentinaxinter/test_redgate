IF OBJECT_ID('[stage].[vFOR_ES_Supplier]') IS NOT NULL
	DROP VIEW [stage].[vFOR_ES_Supplier];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE VIEW [stage].[vFOR_ES_Supplier] AS 
SELECT 
	CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM([Company]), '#', TRIM([SupplierNum]))))) AS SupplierID
	,UPPER(CONCAT([Company],'#',TRIM([SupplierNum]))) AS SupplierCode
	,CONVERT([binary](32), HASHBYTES('SHA2_256', TRIM([Company]))) AS CompanyID
	,[PartitionKey]
	,[Company]
	,TRIM([SupplierNum]) AS SupplierNum
	,MainSupplierName
	,SupplierName
	,AddressLine1
	,[TelephoneNum]
	,[Email]
	,TRIM([ZipCode]) AS ZipCode
	,TRIM([City]) AS City
	,District
	,CountryName
	,TRIM([SupplierResponsible]) AS SupplierResponsible
	,[VATNum]
	,IIF(trim([CodeOfConduct]) = 'Y' or trim([CodeOfConduct_Group]) = 'Y', 'Yes', 'No') as [CodeOfConduct]
	,[Website]
	,SupplierCategory
	, case when SupplierCategory in ('ACREEDOR AXINTER','ACREEDOR AXLOAD','PROVEEDOR AXINTER','PROVEEDOR AXLOAD') 
		then 'Internal' 
		else 'External' 
	  end as [Internal/External]
	, SupplierScore
	,[OrganizationNum] as [OrganizationNum]
FROM 
	 [stage].[FOR_ES_Supplier]
GO
