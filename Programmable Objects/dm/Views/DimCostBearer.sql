IF OBJECT_ID('[dm].[DimCostBearer]') IS NOT NULL
	DROP VIEW [dm].[DimCostBearer];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


/****** Script for SelectTopNRows command from SSMS  ******/

CREATE VIEW [dm].[DimCostBearer] AS
SELECT CONVERT(bigint, [CostBearerID]) AS [CostBearerID]
      ,[PartitionKey]
      ,[CostBearerCode]
      ,CONVERT(bigint, [CompanyID]) AS [CompanyID]
      ,[Company]
      ,[CostBearerNum]
      ,[CostBearerName]
      ,[CostBearerStatus]
      ,[CostBearerGroup]
      ,[CostBearerGroup2]
      ,[CostBearerGroup3]
  FROM [dw].[CostBearer] -- was [fnc].
GO
