IF OBJECT_ID('[stage].[vTRA_FR_Customer]') IS NOT NULL
	DROP VIEW [stage].[vTRA_FR_Customer];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW  [stage].[vTRA_FR_Customer] AS
--COMMENT EMPTY FIELDS // ADD UPPER()TRIM() INTO CustomerID 22-12-29 VA
SELECT
	CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM(Company), '#', TRIM(CustomerNum))))) AS CustomerID
	--CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT(UPPER(Company), '#', TRIM(CustomerNum)))) AS CustomerID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(Company))) AS CompanyID
	,CONCAT(UPPER(Company), '#', TRIM([CustomerNum])) AS CustomerCode
	,PartitionKey

	,UPPER(Company) AS [Company]
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
	,TRIM([City]) AS [City]
	,TRIM([State]) AS [State]
	,TRIM([SalesDistrict]) AS [SalesDistrict]
	,case when len(TRIM(customer.[CountryCode])) = 3 then cc.[Alpha-2 code]
	 else nullif(TRIM(customer.CountryCode),'')
	 end as CountryCode
	,(TRIM(customer.[CountryName])) AS [CountryName]
	,TRIM([Division]) AS [Division]
	,TRIM([CustomerIndustry]) AS [CustomerIndustry]
	,TRIM([CustomerSubIndustry]) AS [CustomerSubIndustry]
	,TRIM([CustomerGroup]) AS [CustomerGroup]
	,TRIM([CustomerSubGroup]) AS [CustomerSubGroup]
	,TRIM([SalesPersonCode]) AS [SalesPersonCode]
	,(TRIM([SalesPersonName])) AS [SalesPersonName]
	,TRIM([SalesPersonResponsible]) AS [SalesPersonResponsible]
	,CAST([VATNum] as nvarchar(50)) AS [VATNum]
	--,'' AS OrganizationNum
	,cast( [AccountNum] as nvarchar(50)) AS [AccountNum]
	,CASE WHEN InternalExternal = 'A' THEN 'AxInter Internal Customer '
		WHEN CustomerGroup = 'CESSIONS INTER AGENCES' THEN 'Traction Levage Internal Customer'
		ELSE 'External Customer' END AS [InternalExternal]
	,TRIM([CustomerScore]) AS [CustomerScore]
	,TRIM([CustomerType]) AS [CustomerType]
	,TRIM([AddressLine1]) AS [AddressLine]
	,CONCAT((TRIM(customer.Countryname)), + ', ' + TRIM(City), + ', ' + TRIM([ZipCode]), + ', ' + TRIM(addressline1)) AS [FullAddressLine]
FROM [stage].[TRA_FR_Customer] as customer
	left join dbo.CountryCodes as cc
		on TRIM(customer.countrycode) = cc.[Alpha-3 code]
GO
