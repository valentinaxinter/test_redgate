IF OBJECT_ID('[prestage].[vCYE_ES_OLine]') IS NOT NULL
	DROP VIEW [prestage].[vCYE_ES_OLine];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO





CREATE view [prestage].[vCYE_ES_OLine]
as
SELECT 
	concat(CONVERT (date, SYSDATETIME()), ' 00:00:00') AS [PartitionKey]
	,'CYESA' AS [Company]
	,TRIM(CustNum) AS CustNum
	,TRIM(OrderNum) AS OrderNum
	,TRIM(OrderLine) AS OrderLine
	,OrderRelNum
	,OrderType
	,CONVERT(DATE, OrderDate, 120) AS OrderDate
	,CONVERT(DATE, DelivDate, 120) AS DelivDate
	,CONVERT(Decimal(18,4), REPLACE(OrderQty,',','')) AS OrderQty
	,CONVERT(Decimal(18,4), REPLACE(DelivQty,',','')) AS DelivQty
	,CONVERT(Decimal(18,4), REPLACE(RemainingQty,',','')) AS RemainingQty
	,CONVERT(Decimal(18,4), REPLACE(InvoiceQty,',','')) AS InvoiceQty
	,CONVERT(Decimal(18,4), REPLACE([UnitPrice],',','')) AS [UnitPrice]
	,CONVERT(Decimal(18,4), REPLACE([UnitCost],',','')) AS [UnitCost]
	,OpenRelease
	,CONVERT(Decimal(18,4), REPLACE([DiscountPercent],',','')) AS [DiscountPercent]
	,CONVERT(Decimal(18,4), REPLACE([DiscountAmount],',','')) AS [DiscountAmount]
	,TRIM(PartNum) AS PartNum
	,CONVERT(DATE, NeedbyDate, 120) AS NeedbyDate
	,SalesPerson
	,SalesOfficeDescrip
	,SalesGroupCode
	,SalesGroupDescrip
	,WarehouseCode
	,TRIM(InvoiceNum) AS InvoiceNum
FROM [prestage].[CYE_ES_OLine]
GO
