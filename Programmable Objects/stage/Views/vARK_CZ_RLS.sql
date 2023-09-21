IF OBJECT_ID('[stage].[vARK_CZ_RLS]') IS NOT NULL
	DROP VIEW [stage].[vARK_CZ_RLS];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO









CREATE VIEW [stage].[vARK_CZ_RLS] AS

WITH base as (
SELECT UPPER(CONCAT('ACZARKOV', '-', TRIM(email))) AS EmailID
	,PartitionKey
	,'ACZARKOV' AS Company
	,email AS [Email]
	,LEFT(email, CHARINDEX('@', email) - 1) AS [Name]
	,COALESCE(Branch, '') AS Branch
	,COALESCE(Account,'') AS Account
	,COALESCE(Manager,'') AS Manager
FROM [stage].[ARK_CZ_RLS]
  
)

--  Testing out new logic for RLS Arkov to handle multiple RLS conditions for one user

SELECT 
	EmailID
	,PartitionKey
	,Company
	,[Email]
	,value AS [Name]
	,'Branch'	AS RLSType
	FROM base
	CROSS APPLY STRING_SPLIT([Branch], ';') 
	Where [Branch] <> ''

UNION ALL
SELECT 
	EmailID
	,PartitionKey
	,Company
	,[Email]
	,value AS [Name]
	,'Account'	AS RLSType
	FROM base
	CROSS APPLY STRING_SPLIT([Account], ';') 
	Where [Account] <> ''

UNION ALL
SELECT 
	EmailID
	,PartitionKey
	,Company
	,[Email]
	,value AS [Name]
	,'Manager'	AS RLSType
	FROM base
	CROSS APPLY STRING_SPLIT([Manager], ';') 
	Where [Manager] <> ''

UNION ALL
SELECT 
	EmailID
	,PartitionKey
	,Company
	,[Email]
	,'ALL' AS [Name]
	,'All'	AS RLSType
	FROM base
	Where [Branch] = ''  AND [Account] = '' AND [Manager] = ''
GO
