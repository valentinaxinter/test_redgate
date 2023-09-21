IF OBJECT_ID('[stage].[vNOM_SE_Customer]') IS NOT NULL
	DROP VIEW [stage].[vNOM_SE_Customer];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [stage].[vNOM_SE_Customer] AS
--COMMENT EMPTY FIELDS 2022-12-20 VA
SELECT 
	CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM(Company),'#',TRIM(CustomerNum))))) AS CustomerID
    ,CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(TRIM([Company])))) AS CompanyID
	,UPPER(CONCAT([Company],'#',TRIM([CustomerNum]))) AS CustomerCode
	
	,PartitionKey
	,UPPER(TRIM(Company)) AS Company
    ,UPPER(TRIM(CustomerNum)) AS CustomerNum
	,MainCustomerName
    ,[dbo].[ProperCase](CustomerName) AS CustomerName
    ,[AddressLine1]
    ,[AddressLine2]
    ,[AddressLine3]
	--,'' AS [TelephoneNum1]
	--,'' AS [TelephoneNum2]
	--,'' AS [Email]
	,[ZIP] AS ZipCode
    ,IIF([City]= ' ',NULL,[dbo].[ProperCase]([City])) AS [City]    
    ,IIF([State]= ' ',NULL,[State]) AS [State]
	,[District]	AS SalesDistrict
	,TRIM(CountryCode) AS CountryCode
    ,[dbo].[ProperCase](CountryName) AS CountryName
	--,'' AS Division
	--,'' AS CustomerIndustry
	--,'' AS CustomerSubIndustry
	,[dbo].[ProperCase](TRIM(CONCAT(AddressLine1,' ',AddressLine2))) as AddressLine
	,[dbo].[ProperCase](concat_ws(',',coalesce(TRIM(CountryName),null),coalesce(IIF([State]= ' ',null,TRIM([State])),IIF(City= ' ',null,TRIM(City)),IIF(ZIP= ' ',null,TRIM(ZIP))),IIF([AddressLine3]=' ',null, TRIM([AddressLine3]))
		,coalesce(IIF([addressline1]= ' ',null,TRIM([addressline1])),IIF([addressline2]= ' ',null,TRIM([addressline2])))
		,coalesce(IIF([addressline2]= ' ',null,TRIM([addressline2])),IIF([addressline3]= ' ',null,TRIM([addressline3]))))) AS FullAddressLine
    ,[dbo].[ProperCase](CustomerMainGroup) AS CustomerGroup
	,[dbo].[ProperCase](CustomerGroup) AS CustomerSubGroup
	,[SalesRepCode] AS SalesPersonCode
    ,[dbo].[ProperCase](SalesPersonName) AS SalesPersonName
	--,'' AS [SalesPersonResponsible]
    ,TRIM([VATRegNr]) AS [VATNum]
	,OrganizationNum
	,[AccountString] AS AccountNum
	,[InternalExternal]
	,[ABCCode] AS CustomerScore
	--,'' AS CustomerType
	,GETDATE() AS ValidFrom
	,DATEADD(year,1,GETDATE()) AS ValidTo
FROM [stage].[NOM_SE_Customer]
GO
