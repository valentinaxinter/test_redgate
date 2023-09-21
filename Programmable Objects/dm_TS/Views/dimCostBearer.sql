IF OBJECT_ID('[dm_TS].[dimCostBearer]') IS NOT NULL
	DROP VIEW [dm_TS].[dimCostBearer];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE   VIEW [dm_TS].[dimCostBearer] AS 
SELECT cb.[CostBearerID]
,cb.[PartitionKey]
,cb.[CostBearerCode]
,cb.[CompanyID]
,cb.[Company]
,cb.[CostBearerNum]
,cb.[CostBearerName]
,cb.[CostBearerStatus]
,cb.[CostBearerGroup]
,cb.[CostBearerGroup2]
,cb.[CostBearerGroup3]
FROM [dm].[DimCostBearer] as cb
WHERE cb.Company  IN ('FESFORA', 'FSEFORA', 'FFRFORA', 'FORPL', 'CERPL', 'FFRGPI', 'FFRLEX', 'IFIWIDN', 'IEEWIDN', 'TMTFI', 'TMTEE', 'FITMT', 'EETMT', 'ABKSE', 'ROROSE','STESE')
GO
