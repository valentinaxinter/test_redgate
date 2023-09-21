IF OBJECT_ID('[stage].[vTRA_SE_Supplier]') IS NOT NULL
	DROP VIEW [stage].[vTRA_SE_Supplier];

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE VIEW [stage].[vTRA_SE_Supplier]
	AS 
	select 
CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM([Company]), '#', TRIM([SupplierNum]))))) AS SupplierID
,UPPER(CONCAT([Company],'#',TRIM([SupplierNum]))) AS SupplierCode
,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(TRIM([Company])))) AS CompanyID
,PartitionKey
,UPPER(Company) as Company
,nullif(TRIM(SupplierNum),'') AS SupplierNum
, SupplierName
, AddressLine1
,AddressLine2
,TelephoneNum1
,Email
,ZipCode
,City
,State
,CountryCode
,CountryName
,SupplierCategory
,VATNum
,OrgNum as OrganizationNum
,cast(IsAxInterInternal as bit) as InternalExternal
,cast(IsBusinessGroupInternal as bit) as IsBusinessGroupInternal
,cast(IsCompanyGroupInternal as bit) as IsCompanyGroupInternal
,cast(RecordIsActive as bit) as IsActiveRecord
,Website
from stage.TRA_SE_Supplier;
GO
