IF OBJECT_ID('[dm_AX].[dimCostUnit]') IS NOT NULL
	DROP VIEW [dm_AX].[dimCostUnit];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE VIEW [dm_AX].[dimCostUnit] AS 

SELECT 
 [CostUnitID]
,[PartitionKey]
,[CostUnitCode]
,[CompanyID]
,[Company]
,[CostUnitNum]
,[CostUnitName]
,[CostUnitStatus]
,[CostUnitGroup]
,[CostUnitGroup2]
,[CostUnitGroup3]
FROM [dm].[DimCostUnit]
WHERE [Company] in ('AXISE','AXHSE') -- HQ basket
GO
