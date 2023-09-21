IF OBJECT_ID('[stage].[vCER_DK_Customer]') IS NOT NULL
	DROP VIEW [stage].[vCER_DK_Customer];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [stage].[vCER_DK_Customer] AS
--COMMENT EMPTY FIELDS 2022-12-14 VA
SELECT 
	CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM(Company),'#',TRIM(CustomerNum))))) AS CustomerID
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
	--,'' AS [TelephoneNum2]
	,[Email]
	,[ZIP] AS ZipCode
    ,IIF([City]= ' ',null,[dbo].[ProperCase]([City])) AS [City]    
    ,IIF([State]= ' ',null,[State]) AS [State]
	,[District] AS SalesDistrict
    ,CASE WHEN CountryName is null THEN 'Denmark' ELSE CountryName END AS CountryName
	,Division
	--,'' AS CustomerIndustry
	--,'' AS CustomerSubIndustry
	,TRIM(CONCAT([dbo].[ProperCase](AddressLine1),' ',[dbo].[ProperCase](AddressLine2))) AS AddressLine
	,CONCAT(TRIM(CountryName), + ', ' + TRIM(City), + ', ' + TRIM(Zip),  + ', ' + TRIM([AddressLine1])) AS FullAddressLine
    ,[dbo].[ProperCase](CustomerGroup) AS CustomerGroup
	,[dbo].[ProperCase](CustomerSubGroup) AS CustomerSubGroup
    ,[SalesRepCode]	AS SalesPersonCode
	,[dbo].[ProperCase](SalesPersonName) AS SalesPersonName
	--,'' AS [SalesPersonResponsible]
    ,TRIM([VATRegNr]) AS [VATNum]
	--,'' AS OrganizationNum
	,[AccountString]	AS AccountNum
	,[InternalExternal]
	,[CustomerABC] AS CustomerScore
	--,'' AS CustomerType
	,[CustomerPriceGroup] as CRes1
	,case when len(CountryCode) > 2 then LEFT(CountryCode,2)
	else CountryCode
	end as CountryCode
FROM [stage].[CER_DK_Customer]
GO
