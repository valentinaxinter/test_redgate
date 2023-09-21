IF OBJECT_ID('[dm_LS].[fctPurchaseOrder]') IS NOT NULL
	DROP VIEW [dm_LS].[fctPurchaseOrder];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [dm_LS].[fctPurchaseOrder] AS

SELECT 

 po.[PurchaseOrderID]
,po.[PurchaseOrderNumID]
,po.[PurchaseInvoiceID]
,po.[CompanyID]
,po.[SupplierID]
,po.[CustomerID]
,po.[PartID]
,po.[WarehouseID]
,po.[CurrencyID]
,po.[PurchaseOrderDateID]
,po.[PurchaseInvoiceDateID]
,po.[Company]
,po.[PurchaseOrderNum]
,po.[PurchaseOrderLine]
,po.[PurchaseOrderSubLine]
,po.[PurchaseOrderType]
,po.[PurchaseOrderDate]
,po.[PurchaseOrderStatus]
,po.[OrgReqDelivDate]
,po.[CommittedDelivDate]
,po.[CommittedShipDate]
,po.[ActualDelivDate]
,po.[ReqDelivDate]
,po.[PurchaseInvoiceNum]
,po.[PartNum]
,po.[SupplierNum]
,po.[SupplierPartNum]
,po.[SupplierInvoiceNum]
,po.[DelivCustomerNum]
,po.[PartStatus]
,po.[OrderQty]
,po.[ReceiveQty]
,po.[InvoiceQty]
,po.[MinOrderQty]
,po.[UoM]
,po.[UnitPrice]
,po.[DiscountPercent]
,po.[DiscountAmount]
,po.[ExchangeRate]
,po.[Currency]
,po.[PurchaserName]
,po.[WarehouseCode]
,po.[ReceivingNum]
,po.[DelivTime]
,po.[PurchaseChannel]
,po.[Documents]
,po.[Comments]
,po.[PORes1]
,po.[PORes2]
,po.[PORes3]
,po.[InvoiceStatus]
,po.[DaysSinceOrder]
,po.[OrgCommittedDelivDate]
,po.[IsOrderClosed]

FROM [dm].[FactPurchaseOrder] po
LEFT JOIN dbo.Company com ON po.Company = com.Company
WHERE com.BusinessArea = 'Lifting Solutions' AND com.[Status] = 'Active'
--WHERE Company  in ('AFISCM', 'CDKCERT', 'CEECERT', 'CFICERT', 'CLTCERT', 'CLVCERT', 'CSECERT', 'CUKCERT', 'CNOEHAU', 'CNOCERT', 'CERPL', 'CyESA', 'HFIHAKL', 'TRACLEV')  -- LS basket
GO
