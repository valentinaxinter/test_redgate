IF OBJECT_ID('[dm].[DimCostUnit]') IS NOT NULL
	DROP VIEW [dm].[DimCostUnit];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



/****** Script for SelectTopNRows command from SSMS  ******/
CREATE VIEW [dm].[DimCostUnit] AS

SELECT CONVERT(bigint, [CostUnitID]) AS [CostUnitID]
      ,[PartitionKey]
      ,[CostUnitCode]
      ,CONVERT(bigint, [CompanyID]) AS [CompanyID]
      ,[Company]
      ,[CostUnitNum]
      ,[CostUnitName]
      ,[CostUnitStatus]
      ,[CostUnitGroup]
      ,[CostUnitGroup2]
      ,[CostUnitGroup3]
  FROM [dw].[CostUnit] -- was [fnc].
GO
