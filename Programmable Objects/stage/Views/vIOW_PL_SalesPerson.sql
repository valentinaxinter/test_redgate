IF OBJECT_ID('[stage].[vIOW_PL_SalesPerson]') IS NOT NULL
	DROP VIEW [stage].[vIOW_PL_SalesPerson];

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE VIEW [stage].[vIOW_PL_SalesPerson] AS

SELECT
	CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(Company, '#', (SalesPersonCode))))) AS SalesPersonID
	,UPPER(CONCAT(Company, '#', TRIM(SalesPersonCode))) AS SalesPersonCode
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(Company))) AS CompanyID
	,getdate() AS PartitionKey

	,TRIM(Company) AS Company
	,(SalesPersonCode) AS SalesPersonName
	,TRIM(RoleType) AS RoleType
	,TRIM(SalesDistrict) AS SalesDistrict
	,TRIM(SalesPersonResponsibleCode) AS SalesPersonResponsibleCode
	,TRIM(SalesPersonResponsibleName) AS SalesPersonResponsibleName
	,TRIM(CreatedTimeStamp) AS CreatedTimeStamp
	,TRIM(ModifiedTimeStamp) AS ModifiedTimeStamp
	,IsActiveRecord
	,STRes1
	,STRes2
	,STRes3
FROM [axbus].[IOW_PL_SalesPerson]
GO
