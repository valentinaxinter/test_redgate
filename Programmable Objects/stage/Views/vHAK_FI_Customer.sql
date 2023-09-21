IF OBJECT_ID('[stage].[vHAK_FI_Customer]') IS NOT NULL
	DROP VIEW [stage].[vHAK_FI_Customer];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [stage].[vHAK_FI_Customer] AS
--COMMENT EMPTY FIELDS // ADD UPPER()TRIM() INTO CustomerID 2022-12-21 VA
--This company have rows added from the fact tables to match.
SELECT 
	CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM(Company), '#', TRIM(CustomerNum))))) AS CustomerID
	--CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT(Company, '#', TRIM(UPPER(CustomerNum))))) AS CustomerID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', [Company])) AS CompanyID
	,CONCAT([Company], '#', TRIM(UPPER(CustomerNum))) AS CustomerCode
	,PartitionKey

	,Company
	,TRIM(UPPER(CustomerNum)) AS [CustomerNum]
	--,'' AS MainCustomerName
	,TRIM([dbo].[ProperCase](CustomerName)) AS  [CustomerName]
	,TRIM([AddressLine1]) AS [AddressLine1]
	,TRIM([AddressLine2]) AS [AddressLine2]
	,TRIM([AddressLine3]) AS [AddressLine3]
	,TRIM([TelephoneNumber1]) AS [TelephoneNum1]
	,TRIM([TelephoneNumber2]) AS [TelephoneNum2]
	,TRIM([Email]) AS [Email]
	,TRIM([ZIP]) AS [ZipCode]
	,CASE WHEN TRIM([City]) = ' '	AND LEFT(TRIM(AddressLine3), 1) IN ('1','2','3','4','5','6','7','8','9') THEN TRIM(substring(replace([dbo].[ProperCase](TRIM(AddressLine3)),' ', ''), 6, 100)) ELSE [dbo].[ProperCase](TRIM([City])) end AS [City]
	,IIF(TRIM([State])= ' ',null,TRIM([State])) AS [State]
	,TRIM([District]) AS [SalesDistrict]
	,IIF(TRIM(CountryName) = '' OR TRIM(CountryName) IS NULL, 'FI', TRIM(CountryCode)) AS CountryCode
	,IIF(TRIM(CountryName) = '' OR TRIM(CountryName) IS NULL, 'Finland', TRIM(CountryName)) AS [CountryName]
	--,'' AS Division
	--,'' AS CustomerIndustry
	--,'' AS CustomerSubIndustry
	,TRIM([AddressLine1]) AS [AddressLine]
	,CONCAT( TRIM(Countryname), + ',  ' + TRIM([City]), + ',  ' + TRIM([Zip]), + ',  ' + TRIM(addressline1) ) AS [FullAddressLine]
	,[dbo].[ProperCase](TRIM(CustomerGroup)) AS [CustomerGroup]
	,[dbo].[ProperCase](TRIM(CustomerGroup)) AS [CustomerSubGroup]
	,TRIM([SalesRepCode]) AS [SalesPersonCode]
	,[dbo].[ProperCase](TRIM(SalesPersonName)) AS [SalesPersonName]
	--,'' AS [SalesPersonResponsible]
	,HASHBYTES('SHA2_256', TRIM([VATRegNr])) AS [VATNum]
	,OrganizationNum
	,HASHBYTES('SHA2_256', TRIM([AccountString])) AS [AccountNum]
	,TRIM([InternalExternal]) AS [InternalExternal]
	,TRIM([ABCCode]) AS [CustomerScore]
	,TRIM([CustomerType]) AS [CustomerType]

FROM [stage].[HAK_FI_Customer]
WHERE CustomerNum != '134144'
GROUP BY
	PartitionKey, Company, CustomerNum, CustomerName, [AddressLine1], [AddressLine2], [AddressLine3], [TelephoneNumber1], [TelephoneNumber2], [Email], [ZIP], [City], TRIM([State]), [District], CountryName, CountryCode, CustomerGroup, [SalesRepCode], SalesPersonName, [VATRegNr], OrganizationNum, [AccountString], [InternalExternal], [ABCCode], [CustomerType]
GO
