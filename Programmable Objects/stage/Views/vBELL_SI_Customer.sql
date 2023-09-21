IF OBJECT_ID('[stage].[vBELL_SI_Customer]') IS NOT NULL
	DROP VIEW [stage].[vBELL_SI_Customer];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [stage].[vBELL_SI_Customer] AS
--COMMENT EMPTY FIELDS // ADD UPPER() TRIM() INTO CustomerID 2022-12-27 VA
SELECT 
	--CONVERT([binary](32),HASHBYTES('SHA2_256',CONCAT(Company,'#',TRIM(CustomerNum)))) AS CustomerID
	CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM(Company),'#',TRIM(CustomerNum))))) AS CustomerID
	,CONVERT([binary](32),HASHBYTES('SHA2_256',[Company])) AS CompanyID
	,CONCAT([Company],'#',TRIM([CustomerNum])) AS CustomerCode
	,PartitionKey

	,Company
    ,TRIM(CustomerNum) AS CustomerNum
	,[dbo].[ProperCase](CustomerName) AS MainCustomerName --add according to taskCard
    ,[dbo].[ProperCase](CustomerName) AS CustomerName -- can be replaced by if there is sub- Customer name
    ,[AddressLine1]
    ,[AddressLine2]
    ,[AddressLine3]
	,[PhoneNo] AS [TelephoneNum1]
	--,'' AS [TelephoneNum2]
	,[Email]
	,[ZIP] AS ZipCode
    ,IIF([City]= ' ',null,[dbo].[ProperCase]([City])) AS [City]    
    ,IIF([State]= ' ',null,[State]) AS [State]
	,[District]	AS SalesDistrict
	--,'' AS CustomerIndustry
	--,'' AS CustomerSubIndustry
    ,[dbo].[ProperCase](CountryName) AS CountryName
	--,'' AS Division
	,[dbo].[ProperCase](TRIM(CONCAT(AddressLine1,' ',AddressLine2))) as AddressLine
	,[dbo].[ProperCase](concat_ws(',',coalesce(CountryName,null),coalesce(IIF([State]= ' ',null,[State]),IIF(City= ' ',null,City),IIF(ZIP= ' ',null,ZIP)),IIF([AddressLine3]=' ',null, [AddressLine3])
		,coalesce(IIF([addressline1]= ' ',null,[addressline1]),IIF([addressline2]= ' ',null,[addressline2]))
		,coalesce(IIF([addressline2]= ' ',null,[addressline2]),IIF([addressline3]= ' ',null,[addressline3])))) AS FullAddressLine
    ,CustomerGroup AS CustomerGroup
	,CustomerGroup AS CustomerSubGroup
	,[SalesRepCode]	AS SalesPersonCode
    ,[dbo].[ProperCase](SalesPerson) AS SalesPersonName
	--,'' AS [SalesPersonResponsible]
    ,TRIM([VATRegNr]) AS [VATNum]
	--,'' AS OrganizationNum
	,[AccountString]	AS AccountNum
	,[InternalExternal]
	,[ABCCode] AS CustomerScore
	--,'' AS CustomerType
	,GETDATE() AS ValidFrom
	,DATEADD(year,1,GETDATE()) AS ValidTo
	, State as CountryCode
  FROM [stage].[BELL_SI_Customer]
GO
