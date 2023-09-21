IF OBJECT_ID('[stage].[vABK_SE_Customer]') IS NOT NULL
	DROP VIEW [stage].[vABK_SE_Customer];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [stage].[vABK_SE_Customer] AS
--COMMENT EMPTY FIELDS 2022-12-21 VA
SELECT 
	CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM(Company), '#', TRIM(CustomerNum))))) AS CustomerID
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
	,[DistrictNm] AS SalesDistrict
	,IIF([CountryName] = '' OR [CountryName] IS NULL, 'SE', [CountryCode]) AS [CountryCode]
	,[dbo].[ProperCase]([CountryName]) AS [CountryName]
	,Division
	,CustomerIndustry
	,CustomerSubIndustry
	,[AddressLine3] AS [AddressLine]
	,CONCAT([dbo].[ProperCase](TRIM([CountryName])), + ',  ' + [dbo].[ProperCase](TRIM([City])), + ',  ' + TRIM([ZipCode]), + ',  ' + trim(addressline3)) AS [FullAddressLine]
	,[CustomerGroup] -- Belongs to Gr3
	,[CustomerSubGroup] -- SellerID
	,[SalesRepCode] AS SalesPersonCode
	,[dbo].[ProperCase](SalesPersonName) AS [SalesPersonName]
	,[SalesPersonResponsible]
	,[VATRegNo] AS [VATNum]
	,OrganizationNum
	--,''	AS [AccountNum] 
	,IIF(SalesPersonName = 'Koncernföretag', 'I', 'E') AS [InternalExternal]
	,[CustomerSubGroup] AS [CustomerScore]
	,CDelTrmNm AS [CustomerType]

FROM [stage].[ABK_SE_Customer]
GO
