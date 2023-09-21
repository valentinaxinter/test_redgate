IF OBJECT_ID('[stage].[vFOR_FR_Customer]') IS NOT NULL
	DROP VIEW [stage].[vFOR_FR_Customer];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [stage].[vFOR_FR_Customer] AS
--COMMENT empty fields / ADD UPPER()TRIM() INTO CustomerID 2022-12-13 VA
SELECT 
	--CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT(Company, '#', TRIM(CustomerNum)))) AS CustomerID
	CONVERT([binary](32), HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM(Company), '#', TRIM(CustomerNum))))) AS CustomerID
    ,CONCAT([Company], '#', TRIM([CustomerNum])) AS CustomerCode
	,CONVERT([binary](32), HASHBYTES('SHA2_256', [Company])) AS CompanyID
	,PartitionKey

	,Company
    ,TRIM(CustomerNum) AS CustomerNum
	,MainCustomerName
    ,[dbo].[ProperCase](CustomerName) AS CustomerName
    ,[AddressLine1]
    ,[AddressLine2]
    ,[AddressLine3]
	,[TelephoneNumber1] AS [TelephoneNum1]
	--,'' AS [TelephoneNum2]
	,[Email]
	,ZipCode
    ,IIF([City]= ' ', null, [dbo].[ProperCase]([City])) AS [City]    
    ,IIF([State]= ' ', null, [State]) AS [State]
	,[District] AS [SalesDistrict]
    ,[dbo].[ProperCase](CountryName) AS CountryName
	,Division
	,CustomerIndustry
	,CustomerSubIndustry
	,TRIM(CONCAT(AddressLine1, ' ', AddressLine2)) AS AddressLine
	,CONCAT(IIF(TRIM(CountryName) = 'Fr', 'France', TRIM(CountryName)), ', ', TRIM([City]), ', ',  TRIM([ZipCode]), ', ',  IIF(TRIM([AddressLine3]) = '', TRIM([AddressLine1]), TRIM([AddressLine3]) )) AS FullAddressLine
    ,(CustomerGroup) AS CustomerGroup
	,(CustomerSubGroup) AS CustomerSubGroup
	,[SalesRepCode] AS [SalesPersonCode]
	,(SalesPersonName) AS SalesPersonName
	,Commercial3 AS [SalesPersonResponsible] -- Should potentially be put into "Extra field" instead - SB 2022-11-30
    ,TRIM([VatRegNo]) AS [VATNum]
	--,'' AS OrganizationNum 
	,[AccountString] AS [AccountNum]
	--,'' AS [InternalExternal]
	,Commercial2 AS [CustomerScore]  -- Should potentially be put into "Extra field" instead - SB 2022-11-30
	,CustomerType
	,CASE 
		WHEN LEN(TRIM(CountryName)) = 3 THEN (SELECT [Alpha-2 code] FROM DBO.CountryCodes WHERE [Alpha-3 code] = TRIM(CountryName))
		ELSE NULLIF(TRIM(CountryName),'')
	 END as CountryCode
FROM [stage].[FOR_FR_Customer]
GO
