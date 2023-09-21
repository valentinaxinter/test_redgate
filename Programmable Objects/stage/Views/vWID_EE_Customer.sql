IF OBJECT_ID('[stage].[vWID_EE_Customer]') IS NOT NULL
	DROP VIEW [stage].[vWID_EE_Customer];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [stage].[vWID_EE_Customer] AS
-- ROWS CREATED FROM BUDGET TABLE 23-01-12
--COMMENT EMPTY FIELDS 23-01-12 VA
SELECT 
	CONVERT([binary](32), HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM(Company), '#', TRIM(CustomerNum))))) AS CustomerID
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
    ,IIF([City]= ' ',null,([City])) AS [City]    
    ,IIF([State]= ' ',null,[State]) AS [State]
	,[District]		AS SalesDistrict
	,case when len(TRIM(customer.CountryCode)) = 3 then cc.[Alpha-2 code]
	else iif(customer.countryName is null, 'EE', customer.countryCode)
	end AS CountryCode
    ,(customer.CountryName) AS CountryName
	--,'' AS Division
	--,'' AS CustomerIndustry
	--,'' AS CustomerSubIndustry
	,TRIM(CONCAT(AddressLine1,' ',AddressLine2)) as AddressLine
	,CONCAT(TRIM(customer.Countryname), + ', ' + TRIM([AddressLine2]), + ', ' + TRIM([AddressLine1])) AS FullAddressLine
    ,CustomerGroup AS CustomerGroup
	,CustomerSubGroup AS CustomerSubGroup
	,[SalesRepCode]	 AS SalesPersonCode
    ,SalesPersonName
	--,'' AS [SalesPersonResponsible]
    ,TRIM([VATRegNr]) AS [VATNum]
	--,'' AS OrganizationNum
	,[AccountString] AS AccountNum
	--,'' AS [InternalExternal]
	,CustomerABC AS CustomerScore
	,CustomerType

  FROM [stage].[WID_EE_Customer] as customer
	LEFT JOIN DBO.CountryCodes AS cc
		ON customer.CountryCode = cc.[Alpha-3 code]
GO
