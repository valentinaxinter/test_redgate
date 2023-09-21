IF OBJECT_ID('[prestage].[TRA_FR_Customer_Load]') IS NOT NULL
	DROP PROCEDURE [prestage].[TRA_FR_Customer_Load];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [prestage].[TRA_FR_Customer_Load] AS
BEGIN

Truncate table stage.[TRA_FR_Customer]

INSERT INTO 
	stage.TRA_FR_Customer 
	(PartitionKey, Company, CustomerNum, [MainCustomerName], CustomerName, AddressLine1, AddressLine2, AddressLine3, TelephoneNum1, [TelephoneNum2], Email, City, ZipCode, [State], [SalesDistrict], CountryCode, CountryName, Division, CustomerIndustry, CustomerSubIndustry, CustomerGroup, CustomerSubGroup, SalesPersonCode, SalesPersonName, SalesPersonResponsible, [VATNum], AccountNum, InternalExternal, CustomerScore, CustomerType, CRes1, CRes2, CRes3)
SELECT 
	PartitionKey, Company, CustomerNum, [MainCustomerName], CustomerName, AddressLine1, AddressLine2, AddressLine3, TelephoneNum1, [TelephoneNum2], Email, City, ZipCode, [State], [SalesDistrict], CountryCode, CountryName, Division, CustomerIndustry, CustomerSubIndustry, CustomerGroup, CustomerSubGroup, SalesPersonCode, SalesPersonName, SalesPersonResponsible, [VATNum], AccountNum, InternalExternal, CustomerScore, CustomerType, CRes1, CRes2, CRes3
FROM 
	[prestage].[vTRA_FR_Customer]

--Truncate table prestage.[TRA_FR_Customer]

End
GO
