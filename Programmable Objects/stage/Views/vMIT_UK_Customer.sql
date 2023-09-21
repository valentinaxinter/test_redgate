IF OBJECT_ID('[stage].[vMIT_UK_Customer]') IS NOT NULL
	DROP VIEW [stage].[vMIT_UK_Customer];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [stage].[vMIT_UK_Customer] AS
--COMMENT EMPTY FIELDS // ADD UPPER() TRIM() CustomerID 22-12-27 VA
SELECT 
	CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM(Company),'#',TRIM(CustomerNum))))) AS CustomerID
	--CONVERT([binary](32),HASHBYTES('SHA2_256',CONCAT(Company,'#',TRIM(CustomerNum)))) AS CustomerID
	,CONCAT([Company],'#',TRIM([CustomerNum])) AS CustomerCode
	,CONVERT([binary](32),HASHBYTES('SHA2_256',[Company])) AS CompanyID
	,PartitionKey
	,Company
	,TRIM(CustomerNum) AS [CustomerNum]
	--,'' AS MainCustomerName
	,[dbo].[ProperCase](CustomerName) AS  [CustomerName]
	,[AddressLine1]
	,[AddressLine2]
	,[AddressLine3]
	--,'' AS [TelephoneNum1]
	--,'' AS [TelephoneNum2]
	--,'' AS [Email]
	,[ZIP] AS [ZipCode]
	,CASE WHEN [City] = ' '	AND LEFT(AddressLine3, 1) IN ('1','2','3','4','5','6','7','8','9') THEN trim(substring(replace([dbo].[ProperCase](AddressLine3),' ',		''), 6, 100)) ELSE [dbo].[ProperCase]([City]) end AS [City]
	,IIF([State]= ' ',null,[State]) AS [State]
	,[District] AS SalesDistrict
	,IIF(CountryCode = 'EL', 'GR', CountryCode) AS CountryCode
	,[dbo].[ProperCase](CountryName) AS [CountryName]
	--,'' AS Division
	--,'' AS CustomerIndustry
	--,'' AS CustomerSubIndustry
	,[AddressLine1] AS [AddressLine]
	,CONCAT(TRIM(Countryname), + ', ' + TRIM([City]), + ', ' + TRIM([AddressLine2]), + ', ' + TRIM(AddressLine1)) AS [FullAddressLine]
	,[dbo].[ProperCase](CustomerGroup) AS [CustomerGroup]
	,[dbo].[ProperCase](CustomerGroup) AS [CustomerSubGroup]
	,[SalesRepCode] AS SalesPersonCode
	,[dbo].[ProperCase](SalesPersonName) AS [SalesPersonName]
	--,'' AS [SalesPersonResponsible]
	,[VATRegNr] AS VATNum
	--,'' AS OrganizationNum
	,[AccountString] AS AccountNum
	,[InternalExternal]
	,[CustomerABC] AS CustomerScore
	--,'' AS [CustomerType]
	
	,GETDATE() AS [ValidFrom]
	,DATEADD(year,1,GETDATE()) AS [ValidTo]
FROM [stage].[MIT_UK_Customer]
GO
