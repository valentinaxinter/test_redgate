IF OBJECT_ID('[stage].[vCER_DE_Supplier]') IS NOT NULL
	DROP VIEW [stage].[vCER_DE_Supplier];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE view [stage].[vCER_DE_Supplier]
as
--ADD TRIM() INTO SupplierID 23-01-232 VA
select 
UPPER(CONCAT([Company],'#',TRIM([SupplierNum]))) AS SupplierCode,
CONVERT([binary](32), HASHBYTES('SHA2_256',[Company])) AS CompanyID,
PartitionKey,
CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM([Company]),'#',TRIM(SupplierNum))))) AS SupplierID,
--CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT([Company],'#',SupplierNum)))) AS SupplierID,
Company,
SupplierNum,
MainSupplierName,
SUPPLIERNAME as SupplierName,
AddressLine1,
AddressLine2,
AddressLine3,
TelephoneNum,
EMAIL as Email,
ZIPCODE as ZipCode,
CITY as City,
DISTRICT as District,
CountryName, Region,
case when left(upper(trim(searchname)),2) = 'DL' THEN 'Service' ELSE 'Non-Service' END  as SupplierCategory,
case when left(upper(trim(searchname)),2) = 'DL' THEN 0 ELSE 1 END  as IsMaterialSupplier, --added 2023-03-23 SB
null as SupplierResponsible,
[dbo].[ProperCase](TRIM(concat (addressline1+' '+ addressline2, null))) AS AddressLine,
concat(CountryName,'-', City, '-', [addressline1], '-', [addressline2]) AS FullAddressLine,
ACCOUNTNUM as AccountNum,
VATNUM as VATNum,
--'' AS OrganizationNum,
InternalExternal,
CODEOFCONDUCT as CodeOfConduct,
null as CustomerNum,
SUPPLIERSCORE as SupplierScore,
MinOrderQty,
MinOrderValue,
WEBSITE as Website,
Comments,
SRes1,
SRes2,
SRes3,
COUNTRY as CountryCode


FROM stage.CER_DE_Supplier
--WHERE UPPER(LEFT(searchName,2)) != 'DL'
;
GO
