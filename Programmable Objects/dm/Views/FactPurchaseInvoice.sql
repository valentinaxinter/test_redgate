IF OBJECT_ID('[dm].[FactPurchaseInvoice]') IS NOT NULL
	DROP VIEW [dm].[FactPurchaseInvoice];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [dm].[FactPurchaseInvoice]
AS
SELECT CONVERT(BIGINT, PINV.[PurchaseInvoiceID]) AS PurchaseInvoiceID
	,CONVERT(BIGINT, PINV.CompanyID) AS CompanyID
	,CONVERT(BIGINT, PINV.SupplierID) AS SupplierID
	,CONVERT(BIGINT, PINV.PartID) AS PartID
	,CONVERT(BIGINT, PINV.WarehouseID) AS WarehouseID
	,CONVERT(BIGINT, PINV.PurchaseOrderNumID) AS PurchaseOrderNumID
	,CONVERT(BIGINT, PORD.[CurrencyID]) AS CurrencyID
	,CONVERT(BIGINT, PINV.[PurchaseInvoiceDateID]) AS PurchaseInvoiceDateID
	,PINV.Company
	,PINV.PurchaseOrderNum
	,PINV.PurchaseOrderLine
	,PORD.PurchaseOrderType
	,PINV.PurchaseInvoiceNum
	,PINV.PurchaseInvoiceLine
	,PINV.PurchaseInvoiceType
	,CASE WHEN PINV.PurchaseInvoiceDate = '' OR PINV.PurchaseInvoiceDate IS NULL THEN '1900-01-01' ELSE  PINV.PurchaseInvoiceDate END AS PurchaseInvoiceDate
	,CASE WHEN PINV.ActualDelivDate = '' OR PINV.ActualDelivDate IS NULL THEN '1900-01-01' ELSE  PINV.ActualDelivDate END AS ActualDelivDate
	,PINV.SupplierNum
	,PINV.PartNum
	,PINV.PurchaseInvoiceQty
	,PINV.UoM
	,PINV.UnitPrice
	,PINV.DiscountPercent
	,PINV.DiscountAmount
	,PINV.TotalMiscChrg
	,PINV.VATAmount
	,PINV.Currency
	,PINV.ExchangeRate
	,PINV.CreditMemo
	,PORD.PurchaserName
	,PINV.WarehouseCode
	,PINV.PurchaseChannel
	,PINV.Comment
	,PINV.PIRes1
	,PINV.PIRes2
	,PINV.PIRes3
	,PINV.PIRes4
	,PINV.PurchaseInvoiceAmountOC
	,CASE WHEN PORD.PurchaseOrderDate = '' OR PORD.PurchaseOrderDate IS NULL THEN '1900-01-01' ELSE  PORD.PurchaseOrderDate END AS PurchaseOrderDate
	,CASE WHEN PORD.ReqDelivDate = '' OR PORD.ReqDelivDate IS NULL THEN '1900-01-01' ELSE  PORD.ReqDelivDate END AS ReqDelivDate
	,CASE WHEN PORD.OrgReqDelivDate = '' OR PORD.OrgReqDelivDate IS NULL THEN '1900-01-01' ELSE  PORD.OrgReqDelivDate END AS OrgReqDelivDate
	,CASE WHEN PORD.CommittedDelivDate = '' OR PORD.CommittedDelivDate IS NULL THEN '1900-01-01' ELSE  PORD.CommittedDelivDate END AS CommittedDelivDate
	,CASE WHEN PORD.OrgCommittedDelivDate = '' OR PORD.OrgCommittedDelivDate IS NULL THEN '1900-01-01' ELSE  PORD.OrgCommittedDelivDate END AS OrgCommittedDelivDate
	,CASE WHEN PLED.PurchaseDueDate = '' OR PLED.PurchaseDueDate IS NULL THEN '1900-01-01' ELSE PLED.PurchaseDueDate END AS DueDate
	,CASE WHEN PLED.PurchaseLastPaymentDate = '' OR PLED.PurchaseLastPaymentDate IS NULL  THEN '1900-01-01' ELSE PLED.PurchaseLastPaymentDate END AS PaymentDate
	,CASE WHEN PLED.PurchaseLastPaymentDate = '1900-01-01' THEN 'Not Paid' WHEN PLED.PurchaseLastPaymentDate > '1900-01-01' THEN 'Paid'END AS InvoiceStatus FROM dw.PurchaseInvoice AS PINV
LEFT JOIN (
	SELECT PurchaseOrderCode --, PurchaseOrderLine --added PurchaseOrderLine for that aggregate at line level, not at order level by DZ 2023-06-27
		,MAX(PurchaseOrderDate) AS PurchaseOrderDate
		,MAX(ReqDelivDate) AS ReqDelivDate
		,MAX(OrgReqDelivDate) AS OrgReqDelivDate
		,MAX(CommittedDelivDate) AS CommittedDelivDate
		,MAX(PurchaseOrderType) AS PurchaseOrderType
		,MAX([CurrencyID]) AS CurrencyID
		,MAX(PurchaserName) AS PurchaserName
		,max(OrgCommittedDelivDate) as OrgCommittedDelivDate
	FROM dw.PurchaseOrder
	GROUP BY PurchaseOrderCode --, PurchaseOrderLine  --added PurchaseOrderLine for that aggregate at line level, not at order level by DZ 2023-06-27
	) AS PORD ON PINV.PurchaseOrderCode = PORD.PurchaseOrderCode --Added group by statement to protect against duplicate from join /SM 2021-09-23
LEFT JOIN dw.PurchaseLedger AS PLED ON PINV.PurchaseLedgerID = PLED.PurchaseLedgerID
WHERE PINV.is_deleted != 1 or PINV.is_deleted is null
	/*GROUP BY
	PINV.[PurchaseInvoiceID], PINV.PurchaseOrderNumID, PINV.CompanyID, PINV.SupplierID, PINV.PartID, PINV.Company, PINV.WarehouseID, PINV.PurchaseOrderNum, PINV.PurchaseOrderLine, PINV.PurchaseOrderType, PINV.PurchaseInvoiceNum, PINV.PurchaseInvoiceLine, 
	PINV.PurchaseInvoiceType, PINV.PurchaseInvoiceDate, PINV.ActualDelivDate, PINV.SupplierNum, PINV.PartNum, PINV.PurchaseInvoiceQty, PINV.UoM, PINV.UnitPrice, PINV.DiscountPercent, 
	PINV.DiscountAmount, PINV.TotalMiscChrg, PINV.VATAmount, PINV.Currency, PINV.ExchangeRate, PINV.CreditMemo, PINV.PurchaserName, PINV.WarehouseCode, PINV.PurchaseChannel, 
	PINV.PurchaseInvoiceDateID, PORD.PurchaseOrderType, PORD.ReqDelivDate, PORD.OrgReqDelivDate, PORD.CommittedDelivDate, PORD.PurchaseOrderDate, PORD.CurrencyID, PLED.DueDate, PLED.LastPaymentDate */
GO
