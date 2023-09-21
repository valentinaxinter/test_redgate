IF OBJECT_ID('[dm_PT].[dimPart]') IS NOT NULL
	DROP VIEW [dm_PT].[dimPart];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO





CREATE VIEW [dm_PT].[dimPart] AS 
-- AS decided by Ian & Random Forest AB on the 7th May 2020, the data is spliting after data-warehouse for each Business Group
SELECT 

        pt.[PartID]
      ,pt.[CompanyID]
      ,pt.[Company]
      ,pt.[PartNum]
      ,pt.[PartName]
      ,pt.[Part]
      ,pt.[PartDescription]
      ,pt.[PartDescription2]
      ,pt.[PartDescription3]
      ,pt.[MainSupplier]
      ,pt.[AlternativeSupplier]
      ,pt.[ProductGroup]
      ,pt.[ProductGroup2]
      ,pt.[ProductGroup3]
      ,pt.[ProductGroup4]
      ,pt.[Brand]
      ,pt.[CommodityCode]
      ,pt.[PartReplacementNum]
      ,pt.[PartStatus]
      ,pt.[CountryOfOrigin]
      ,pt.[NetWeight]
      ,pt.[UoM]
      ,pt.[Material]
      ,pt.[ReOrderlevel]
      ,pt.[Barcode]
      ,pt.[PartResponsible]
      ,pt.[ProductID]
      ,pt.[PimID]
      ,pt.[PIM_Category1]
      ,pt.[PIM_Category2]
      ,pt.[PIM_Category3]
      ,pt.[PIM_Category4]
      ,pt.[PIM_Category5]
      ,pt.[PIM_Category6]
      ,pt.[PIM_Brand]
      ,pt.[PIM_Heading]
      ,pt.[PIM_Original_Description]
      ,pt.[PIM_LCName]
      ,pt.[ManufacturerID]
      ,pt.[StartDate]
      ,pt.[EndDate]
      ,pt.[PARes1]
      ,pt.[is_inferred]
      ,pt.[PartAge]
      ,pt.[PartActivity]
      ,pt.[StockMovement]
FROM [dm].[DimPart] as pt
/* alt.1  --this option takes too long time than alt.2 20 min vs 8,5min */
--LEFT JOIN dbo.Company com ON pt.Company = com.Company
--WHERE com.BusinessArea = 'Power Transmission Solutions' AND com.[Status] = 'Active'

/* alt.2 */
WHERE pt.[Company] in ('ACZARKOV', 'AcornUK', 'BSIBELL', 'JDKJENSS', 'MNLMAK', 'JNOJENSS', 'NORNO', 'JSEJENSS', 'SSWSE', 'NINSE', 'NomoSE', 'NomoDK', 'NomoFI', 'NomoNo', 'PASSEROT', 'SCOFI', 'SMKFI', 'SPRUITNL', 'GSUGB', 'SVESE')  

/*  The PT basket */
GO
