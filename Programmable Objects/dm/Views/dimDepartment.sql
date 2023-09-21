IF OBJECT_ID('[dm].[dimDepartment]') IS NOT NULL
	DROP VIEW [dm].[dimDepartment];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE view [dm].[dimDepartment] as

select 
	CONVERT(BIGINT, DepartmentID) AS DepartmentID
	,CONVERT(BIGINT, CompanyID) AS CompanyID
	, Company
	, DepartmentCode
	, DepartmentName
	, DepartmentSite
	, Address
	, ZipCode
	, City
	, State
	, CountryCode
	, CountryName
	, DepartmentType
	, DepartmentDescription
	, DptRes1
	, DptRes2
	, DptRes3
from dw.Department;
GO
