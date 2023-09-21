IF OBJECT_ID('[stage].[vMEN_NL_Customer]') IS NOT NULL
	DROP VIEW [stage].[vMEN_NL_Customer];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [stage].[vMEN_NL_Customer] AS
WITH CTE AS (
-- A 
SELECT [CompanyCode], [PartitionKey], [Company], [CustomerNum], [CustomerName], [AddressLine1], [AddressLine2], [AddressLine3], [ABCCode], [City], [ZIP], [State], [CountryName], [CustomerCountryCode], [CustomerGroup], [SalesRepCode], [VATRegNr], [AccountString], [District], [InternalExternal], [SalesPersonName], [DebiteurKey], [DW_TimeStamp], [InterCompanyIdentifier], [OrganizationNum], [rownum]
FROM (
SELECT CASE WHEN Company = '14' THEN  CONCAT(N'MENBE',Company) 
			ELSE  CONCAT(N'MENNL',Company) END AS CompanyCode		
	  ,[PartitionKey], [Company], [CustomerNum], [CustomerName], [AddressLine1], [AddressLine2], [AddressLine3], [ABCCode], [City], [ZIP], [State], [CountryName], [CustomerCountryCode], [CustomerGroup], [SalesRepCode], [VATRegNr], [AccountString], [District], [InternalExternal], [SalesPersonName], [DebiteurKey], [DW_TimeStamp], [InterCompanyIdentifier], [OrganizationNum]
	  ,ROW_NUMBER() OVER (PARTITION BY Company, DebiteurKey ORDER BY Countryname DESC) AS rownum
  FROM [stage].[MEN_NL_Customer]
  ) tmp WHERE  rownum = 1
)


SELECT 
--NO NEED TO USED THE UPPER() IN CustomerID. Data from source could be the same CustomerNum but diferent product. the ERP is not case sensitive.
	CONVERT([binary](32),HASHBYTES('SHA2_256',CONCAT(CompanyCode,'#',CustomerNum))) AS CustomerID
	,CONCAT(CompanyCode,'#',CustomerNum) AS CustomerCode
	,CONVERT([binary](32),HASHBYTES('SHA2_256',CompanyCode)) AS CompanyID
	,CTE.PartitionKey

	,CompanyCode AS Company
	,[CustomerNum]
	,[dbo].[ProperCase](CustomerName) MainCustomerName
    ,[dbo].[ProperCase](CustomerName) AS CustomerName
	,LEFT([AddressLine1], 100) AS [AddressLine1]
	,LEFT([AddressLine2], 100) AS [AddressLine2]
	,LEFT([AddressLine3], 100) AS [AddressLine3]
	--,NULL			AS TelephoneNum1
	--,NULL			AS TelephoneNum2
	--,NULL			AS [Email]
	,ZIP			AS [ZipCode]
	,[dbo].[ProperCase]([City]) AS	City
	,IIF(trim([State])= '',null,[State]) AS [State]
	,[District]		AS SalesDistrict
	,COALESCE(cc1.Countryname, cc2.Countryname) AS [CountryName]
	--,NULL AS Division
	--,NULL AS CustomerIndustry
	--,NULL AS CustomerSubIndustry
	,[AddressLine1] AS [AddressLine]
	,CONCAT(COALESCE(cc1.Countryname, cc2.Countryname), ', ' + trim([City]),  ', ' + TRIM([Zip]),', ' + trim(addressline1)) AS [FullAddressLine]
	,[dbo].[ProperCase](CustomerGroup) AS [CustomerGroup]
	--,NULL AS [CustomerSubGroup]
	,SalesRepCode	AS [SalesPersonCode]
	,[SalesPersonName]
	--,NULL AS [SalesPersonResponsible]
	,VATRegNr AS  [VATNum]
	--,'' AS OrganizationNum
	,AccountString AS  [AccountNum]
	,cast(CTE.InternalExternal as nvarchar(40)) AS [InternalExternal]
	,ABCCode AS [CustomerScore]
	--,NULL AS [CustomerType]

	--,NULL AS [ValidFrom]
	--,NULL AS [ValidTo]
	,Upper(CTE.CustomerCountryCode) as CountryCode
FROM CTE
LEFT JOIN (SELECT DISTINCT CountryCode, ISOCountryCode 
		FROM stage.MEN_NL_countrycode_map) AS cmp ON cmp.CountryCode = CTE.CustomerCountryCode 
LEFT JOIN dbo.CountryCodes AS cc1 ON cc1.[Alpha-2 code] = cmp.ISOCountryCode
LEFT JOIN dbo.CountryCodes AS cc2 ON cc2.[Alpha-2 code] = cmp.CountryCode
GO
