IF OBJECT_ID('[stage].[vABK_SE_RLS]') IS NOT NULL
	DROP VIEW [stage].[vABK_SE_RLS];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO






CREATE VIEW [stage].[vABK_SE_RLS] AS

WITH base as (
SELECT UPPER(CONCAT('ABKSE', '-', TRIM(Email),'-' + SalesPersonName , '-' + [All])) AS EmailID
	,FORMAT(GETDATE(),'yyyy-MM-dd hh:mm:ss') AS PartitionKey
	,'ABKSE' AS Company
	,[Email]
	,[Name]
	,SalesPersonName
	,[All]
	
FROM [stage].[ABK_SE_RLS]
  
)

SELECT 
	EmailID
	,PartitionKey
	,Company
	,[Email]
	,SalesPersonName AS [Name]
	,'SalesPersonName'	AS RLSType
	FROM base
	Where SalesPersonName IS NOT NULL

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
