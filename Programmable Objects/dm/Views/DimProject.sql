IF OBJECT_ID('[dm].[DimProject]') IS NOT NULL
	DROP VIEW [dm].[DimProject];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



/****** Script for SelectTopNRows command from SSMS  ******/
CREATE VIEW [dm].[DimProject] AS 
SELECT CONVERT(bigint, [ProjectID]) AS ProjectID
      ,[ProjectCode]
      ,[PartitionKey]
      ,[Company]
      ,[MainProjectNum]
      ,[ProjectNum]
      ,[ProjectDescription]
	  ,CONCAT(ProjectNum, ' - ' + NULLIF(TRIM(ProjectDescription),''))	AS Project 
      ,[Organisation]
      ,[ProjectStatus]
      ,[ProjectCategory]
      ,[WBSElement]
      ,[ObjectNum]
      ,[Level]
      ,[Currency]
      ,[WarehouseCode]
      ,[ProjectResponsible]
      ,[Comments]
      ,[StartDate]
      ,[EndDate]
      ,[EstEndDate]
	  ,ActualCost
  FROM [dw].[Project]
  GROUP BY ProjectID,[ProjectCode],[PartitionKey],[Company],[MainProjectNum],[ProjectNum],[ProjectDescription],[Organisation],[ProjectStatus],[ProjectCategory],[WBSElement]
      ,[ObjectNum],[Level],[Currency],[WarehouseCode],[ProjectResponsible],[Comments],[StartDate],[EndDate],[EstEndDate], ActualCost
GO
