IF OBJECT_ID('[dm_DS].[fctSalesOrder]') IS NOT NULL
	DROP VIEW [dm_DS].[fctSalesOrder];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE VIEW [dm_DS].[fctSalesOrder] AS

SELECT 
 so.[SalesOrderID]
,so.[SalesOrderNumID]
,so.[CustomerID]
,so.[CompanyID]
,so.[PartID]
,so.[WarehouseID]
,so.[ProjectID]
,so.[SalesPersonNameID]
,so.[DepartmentID]
,so.[SalesOrderDateID]
,so.[Company]
,so.[CustomerNum]
,so.[SalesOrderNum]
,so.[SalesOrderLine]
,so.[SalesOrderSubLine]
,so.[SalesOrderType]
,so.[SalesOrderCategory]
,so.[SalesOrderDate]
,so.[NeedbyDate]
,so.[ExpDelivDate]
,so.[ConfirmedDelivDate]
,so.[SalesInvoiceNum]
,so.[SalesOrderQty]
,so.[DelivQty]
,so.[RemainingQty]
,so.[UoM]
,so.[UnitPrice]
,so.[UnitCost]
,so.[Currency]
,so.[ExchangeRate]
,so.[OpenRelease]
,so.[OrderStatus]
,so.[DiscountAmount]
,so.[DiscountPercent]
,so.[PartNum]
,so.[PartType]
,so.[PartStatus]
,so.[SalesPersonName]
,so.[WarehouseCode]
,so.[SalesChannel]
,so.[AxInterSalesChannel]
,so.[Department]
,so.[ProjectNum]
,so.[ActualDelivDate]
,so.[SalesInvoiceQty]
,so.[TotalMiscChrg]
,so.[IsUpdatingStock]
,so.[SORes1]
,so.[SORes2]
,so.[SORes3]
,so.[SORes4]
,so.[SORes5]
,so.[SORes6]
FROM dm.FactSalesOrder so
LEFT JOIN dbo.Company com ON so.Company = com.Company
WHERE com.BusinessArea = 'Driveline Solutions' AND com.[Status] = 'Active';
GO
