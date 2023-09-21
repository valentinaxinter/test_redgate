IF OBJECT_ID('[stage].[vSKS_FI_Customer]') IS NOT NULL
	DROP VIEW [stage].[vSKS_FI_Customer];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

--select distinct CustomerNum from [stage].[vSKS_FI_Customer] order by 1 desc


CREATE VIEW [stage].[vSKS_FI_Customer] AS
--COMMENT EMPTY FIELDS // ADD UPPER() TRIM() INTO CustomerID 2022-12-16 VA
SELECT 
	CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM([COMPANY]),'#',TRIM([CUSTNUM]),'#',TRIM([VKORG]))))) AS CustomerID
	--CONVERT([binary](32),HASHBYTES('SHA2_256',CONCAT([COMPANY],'#',TRIM([CUSTNUM]),'#',TRIM([VKORG])))) AS CustomerID
	,CONVERT([binary](32),HASHBYTES('SHA2_256',[COMPANY])) AS CompanyID
	,CONCAT([COMPANY],'#',TRIM([CUSTNUM])) AS CustomerCode
	,PartitionKey

	--,CASE WHEN COMPANY = 'SKSSWE' THEN 'JSESKSSW' ELSE COMPANY END AS Company 
	,Company
	,IIF(ISNUMERIC(CUSTNUM) = 1,CAST(CAST(trim(CUSTNUM) AS int)as nvarchar(50)),(trim(CUSTNUM))) AS CustomerNum
	,[dbo].[ProperCase](CustomerName) AS MainCustomerName --add according to taskCard
    ,[dbo].[ProperCase](CustomerName) AS CustomerName -- can be replaced by if there is sub- Customer name
	,[AddressLine1]
	,[AddressLine2]
	,[AddressLine3]
	,[TELEPHONE1] AS TelephoneNum1
	,[TELEPHONE2] AS TelephoneNum2
	,[EMAIL] AS Email
	,[ZIP] AS ZipCode
	,IIF([CITY]= ' ',null,[dbo].[ProperCase]([CITY])) AS [City]
	,IIF([STATE]= ' ',null,[STATE]) AS [State]
	,DISTRICT AS SalesDistrict
	,[dbo].[ProperCase]([COUNTRYNAME]) AS CountryName
	,DIVISION AS Division
	--,'' AS CustomerIndustry
	--,'' AS CustomerSubIndustry
	,[dbo].[ProperCase](TRIM(CONCAT([ADDRESSLINE1],' ','--'))) AS AddressLine
	,CONCAT(TRIM(CountryName), ', ', TRIM(CITY), ', ', TRIM(ZIP), ', ', TRIM(ADDRESSLINE1) ) AS FullAddressLine
	,[dbo].[ProperCase]([CUSTOMERGROUPTEXT]) AS CustomerGroup
	,[dbo].[ProperCase]([CUSTOMERGROUP]) AS CustomerSubGroup
	,[SALESREPCODE] AS SalespersonCode
	,[dbo].[ProperCase]([SALESPERSON]) AS SalesPersonName
	,SALESPERSONRESPONSIBLE AS SalesPersonResponsible
	,TRIM([VATREGNR]) AS VATNum
	--,'' AS OrganizationNum
	,ACCOUNTSTRING AS AccountNum
	,INTERNALEXTERNAL AS InternalExternal
	,[ABCCODE] AS CustomerScore
	,CUSTOMERTYPE AS CustomerType
	,GETDATE() AS ValidFrom
	,DATEADD(year,1,GETDATE()) AS ValidTo
	, INTCA AS CountryCode
FROM 
	[stage].[SKS_FI_Customer]
WHERE 
	VKORG NOT IN ('FI00','SE10')
GO
