IF OBJECT_ID('[stage].[vCYE_ES_Customer]') IS NOT NULL
	DROP VIEW [stage].[vCYE_ES_Customer];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE view [stage].[vCYE_ES_Customer] AS
--COMMENT EMPTY FIELDS // ADD TRIM() INTO CustomerID 23-01-03 VA
SELECT 
	CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM(Company), '#', TRIM(CustomerNum))))) AS CustomerID
	--CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(Company, '#', TRIM(CustomerNum))))) AS CustomerID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER([Company]))) AS CompanyID
	,UPPER(CONCAT([Company], '#', TRIM([CustomerNum]))) AS CustomerCode
	,PartitionKey

	,UPPER([Company]) AS Company
	,UPPER(TRIM(CustomerNum)) AS CustomerNum
	--,'' AS MainCustomerName
	,CustomerName
	,[AddressLine1]
	,[AddressLine2]
	,[AddressLine3]
	,TelephoneNumber1 AS TelephoneNum1
	--,'' AS TelephoneNum2
	,Email
	,[ZIP] AS ZipCode
	,IIF([City]= ' ', null, [City]) AS [City]
	,IIF([State]= ' ', null, [State]) AS [State]
	,[District]	AS SalesDistrict
	,CountryCode
	,CountryName
	--,'' AS Division
	--,'' AS CustomerIndustry
	--,'' AS CustomerSubIndustry
	,CONCAT(TRIM(AddressLine1), ' ', TRIM(AddressLine2)) AS AddressLine
	,CONCAT(TRIM(CountryName), ', ', TRIM([ZIP]), ', ', TRIM(City), ', ', TRIM(AddressLine1)) AS FullAddressLine
	,CustomerGroup
	,CustomerSubGroup
	,[SalesRepCode]	AS SalesPersonCode
	,SalesRepCode AS SalesPersonName
	--,'' AS SalesPersonResponsible
	,TRIM([VATRegNr]) AS [VATNum]
	--,'' AS OrganizationNum
	--,'' AS AccountNum 
	,[InternalExternal]
	,CustomerScore --[ABCCode] AS 
	--,'' AS CustomerType
FROM [stage].[CYE_ES_Customer]
GO
