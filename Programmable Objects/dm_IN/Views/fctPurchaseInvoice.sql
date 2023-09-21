IF OBJECT_ID('[dm_IN].[fctPurchaseInvoice]') IS NOT NULL
	DROP VIEW [dm_IN].[fctPurchaseInvoice];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE VIEW [dm_IN].[fctPurchaseInvoice] AS
-- LS basket
SELECT 
 pinv.[PurchaseInvoiceID]
,pinv.[CompanyID]
,pinv.[SupplierID]
,pinv.[PartID]
,pinv.[WarehouseID]
,pinv.[PurchaseOrderNumID]
,pinv.[CurrencyID]
,pinv.[PurchaseInvoiceDateID]
,pinv.[Company]
,pinv.[PurchaseOrderNum]
,pinv.[PurchaseOrderLine]
,pinv.[PurchaseOrderType]
,pinv.[PurchaseInvoiceNum]
,pinv.[PurchaseInvoiceLine]
,pinv.[PurchaseInvoiceType]
,pinv.[PurchaseInvoiceDate]
,pinv.[ActualDelivDate]
,pinv.[SupplierNum]
,pinv.[PartNum]
,pinv.[PurchaseInvoiceQty]
,pinv.[UoM]
,pinv.[UnitPrice]
,pinv.[DiscountPercent]
,pinv.[DiscountAmount]
,pinv.[TotalMiscChrg]
,pinv.[VATAmount]
,pinv.[Currency]
,pinv.[ExchangeRate]
,pinv.[CreditMemo]
,pinv.[PurchaserName]
,pinv.[WarehouseCode]
,pinv.[PurchaseChannel]
,pinv.[Comment]
,pinv.[PIRes1]
,pinv.[PIRes2]
,pinv.[PIRes3]
,pinv.[PIRes4]
,pinv.[PurchaseInvoiceAmountOC]
,pinv.[PurchaseOrderDate]
,pinv.[ReqDelivDate]
,pinv.[OrgReqDelivDate]
,pinv.[CommittedDelivDate]
,pinv.[OrgCommittedDelivDate]
,pinv.[DueDate]
,pinv.[PaymentDate]
,pinv.[InvoiceStatus]
FROM dm.FactPurchaseInvoice pinv
LEFT JOIN dbo.Company com ON pinv.Company = com.Company
WHERE com.BusinessArea = 'Industrial Solutions' AND com.[Status] = 'Active'
GO
