IF OBJECT_ID('[dm_AX].[dimCostBearer]') IS NOT NULL
	DROP VIEW [dm_AX].[dimCostBearer];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE VIEW [dm_AX].[dimCostBearer] AS 

SELECT  [CostBearerID]
,[PartitionKey]
,[CostBearerCode]
,[CompanyID]
,[Company]
,[CostBearerNum]
,[CostBearerName]
,[CostBearerStatus]
,[CostBearerGroup]
,[CostBearerGroup2]
,[CostBearerGroup3]
FROM [dm].[DimCostBearer]
WHERE [Company] in ('AXISE','AXHSE') -- HQ basket
GO
