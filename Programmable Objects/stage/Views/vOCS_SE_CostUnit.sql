IF OBJECT_ID('[stage].[vOCS_SE_CostUnit]') IS NOT NULL
	DROP VIEW [stage].[vOCS_SE_CostUnit];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE VIEW [stage].[vOCS_SE_CostUnit] AS

SELECT
	CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(Company, '#', TRIM([CostUnitNum]))))) AS CostUnitID,
	CONCAT(Company, '#', TRIM([CostUnitNum])) AS CostUnitCode,
	(CONVERT([binary](32), HASHBYTES('SHA2_256', Company))) AS CompanyID,
	PartitionKey,

	Company,
	[CostUnitNum],
	[CostUnitName],
	[MainCostUnitNum] AS CostUnitGroup,
	CURes AS [CostUnitGroup2],
	CreatedTimeStamp AS CURes1,
	ModifiedTimeStamp AS CURes2,
	'' AS CURes3

FROM 
	stage.OCS_SE_CostUnit
--GROUP BY
--	PartitionKey, Company, [CostUnitNum],[CostUnitName],[CostUnitStatus],[CostUnitGroup],[CostUnitGroup2],[CostUnitGroup3]
GO
