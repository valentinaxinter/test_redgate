IF OBJECT_ID('[stage].[vFOR_ES_Customer]') IS NOT NULL
	DROP VIEW [stage].[vFOR_ES_Customer];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE view [stage].[vFOR_ES_Customer] AS
--COMMENT EMPTY FIELD 2022-12-21 VA
SELECT 
	CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM(Company),'#',TRIM(CustomerNum))))) AS CustomerID
	,CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(TRIM([Company])))) AS CompanyID
	,UPPER(CONCAT(TRIM([Company]),'#',TRIM([CustomerNum]))) AS CustomerCode
	,PartitionKey

	,Company
    ,TRIM(CustomerNum) AS CustomerNum
	,CustomerName AS MainCustomerName --Swapping MainCustomerName and CustomerName due to data quality in MainCustomerName being much better /SM 2021-11-30
    ,MainCustomerName AS CustomerName
    ,[AddressLine1]
    --,''	AS [AddressLine2]
    --,'' AS [AddressLine3]
	,[TelephoneNum1]
	,[TelephoneNum2]
	,[Email]
	,[ZIPCode]
    ,IIF([City]= ' ',null,[dbo].[ProperCase]([City])) AS [City]    
    --,'' AS [State]
	,SalesDistrict
    ,cc.CountryName AS CountryName
	--,'' AS Division
	--,'' AS CustomerIndustry
	--,'' AS CustomerSubIndustry
	,[dbo].[ProperCase](TRIM(AddressLine1)) as AddressLine
	,[dbo].[ProperCase](concat_ws(',',coalesce(cc.CountryName,null),' ' + coalesce(IIF(City= ' ',null,City),' ' + IIF(ZIPCode= ' ',null,ZIPCode)),' ' + coalesce(IIF([addressline1]= ' ',null,[addressline1]),''))) AS FullAddressLine
    ,[dbo].[ProperCase](CustomerGroup) AS CustomerGroup
	--,'' AS CustomerSubGroup
	,SalesPersonCode
    ,[dbo].[ProperCase](SalesPersonName) AS SalesPersonName
	--,'' AS [SalesPersonResponsible]
    ,[VATNum]
	,[OrganizationNum] AS OrganizationNum
	--,'' AS AccountNum
	--,''	AS [InternalExternal]
	--,''	AS CustomerScore
	,[Type] AS CustomerType
	,GETDATE() AS ValidFrom
	,DATEADD(year,1,GETDATE()) AS ValidTo
	,c.CountryName as CountryCode
  FROM [stage].[FOR_ES_Customer] c
  LEFT JOIN [dbo].[CountryCodes] cc ON c.CountryName = cc.[Alpha-2 code]
GO
