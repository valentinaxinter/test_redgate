IF OBJECT_ID('[stage].[vARK_CZ_Customer]') IS NOT NULL
	DROP VIEW [stage].[vARK_CZ_Customer];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [stage].[vARK_CZ_Customer] AS
--COMMENT EMPTY FIELDS // ADD TRIM()UPPER() INTO CustomerID 2022-12-16 VA
SELECT 
	CONVERT([binary](32), HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM(Company), '#' ,TRIM(CustomerNum))))) AS CustomerID
	--CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT(Company, '#' ,TRIM(CustomerNum)))) AS CustomerID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', [Company])) AS CompanyID
	,CONCAT([Company], '#', TRIM([CustomerNum])) AS CustomerCode
	,PartitionKey

	,Company
    ,TRIM(CustomerNum) AS CustomerNum
	--,'' AS MainCustomerName
    ,CustomerName
    ,[AddressLine1]
    ,[AddressLine2]
    ,[AddressLine3]
	,[TelephoneNumber1] AS [TelephoneNum1]
	,[TelephoneNumber2] AS [TelephoneNum2]
	,[Email]
	,ZipCode
	,[City]
    ,IIF([State]= ' ',null,[State]) AS [State]
	,[District] AS SalesDistrict
	,TRIM(CountryCode) AS CountryCode
    ,CASE WHEN CountryName is null THEN 'Czech Republic' ELSE CountryName END AS CountryName
	,Division
	--,'' AS CustomerIndustry
	--,'' AS CustomerSubIndustry
	,TRIM(CONCAT(AddressLine1,', ',AddressLine2)) AS AddressLine
	,CONCAT(CASE WHEN CountryName is null THEN 'Czech Republic' ELSE CountryName END, + ',' + ZipCode, + ',' + City) AS FullAddressLine
    ,CustomerGroup AS CustomerGroup
	,CustomerSubGroup AS CustomerSubGroup
    ,[SalesRepCode]	AS SalesPersonCode
	,CONVERT(varchar(50), SalesPersonName) AS SalesPersonName --[dbo].[ProperCase](SalesPersonName) AS --SERVERPROPERTY('Czech_CI_AS'), 
	,[SalesPersonResponsible]
    ,TRIM([VATRegNr]) AS [VATNum]
	--,'' AS OrganizationNum
	,[AccountString] AS AccountNum
	,[InternalExternal]
	,[CustomerABC] AS CustomerScore
	,CustomerType
FROM [stage].[ARK_CZ_Customer]
GO
