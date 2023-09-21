IF OBJECT_ID('[stage].[vSCM_FI_Customer]') IS NOT NULL
	DROP VIEW [stage].[vSCM_FI_Customer];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [stage].[vSCM_FI_Customer] AS
--COMMENT EMPTY FIELDS // ADD UPPER()TRIM() INTO CustomerID 2022-12-21 VA
SELECT 
	CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM(Company),'#',TRIM(CustomerNum))))) AS CustomerID
	--CONVERT([binary](32),HASHBYTES('SHA2_256',CONCAT(Company,'#',TRIM(CustomerNum)))) AS CustomerID
	,CONVERT([binary](32),HASHBYTES('SHA2_256',[Company])) AS CompanyID
	,CONCAT([Company],'#',TRIM([CustomerNum])) AS CustomerCode
	,PartitionKey

	,Company
	,TRIM(CustomerNum) AS [CustomerNum]
	--,'' AS MainCustomerName
    ,[dbo].[ProperCase](CustomerName) AS CustomerName
	,[AddressLine1]
	,[AddressLine2]
	,[AddressLine3]
	,[TelephoneNumber1]	AS [TelephoneNum1]	
	,[TelephoneNumber2]	AS [TelephoneNum2]	
	,[Email]
	,[ZIP] AS [ZipCode]
	,CASE WHEN [City] = ' '	AND LEFT(AddressLine3, 1) IN ('1','2','3','4','5','6','7','8','9') THEN trim(substring(replace([dbo].[ProperCase](AddressLine3),' ',		''), 6, 100)) ELSE [dbo].[ProperCase]([City]) end AS [City]
	,IIF([State]= ' ',null,[State]) AS [State]
	,[District]	AS SalesDistrict
	,IIF(TRIM(CountryName) = '' OR TRIM(CountryName) IS NULL, 'FI', TRIM(CountryCode)) AS CountryCode
	,IIF(TRIM(CountryName) = '' OR TRIM(CountryName) IS NULL, 'Finland', TRIM(CountryName)) AS [CountryName]
	--,'' AS Division
	--,'' AS CustomerIndustry
	--,'' AS CustomerSubIndustry
	,[AddressLine1] AS [AddressLine]
	,CONCAT(Countryname, + ',  ' + trim([City]), + ',  ' + TRIM([Zip]), + ',  ' + trim(addressline1)) AS [FullAddressLine]
	,[dbo].[ProperCase](CustomerGroup) AS [CustomerGroup]
	,[dbo].[ProperCase](CustomerGroup) AS [CustomerSubGroup]
	,[SalesRepCode]	AS SalesPersonCode
	,[dbo].[ProperCase](SalesPersonName) AS [SalesPersonName]
	--,'' AS [SalesPersonResponsible]
	,[VATRegNr]	AS VATNum
	,OrganizationNum
	,[AccountString]	AS AccountNum
	,[InternalExternal]
	,[ABCCode] AS [CustomerScore]
	,[CustomerType]

	,GETDATE() AS [ValidFrom]
	,DATEADD(year,1,GETDATE()) AS [ValidTo]
FROM [stage].[SCM_FI_Customer]
GROUP BY
	PartitionKey, Company, CustomerNum, CustomerName, [AddressLine1], [AddressLine2], [AddressLine3], [TelephoneNumber1], [TelephoneNumber2], [Email], [ZIP], [City], [State], [District], CountryName, CountryCode, CustomerGroup, [SalesRepCode], SalesPersonName, [VATRegNr], OrganizationNum, [AccountString], [InternalExternal], [ABCCode], [CustomerType] --CustomerID, CompanyID, CustomerCode, 
GO
