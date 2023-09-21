IF OBJECT_ID('[dm_PT].[fctPurchaseInvoice]') IS NOT NULL
	DROP VIEW [dm_PT].[fctPurchaseInvoice];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [dm_PT].[fctPurchaseInvoice] AS

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
FROM [dm].[FactPurchaseInvoice] pinv
LEFT JOIN dbo.Company com ON pinv.Company = com.Company
WHERE com.BusinessArea = 'Power Transmission Solutions' AND com.[Status] = 'Active'


--WHERE [Company] in ('ACZARKOV', 'AcornUK', 'BSIBELL', 'JDKJENSS', 'JDKKALTE', 'JFIJENSS', 'MNLMAK', 'JNOJENSS', 'JNOORBEL', 'JSEJENSS', 'JSESKSSW', 'NORNO', 'SSWSE', 'NomoSE', 'NomoDK', 'NomoFI', 'NomoNo', 'PASSEROT', 'SKSSCOFI', 'SCOFI', 'SMKFI', 'SNLSPRUI', 'SVESE')  -- The PT basket --
GO
