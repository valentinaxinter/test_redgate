IF OBJECT_ID('[stage].[vJEN_NO_Customer]') IS NOT NULL
	DROP VIEW [stage].[vJEN_NO_Customer];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE VIEW [stage].[vJEN_NO_Customer] AS
--COMMENT EMPTY FIELDS // ADD TRIM() UPPER()INTO CustomerID 2022-12-23 VA
SELECT
	--CONVERT([binary](32),HASHBYTES('SHA2_256',CONCAT(Company,'#',TRIM(CustomerNum)))) AS CustomerID
	CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM(Company),'#',TRIM(CustomerNum))))) AS CustomerID
	,CONVERT([binary](32),HASHBYTES('SHA2_256',[Company])) AS CompanyID
	,CONCAT([Company],'#',TRIM([CustomerNum])) AS CustomerCode
	,PartitionKey

	,Company
	,TRIM(CustomerNum) AS CustomerNum
	,[dbo].[ProperCase](CustomerName) AS MainCustomerName --add according to taskCard
    ,[dbo].[ProperCase](CustomerName) AS CustomerName -- can be replaced by if there is sub- Customer name
	,CASE WHEN [AddressLine1] is null OR [AddressLine1] = '' THEN [AddressLine2]  
		ELSE [AddressLine1] END AS [AddressLine1] -- added 20210204 SM
	,[AddressLine2]
	,[AddressLine3]
	,[TelephoneNumber1]	AS [TelephoneNum1]
	,[TelephoneNumber2]	AS [TelephoneNum2]
	,Email
	-- Previous logic
--	,CASE WHEN countryname like 'Sweden' AND LEFT(AddressLine3, 1) IN ('1','2','3','4','5','6','7','8','9')	THEN substring(replace([dbo].[ProperCase](AddressLine3), ' ', ''), 1,5) ELSE null end AS ZipCode
	,TRIM(SUBSTRING(AddressLine3, 1, PATINDEX('%[ ][A-ZÅÄÖ]%',AddressLine3)))	AS [ZipCode]
	--,CASE WHEN [City] = ' '	AND LEFT(AddressLine3, 1) IN ('1','2','3','4','5','6','7','8','9') THEN trim(substring(replace([dbo].[ProperCase](AddressLine3),' ',		''), 6, 100)) ELSE [dbo].[ProperCase]([City]) end AS [City]
	,[dbo].[ProperCase](TRIM(SUBSTRING(AddressLine3,PATINDEX('%[ ][A-ZÅÄÖ]%',AddressLine3 ) + 1, 100)))		AS [City]
	,IIF([State]= ' ',null,[State]) AS [State]
	,[District]	AS SalesDistrict
	,[dbo].[ProperCase](customer.CountryName) AS CountryName
	--,'' AS Division
	--,'' AS CustomerIndustry
	--,'' AS CustomerSubIndustry
	,[dbo].[ProperCase](TRIM(CONCAT (addressline1+' '+ addressline2, null))) AS AddressLine
	,CONCAT(customer.Countryname, +','+
		--CASE WHEN countryname like 'Sweden'	AND LEFT(AddressLine3, 1) IN ('1','2','3','4','5','6','7','8','9')
		--THEN trim(substring(REPLACE([dbo].[ProperCase](AddressLine3),' ', ''), 6, 100)) ELSE null end	+','+
		[dbo].[ProperCase](TRIM(SUBSTRING(AddressLine3,PATINDEX('%[ ][A-ZÅÄÖ]%',AddressLine3 ) + 1, 100))) +','+
		--CASE WHEN countryname like 'Sweden'	AND LEFT(AddressLine3, 1) IN ('1','2','3','4','5','6','7','8','9')
		--THEN substring(replace([dbo].[ProperCase](AddressLine3), ' ', ''), 1,5) ELSE null end	+','+
		TRIM(SUBSTRING(AddressLine3, 1, PATINDEX('%[ ][A-ZÅÄÖ]%',AddressLine3))) +','+
		[dbo].[ProperCase](TRIM(CONCAT (addressline1+' '+ addressline2, null)))) AS FullAddressLine
	,[dbo].[ProperCase](CustomerGroup) AS CustomerGroup
	,[dbo].[ProperCase](CustomerGroup) AS CustomerSubGroup	
	,[SalesRepCode]		AS SalesPersonCode
	,[dbo].[ProperCase](SalesPersonName) AS SalesPersonName
	--,'' AS [SalesPersonResponsible]
	,[VATRegNr]		AS VATNum
	--,'' AS OrganizationNum
	,[AccountString]	AS AccountNum
	,[InternalExternal]
	,[ABCCode] AS CustomerScore
	,CustomerType
	,GETDATE() AS ValidFrom
	,DATEADD(year,1,GETDATE()) AS ValidTo
	,case when LEN(TRIM(customer.CountryCode)) = 3 then cc.[Alpha-2 code]
	ELSE iif(TRIM(customer.CountryCode) is null or TRIM(customer.CountryCode) = '','NO',TRIM(customer.CountryCode))
	end as CountryCode
FROM [stage].[JEN_NO_Customer] as customer
	LEFT JOIN dbo.CountryCodes as cc
		ON trim(customer.CountryCode) = cc.[Alpha-3 code]
WHERE CustomerNum NOT LIKE 'INTR%' -- SM added according to validtion feedback 2021-02-09
GO
