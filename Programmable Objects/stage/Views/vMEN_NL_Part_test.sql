IF OBJECT_ID('[stage].[vMEN_NL_Part_test]') IS NOT NULL
	DROP VIEW [stage].[vMEN_NL_Part_test];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO















/****** Script for SelectTopNRows command from SSMS  ******/

CREATE VIEW [stage].[vMEN_NL_Part_test] AS
WITH CTE AS (
SELECT CASE WHEN Company = '14' THEN  CONCAT(N'MENBE',Company)
			ELSE  CONCAT(N'MENNL',Company) END AS CompanyCode		--Doing this to have the company code in nvarchar and don't need to repeat CAST(CONCAT('MEN-',Company) AS nvarchar(50)) everywhere /SM
	  ,[PartitionKey], [Company], [PartNum], [PartDescription], [PartDescription2], [PartDescription3], [ProductGroup], [ProductGroup2], [ProductGroup3], [ProductGroup4], [Brand], [CommodityCode], [PartReplacementNum], [PartStatus], [CountryOfOrigin], [NetWeight], [UoM], [Material], [Barcode], [ReorderLevel], [PartResponsible], [MainSupplier], [AlternativeSupplier], [StartDate], [EndDate], [PARes1], [PARes2], [PARes3], [ProductKey], [DW_TimeStamp], [ProductCOOCode], [ProductIsAssembly]
  FROM [stage].[MEN_NL_Part]
)


SELECT 
	  CONVERT([binary](32),HASHBYTES('SHA2_256',CONCAT(CompanyCode,'#',PartNum))) AS PartID
	  ,CONVERT([binary](32),HASHBYTES('SHA2_256',CompanyCode)) AS CompanyID
	  ,UPPER(CONCAT(TRIM(CompanyCode),'#',TRIM([PartNum]))) AS PartCode
	  ,[PartitionKey]

      ,[CompanyCode]		AS Company
      ,[PartNum]			
	  ,[PartDescription]	AS PartName
      ,[PartDescription]
      ,[PartDescription2]
	  ,PartDescription3
	  ,MainSupplier
	  ,AlternativeSupplier
      ,[ProductGroup]
	  ,[ProductGroup2]
	  ,[ProductGroup3]
	  ,[ProductGroup4]
	  ,[Brand]
      ,[CommodityCode]
	  --,PartReplacementNum
	  --,PartStatus
      --,[CountryOfOrigin]
      --,[NetWeight]
	  --,UoM
	  --,[Material]
	  --,[Barcode]
	  --,[ReOrderLevel]
	  --,PartResponsible
	  --,[StartDate]
	  --,[EndDate]
  FROM CTE
GO
