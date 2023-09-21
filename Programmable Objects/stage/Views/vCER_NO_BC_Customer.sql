IF OBJECT_ID('[stage].[vCER_NO_BC_Customer]') IS NOT NULL
	DROP VIEW [stage].[vCER_NO_BC_Customer];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




CREATE VIEW [stage].[vCER_NO_BC_Customer] AS 
SELECT 
	CONVERT(binary(32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM(Company), '#', TRIM(CustomerNum))))) AS CustomerID
	--,UPPER(CONCAT(Company,'#',TRIM(SupplierNum))) AS SupplierCode
	,CONVERT(binary(32), HASHBYTES('SHA2_256', TRIM(Company))) AS CompanyID
	,PartitionKey
	,Company
	,nullif(TRIM(CustomerNum),'') AS CustomerNum
	,nullif(trim(CustomerName),'') as CustomerName
	,nullif(trim(AddressLine1),'') as AddressLine1
	,nullif(trim(AddressLine2),'') as AddressLine2
	,nullif(CONCAT(CountryName, ', ' + trim([City]),  ', ' + TRIM([Zip]),', ' + trim(addressline1)),'') AS [FullAddressLine]
	,nullif(trim(TelephoneNumber1),'') as TelephoneNum1
	,nullif(trim(Email),'') as Email
	,nullif(TRIM(City),'') AS City
	,nullif(TRIM(ZIP),'') AS ZipCode
	,nullif(trim(CountryName       ),'') as CountryName
	,nullif(trim(CustomerGroup   ),'') as CustomerGroup
    ,nullif(trim(CustomerSubGroup),'') as CustomerSubGroup
    ,nullif(trim(SalesPersonCode ),'') as SalesPersonCode
    ,nullif(trim(SalesPersonName ),'') as SalesPersonName
    ,nullif(trim(VATNum		   ),'') as VATNum
	, CASE
		WHEN CUSTOMERPOSTINGGROUP = 'KONSERN' THEN 'Internal'
		ELSE 'External'
	 END AS InternalExternal
    --,systemCreatedAt
	--,systemModifiedAt
	, CountryCode
	,nullif(CustomerIndustry,'') as CustomerIndustry
FROM 
	 stage.CER_NO_BC_Customer
GO
