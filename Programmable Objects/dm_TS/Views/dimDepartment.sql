IF OBJECT_ID('[dm_TS].[dimDepartment]') IS NOT NULL
	DROP VIEW [dm_TS].[dimDepartment];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


create view [dm_TS].[dimDepartment] as

select 
dpt.[DepartmentID]
,dpt.CompanyID
,dpt.[Company]
,dpt.[DepartmentCode]
,dpt.[DepartmentName]
,dpt.[DepartmentSite]
,dpt.[Address]
,dpt.[ZipCode]
,dpt.[City]
,dpt.[State]
,dpt.[CountryCode]
,dpt.[CountryName]
,dpt.[DepartmentType]
,dpt.[DepartmentDescription]
,dpt.[DptRes1]
,dpt.[DptRes2]
,dpt.[DptRes3]
from dm.dimDepartment as dpt
LEFT JOIN DBO.Company as company
	on dpt.Company = company.Company
WHERE company.BusinessArea = 'Transport Solutions' AND company.[Status] = 'Active';
GO
