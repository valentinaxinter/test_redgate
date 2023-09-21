IF OBJECT_ID('[stage].[vMEN_NL_Department]') IS NOT NULL
	DROP VIEW [stage].[vMEN_NL_Department];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [stage].[vMEN_NL_Department] AS
WITH CTE AS (
SELECT CASE WHEN Company = '14' THEN  CONCAT(N'MENBE',Company)
			ELSE  CONCAT(N'MENNL',Company) END AS CompanyCode		--Doing this to have the company code in nvarchar and don't need to repeat CAST(CONCAT('MEN-',Company) AS nvarchar(50)) everywhere /SM
	  ,[PartitionKey], [Company], [Department], [DepartmentText], [DW_TimeStamp]
  FROM stage.MEN_NL_Department
)


SELECT 
	  CONVERT([binary](32),HASHBYTES('SHA2_256',CONCAT(CompanyCode,'#',trim(Department)))) AS DepartmentID
	  ,CONVERT([binary](32),HASHBYTES('SHA2_256',CompanyCode)) AS CompanyID
	  ,[PartitionKey]
      ,[CompanyCode] AS Company
	  ,Department as DepartmentCode
	  ,DepartmentText as DepartmentName
	  --,DW_TimeStamp
  FROM CTE
GO
