IF OBJECT_ID('[dm_DEMO].[fctSalesInvoice]') IS NOT NULL
	DROP VIEW [dm_DEMO].[fctSalesInvoice];

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE VIEW [dm_DEMO].[fctSalesInvoice] AS


SELECT 
[SalesInvoiceID]
,[SalesOrderID]
,[SalesOrderNumID]
,[CustomerID]
,[CompanyID]
,[PartID]
,[WarehouseID]
,[SalesPersonNameID]
,[DepartmentID]
,[Company]
,[SalesInvoiceCode]
,[SalesInvoiceDateID]
,[ProjectID]
,[SalesPersonName]
,[CustomerNum]
,[PartNum]
,[PartType]
,[SalesOrderNum]
,[SalesOrderLine]
,[SalesOrderSubLine]
,[SalesOrderType]
,[SalesInvoiceNum]
,[SalesInvoiceLine]
,[SalesInvoiceType]
,[SalesInvoiceDate]
,[ActualDelivDate]
,[SalesInvoiceQty]
,[UoM]
,[UnitPrice]
,[UnitCost]
,[DiscountPercent]
,[DiscountAmount]
,[TotalMiscChrg]
,[Currency]
,[ExchangeRate]
,[VATAmount]
,[CreditMemo]
,[Department]
,[ProjectNum]
,[WarehouseCode]
,[CostBearerNum]
,[CostUnitNum]
,[ReturnComment]
,[ReturnNum]
,[OrderHandler]
,[SalesChannel]
,[NeedbyDate]
,[ExpDelivDate]
,[SalesOrderCode]
,[SalesOrderDateID]
,[SalesOrderDate]
,[ConfirmedDelivDate]
,[PartStatus]
,[AxInterSalesChannel]
,[DueDate]
,[LastPaymentDate]
,[SalesInvoiceStatus]
,[CashDiscountOffered]
,[CashDiscountUsed]
,[IsUpdatingStock]
,[SIRes1]
,[SIRes2]
,[SIRes3]
,[SIRes4]
,[SIRes5]
,[SIRes6]
FROM dm.FactSalesInvoice
WHERE Company  in ('DEMO')
GO
