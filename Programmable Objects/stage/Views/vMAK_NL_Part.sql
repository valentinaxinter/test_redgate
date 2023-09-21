IF OBJECT_ID('[stage].[vMAK_NL_Part]') IS NOT NULL
	DROP VIEW [stage].[vMAK_NL_Part];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE view [stage].[vMAK_NL_Part] AS
--COMMENT empty fields / ADD UPPER()TRIM() INTO PartID 13-12-2022 VA
/****** First group by to collect all brands  ******/
WITH Part AS (

SELECT  [PartitionKey]
      ,[Company]
      ,[PartNum]
      ,[PartName]
      ,[PartDescription]
      ,[PartDescription2]
      ,[PartDescription3]
      ,[DescLineNr]
      ,[ProductGroup]
      ,[ProductGroup2]
      ,[ProductGroup3]
      ,[ProductGroup4]
      ,STRING_AGG([Brand],', ') WITHIN GROUP (Order BY Brand)	AS Brand
      ,[CommodityCode]
      ,[PartNumReplacement]
	  ,STRING_AGG(TRIM([CountryOfOrigin]),', ') WITHIN GROUP (Order BY Brand)	AS CountryOfOrigin
      ,[NetWeight]
     -- ,[Volume]
      ,[Material]
      ,[ReOrderLevel]
      ,[Barcode]
      ,CONVERT(date, [Startdate], 112 ) AS Startdate
      ,CASE WHEN [Enddate] = '0' THEN NULL ELSE CONVERT(date, [Enddate], 112 ) END	AS EndDate
      ,[UoM]
      ,[StockMonitoring]
      ,[Language]
      ,[PartStatus]
--      ,[PrefSupplier]
  FROM [stage].[MAK_NL_Part]
  GROUP BY 
    [PartitionKey], [Company], [PartNum], [PartName], [PartDescription], [PartDescription2], [PartDescription3], [DescLineNr]
      ,[ProductGroup], [ProductGroup2], [ProductGroup3], [ProductGroup4] /* ,[Brand] */, [CommodityCode], [PartNumReplacement] /*,[CountryOfOrigin]*/ ,[NetWeight] /*, [Volume]*/
      ,[Material], [ReorderLevel], [Barcode], [Startdate], [Enddate], [UoM], [StockMonitoring], [Language], [PartStatus] /*   ,[PrefSupplier]*/
	  )

	  /* Part description are split up into multiple rows. We group and concatenate it all to one row. */
SELECT
	  CONVERT([binary](32), HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM(Company), '#', TRIM(PartNum))))) AS PartID 
	  ,CONVERT([binary](32),HASHBYTES('SHA2_256',Company)) AS CompanyID
	  ,CONCAT(Company, '#', PartNum) AS PartCode
	  ,[PartitionKey]

      ,[Company]
      ,[PartNum]
      ,[PartName]
      ,STRING_AGG(TRIM( [PartDescription]),' ') WITHIN GROUP (Order BY [DescLineNr])	AS [PartDescription]
      ,[PartDescription2]
      ,[PartDescription3]
	  --,NULL AS MainSupplier
	  --,NULL AS AlternativeSupplier
      ,CONCAT([ProductGroup],' - ', [ProductGroup2]) AS ProductGroup	--ProductGroupNum + Name
      ,[ProductGroup2]
      ,[ProductGroup3]
      ,[ProductGroup4]
      ,Brand
      ,[CommodityCode]
      ,[PartNumReplacement]	AS PartReplacementNum
	  ,[PartStatus]
	  ,CountryOfOrigin
      ,[NetWeight]
      ,[UoM]
      ,[Material]
      ,[Barcode]
	  ,[ReOrderLevel]
	  --,'' AS PartResponsible
      ,[StartDate]
      ,[EndDate]
      ,[StockMonitoring]
      ,[Language]
     
FROM Part
   GROUP BY
     [PartitionKey],[Company] ,[PartNum] ,[PartName] /* ,[PartDescription] */, [PartDescription2], [PartDescription3] /*   ,[DescLineNr] */
      ,[ProductGroup], [ProductGroup2], [ProductGroup3], [ProductGroup4], [Brand], [CommodityCode], [PartNumReplacement], [CountryOfOrigin], [NetWeight],
      /*[Volume],*/ [Material], [ReorderLevel], [Barcode], [Startdate], [Enddate], [UoM], [StockMonitoring], [Language], [PartStatus] /*  ,[PrefSupplier] */
GO
