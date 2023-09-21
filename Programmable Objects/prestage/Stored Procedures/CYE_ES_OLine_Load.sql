IF OBJECT_ID('[prestage].[CYE_ES_OLine_Load]') IS NOT NULL
	DROP PROCEDURE [prestage].[CYE_ES_OLine_Load];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [prestage].[CYE_ES_OLine_Load]
AS
BEGIN

Truncate table stage.[CYE_ES_OLine]

insert into stage.CYE_ES_OLine(
		[PartitionKey]
      ,[Company]
      ,[CustNum]
      ,[OrderNum]
      ,[OrderLine]
      ,[OrderType]
      ,[OrderRelNum]
      ,[OrderDate]
      ,[DelivDate]
      ,[OrderQty]
	  ,[DelivQty]
      ,[RemainingQty]
	  ,[InvoiceQty]
      ,[UnitPrice]
      ,[UnitCost]
      ,[OpenRelease]
      ,[DiscountPercent]
      ,[DiscountAmount]
      ,[PartNum]
      ,[NeedbyDate]
      ,[SalesPerson]
      ,[SalesOfficeDescrip]
      ,[SalesGroupCode]
      ,[SalesGroupDescrip]
      ,[WarehouseCode]
      ,[InvoiceNum])
select [PartitionKey]
      ,[Company]
      ,[CustNum]
      ,[OrderNum]
      ,[OrderLine]
      ,[OrderType]
      ,[OrderRelNum]
      ,[OrderDate]
      ,[DelivDate]
      ,[OrderQty]
	  ,[DelivQty]
      ,[RemainingQty]
	  ,[InvoiceQty]
      ,[UnitPrice]
      ,[UnitCost]
      ,[OpenRelease]
      ,[DiscountPercent]
      ,[DiscountAmount]
      ,[PartNum]
      ,[NeedbyDate]
      ,[SalesPerson]
      ,[SalesOfficeDescrip]
      ,[SalesGroupCode]
      ,[SalesGroupDescrip]
      ,[WarehouseCode]
      ,[InvoiceNum] 
from [prestage].[vCYE_ES_OLine]

--Truncate table prestage.[CYE_ES_OLine]

End
GO
