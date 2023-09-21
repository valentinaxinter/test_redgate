IF OBJECT_ID('[dm_FH].[dimCostBearer]') IS NOT NULL
	DROP VIEW [dm_FH].[dimCostBearer];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
--CREATE schema dm_FH

CREATE VIEW [dm_FH].[dimCostBearer] AS 

SELECT  cb.[CostBearerID]
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
FROM [dm].[DimCostBearer] cb
LEFT JOIN dbo.Company com ON cb.Company = com.Company
WHERE com.BusinessArea = 'Fluid Handling Solutions' AND com.[Status] = 'Active'
GO
