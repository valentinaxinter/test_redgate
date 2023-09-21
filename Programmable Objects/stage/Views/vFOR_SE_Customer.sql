IF OBJECT_ID('[stage].[vFOR_SE_Customer]') IS NOT NULL
	DROP VIEW [stage].[vFOR_SE_Customer];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE view [stage].[vFOR_SE_Customer] AS
--COMMEN EMPTY FIELDS 2022-12-20 VA
SELECT 
	CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM(Company), '#', TRIM(CustomerNum))))) AS CustomerID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(TRIM([Company])))) AS CompanyID
	,UPPER(CONCAT(TRIM([Company]), '#', TRIM([CustomerNum]))) AS CustomerCode
	,PartitionKey

	,UPPER(Company) AS Company
    ,UPPER(TRIM(CustomerNum)) AS CustomerNum
	--,'' AS MainCustomerName
    ,[dbo].[ProperCase](CustomerName) AS CustomerName
    ,[AddressLine1]
    ,[AddressLine2]
    ,[AddressLine3]
	--,'' AS [TelephoneNum1]
	--,'' AS [TelephoneNum2]
	--,'' AS [Email]
	,[ZIP] AS ZipCode
    ,IIF([City]= ' ',null,[dbo].[ProperCase]([City])) AS [City]    
    ,IIF([State]= ' ',null,[State]) AS [State]
	,[District]	AS SalesDistrict
	,IIF(CountryName IS null OR CountryName = '', 'SE', CountryCode) AS CountryCode
    ,IIF(CountryName IS null OR CountryName = '', 'Sweden', CountryName) AS CountryName
	--,'' AS Division
	--,'' AS CustomerIndustry
	--,'' AS CustomerSubIndustry
	,[dbo].[ProperCase](TRIM(CONCAT(AddressLine1,' ',AddressLine2))) as AddressLine
	,[dbo].[ProperCase](concat_ws(',',coalesce(CountryName,null),coalesce(IIF([State]= ' ',null,[State]),IIF(City= ' ',null,City),IIF(ZIP= ' ',null,ZIP)),IIF([AddressLine3]=' ',null, [AddressLine3])
		,coalesce(IIF([addressline1]= ' ',null,[addressline1]),IIF([addressline2]= ' ',null,[addressline2]))
		,coalesce(IIF([addressline2]= ' ',null,[addressline2]),IIF([addressline3]= ' ',null,[addressline3])))) AS FullAddressLine
    ,[dbo].[ProperCase](CustomerGroup) AS CustomerGroup
	,[dbo].[ProperCase](CustomerGroup) AS CustomerSubGroup
	,[SalesRepCode] AS SalesPersonCode
    ,[dbo].[ProperCase](SalesPersonName) AS SalesPersonName
	--,'' AS [SalesPersonResponsible]
    ,TRIM([VATRegNr]) AS [VATNum]
	,OrganisationNum AS OrganizationNum
	,[AccountString] AS AccountNum
	,iif([InternalExternal] = 'True', 'Internal', 'External') as InternalExternal
	,[ABCCode] AS CustomerScore
	--,'' AS CustomerType


  FROM [stage].[FOR_SE_Customer]
  GROUP BY [Company], [CustomerNum], [PartitionKey], [CustomerNum],  [CustomerName],[AddressLine1], [AddressLine2] ,[AddressLine3], [ZIP], [City], [State], [District], CountryCode, CountryName,CustomerGroup, [SalesRepCode], SalesPersonName, [VATRegNr], [AccountString], [InternalExternal], [ABCCode], OrganisationNum
GO
