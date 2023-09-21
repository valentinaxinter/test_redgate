IF OBJECT_ID('[stage].[vIOW_PL_Customer]') IS NOT NULL
	DROP VIEW [stage].[vIOW_PL_Customer];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [stage].[vIOW_PL_Customer] AS

SELECT 
	CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(Company, '#', TRIM(CustomerNum))))) AS CustomerID
	,UPPER(CONCAT(Company, '#', TRIM(CustomerNum))) AS CustomerCode
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(Company))) AS CompanyID
	,PartitionKey --getdate() AS 

	,UPPER(TRIM(Company)) AS Company
	,UPPER(TRIM([CustomerNum])) AS [CustomerNum]
	,TRIM(MainCustomerName) AS MainCustomerName
    ,TRIM(CustomerName) AS CustomerName
	,TRIM([AddressLine1]) AS [AddressLine1]
	,TRIM([AddressLine2]) AS [AddressLine2]
	,TRIM([AddressLine3]) AS [AddressLine3]
	,TRIM(TelephoneNum1) AS TelephoneNum1
	,TRIM(TelephoneNum2) AS TelephoneNum2
	,TRIM([Email]) AS [Email]
	,TRIM(ZIPCode) AS [ZipCode]
	,TRIM(City) AS City
	,TRIM([State]) AS [State]
	,TRIM(SalesDistrict) AS SalesDistrict
	,TRIM([CountryName]) AS [CountryName]
	,TRIM([CountryCode]) AS [CountryCode]
	,TRIM(Division) AS Division
	,TRIM(CustomerIndustry) AS CustomerIndustry
	,TRIM(CustomerSubIndustry) AS CustomerSubIndustry
	,[AddressLine1] AS [AddressLine]
	,CONCAT(COALESCE(Countryname, Countryname), ', ' + trim([City]),  ', ' + TRIM(ZIPCode),', ' + trim(addressline1)) AS [FullAddressLine]
	,TRIM([CustomerGroup]) AS [CustomerGroup]
	,(TRIM([CustomerSubGroup])) AS [CustomerSubGroup] --MAX
	,TRIM([SalesPersonCode]) AS [SalesPersonCode]
	,TRIM([SalesPersonName]) AS [SalesPersonName]
	,TRIM([SalesPersonResponsible]) AS [SalesPersonResponsible]
	,TRIM([VATNum]) AS [VATNum]
	,TRIM([VATNum]) AS OrganizationNum
	,TRIM([AccountNum]) AS [AccountNum]
	,TRIM([InternalExternal]) AS [InternalExternal]
	,TRIM([CustomerScore]) AS [CustomerScore]
	,TRIM([CustomerType]) AS [CustomerType]
	,CONVERT(Date,'1900-01-01') AS [ValidFrom]
	,CONVERT(Date,'1900-01-01') AS [ValidTo]
FROM axbus.IOW_PL_Customer
--GROUP BY 
--	PartitionKey
--	,Company
--	,[CustomerNum]
--	,MainCustomerName
--    ,CustomerName
--	,[AddressLine1]
--	,[AddressLine2]
--	,[AddressLine3]
--	,TelephoneNum1
--	,TelephoneNum2
--	,[Email]
--	,ZIPCode
--	,City
--	,[State]
--	,SalesDistrict
--	,[CountryName]
--	,Division
--	,CustomerIndustry
--	,CustomerSubIndustry
--	,[CustomerGroup]
----	,[CustomerSubGroup]
--	,[SalesPersonCode]
--	,[SalesPersonName]
--	,[SalesPersonResponsible]
--	,[VATNum]
--	,[AccountNum]
--	,[InternalExternal]
--	,[CustomerScore]
--	,[CustomerType]
GO
