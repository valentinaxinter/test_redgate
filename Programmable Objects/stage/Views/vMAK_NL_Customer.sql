IF OBJECT_ID('[stage].[vMAK_NL_Customer]') IS NOT NULL
	DROP VIEW [stage].[vMAK_NL_Customer];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [stage].[vMAK_NL_Customer] AS
--COMMENT empty fields / ADD UPPER()TRIM() INTO CustomerID 13-12-2022 VA 
SELECT 
	CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM(Company),'#',TRIM(CustomerNum))))) AS CustomerID
	--CONVERT([binary](32),HASHBYTES('SHA2_256',CONCAT(Company,'#',TRIM(CustomerNum)))) AS CustomerID
	,CONCAT(Company,'#',TRIM([CustomerNum])) AS CustomerCode
	,CONVERT([binary](32),HASHBYTES('SHA2_256',Company)) AS CompanyID
	,PartitionKey
	,Company
	,TRIM(CustomerNum) AS [CustomerNum]
	,MainCustomerName
    ,[dbo].[ProperCase](CustomerName) AS CustomerName
	,LEFT([AddressLine1], 100) AS [AddressLine1]
	,LEFT([AddressLine2], 100) AS [AddressLine2]
	,LEFT([AddressLine3], 100) AS [AddressLine3]
	,[TelephoneNum1]			AS TelephoneNum1
	--,''		AS TelephoneNum2
	,[Email]
	,[ZipCode]
	,[dbo].[ProperCase]([City]) AS	City
	,IIF([State]= ' ',null,[State]) AS [State]
	,[District]		AS SalesDistrict
	,[dbo].[ProperCase](CountryName) AS [CountryName]
	,Division
	,CustomerIndustry
	,CustomerSubIndustry
	,[AddressLine1] AS [AddressLine]
	,CONCAT(Countryname, + ', '+ trim([City]),  ', ' + TRIM([ZipCode]), ', ' + trim(addressline1)) AS [FullAddressLine]
	,[dbo].[ProperCase](CustomerGroup) AS [CustomerGroup]
	,[dbo].[ProperCase](CustomerGroup) AS [CustomerSubGroup]
	,[SalesPersonCode]
	,[dbo].[ProperCase](SalesPersonName) AS [SalesPersonName]
	,[SalesPersonResponsible]
	,[VATNum]
	--,'' AS OrganizationNum
	,[AccountNum]
	,[InternalExternal]
	,[CustomerScore]
	,[CustomerType]

	--,NULL AS [ValidFrom]
	--,NULL AS [ValidTo]
	,UPPER([dbo].[ProperCase](CountryName)) as CountryCode
FROM [stage].[MAK_NL_Customer]
GO
