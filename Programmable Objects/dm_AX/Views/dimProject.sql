IF OBJECT_ID('[dm_AX].[dimProject]') IS NOT NULL
	DROP VIEW [dm_AX].[dimProject];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [dm_AX].[dimProject] AS

SELECT 
[ProjectID]
,[ProjectCode]
,[PartitionKey]
,[Company]
,[MainProjectNum]
,[ProjectNum]
,[ProjectDescription]
,[Project]
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
,[ActualCost]
FROM [dm].[DimProject] 
WHERE Company IN ('AXISE','AXHSE')
GO
