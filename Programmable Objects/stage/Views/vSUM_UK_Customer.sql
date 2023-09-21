IF OBJECT_ID('[stage].[vSUM_UK_Customer]') IS NOT NULL
	DROP VIEW [stage].[vSUM_UK_Customer];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [stage].[vSUM_UK_Customer] AS 
SELECT 
	PartitionKey,
	CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(TRIM(dbo.summers())))) AS CompanyID,
	CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM(dbo.summers()),'#',TRIM(CustomerNum))))) AS CustomerID,
	UPPER(TRIM(dbo.summers())) as Company,
	CustomerNum,
	MainCustomerName,
	CustomerName,
	AddressLine1,
	AddressLine2,
	AddressLine3,
	TelephoneNumber1,
	PHONE2,
	ZipCode,
	CITY,
	STATE,
	CCode,
	TRIM(CountryName) as CountryName,
	Division,
	CustomerIndustry,
	CustomerSubIndustry,
	CustomerGroup,
	CustomerSubGroup,
	nullif(trim(SalesRepCode),'') as SalesRepCode,
	VATRegNo

FROM 
	 stage.SUM_UK_Customer
GO
