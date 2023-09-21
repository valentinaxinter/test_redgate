IF OBJECT_ID('[dm_ALL].[fctPurchaseInvoice]') IS NOT NULL
	DROP VIEW [dm_ALL].[fctPurchaseInvoice];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [dm_ALL].[fctPurchaseInvoice] AS

SELECT 
 [PurchaseInvoiceID]
,[CompanyID]
,[SupplierID]
,[PartID]
,[WarehouseID]
,[PurchaseOrderNumID]
,[CurrencyID]
,[PurchaseInvoiceDateID]
,[Company]
,[PurchaseOrderNum]
,[PurchaseOrderLine]
,[PurchaseOrderType]
,[PurchaseInvoiceNum]
,[PurchaseInvoiceLine]
,[PurchaseInvoiceType]
,[PurchaseInvoiceDate]
,[ActualDelivDate]
,[SupplierNum]
,[PartNum]
,[PurchaseInvoiceQty]
,[UoM]
,[UnitPrice]
,[DiscountPercent]
,[DiscountAmount]
,[TotalMiscChrg]
,[VATAmount]
,[Currency]
,[ExchangeRate]
,[CreditMemo]
,[PurchaserName]
,[WarehouseCode]
,[PurchaseChannel]
,[Comment]
,[PIRes1]
,[PIRes2]
,[PIRes3]
,[PIRes4]
,[PurchaseInvoiceAmountOC]
,[PurchaseOrderDate]
,[ReqDelivDate]
,[OrgReqDelivDate]
,[CommittedDelivDate]
,[OrgCommittedDelivDate]
,[DueDate]
,[PaymentDate]
,[InvoiceStatus]
FROM dm.FactPurchaseInvoice
GO
