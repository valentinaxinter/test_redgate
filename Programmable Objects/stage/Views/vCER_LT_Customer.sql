IF OBJECT_ID('[stage].[vCER_LT_Customer]') IS NOT NULL
	DROP VIEW [stage].[vCER_LT_Customer];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [stage].[vCER_LT_Customer] AS
--COMMENT EMPTY FIELD / ADD UPPER()TRIM() INTO CustomerID 2022-12-13 VA
SELECT 
	--CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT(Company, '#',TRIM(CustomerNum)))) AS CustomerID
	CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM(Company), '#',TRIM(CustomerNum))))) AS CustomerID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', Company)) AS CompanyID
	,CONCAT(Company,'#', TRIM([CustomerNum])) AS CustomerCode
	,PartitionKey

	,Company
	,TRIM(CustomerNum) AS [CustomerNum]
	--,'' AS MainCustomerName
	,[dbo].[ProperCase](CustomerName) AS [CustomerName]
	,[AddressLine1]
	,[AddressLine2]
	,[AddressLine3]
	,[TelephoneNumber1] AS [TelephoneNum1]
	,[TelephoneNumber2] AS [TelephoneNum2]
	,[Email]
	,[ZIP] AS [ZipCode]
	,CASE WHEN [City] = ' '	AND LEFT(AddressLine3, 1) IN ('1','2','3','4','5','6','7','8','9') THEN trim(substring(replace([dbo].[ProperCase](AddressLine3),' ',		''), 6, 100)) ELSE [dbo].[ProperCase]([City]) end AS [City]
	,IIF([State]= ' ', null, [State]) AS [State]
	,[District] AS SalesDistrict
	,IIF(CountryName is null, 'LT', CountryCode) AS CountryCode
    ,IIF(CountryName is null, 'Lithuania', CountryName) AS CountryName
	--,'' AS Division
	--,'' AS CustomerIndustry
	--,'' AS CustomerSubIndustry
	,[dbo].[ProperCase](TRIM(concat (addressline1 + ' ' + addressline2, null))) AS [AddressLine]
	,CONCAT(IIF(Countryname IS NULL, 'Lietuva', TRIM(Countryname)), + ', ' + IIF([City] IS NULL, TRIM(AddressLine3), TRIM([City])), + ', ' + IIF([ZIP] IS NULL, TRIM(AddressLine3), TRIM([ZIP])), + ', ' + TRIM(AddressLine2)) AS [FullAddressLine]
	,[dbo].[ProperCase](CustomerGroup) AS [CustomerGroup]
	--,'' AS [CustomerSubGroup]
	,[SalesRepCode] AS SalesPersonCode
	,[dbo].[ProperCase](SalesPersonName) AS [SalesPersonName]
	--,'' AS [SalesPersonResponsible]
	,[VATRegNr] AS VATNum
	,OrganizationNum
	,[AccountString] AS AccountNum
	,[InternalExternal]
	,[ABCCode] AS CustomerScore
	,[CustomerType]
FROM [stage].[CER_LT_Customer]
GO
