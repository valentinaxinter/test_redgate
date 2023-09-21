IF OBJECT_ID('[stage].[vPAS_PL_Customer]') IS NOT NULL
	DROP VIEW [stage].[vPAS_PL_Customer];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [stage].[vPAS_PL_Customer] AS
--COMMENT EMPTY FIELDS // ADD TRIM()UPPER() INTO CustomerID 23-01-05 VA
SELECT 
	CONVERT([binary](32), HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM(Company), '#', TRIM(CustomerNum))))) AS CustomerID
--	CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT(Company, '#', TRIM(UPPER(CustomerNum))))) AS CustomerID
	,CONVERT([binary](32), HASHBYTES('SHA2_256',Company)) AS CompanyID --
	,CONCAT(Company, '#', TRIM(UPPER([CustomerNum]))) AS CustomerCode
	,PartitionKey

	,[company] AS Company
	,TRIM(UPPER([customernum])) AS [CustomerNum]
	,LEFT([customercode], 100) AS MainCustomerName
	,LEFT([customername], 100) AS [CustomerName]
	,[addressline1] AS [AddressLine1]
	,[addressline2] AS [AddressLine2]
	,[addressline3] AS [AddressLine3]
	,[telephonenum1] AS [TelephoneNum1]
	,[telephonenum2] AS [TelephoneNum2]
	,[email] AS [Email]
	,[zipcode] AS [ZipCode]
	,CASE WHEN [city] = ' '	AND LEFT(addressline3, 1) IN ('1','2','3','4','5','6','7','8','9') THEN trim(substring(replace(addressline3,' ', ''), 6, 100)) ELSE [city] end AS [City]
	,IIF([state]= ' ',null,[state]) AS [State]
	,[district] AS SalesDistrict
	,IIF(TRIM(countryname) like '%Polska%', 'PL', TRIM(countrycode)) AS CountryCode
	,TRIM(countryname) AS [CountryName]
	--,'' AS Division
	--,'' AS CustomerIndustry
	--,'' AS CustomerSubIndustry
	,TRIM(CONCAT (addressline1 + ' ' + addressline2, null)) AS [AddressLine]
	,CONCAT(TRIM(countryname), + ', ' + TRIM([city]), + ', ' + TRIM([zipcode]), + ', ' + trim(addressline1)) AS [FullAddressLine]
	,(customergroup) AS [CustomerGroup]
	,(customersubgroup) AS [CustomerSubGroup]
	,[salesrepcode] AS SalesPersonCode
	,(salespersonname) AS [SalesPersonName]
	,[salespersonresponsible] AS [SalesPersonResponsible]
	,[vatregnr] AS VATNum
	--,'' AS OrganizationNum
	,[accountstring] AS AccountNum
	,[internalexternal]
	,[customerabc] AS CustomerScore
	,[customertype] AS [CustomerType]

FROM [stage].[PAS_PL_Customer]
GO
