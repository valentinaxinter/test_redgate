IF OBJECT_ID('[stage].[vCER_SE_Customer]') IS NOT NULL
	DROP VIEW [stage].[vCER_SE_Customer];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [stage].[vCER_SE_Customer] AS
--COMMINT empty field / ADD Trim(company) into CustomerID 12-12-2022 VA
SELECT 
	CONVERT([binary](32), HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM(Company), '#', TRIM(CustomerNum))))) AS CustomerID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', [Company])) AS CompanyID
	,CONCAT([Company], '#', UPPER(TRIM([CustomerNum]))) AS CustomerCode
	,PartitionKey

	,Company
	,UPPER(TRIM(CustomerNum)) AS CustomerNum
	--,'' AS MainCustomerName
	,[dbo].[ProperCase](CustomerName) AS CustomerName
	,[AddressLine1]
	,[AddressLine2]
	,[AddressLine3]
	,[TelephoneNumber1] AS [TelephoneNum1]
	,[TelephoneNumber2] AS [TelephoneNum2]
	,cast([Email] as NVARCHAR(100)) as [Email]
	,CASE WHEN LEN(TRIM(customer.CountryCode)) = 3 then cc.[Alpha-2 code]
	else IIF(customer.CountryName is null, 'SE', customer.CountryCode) 
	end AS CountryCode
	,CASE 
		WHEN (customer.countryname like 'Sweden' or customer.countryname is null) AND LEFT(AddressLine3, 1) IN ('1','2','3','4','5','6','7','8','9') THEN substring(replace([dbo].[ProperCase](AddressLine3), ' ', ''), 1,5)
		WHEN customer.countryname like 'Sweden' AND AddressLine3 = '' THEN substring(replace([dbo].[ProperCase](AddressLine2), ' ', ''), 1,5)
		ELSE null END AS ZipCode
	,CASE 
		WHEN [City] = ' '	AND LEFT(AddressLine3, 1) IN ('1','2','3','4','5','6','7','8','9') THEN trim(substring(replace([dbo].[ProperCase](AddressLine3),' ',		''), 6, 100))
		WHEN [City] = ' '	AND AddressLine3 = '' THEN trim(substring(replace([dbo].[ProperCase](AddressLine2),' ',		''), 6, 100))
		ELSE [dbo].[ProperCase]([City]) END AS [City]
	,IIF([State]= ' ',null,[State]) AS [State]
	,[District] AS SalesDistrict
	,[dbo].[ProperCase](customer.CountryName) AS CountryName
	--,'' AS Division
	--,'' AS CustomerIndustry
	--,'' AS CustomerSubIndustry
	,[dbo].[ProperCase](TRIM(concat (addressline1+' '+ addressline2, null))) AS AddressLine
	,CONCAT(customer.Countryname
		, + ', ' + CASE 
			WHEN [City] = ' ' AND LEFT(AddressLine3, 1) IN ('1','2','3','4','5','6','7','8','9') THEN trim(substring(replace([dbo].[ProperCase](AddressLine3),' ',		''), 6, 100))
			WHEN [City] = ' ' AND AddressLine3 = '' THEN trim(substring(replace([dbo].[ProperCase](AddressLine2),' ',		''), 6, 100))
			ELSE [dbo].[ProperCase]([City]) END
		, + ', ' + CASE 
			WHEN (customer.countryname like 'Sweden' or customer.countryname is null) AND LEFT(AddressLine3, 1) IN ('1','2','3','4','5','6','7','8','9') THEN substring(replace([dbo].[ProperCase](AddressLine3), ' ', ''), 1, 5)
			WHEN customer.countryname like 'Sweden' AND AddressLine3 = '' THEN substring(replace([dbo].[ProperCase](AddressLine2), ' ', ''), 1,5)
			ELSE null END
		, + ', ' + [dbo].[ProperCase](TRIM(concat (addressline1 +' ' + addressline2, null)))) AS FullAddressLine
	,[dbo].[ProperCase](CustomerGroup) AS CustomerGroup
	,[dbo].[ProperCase](CustomerGroup) AS CustomerSubGroup
	,[SalesRepCode] AS SalesPersonCode
	,[dbo].[ProperCase](SalesPersonName) AS SalesPersonName
	--,'' AS [SalesPersonResponsible]
	,[VATRegNr] AS VATNum
	,OrganizationNum
	,[AccountString] AS AccountNum
	,[InternalExternal]
	,[ABCCode] AS CustomerScore
	,CustomerType
	,GETDATE() AS ValidFrom
	,DATEADD(year,1,GETDATE()) AS ValidTo
FROM [stage].[CER_SE_Customer] as customer
	 LEFT JOIN dbo.CountryCodes as cc
		ON cc.[Alpha-3 code] = customer.CountryCode
GO
