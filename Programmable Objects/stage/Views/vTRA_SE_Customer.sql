IF OBJECT_ID('[stage].[vTRA_SE_Customer]') IS NOT NULL
	DROP VIEW [stage].[vTRA_SE_Customer];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW  [stage].[vTRA_SE_Customer] AS
--COMMENT EMPTY FIELDS // ADD UPPER()TRIM() INTO CustomerID 2022-12-27 VA
SELECT
	--CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT(UPPER([Company]), '#', TRIM(CustomerNum)))) AS CustomerID
	CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM([Company]), '#', TRIM(CustomerNum))))) AS CustomerID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER([Company]))) AS CompanyID
	,CONCAT(UPPER([Company]), '#', TRIM([CustomerNum])) AS CustomerCode
	,PartitionKey

	,UPPER([Company]) AS [Company]
	,TRIM(CustomerNum) AS [CustomerNum]
	--,'' AS [MainCustomerName]
	,TRIM(CustomerName) AS [CustomerName]
	,TRIM([AddressLine1]) AS [AddressLine1]
	,TRIM([AddressLine2]) AS [AddressLine2]
	--,'' AS [AddressLine3]
	,TRIM([TelephoneNum1]) AS [TelephoneNum1]
	--,'' AS [TelephoneNum2]
	,TRIM([Email]) AS [Email]
	,TRIM([ZipCode]) AS [ZipCode]
	,TRIM([City]) AS [City]
	,TRIM([State]) AS [State]
	,TRIM([SalesDistrict]) AS [SalesDistrict]
	,IIF([CountryName] = '' or [CountryName] is null, 'SE', TRIM(CountryCode)) AS CountryCode
	,IIF([CountryName] = '' or [CountryName] is null, 'Sweden', TRIM([CountryName])) AS [CountryName]
	--,'' AS [Division]
	,TRIM([CustomerIndustry]) AS [CustomerIndustry]
	--,'' AS [CustomerSubIndustry]
	,TRIM([CustomerGroup]) AS [CustomerGroup]
	--,'' AS [CustomerSubGroup]
	,TRIM([SalesPersonCode]) AS [SalesPersonCode]
	,TRIM([SalesPersonName]) AS [SalesPersonName]
	--,'' AS [SalesPersonResponsible]
	,cast([VATNum] as nvarchar(50)) AS [VATNum]
	--,'' AS OrganizationNum
	--,'' AS [AccountNum]
	--,'' AS [InternalExternal]
	--,'' AS [CustomerScore]
	,TRIM([CustomerType]) AS [CustomerType]
	,TRIM([AddressLine1]) AS [AddressLine]
	,CONCAT((TRIM(Countryname)), + ', ' + TRIM([City]), + ', ' + TRIM([ZipCode]), + ', ' + TRIM(addressline1)) AS [FullAddressLine]
FROM [stage].[TRA_SE_Customer]
GO
