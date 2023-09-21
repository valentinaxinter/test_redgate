IF OBJECT_ID('[stage].[vCER_DK_Project]') IS NOT NULL
	DROP VIEW [stage].[vCER_DK_Project];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




CREATE VIEW [stage].[vCER_DK_Project] AS

SELECT 
	CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT(upper(TRIM([COMPANY])), '#', UPPER(trim([ProjectNum]))))) AS ProjectID
	,UPPER(CONCAT(TRIM([COMPANY]),'#',UPPER(TRIM([ProjectNum])) )) AS ProjectCode
	,CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(TRIM([COMPANY])))) AS CompanyID
	,PartitionKey

	,Company 
	,MainProjectNum
	,UPPER(trim(ProjectNum)) as [ProjectNum]
	,[ProjectDescription]
	,[Organisation]
	,ProjectStatus
	,ProjectCategory
	,[WBSElement]
	,'' AS [ObjectNum]
	,[Level]
	,[Currency]
	,trim([WarehouseCode]) as [WarehouseCode]
	,ProjectResponsible
	,Comments
	,COALESCE(CONVERT(date, [StartDate],112),'1900-01-01') AS StartDate
	,COALESCE(CONVERT(date, [EndDate],112),'1900-01-01') AS EndDate
	,COALESCE(CONVERT(date,[EstEndDate],112),'1900-01-01') AS EstEndDate
	,NULL AS ProjectCompletion
	,(ActualCost) AS ActualCost --SUM
FROM [stage].[CER_DK_Project]
--GROUP BY Company ,MainProjectNum,[ProjectNum],[ProjectDescription],[Organisation],ProjectStatus,ProjectCategory,[WBSElement],[ObjectNum],[Level]
--	,[Currency],[WarehouseCode],ProjectResponsible,Comments,[StartDate],EndDate,EstEndDate, PartitionKey
GO
