IF OBJECT_ID('[stage].[vWID_FI_Customer]') IS NOT NULL
	DROP VIEW [stage].[vWID_FI_Customer];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE VIEW [stage].[vWID_FI_Customer] AS
--COMMENT EMPTY FIELDS // ADD UPPER()TRIM() INTO CustomerID
SELECT 
	CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM(Company), '#', TRIM(CustomerNum))))) AS CustomerID
	--CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT(Company, '#', TRIM(CustomerNum)))) AS CustomerID
    ,CONVERT([binary](32), HASHBYTES('SHA2_256', [Company])) AS CompanyID
	,CONCAT([Company], '#', TRIM([CustomerNum])) AS CustomerCode
	,PartitionKey

	,Company
    ,TRIM(CustomerNum) AS CustomerNum
	--,'' AS MainCustomerName
    ,CustomerName AS CustomerName
    ,[AddressLine1]
    ,[AddressLine2]
    ,[AddressLine3]
	,[TelephoneNumber1]	AS [TelephoneNum1]
	,[TelephoneNumber2]	AS [TelephoneNum2]
	,[Email]
	,[ZIP] AS ZipCode
    ,IIF([City]= ' ',null,[dbo].[ProperCase]([City])) AS [City]    
    ,IIF([State]= ' ',null,[State]) AS [State]
	,[District]		AS SalesDistrict
	,case when len(TRIM(customer.CountryCode)) = 3 then cc.[Alpha-2 code]
	else iif(customer.countryName is null, 'FI', customer.countryCode)
	end AS CountryCode
    ,[dbo].[ProperCase](customer.CountryName) AS CountryName
	--,'' AS Division
	--,'' AS CustomerIndustry
	--,'' AS CustomerSubIndustry
	,TRIM(CONCAT(AddressLine1,' ',AddressLine2)) as AddressLine
	,CONCAT(customer.Countryname, + ',  ' + trim([AddressLine3]), + ',  ' + TRIM([AddressLine2]), + ',  ' + trim(addressline1)) AS FullAddressLine
    ,CustomerGroup AS CustomerGroup
	,CustomerSubGroup AS CustomerSubGroup
	,[SalesRepCode]	 AS SalesPersonCode
    ,SalesPersonName
	--,'' AS [SalesPersonResponsible]
    ,TRIM([VATRegNr]) AS [VATNum]
	,OrganizationNum
	,[AccountString] AS AccountNum
	,CASE WHEN CustomerGroup = 'INTERNAL SALES' and customernum not in ('1283','CEU','CEX','CFIN') THEN 'I'
	else 'E' END AS [InternalExternal] --,'' AS [InternalExternal]
	,CustomerABC AS CustomerScore
	,CustomerType

  FROM [stage].[WID_FI_Customer] as customer
	left join dbo.CountryCodes as cc
		on customer.CountryCode = cc.[Alpha-3 code]
GO
