IF OBJECT_ID('[stage].[vOCS_SE_Project]') IS NOT NULL
	DROP VIEW [stage].[vOCS_SE_Project];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO









CREATE VIEW [stage].[vOCS_SE_Project] AS

SELECT 
	CONVERT([binary](32),HASHBYTES('SHA2_256',CONCAT(TRIM([COMPANY]),'#',[ProjectNum]))) AS ProjectID
	,UPPER(CONCAT(TRIM([COMPANY]),'#',[ProjectNum] )) AS ProjectCode
	,CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(TRIM([COMPANY])))) AS CompanyID
	,PartitionKey

	,Company 
	,MainProjectNum
	,[ProjectNum]
	,[ProjectDescription]
	,[Organisation]
	,ProjectStatus
	,ProjectCategory
	,[WBSElement]
	,[ObjectNum]
	,[Level]
	,[Currency]
	,[WarehouseCode]
	,ProjectResponsible
	,Comments
	,COALESCE(TRY_CONVERT(date, [StartDate],112),'1900-01-01') AS StartDate
	,COALESCE(TRY_CONVERT(date, [EndDate],112),'1900-01-01') AS EndDate
	,COALESCE(TRY_CONVERT(date,[EstEndDate],112),'1900-01-01') AS EstEndDate
	,NULL AS ProjectCompletion
	,SUM(ActualCost) AS ActualCost
FROM [stage].[OCS_SE_Project]
GROUP BY Company ,MainProjectNum,[ProjectNum],[ProjectDescription],[Organisation],ProjectStatus,ProjectCategory,[WBSElement],[ObjectNum],[Level]
	,[Currency],[WarehouseCode],ProjectResponsible,Comments,[StartDate],EndDate,EstEndDate, PartitionKey
GO
