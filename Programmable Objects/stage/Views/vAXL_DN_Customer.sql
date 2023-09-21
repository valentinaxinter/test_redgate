IF OBJECT_ID('[stage].[vAXL_DN_Customer]') IS NOT NULL
	DROP VIEW [stage].[vAXL_DN_Customer];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE VIEW [stage].[vAXL_DN_Customer] AS

SELECT 
	CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(Company, '#', TRIM(CustomerNum))) )) AS CustomerID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER([Company]))) AS CompanyID
	,UPPER(CONCAT([Company], '#', TRIM([CustomerNum]))) AS CustomerCode
	,PartitionKey

	,UPPER(Company) AS Company
	,UPPER(TRIM(CustomerNum)) AS [CustomerNum]
	,TRIM(MainCustomerName) AS MainCustomerName
	,TRIM(CustomerName) AS  [CustomerName]
	,TRIM([AddressLine1]) AS [AddressLine1]
	,TRIM([AddressLine2]) AS [AddressLine2]
	,TRIM([AddressLine3]) AS [AddressLine3]
	,TRIM([TelephoneNumber1]) AS [TelephoneNum1]
	,TRIM([TelephoneNumber2]) AS [TelephoneNum2]
	,TRIM([Email]) AS [Email]
	,TRIM([ZipCode]) AS [ZipCode]
	,TRIM([City]) AS [City]
	,TRIM([State]) AS [State]
	,TRIM([District]) AS [SalesDistrict]
	,TRIM(con.CountryName) AS CountryName
	,TRIM([ISOAlpha2Code]) AS [CountryCode]
	,TRIM([Division]) AS [Division]
	,TRIM([CustomerIndustry]) AS [CustomerIndustry]
	,TRIM([CustomerSubIndustry]) AS [CustomerSubIndustry]
	,TRIM([AddressLine3]) AS [AddressLine]
	,CONCAT(TRIM(con.CountryName), + ',  ' + TRIM([City]), + ',  ' + TRIM([ZipCode]), + ',  ' + TRIM(addressline3)) AS [FullAddressLine]
	,TRIM(CustomerGroup) AS [CustomerGroup]
	,TRIM(CustomerGroup) AS [CustomerSubGroup]
	,TRIM([SalesRepCode]) AS [SalesPersonCode]
	,TRIM(SalesPersonName) AS [SalesPersonName]
	,TRIM([SalesPersonResponsible]) AS [SalesPersonResponsible]
	,TRIM([VATRegNo]) AS [VATNum]
	,TRIM([AccountString]) AS [AccountNum]
	,TRIM([InternalExternal]) AS [InternalExternal]
	,TRIM([CustomerABC]) AS [CustomerScore]
	,TRIM([CustomerType]) AS [CustomerType]
FROM [stage].[AXL_DN_Customer] com
	LEFT JOIN dbo.Country con ON com.CountryName = con.[ISOAlpha2Code]

--GROUP BY
--	PartitionKey, Company, CustomerNum, CustomerName, MainCustomerName, [AddressLine1], [AddressLine2], [AddressLine3], [TelephoneNumber1], [TelephoneNumber2], [Email], [ZipCode], [City], [State], [District], [CountryName], [Division], [CustomerIndustry], [CustomerSubIndustry], CustomerGroup, [SalesRepCode], SalesPersonName, [SalesPersonResponsible], [VATRegNo], [AccountString], [InternalExternal], [CustomerABC], [CustomerType]

--	Stagetablename in ('AXL_AU_Customer', 'AXL_DC_Customer', 'AXL_HU_Customer', 'AXL_IE_Customer', 'AXL_PL_Customer', 'AXL_PT_Customer', 'AXL_UK_Customer')
GO
