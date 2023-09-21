IF OBJECT_ID('[stage].[vSPR_NL_Customer]') IS NOT NULL
	DROP VIEW [stage].[vSPR_NL_Customer];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE VIEW  [stage].[vSPR_NL_Customer] AS
--ADD TRIM() UPPER() INTO CustomerID 23-01-09 VA
SELECT
	CONVERT([binary](32), HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM(Company), '#', TRIM(CustomerNum))))) AS CustomerID
	--	CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT(Company, '#', TRIM(CustomerNum)))) AS CustomerID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', [Company])) AS CompanyID
	,CONCAT([Company], '#', TRIM([CustomerNum])) AS CustomerCode
	,PartitionKey

	,[Company]
	,TRIM(CustomerNum) AS [CustomerNum]
	,(TRIM([MainCustomerName])) AS [MainCustomerName] --MAX
	,TRIM(CustomerName) AS [CustomerName] --()
	,TRIM([AddressLine1]) AS [AddressLine1] --()
	,TRIM([AddressLine2]) AS [AddressLine2]
	,TRIM([AddressLine3]) AS [AddressLine3]
	,(TRIM([TelephoneNum1])) AS [TelephoneNum1]
	,TRIM([TelephoneNum2]) AS [TelephoneNum2]
	,(TRIM([Email])) AS [Email]
	,(TRIM([ZipCode])) AS [ZipCode] --MAX
	,TRIM([City]) AS [City] --(SUBSTRING(TRIM(REPLACE([City], ' ', '')), 0, CHARINDEX('-', TRIM(REPLACE([City], ' ', '')))))
	,IIF(TRIM([CountryName]) = 'NL', TRIM(z.[Gemeente]), '') AS [State]
	,IIF(TRIM([CountryName]) = 'NL', TRIM(z.[Provincie]), '') AS [SalesDistrict]
	,(TRIM([CountryName])) AS [CountryName]
	,TRIM([Division]) AS [Division]
	,TRIM([CustomerIndustry]) AS [CustomerIndustry]
	,TRIM([CustomerSubIndustry]) AS [CustomerSubIndustry]
	,TRIM([CustomerGroup]) AS [CustomerGroup]
	,TRIM([CustomerSubGroup]) AS [CustomerSubGroup]
	,(TRIM([SalesPersonCode])) AS [SalesPersonCode] --MAX
	,(TRIM([SalesPersonName])) AS [SalesPersonName] --MAX
	,TRIM([SalesPersonResponsible]) AS [SalesPersonResponsible]
	,TRIM([VATNum]) AS [VATNum] --MAX
	--,'' AS OrganizationNum
	,TRIM(AccountNum) AS [AccountNum] --MAX
	,TRIM([InternalExternal]) AS [InternalExternal]
	,TRIM([CustomerScore]) AS [CustomerScore]
	,TRIM([CustomerType]) AS [CustomerType]
	,(TRIM([AddressLine2])) AS [AddressLine] --MAX
	,CONCAT((TRIM(Countryname)), + ', ' + TRIM([City]), + ', ' + (TRIM([ZipCode])), + ', ' + (TRIM(addressline2))) AS [FullAddressLine]
	,case when UPPER(TRIM(CountryName)) = 'SEVILLA' THEN 'ES'
	ELSE CountryName
	END as CountryCode
FROM [stage].[SPR_NL_Customer] c
	LEFT JOIN SPR_NL_ZipCode z ON z.PostCode = LEFT(c.ZipCode, 4)

--GROUP BY PartitionKey, Company, CustomerNum, [MainCustomerName], CustomerName, [AddressLine2], [AddressLine3], [TelephoneNum2], [City], [State], [SalesDistrict], [CountryName], [Division], [CustomerIndustry], [CustomerSubIndustry], [CustomerGroup], [CustomerSubGroup], [SalesPersonResponsible], [InternalExternal], [CustomerScore], [CustomerType], [SalesPersonName], [VATNum], [SalesPersonCode], [AddressLine1], [ZipCode], AccountNum --, [Email], [TelephoneNum1]
GO
