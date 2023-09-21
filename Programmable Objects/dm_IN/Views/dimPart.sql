IF OBJECT_ID('[dm_IN].[dimPart]') IS NOT NULL
	DROP VIEW [dm_IN].[dimPart];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO






CREATE VIEW [dm_IN].[dimPart] AS 

SELECT 
        [PartID]
      ,[CompanyID]
      ,[Company]
      ,[PartNum]
      ,[PartName]
      ,[Part]
      ,[PartDescription]
      ,[PartDescription2]
      ,[PartDescription3]
      ,[MainSupplier]
      ,[AlternativeSupplier]
      ,[ProductGroup]
      ,[ProductGroup2]
      ,[ProductGroup3]
      ,[ProductGroup4]
      ,[Brand]
      ,[CommodityCode]
      ,[PartReplacementNum]
      ,[PartStatus]
      ,[CountryOfOrigin]
      ,[NetWeight]
      ,[UoM]
      ,[Material]
      ,[ReOrderlevel]
      ,[Barcode]
      ,[PartResponsible]
      ,[ProductID]
      ,[PimID]
      ,[PIM_Category1]
      ,[PIM_Category2]
      ,[PIM_Category3]
      ,[PIM_Category4]
      ,[PIM_Category5]
      ,[PIM_Category6]
      ,[PIM_Brand]
      ,[PIM_Heading]
      ,[PIM_Original_Description]
      ,[PIM_LCName]
      ,[ManufacturerID]
      ,[StartDate]
      ,[EndDate]
      ,[PARes1]
      ,[is_inferred]
      ,[PartAge]
      ,[PartActivity]
      ,[StockMovement]

FROM [dm].[DimPart]
WHERE [Company] in ('OCSSE') -- Industry basket
GO
