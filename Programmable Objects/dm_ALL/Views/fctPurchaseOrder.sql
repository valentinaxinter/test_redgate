IF OBJECT_ID('[dm_ALL].[fctPurchaseOrder]') IS NOT NULL
	DROP VIEW [dm_ALL].[fctPurchaseOrder];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [dm_ALL].[fctPurchaseOrder] AS

SELECT 
[PurchaseOrderID]
,[PurchaseOrderNumID]
,[PurchaseInvoiceID]
,[CompanyID]
,[SupplierID]
,[CustomerID]
,[PartID]
,[WarehouseID]
,[CurrencyID]
,[PurchaseOrderDateID]
,[PurchaseInvoiceDateID]
,[Company]
,[PurchaseOrderNum]
,[PurchaseOrderLine]
,[PurchaseOrderSubLine]
,[PurchaseOrderType]
,[PurchaseOrderDate]
,[PurchaseOrderStatus]
,[OrgReqDelivDate]
,[CommittedDelivDate]
,[CommittedShipDate]
,[ActualDelivDate]
,[ReqDelivDate]
,[PurchaseInvoiceNum]
,[PartNum]
,[SupplierNum]
,[SupplierPartNum]
,[SupplierInvoiceNum]
,[DelivCustomerNum]
,[PartStatus]
,[OrderQty]
,[ReceiveQty]
,[InvoiceQty]
,[MinOrderQty]
,[UoM]
,[UnitPrice]
,[DiscountPercent]
,[DiscountAmount]
,[ExchangeRate]
,[Currency]
,[PurchaserName]
,[WarehouseCode]
,[ReceivingNum]
,[DelivTime]
,[PurchaseChannel]
,[Documents]
,[Comments]
,[PORes1]
,[PORes2]
,[PORes3]
,[InvoiceStatus]
,[DaysSinceOrder]
,[OrgCommittedDelivDate]
,[IsOrderClosed]

FROM [dm].[FactPurchaseOrder]
GO
