IF OBJECT_ID('[dm_DS].[fctSalesOrderLog]') IS NOT NULL
	DROP VIEW [dm_DS].[fctSalesOrderLog];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE   VIEW [dm_DS].[fctSalesOrderLog] AS

SELECT  sol.[SalesOrderLogID]
,sol.[CompanyID]
,sol.[CustomerID]
,sol.[PartID]
,sol.[WarehouseID]
,sol.[SalesPersonNameID]
,sol.[SalesOrderDateID]
,sol.[PartitionKey]
,sol.[Company]
,sol.[CustomerNum]
,sol.[SalesOrderNum]
,sol.[SalesOrderLine]
,sol.[SalesOrderSubLine]
,sol.[SalesOrderType]
,sol.[SalesOrderLogType]
,sol.[SalesOrderDate]
,sol.[SalesOrderLogDate]
,sol.[SalesInvoiceNum]
,sol.[SalesOrderQty]
,sol.[UoM]
,sol.[UnitPrice]
,sol.[UnitCost]
,sol.[Currency]
,sol.[ExchangeRate]
,sol.[OpenRelease]
,sol.[DiscountPercent]
,sol.[DiscountAmount]
,sol.[PartNum]
,sol.[PartType]
,sol.[SalesPersonName]
,sol.[Department]
,sol.[WarehouseCode]
FROM [dm].[FactSalesOrderLog] as sol
LEFT JOIN dbo.Company com ON sol.Company = com.Company
WHERE com.BusinessArea = 'Driveline Solutions' AND com.[Status] = 'Active'

--WHERE Company in ('MIT', 'ATZ', 'Transaut')
GO
