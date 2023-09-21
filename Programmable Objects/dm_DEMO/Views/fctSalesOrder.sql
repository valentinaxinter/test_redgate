IF OBJECT_ID('[dm_DEMO].[fctSalesOrder]') IS NOT NULL
	DROP VIEW [dm_DEMO].[fctSalesOrder];

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO

CREATE VIEW [dm_DEMO].[fctSalesOrder] AS


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
WHERE Company  in ('DEMO')
GO
