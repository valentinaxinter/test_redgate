IF OBJECT_ID('[dm_FH].[dimCostUnit]') IS NOT NULL
	DROP VIEW [dm_FH].[dimCostUnit];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [dm_FH].[dimCostUnit] AS 


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
FROM [dm].[DimCostUnit] cu
LEFT JOIN dbo.Company com ON cu.Company = com.Company
WHERE com.BusinessArea = 'Fluid Handling Solutions' AND com.[Status] = 'Active'

--WHERE [Company] in ('CNOCERT')
GO
