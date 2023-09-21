IF OBJECT_ID('[dm_CS_PT].[dimProject]') IS NOT NULL
	DROP VIEW [dm_CS_PT].[dimProject];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
--CREATE schema [dm_CS_PT]
CREATE VIEW [dm_CS_PT].[dimProject] AS

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
FROM [dm].[DimProject] proj
LEFT JOIN dbo.Company com ON proj.Company = com.Company
WHERE com.BusinessArea = '' AND com.[Status] = 'Active'
GO
