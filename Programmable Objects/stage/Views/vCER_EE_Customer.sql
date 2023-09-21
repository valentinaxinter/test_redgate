IF OBJECT_ID('[stage].[vCER_EE_Customer]') IS NOT NULL
	DROP VIEW [stage].[vCER_EE_Customer];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE VIEW [stage].[vCER_EE_Customer] AS
--COMMENT EMPTY FIELDS // ADD UPPER()TRIM() INTO CustomerID 2022-12-15 VA
SELECT 
	CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM(Company),'#',TRIM(CustomerNum))))) AS CustomerID
--	CONVERT([binary](32),HASHBYTES('SHA2_256',CONCAT(Company,'#',TRIM(CustomerNum)))) AS CustomerID
	,CONVERT([binary](32),HASHBYTES('SHA2_256',[Company])) AS CompanyID
	,CONCAT([Company],'#',TRIM([CustomerNum])) AS CustomerCode
	,PartitionKey

	,Company
    ,TRIM(CustomerNum) AS CustomerNum
	--,'' AS MainCustomerName
    ,[dbo].[ProperCase](CustomerName) AS CustomerName
    ,[AddressLine1]
    ,[AddressLine2]
    ,[AddressLine3]
	,[TelephoneNumber1] AS [TelephoneNum1]
	,[TelephoneNumber2] AS [TelephoneNum2]
	,left([Email],99) as [Email]
	,IIF([AddressLine3]=' ',null, SUBSTRING(AddressLine3,1,5))  AS ZipCode
	,IIF(LEN(AddressLine3) - LEN(REPLACE(AddressLine3, ' ', '')) >= 1,RIGHT(AddressLine3, CHARINDEX(' ', REVERSE(AddressLine3)) - 1),AddressLine3)  AS [City]
    ,IIF([State]= ' ',null,[State]) AS [State]
	,[District] AS SalesDistrict
	,case when LEN(trim(customer.CountryCode)) = 3 then cc.[Alpha-2 code]
		else IIF(customer.CountryName is null, 'EE', customer.CountryCode) 
	 end AS CountryCode
    ,IIF(customer.CountryName is null, 'Estonia', customer.CountryName) AS CountryName
	--,'' AS Division
	--,'' AS CustomerIndustry
	--,'' AS CustomerSubIndustry
	,TRIM(CONCAT([dbo].[ProperCase](AddressLine1),' ',[dbo].[ProperCase](AddressLine2))) AS AddressLine
	,CONCAT(CASE WHEN customer.CountryName is null THEN 'Estonia' ELSE customer.CountryName END, + ','
		+ IIF(LEN(AddressLine3) - LEN(REPLACE(AddressLine3, ' ', '')) >= 1,RIGHT(AddressLine3, CHARINDEX(' ', REVERSE(AddressLine3)) - 1),AddressLine3), + ','
		+ IIF([AddressLine3]=' ', null, SUBSTRING(AddressLine3,1,5)),  + ','
		+ [AddressLine3]
		) AS FullAddressLine
    ,[dbo].[ProperCase](CustomerGroup) AS CustomerGroup
	,[dbo].[ProperCase](CustomerGroup) AS CustomerSubGroup
    ,[SalesRepCode]		AS SalesPersonCode
	,[dbo].[ProperCase](SalesPersonName) AS SalesPersonName
	--,'' AS [SalesPersonResponsible]
    ,TRIM([VATRegNr]) AS [VATNum]
	,OrganizationNum
	,[AccountString]	AS AccountNum
	,[InternalExternal]
	,[ABCCode] AS CustomerScore
	,CustomerType
	,GETDATE() AS ValidFrom
	,DATEADD(year,1,GETDATE()) AS ValidTo

FROM [stage].[CER_EE_Customer] as customer
	LEFT JOIN dbo.CountryCodes as cc
		on cc.[Alpha-3 code] = CountryCode
GO
