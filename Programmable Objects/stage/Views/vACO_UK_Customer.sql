IF OBJECT_ID('[stage].[vACO_UK_Customer]') IS NOT NULL
	DROP VIEW [stage].[vACO_UK_Customer];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [stage].[vACO_UK_Customer] AS
-- ADD UPPER()/ TRIM(COMPANY) INTO CustomerID 12-13-2022 VA
SELECT 
	CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM(Company),'#',TRIM(CustomerNum))))) as CustomerID
	,CONVERT([binary](32),HASHBYTES('SHA2_256',Company)) AS CompanyID
	,CONCAT(Company,'#',TRIM([CustomerNum])) AS CustomerCode
	,PartitionKey

	,Company
	,TRIM(CustomerNum) AS [CustomerNum]
	,MainCustomerName
    ,dbo.ProperCase(CustomerName) AS CustomerName
	,LEFT([AddressLine1], 50) AS [AddressLine1]
	,LEFT([AddressLine2], 50) AS [AddressLine2]
	,LEFT([AddressLine3], 50) AS [AddressLine3]
	,[TelephoneNumber1]	AS [TelephoneNum1]
	,[PHONE2] AS [TelephoneNum2]
	,[Email]
	,[ZipCode]
	,CASE WHEN [City] = ' '	AND LEFT(AddressLine3, 1) IN ('1','2','3','4','5','6','7','8','9') THEN trim(substring(replace((AddressLine3),' ',		''), 6, 100)) ELSE ([City]) end AS [City]
	,IIF([State]= ' ',null,[State]) AS [State]
	,[District]	AS SalesDistrict
	--,CCode AS [CountryCode]
	,CASE 
		WHEN LEN(TRIM(CCode)) = 3 THEN (SELECT [Alpha-2 code] FROM DBO.CountryCodes WHERE [Alpha-3 code] = TRIM(dbo.ProperCase(CountryName)))
		ELSE NULLIF(TRIM(CCode),'')
	END as CountryCode
	,dbo.ProperCase(trim(CountryName)) AS [CountryName]
	,Division
	,CustomerIndustry
	,CustomerSubIndustry
	,[AddressLine1] AS [AddressLine]
	,CONCAT(trim(dbo.ProperCase(Countryname)), + ', ' + trim([City]), + ', ' + TRIM([ZipCode]), + ', ' + trim(addressline1)) AS [FullAddressLine]
	,LEFT([CustomerGroup], charindex(' ', [CustomerGroup])-1)	AS [CustomerGroup]
	,dbo.ProperCase(CustomerGroup) AS [CustomerSubGroup]
	,[SalesRepCode]	AS SalesPersonCode
	,dbo.ProperCase(SalesPersonName) AS [SalesPersonName]
	,[SalesPersonResponsible]
	,[VATRegNo] AS [VATNum]
	--,'' AS OrganizationNum
	,[AccountString]	AS AccountNum
	,[InternalExternal]
	,[CustomerType]
	,[CustomerABC]		AS CustomerScore
	,GETDATE() AS [ValidFrom]
	,DATEADD(year,1,GETDATE()) AS [ValidTo]


FROM [stage].[ACO_UK_Customer]
GO
