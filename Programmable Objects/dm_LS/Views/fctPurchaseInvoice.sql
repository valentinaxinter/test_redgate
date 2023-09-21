IF OBJECT_ID('[dm_LS].[fctPurchaseInvoice]') IS NOT NULL
	DROP VIEW [dm_LS].[fctPurchaseInvoice];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [dm_LS].[fctPurchaseInvoice] AS
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
WHERE com.BusinessArea = 'Lifting Solutions' AND com.[Status] = 'Active'
--It is a dynamic Company addition in the sub-dataset in a way that so long a company is added in its parent dataset, this company will automatically appear in its assigend Business Area sub-dataset.
--This company addtion should in its first hand appear in the dbo.Company with correct attributes.

--WHERE Company in ('AFISCM', 'CDKCERT', 'CEECERT','CERDE', 'CFICERT', 'CLTCERT', 'CLVCERT', 'CSECERT', 'CUKCERT', 'CNOEHAU', 'CNOCERT', 'CyESA', 'HFIHAKL', 'TRACLEV','MENBE14','MENNL01','MENNL02','MENNL03','MENNL04','MENNL07','MENNL11')  --and PurchaseOrderType <> 'Backorder' -- don't know/remember why BackOrder is excluded before changes time 20210604 /DZ
GO
