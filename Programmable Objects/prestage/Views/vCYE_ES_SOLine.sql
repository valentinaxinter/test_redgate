IF OBJECT_ID('[prestage].[vCYE_ES_SOLine]') IS NOT NULL
	DROP VIEW [prestage].[vCYE_ES_SOLine];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE view [prestage].[vCYE_ES_SOLine] AS

SELECT 
	  concat(CONVERT (date, SYSDATETIME()), ' 00:00:00') AS [PartitionKey]
	  ,'CYESA' AS [Company]
	  ,CONVERT(date, IIF(InvoiceDate = '0000-00-00' or InvoiceDate = '', '1900-01-01', InvoiceDate)) AS InvoiceDate
	  ,CONVERT(date, IIF([ActualDeliveryDate] = '0000-00-00' or [ActualDeliveryDate] = '', '1900-01-01', [ActualDeliveryDate])) AS [ActualDeliveryDate]
	  ,SalesPerson
	  ,CustNum
	  ,OrderNum
	  ,OrderLine
	  ,LEFT(OrderRel, 50) AS OrderRel
	  ,InvoiceNum
	  ,InvoiceLine
	  ,InvoiceType -- Capgemani added this field on 20210622 /DZ
	  ,CreditMemo
	  ,PartNum
	  ,IIF([SellingShipQty] IS NULL OR [SellingShipQty] = '', NULL, CONVERT(Decimal(18,4), REPLACE([SellingShipQty],',',''))) AS [SellingShipQty]
	  ,IIF([UnitPrice] IS NULL OR [UnitPrice] = '', NULL, CONVERT(Decimal(18,4), REPLACE([UnitPrice],',',''))) AS [UnitPrice]
	  ,IIF([UnitCost] IS NULL OR [UnitCost] = '', NULL, CONVERT(Decimal(18,4), REPLACE([UnitCost],',',''))) AS [UnitCost]
	  ,IIF([DiscountAmount] IS NULL OR [DiscountAmount] = '', NULL, CONVERT(Decimal(18,4), REPLACE([DiscountAmount],',',''))) AS [DiscountAmount]
	  ,IIF([TotalMiscChrg] IS NULL OR [TotalMiscChrg] = '', NULL, CONVERT(Decimal(18,4), REPLACE([TotalMiscChrg],',',''))) AS [TotalMiscChrg]
	  ,IIF([DiscountPercent] IS NULL OR [DiscountPercent] = '', NULL, CONVERT(Decimal(18,4), REPLACE([DiscountPercent],',',''))) AS [DiscountPercent]
	  ,[UnitCostEK02]
	  ,[SalesOfficeDescrip]
	  ,[SalesGroupCode]
	  ,[SalesGroupDescrip]
	  ,WarehouseCode
	  ,Indexkey
	  ,[ReturnNum]
	  ,[ReturnComment]

FROM [prestage].[CYE_ES_SOLine]
GO
