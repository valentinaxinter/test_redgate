IF OBJECT_ID('[dm_ALL].[fctSalesOrderLog]') IS NOT NULL
	DROP VIEW [dm_ALL].[fctSalesOrderLog];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE   VIEW [dm_ALL].[fctSalesOrderLog] AS

SELECT  [SalesOrderLogID]
,[CompanyID]
,[CustomerID]
,[PartID]
,[WarehouseID]
,[SalesPersonNameID]
,[SalesOrderDateID]
,[PartitionKey]
,[Company]
,[CustomerNum]
,[SalesOrderNum]
,[SalesOrderLine]
,[SalesOrderSubLine]
,[SalesOrderType]
,[SalesOrderLogType]
,[SalesOrderDate]
,[SalesOrderLogDate]
,[SalesInvoiceNum]
,[SalesOrderQty]
,[UoM]
,[UnitPrice]
,[UnitCost]
,[Currency]
,[ExchangeRate]
,[OpenRelease]
,[DiscountPercent]
,[DiscountAmount]
,[PartNum]
,[PartType]
,[SalesPersonName]
,[Department]
,[WarehouseCode]
FROM [dm].[FactSalesOrderLog]
GO
