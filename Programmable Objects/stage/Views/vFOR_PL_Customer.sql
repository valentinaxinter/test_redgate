IF OBJECT_ID('[stage].[vFOR_PL_Customer]') IS NOT NULL
	DROP VIEW [stage].[vFOR_PL_Customer];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE VIEW [stage].[vFOR_PL_Customer] AS

SELECT 
	CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM(Company),'#',TRIM(CustomerNum))))) AS CustomerID
	,CONVERT([binary](32),HASHBYTES('SHA2_256',[Company])) AS CompanyID
	,CONCAT([Company],'#',TRIM([CustomerNum])) AS CustomerCode
	,PartitionKey
	,Company
    ,TRIM(CustomerNum) AS CustomerNum
	,MainCustomerName AS MainCustomerName
    ,COALESCE(MainCustomerName,CustomerName) AS CustomerName
    ,[AddressLine1]
    --,''	AS [AddressLine2]
    --,'' AS [AddressLine3]
	,[TelephoneNum1]
	,[TelephoneNum2]
	,[Email]
	,[ZIPCode]
    ,IIF([City]= ' ',null,[dbo].[ProperCase]([City])) AS [City]    
    ,[State]
	,SalesDistrict
    ,cc.CountryName		AS CountryName
	--,''					AS Division
	,CustomerIndustry
	,CustomerSubIndustry
	,TRIM(AddressLine1) as AddressLine
	,concat_ws(',',coalesce(cc.CountryName,null),' ' + coalesce(IIF(City= ' ',null,City),' ' + IIF(ZIPCode= ' ',null,ZIPCode)),' ' + coalesce(IIF([addressline1]= ' ',null,[addressline1]),'')) AS FullAddressLine
    ,CustomerGroup
	,CustomerSubGroup
	,SalesPersonCode
    ,SalesPersonName
	--,'' AS [SalesPersonResponsible]
    ,[VATNum]
	--,'' AS OrganizationNum
	,AccountNum
	,[InternalExternal]
	--,''	AS CustomerScore
	--,'' CustomerType
	--,'' ValidFrom
	--,'' ValidTo
	,c.[CRes1] as CRes1
	,c.CountryName as CountryCode

  FROM [stage].[FOR_PL_Customer] c
  LEFT JOIN [dbo].[CountryCodes] cc ON c.CountryName = cc.[Alpha-2 code]
GO
