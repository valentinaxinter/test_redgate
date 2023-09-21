IF OBJECT_ID('[stage].[vCER_DK_RLS]') IS NOT NULL
	DROP VIEW [stage].[vCER_DK_RLS];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO





CREATE VIEW [stage].[vCER_DK_RLS] AS

WITH base as (
SELECT UPPER(CONCAT('CDKCERT', '-', TRIM(Email),'-' + CustomerGroup ,'-' + AccountResponsible, '-' + [All])) AS EmailID
	,FORMAT(GETDATE(),'yyyy-MM-dd HH:mm:ss') AS PartitionKey
	,'CDKCERT' AS Company
	,[Email]
	,[Name]
	,COALESCE(CustomerGroup, '') AS CustomerGroup
	,COALESCE(AccountResponsible,'') AS AccountResponsible
	,[All]
FROM [stage].[CER_DK_RLS]
  
)

SELECT 
	EmailID
	,PartitionKey
	,Company
	,[Email]
	,value AS [Name]
	,'Account Responsible'	AS RLSType
	FROM base
	CROSS APPLY STRING_SPLIT(AccountResponsible, ';') 
	Where AccountResponsible <> ''

UNION ALL
SELECT 
	EmailID
	,PartitionKey
	,Company
	,[Email]
	,value AS [Name]
	,'CustomerGroup'	AS RLSType
	FROM base
	CROSS APPLY STRING_SPLIT(CustomerGroup, ';') 
	Where CustomerGroup <> ''

UNION ALL
SELECT 
	EmailID
	,PartitionKey
	,Company
	,[Email]
	,'ALL' AS [Name]
	,'All'	AS RLSType
	FROM base
	Where [All] = 1
GO
