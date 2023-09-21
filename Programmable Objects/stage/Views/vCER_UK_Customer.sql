IF OBJECT_ID('[stage].[vCER_UK_Customer]') IS NOT NULL
	DROP VIEW [stage].[vCER_UK_Customer];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [stage].[vCER_UK_Customer] AS
--COMMENT EMPTY FIELDS // ADD UPPER()TRIM() INTO CustomerID
SELECT 
	--CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT(Company, '#', TRIM(CustomerNum)))) AS CustomerID
	CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM(Company), '#', TRIM(CustomerNum))))) AS CustomerID
    ,CONCAT([Company], '#', TRIM([CustomerNum])) AS CustomerCode
	,CONVERT([binary](32), HASHBYTES('SHA2_256', [Company])) AS CompanyID
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
	,LEFT([Email],100) AS [Email]
	,[City]
	,IIF([ZIP]= ' ',null,[ZIP]) AS ZipCode
    ,IIF([State]= ' ',null,[State]) AS [State]
	,[District] AS [SalesDistrict]
	,
	case when IIF(CountryName is null, 'GB', CountryCode) = 'UK' then 'GB'
	else IIF(CountryName is null, 'GB', CountryCode)
	end AS CountryCode
	,IIF(CountryName is null, 'United Kingdom', CountryName) AS CountryName
	,[Division]
	--,'' AS CustomerIndustry
	--,'' AS CustomerSubIndustry
    ,[dbo].[ProperCase](CustomerGroup) AS CustomerGroup
	,[dbo].[ProperCase](CustomerSubGroup) AS CustomerSubGroup
	,[SalesRepCode] AS [SalesPersonCode]
	,[dbo].[ProperCase](SalesPersonName) AS SalesPersonName
	--,'' AS [SalesPersonResponsible]
	,[VATRegNr] AS [VATNum]
	,OrganizationNum
	,[AccountString] AS [AccountNum]
	,[InternalExternal]
	,[ABCCode] AS [CustomerScore]
	,[CustomerType] AS CustomerType
	,[dbo].[ProperCase](TRIM(CONCAT(AddressLine1,' ',AddressLine2,' ',AddressLine3))) AS AddressLine
	,[dbo].[ProperCase](concat_ws(',',coalesce(CountryName,null),coalesce(IIF([State]= ' ',null,[State]),IIF(District= ' ',null,District),IIF(City= ' ',null,City),IIF(ZIP= ' ',null,ZIP))
		,coalesce(IIF([addressline1]= ' ',null,[addressline1]),IIF([addressline2]= ' ',null,[addressline2]))
		,coalesce(IIF([addressline2]= ' ',null,[addressline2]),IIF([addressline3]= ' ',null,[addressline3])))) AS FullAddressLine
  FROM [stage].[CER_UK_Customer]
GO
