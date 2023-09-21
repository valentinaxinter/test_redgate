IF OBJECT_ID('[stage].[vGPI_FR_Customer]') IS NOT NULL
	DROP VIEW [stage].[vGPI_FR_Customer];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [stage].[vGPI_FR_Customer] AS
--COMMENT EMPTY FIELD // ADD UPPER()TRIM() INTO CustomerID 22-12-28 VA
SELECT 
	CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM(Company), '#', TRIM(CustomerNum))))) AS CustomerID
	--CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT(Company, '#', TRIM(CustomerNum)))) AS CustomerID
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
    ,[dbo].[ProperCase](customer.CountryName) AS CountryName
	,Division
	,CustomerIndustry
	,CustomerSubIndustry
	,[dbo].[ProperCase](TRIM(CONCAT(AddressLine1,' ',AddressLine2))) AS AddressLine
	,[dbo].[ProperCase](concat_ws(',',coalesce(customer.CountryName,null),coalesce(IIF([State]= ' ',null,[State]),IIF(City= ' ',null,City),IIF(ZipCode= ' ',null,ZipCode)),IIF([AddressLine3]=' ',null, [AddressLine3])
		,coalesce(IIF([addressline1]= ' ',null,[addressline1]),IIF([addressline2]= ' ',null,[addressline2]))
		,coalesce(IIF([addressline2]= ' ',null,[addressline2]),IIF([addressline3]= ' ',null,[addressline3])))) AS FullAddressLine
    ,[dbo].[ProperCase](CustomerGroup) AS CustomerGroup
	,[dbo].[ProperCase](CustomerSubGroup) AS CustomerSubGroup
	,[SalesRepCode] AS [SalesPersonCode]
	,[dbo].[ProperCase](SalesPersonName) AS SalesPersonName
	,Commercial3 AS [SalesPersonResponsible] -- Should potentially be put into "Extra field" instead - SB 2022-11-30
    ,TRIM([VatRegNo]) AS [VATNum]
	--,'' AS OrganizationNum 
	,[AccountString] AS [AccountNum]
	--,'' AS [InternalExternal]
	,Commercial2 AS [CustomerScore]  -- Should potentially be put into "Extra field" instead - SB 2022-11-30
	,CustomerType
	,case when len(trim(customer.CountryName)) = 3 then cc.[Alpha-2 code]
	else customer.CountryName 
	end as CountryCode
FROM [stage].[GPI_FR_Customer] as customer
	LEFT JOIN dbo.CountryCodes as cc
		on customer.CountryName = cc.[Alpha-3 code]
GO
