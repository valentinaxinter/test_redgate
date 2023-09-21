IF OBJECT_ID('[stage].[vFOR_SE_CostUnit]') IS NOT NULL
	DROP VIEW [stage].[vFOR_SE_CostUnit];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [stage].[vFOR_SE_CostUnit] AS

SELECT
	CONVERT([binary](32),HASHBYTES('SHA2_256',CONCAT(Company, '#', [CostUnitNum]))) AS CostUnitID,
	CONCAT(Company,'#',[CostUnitNum]) AS CostUnitCode,
	CONVERT([binary](32),HASHBYTES('SHA2_256',Company)) AS CompanyID,
	PartitionKey,

	Company,
	[CostUnitNum],
	[CostUnitName],
	[CostUnitStatus],
	[CostUnitGroup],
	[CostUnitGroup2],
	[CostUnitGroup3],
	RecordIsActive AS CURes1,
	'' AS CURes2,
	'' AS CURes3

FROM 
	stage.FOR_SE_CostUnit
--GROUP BY
--	PartitionKey, Company, [CostUnitNum],[CostUnitName],[CostUnitStatus],[CostUnitGroup],[CostUnitGroup2],[CostUnitGroup3]
GO
