IF OBJECT_ID('[stage].[vCYE_ES_RLS]') IS NOT NULL
	DROP VIEW [stage].[vCYE_ES_RLS];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE VIEW [stage].[vCYE_ES_RLS] AS

--WITH base as (
SELECT UPPER(CONCAT('CyESA', '-', TRIM(Email),'-' + [Name])) AS EmailID --,'-' + SalesPersonName , '-' + [All]
	,FORMAT(GETDATE(),'yyyy-MM-dd hh:mm:ss') AS PartitionKey
	,'CyESA' AS Company
	,[Email]
	,[Name]
	,'Department'	AS [RLSType]
--	,SalesPersonName
--	,[All]
FROM [stage].[CYE_ES_RLS]
  
--)

--  Testing out new logic for RLS Arkov to handle multiple RLS conditions for one user

--SELECT 
--	EmailID
--	,PartitionKey
--	,Company
--	,[Email]
--	,[Name]
--	FROM base
--	Where [Name] IS NOT NULL

--UNION ALL
--SELECT 
--	EmailID
--	,PartitionKey
--	,Company
--	,[Email]
--	,[Name]

--	FROM base
----	Where [All] = 1
GO
