IF OBJECT_ID('[stage].[vSVE_SE_Customer]') IS NOT NULL
	DROP VIEW [stage].[vSVE_SE_Customer];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW  [stage].[vSVE_SE_Customer] AS
--ADD UPPER() TRIM() INTO CustomerID 23-01-03 VA
SELECT
	CONVERT([binary](32), HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM(Company), '#', TRIM(CustomerNum)))))   AS CustomerID
	--CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT(Company, '#', TRIM(CustomerNum)))) AS CustomerID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', [Company])) AS CompanyID
	,CONCAT([Company], '#', TRIM([CustomerNum])) AS CustomerCode
	,PartitionKey

	,[Company]
	,TRIM(CustomerNum) AS [CustomerNum]
	,(TRIM([MainCustomerName])) AS [MainCustomerName]
	,(TRIM(CustomerName)) AS [CustomerName]
	,TRIM([AddressLine1]) AS [AddressLine1]
	,TRIM([AddressLine2]) AS [AddressLine2]
	,TRIM([AddressLine3]) AS [AddressLine3]
	,TRIM([TelephoneNum1]) AS [TelephoneNum1]
	,TRIM([TelephoneNum2]) AS [TelephoneNum2]
	,TRIM([Email]) AS [Email]
	,TRIM([ZipCode]) AS [ZipCode]
	,TRIM(SUBSTRING(REPLACE([City], ' ', ''), 6, 100)) AS [City]
	,TRIM([State]) AS [State]
	,TRIM([SalesDistrict]) AS [SalesDistrict]
	,CASE 
		WHEN TRIM([CountryName]) = 'Sverige' AND [CountryCode] = '' THEN 'SE'
		WHEN TRIM([CountryName]) = 'Sverige' AND [CountryCode] IS NULL THEN 'SE'
		WHEN TRIM([CountryName]) is null AND [CountryCode] IS NULL THEN 'SE'
		ELSE TRIM([CountryCode]) END AS [CountryCode]
	,IIF(TRIM([CountryName]) = '', 'Sverige', TRIM([CountryName])) AS [CountryName]
	,TRIM([Division]) AS [Division]
	,TRIM([CustomerIndustry]) AS [CustomerIndustry]
	,TRIM([CustomerSubIndustry]) AS [CustomerSubIndustry]
	,TRIM([CustomerGroup]) AS [CustomerGroup]
	,TRIM([CustomerSubGroup]) AS [CustomerSubGroup]
	,TRIM([SalesPersonCode]) AS [SalesPersonCode]
	,(TRIM([SalesPersonName])) AS [SalesPersonName]
	,TRIM([SalesPersonResponsible]) AS [SalesPersonResponsible]
	,[VATNum] AS [VATNum]
	--,'' AS OrganizationNum
	,[AccountNum] AS [AccountNum]
	,TRIM([InternalExternal]) AS [InternalExternal]
	,TRIM([CustomerScore]) AS [CustomerScore]
	,TRIM([CustomerType]) AS [CustomerType]
	,TRIM([AddressLine1]) AS [AddressLine]
	,CONCAT((TRIM(Countryname)), + ', ' + TRIM(SUBSTRING(REPLACE([City], ' ', ''), 6, 100)), + ', ' + TRIM([ZipCode]), + ', ' + TRIM(addressline1)) AS [FullAddressLine]
FROM [stage].[SVE_SE_Customer]
GO
