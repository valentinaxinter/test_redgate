IF OBJECT_ID('[dm_DEMO].[fctPurchaseOrder]') IS NOT NULL
	DROP VIEW [dm_DEMO].[fctPurchaseOrder];

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE VIEW  [dm_DEMO].[fctPurchaseOrder] as 
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

FROM dm.FactPurchaseOrder

WHERE Company  in ('DEMO')
GO
