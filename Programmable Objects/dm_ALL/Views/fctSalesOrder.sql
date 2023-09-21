IF OBJECT_ID('[dm_ALL].[fctSalesOrder]') IS NOT NULL
	DROP VIEW [dm_ALL].[fctSalesOrder];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [dm_ALL].[fctSalesOrder] AS

SELECT 
[SalesOrderID]
,[SalesOrderNumID]
,[CustomerID]
,[CompanyID]
,[PartID]
,[WarehouseID]
,[ProjectID]
,[SalesPersonNameID]
,[DepartmentID]
,[SalesOrderDateID]
,[Company]
,[CustomerNum]
,[SalesOrderNum]
,[SalesOrderLine]
,[SalesOrderSubLine]
,[SalesOrderType]
,[SalesOrderCategory]
,[SalesOrderDate]
,[NeedbyDate]
,[ExpDelivDate]
,[ConfirmedDelivDate]
,[SalesInvoiceNum]
,[SalesOrderQty]
,[DelivQty]
,[RemainingQty]
,[UoM]
,[UnitPrice]
,[UnitCost]
,[Currency]
,[ExchangeRate]
,[OpenRelease]
,[OrderStatus]
,[DiscountAmount]
,[DiscountPercent]
,[PartNum]
,[PartType]
,[PartStatus]
,[SalesPersonName]
,[WarehouseCode]
,[SalesChannel]
,[AxInterSalesChannel]
,[Department]
,[ProjectNum]
,[ActualDelivDate]
,[SalesInvoiceQty]
,[TotalMiscChrg]
,[IsUpdatingStock]
,[SORes1]
,[SORes2]
,[SORes3]
,[SORes4]
,[SORes5]
,[SORes6]
FROM dm.FactSalesOrder
GO
