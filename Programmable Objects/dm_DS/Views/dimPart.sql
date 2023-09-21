IF OBJECT_ID('[dm_DS].[dimPart]') IS NOT NULL
	DROP VIEW [dm_DS].[dimPart];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE VIEW [dm_DS].[dimPart] AS 

SELECT 
		p.[PartID]
      ,p.[CompanyID]
      ,p.[Company]
      ,p.[PartNum]
      ,p.[PartName]
      ,p.[Part]
      ,p.[PartDescription]
      ,p.[PartDescription2]
      ,p.[PartDescription3]
      ,p.[MainSupplier]
      ,p.[AlternativeSupplier]
      ,p.[ProductGroup]
      ,p.[ProductGroup2]
      ,p.[ProductGroup3]
      ,p.[ProductGroup4]
      ,p.[Brand]
      ,p.[CommodityCode]
      ,p.[PartReplacementNum]
      ,p.[PartStatus]
      ,p.[CountryOfOrigin]
      ,p.[NetWeight]
      ,p.[UoM]
      ,p.[Material]
      ,p.[ReOrderlevel]
      ,p.[Barcode]
      ,p.[PartResponsible]
      ,p.[ProductID]
      ,p.[PimID]
      ,p.[PIM_Category1]
      ,p.[PIM_Category2]
      ,p.[PIM_Category3]
      ,p.[PIM_Category4]
      ,p.[PIM_Category5]
      ,p.[PIM_Category6]
      ,p.[PIM_Brand]
      ,p.[PIM_Heading]
      ,p.[PIM_Original_Description]
      ,p.[PIM_LCName]
      ,p.[ManufacturerID]
      ,p.[StartDate]
      ,p.[EndDate]
      ,p.[PARes1]
      ,p.[is_inferred]
      ,p.[PartAge]
      ,p.[PartActivity]
      ,p.[StockMovement]


FROM [dm].[DimPart] as p
LEFT JOIN dbo.Company as com ON p.Company = com.Company
WHERE com.BusinessArea = 'Driveline Solutions' AND com.[Status] = 'Active' 
--WHERE [Company] in ('MIT', 'ATZ', 'Transaut', 'IPLIOWTR')
GO
