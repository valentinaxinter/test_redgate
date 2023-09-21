IF OBJECT_ID('[stage].[vTMT_FI_Customer]') IS NOT NULL
	DROP VIEW [stage].[vTMT_FI_Customer];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [stage].[vTMT_FI_Customer] AS
--COMMENT EMPTY FIELDS // ADD TRIM() INTO CustomerID 23-01-09 VA
SELECT 
	CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM(Company),'#', TRIM(CustomerNum))))) AS CustomerID
--	CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(Company,'#', TRIM(CustomerNum))))) AS CustomerID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER([Company]))) AS CompanyID
	,UPPER(CONCAT([Company], '#',TRIM([CustomerNum]))) AS CustomerCode
	,PartitionKey

	,UPPER(Company) AS Company
	,UPPER(TRIM(CustomerNum)) AS [CustomerNum]
	--,'' AS MainCustomerName
	,[dbo].[ProperCase](CustomerName) AS  [CustomerName]
	,[AddressLine1] AS [AddressLine1]
	,[AddressLine2] AS [AddressLine2]
	,[AddressLine3] AS [AddressLine3]
	,[TelephoneNo] AS [TelephoneNum1]
	--,'' AS [TelephoneNum2]
	,LEFT([email], 50) AS [Email]
	,CASE 
		WHEN [dbo].[ProperCase](CountryName) in ('Suomi', 'Viro') THEN LEFT(City, 5)
		WHEN [dbo].[ProperCase](CountryName) in ('Venäjä', 'Puola', 'Kiina') THEN LEFT(City, 6)
		WHEN [dbo].[ProperCase](CountryName) in ('Viro') THEN LEFT(City, 8)
		WHEN [dbo].[ProperCase](CountryName) in ('Ruotsi') THEN LEFT(City, 10)
		ELSE LEFT(City, 7) end
		AS [ZipCode]
	,TRIM(SUBSTRING(REPLACE([dbo].[ProperCase](City),' ', ''), 6, 100))  AS [City] 
	,IIF([State]= ' ', null, [State]) AS [State]
	,[District]	AS SalesDistrict
	,IIF((CountryName) IS NULL, 'FI', CountryCode) AS CountryCode
	,[dbo].[ProperCase](CountryName) AS [CountryName]
	,Division
	--,'' AS CustomerIndustry
	--,'' AS CustomerSubIndustry
	,[dbo].[ProperCase](TRIM(concat(TRIM(addressline1)+' '+ TRIM(addressline2), null))) AS [AddressLine]
	,CONCAT(Countryname, + ',  ' + trim(TRIM(SUBSTRING(REPLACE([dbo].[ProperCase](City),' ', ''), 6, 100))), + ',  ' + TRIM([Zip]), + ',  ' + trim(addressline1)) AS [FullAddressLine]
	,[dbo].[ProperCase](CustomerGroup) AS [CustomerGroup]
	,[CustomerSubGroup]
	,[SalesRepCode]		AS SalesPersonCode
	,[dbo].[ProperCase](SalesPersonName) AS [SalesPersonName]
	--,'' AS [SalesPersonResponsible]
	,[VATRegNr]	AS VATNum
	,OrganizationNum
	,[AccountString] AS AccountNum
	,[InternalExternal]
	,[ABCCode] AS [CustomerScore]
	,[CustomerType]
	,GETDATE() AS [ValidFrom]
	,DATEADD(year,1,GETDATE()) AS [ValidTo]
FROM [stage].[TMT_FI_Customer]
GO
