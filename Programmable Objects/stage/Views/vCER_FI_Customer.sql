IF OBJECT_ID('[stage].[vCER_FI_Customer]') IS NOT NULL
	DROP VIEW [stage].[vCER_FI_Customer];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE VIEW [stage].[vCER_FI_Customer] AS
--COMMENT EMPTY FIELD // ADD TRIM()UPPER() INTO CustomerID 2022-12-20 VA
SELECT 

	CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM(Company),'#',TRIM(CustomerNum))))) AS CustomerID
	--CONVERT([binary](32),HASHBYTES('SHA2_256',CONCAT(Company,'#',TRIM(CustomerNum)))) AS CustomerID
	,CONVERT([binary](32),HASHBYTES('SHA2_256',[Company])) AS CompanyID
	,CONCAT([Company],'#',TRIM([CustomerNum])) AS CustomerCode
	,PartitionKey

	,Company
    ,TRIM(CustomerNum) AS CustomerNum
	,CASE WHEN CustomerName LIKE '%/%' THEN CONCAT(MainCustomerNum, ' - ', SUBSTRING (CustomerName, 0, CHARINDEX('/', CustomerName)))
		WHEN CustomerName LIKE '%,%' THEN CONCAT(MainCustomerNum, ' - ', SUBSTRING (CustomerName, 0, CHARINDEX(',', CustomerName)))
		ELSE CONCAT(TRIM(CustomerNum), ' - ', CustomerName) END AS MainCustomerName -- requested by Vera Teplits ticket #SR-95348 2023-02-14 /DZ
    ,[dbo].[ProperCase](CustomerName) AS CustomerName
    ,[AddressLine1]
    ,[AddressLine2]
    ,[AddressLine3]
	,[TelephoneNumber1] AS [TelephoneNum1] 
	,[TelephoneNumber2]  AS [TelephoneNum2] 
	,[Email]
	,IIF([AddressLine3]=' ',null, SUBSTRING(AddressLine3,1,5))  AS ZipCode
	,IIF(LEN(AddressLine3) - LEN(REPLACE(AddressLine3, ' ', '')) >= 1,RIGHT([dbo].[ProperCase](AddressLine3), CHARINDEX(' ', REVERSE(AddressLine3)) - 1),[dbo].[ProperCase](AddressLine3)) AS [City]
    ,IIF([State]= ' ',null,[State]) AS [State]
	,[dbo].[ProperCase]([District])  AS SalesDistrict
	,case when LEN(TRIM(customer.CountryCode)) = 3 then cc.[Alpha-2 code]
	else IIF(customer.CountryName is null, 'FI', customer.CountryCode) 
	end AS CountryCode
    ,IIF(ISNULL(customer.[CountryName],'Finland')='Finland','Finland',[dbo].[ProperCase](customer.CountryName)) AS CountryName
	--,'' AS Division
	--,'' AS CustomerIndustry
	--,'' AS CustomerSubIndustry
	,TRIM(CONCAT([dbo].[ProperCase](AddressLine1),' ',[dbo].[ProperCase](AddressLine2))) AS AddressLine
	,CONCAT(IIF(ISNULL(customer.[CountryName],'Finland')='Finland','Finland',[dbo].[ProperCase](customer.CountryName)), + ', ' + IIF([AddressLine3]=' ', null, SUBSTRING(AddressLine3,1,5)), + ', ' + 
		IIF(LEN(AddressLine3) - LEN(REPLACE(AddressLine3, ' ', '')) >= 1,RIGHT([dbo].[ProperCase](AddressLine3), CHARINDEX(' ', REVERSE(AddressLine3)) - 1),[dbo].[ProperCase](AddressLine3))
		, + ', ' + TRIM(CONCAT([dbo].[ProperCase](AddressLine1),' ',[dbo].[ProperCase](AddressLine2)))) AS FullAddressLine
    ,[dbo].[ProperCase](CustomerGroup) AS CustomerGroup
	,[dbo].[ProperCase](CustomerGroup) AS CustomerSubGroup
    ,[SalesRepCode] AS SalesPersonCode
	,[dbo].[ProperCase](SalesPersonName) AS SalesPersonName
	--,'' AS [SalesPersonResponsible]
    ,[VATRegNr] AS VATNum
	,OrganizationNum
	,[AccountString]	AS AccountNum
	,[InternalExternal]
	,[ABCCode] AS CustomerScore
	,CustomerType
	,GETDATE() AS ValidFrom
	,DATEADD(year,1,GETDATE()) AS ValidTo
FROM [stage].[CER_FI_Customer] as customer
	LEFT JOIN dbo.CountryCodes as cc
		ON customer.CountryCode = cc.[Alpha-3 code]
GO
