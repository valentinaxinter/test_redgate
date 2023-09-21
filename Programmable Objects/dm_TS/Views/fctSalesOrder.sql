IF OBJECT_ID('[dm_TS].[fctSalesOrder]') IS NOT NULL
	DROP VIEW [dm_TS].[fctSalesOrder];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE VIEW [dm_TS].[fctSalesOrder] AS


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

FROM dm.FactSalesOrder as so
/*temp putting (CERPL) Certex PL here such that they see the data in same company*/
WHERE Company  in ('FESFORA', 'FSEFORA', 'FFRFORA', 'FORPL', 'CERPL', 'FFRGPI', 'FFRLEX','IFIWIDN', 'IEEWIDN', 'TMTFI', 'TMTEE', 'FITMT', 'ABKSE', 'ROROSE','STESE','CERBG'
,'FORBG')  -- TS basket by 2020-08-31 -- , 'EIGSE'
GO
