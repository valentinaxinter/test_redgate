IF OBJECT_ID('[dm_IN].[dimProject]') IS NOT NULL
	DROP VIEW [dm_IN].[dimProject];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO







CREATE VIEW [dm_IN].[dimProject] AS

SELECT 
 proj.[ProjectID]
,proj.[ProjectCode]
,proj.[PartitionKey]
,proj.[Company]
,proj.[MainProjectNum]
,proj.[ProjectNum]
,proj.[ProjectDescription]
,proj.[Project]
,proj.[Organisation]
,proj.[ProjectStatus]
,proj.[ProjectCategory]
,proj.[WBSElement]
,proj.[ObjectNum]
,proj.[Level]
,proj.[Currency]
,proj.[WarehouseCode]
,proj.[ProjectResponsible]
,proj.[Comments]
,proj.[StartDate]
,proj.[EndDate]
,proj.[EstEndDate]
,proj.[ActualCost]
FROM [dm].[DimProject] as proj
WHERE proj.[Company] in ('OCSSE')  -- Industry basket
GO
