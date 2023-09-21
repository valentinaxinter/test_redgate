IF OBJECT_ID('[dm_TS].[dimCostUnit]') IS NOT NULL
	DROP VIEW [dm_TS].[dimCostUnit];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE   VIEW [dm_TS].[dimCostUnit] AS 

SELECT  cu.[CostUnitID]
,cu.[PartitionKey]
,cu.[CostUnitCode]
,cu.[CompanyID]
,cu.[Company]
,cu.[CostUnitNum]
,cu.[CostUnitName]
,cu.[CostUnitStatus]
,cu.[CostUnitGroup]
,cu.[CostUnitGroup2]
,cu.[CostUnitGroup3]
FROM [dm].[DimCostUnit] as cu
WHERE cu.Company  IN ('FESFORA', 'FSEFORA', 'FFRFORA', 'FORPL', 'CERPL', 'FFRGPI', 'FFRLEX', 'IFIWIDN', 'IEEWIDN', 'TMTFI', 'TMTEE', 'FITMT', 'EETMT', 'ABKSE', 'ROROSE','STESE')
GO
