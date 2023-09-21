IF OBJECT_ID('[dm_FH].[dimPart]') IS NOT NULL
	DROP VIEW [dm_FH].[dimPart];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [dm_FH].[dimPart] AS 

SELECT 
        par.[PartID]
      ,par.[CompanyID]
      ,par.[Company]
      ,par.[PartNum]
      ,par.[PartName]
      ,par.[Part]
      ,par.[PartDescription]
      ,par.[PartDescription2]
      ,par.[PartDescription3]
      ,par.[MainSupplier]
      ,par.[AlternativeSupplier]
      ,par.[ProductGroup]
      ,par.[ProductGroup2]
      ,par.[ProductGroup3]
      ,par.[ProductGroup4]
      ,par.[Brand]
      ,par.[CommodityCode]
      ,par.[PartReplacementNum]
      ,par.[PartStatus]
      ,par.[CountryOfOrigin]
      ,par.[NetWeight]
      ,par.[UoM]
      ,par.[Material]
      ,par.[ReOrderlevel]
      ,par.[Barcode]
      ,par.[PartResponsible]
      ,par.[ProductID]
      ,par.[PimID]
      ,par.[PIM_Category1]
      ,par.[PIM_Category2]
      ,par.[PIM_Category3]
      ,par.[PIM_Category4]
      ,par.[PIM_Category5]
      ,par.[PIM_Category6]
      ,par.[PIM_Brand]
      ,par.[PIM_Heading]
      ,par.[PIM_Original_Description]
      ,par.[PIM_LCName]
      ,par.[ManufacturerID]
      ,par.[StartDate]
      ,par.[EndDate]
      ,par.[PARes1]
      ,par.[is_inferred]
      ,par.[PartAge]
      ,par.[PartActivity]
      ,par.[StockMovement]


FROM [dm].[DimPart] as par
/* Alt.1 can take long time, as with PT */
LEFT JOIN dbo.Company as com ON par.Company = com.Company
WHERE com.BusinessArea = 'Fluid Handling Solutions' AND com.[Status] = 'Active'
GO
