IF OBJECT_ID('[dm_IN].[dimCostUnit]') IS NOT NULL
	DROP VIEW [dm_IN].[dimCostUnit];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [dm_IN].[dimCostUnit] AS 

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
WHERE com.BusinessArea = 'Industrial Solutions' AND com.[Status] = 'Active'

--WHERE [Company] in ('CNOCERT')
GO
