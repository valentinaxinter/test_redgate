IF OBJECT_ID('[stage].[vOCS_SE_Customer]') IS NOT NULL
	DROP VIEW [stage].[vOCS_SE_Customer];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [stage].[vOCS_SE_Customer] AS
--COMMENT EMPTY FIELDS // ADD UPPER()TRIM() INTO CustomerID 2022-12-21 VA
SELECT 
	CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM(Company), '#', TRIM(CustomerNum))))) AS CustomerID
--	CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT(Company, '#', TRIM(CustomerNum)))) AS CustomerID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', Company)) AS CompanyID
	,CONCAT(Company, '#', TRIM([CustomerNum])) AS CustomerCode
	,PartitionKey

	,Company
	,TRIM(CustomerNum) AS [CustomerNum]
	,MainCustomerName
    ,[dbo].[ProperCase](CustomerName) AS CustomerName
	,LEFT([AddressLine1], 100) AS [AddressLine1]
	,LEFT([AddressLine2], 100) AS [AddressLine2]
	,LEFT([AddressLine3], 100) AS [AddressLine3]
	,[TelephoneNumber1] AS [TelephoneNum1]
	--,'' AS [TelephoneNum2]
	,[Email]
	,[ZipCode]
	,CASE WHEN [City] = ' '	AND LEFT(AddressLine3, 1) IN ('1','2','3','4','5','6','7','8','9') THEN trim(substring(replace([dbo].[ProperCase](AddressLine3),' ', ''), 6, 100)) ELSE [dbo].[ProperCase]([City]) end AS [City]
	,[State]
	,[District] AS SalesDistrict
	,case when len(TRIM(customer.[CountryCode])) = 3 then cc.[Alpha-2 code]
	 else isnull(nullif(TRIM(customer.CountryCode),''),'SE')
	 end as CountryCode
	,[dbo].[ProperCase](customer.[CountryName]) AS [CountryName]
	,Division
	,CustomerIndustry
	,CustomerSubIndustry
	,[AddressLine3] AS [AddressLine]
	,CONCAT([dbo].[ProperCase](TRIM(customer.[CountryName])), + ',  ' + [dbo].[ProperCase](TRIM([City])), + ',  ' + TRIM([ZipCode]), + ',  ' + trim(addressline3)) AS [FullAddressLine]
	,[CustomerGroup] -- Belongs to Gr3
	,[CustomerSubGroup] -- SellerID
	,[SalesRepCode] AS SalesPersonCode
	,[dbo].[ProperCase](SalesPersonName) AS [SalesPersonName]
	,[SalesPersonResponsible]
	,NULLIF(TRIM([VATRegNo]),'') AS [VATNum]
	--,'' AS OrganizationNum
	--,'' [AccountNum] 
	--,'' [InternalExternal]
	,Res1_SellerCode AS [CustomerScore]
	,Res2_SalesChannel AS [CustomerType]
FROM [stage].[OCS_SE_Customer] as customer
	LEFT JOIN dbo.CountryCodes as cc
		on customer.CountryCode = cc.[Alpha-2 code]
GO
