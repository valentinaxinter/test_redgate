IF OBJECT_ID('[dm_ALL].[dimDepartment]') IS NOT NULL
	DROP VIEW [dm_ALL].[dimDepartment];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dm_ALL].[dimDepartment] as

select 
	
[DepartmentID]
, CompanyID
,[Company]
,[DepartmentCode]
,[DepartmentName]
,[DepartmentSite]
,[Address]
,[ZipCode]
,[City]
,[State]
,[CountryCode]
,[CountryName]
,[DepartmentType]
,[DepartmentDescription]
,[DptRes1]
,[DptRes2]
,[DptRes3]
from dm.dimDepartment
GO
