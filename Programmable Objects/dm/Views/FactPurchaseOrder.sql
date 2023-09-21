IF OBJECT_ID('[dm].[FactPurchaseOrder]') IS NOT NULL
	DROP VIEW [dm].[FactPurchaseOrder];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [dm].[FactPurchaseOrder]
AS
SELECT CONVERT(BIGINT, PORD.PurchaseOrderID) AS [PurchaseOrderID]
	,CONVERT(BIGINT, PORD.PurchaseOrderNumID) AS [PurchaseOrderNumID]
	,CONVERT(BIGINT, PORD.[PurchaseInvoiceID]) AS [PurchaseInvoiceID]
	,CONVERT(BIGINT, PORD.[CompanyID]) AS [CompanyID]
	,CONVERT(BIGINT, PORD.[SupplierID]) AS [SupplierID]
	,CONVERT(BIGINT, PORD.[CustomerID]) AS [CustomerID]
	,CONVERT(BIGINT, PORD.[PartID]) AS [PartID]
	,CONVERT(BIGINT, PORD.[WarehouseID]) AS [WarehouseID]
	,CONVERT(BIGINT, PORD.[CurrencyID]) AS [CurrencyID]
	,CONVERT(INT, replace(CONVERT(DATE, [PurchaseOrderDate]), '-', '')) AS PurchaseOrderDateID
	,CONVERT(INT, replace(CONVERT(DATE, [PurchaseInvoiceDate]), '-', '')) AS PurchaseInvoiceDateID
	,PORD.Company
	,TRIM(PORD.[PurchaseOrderNum]) AS [PurchaseOrderNum]
	,TRIM(PORD.[PurchaseOrderLine]) AS [PurchaseOrderLine]
	,PORD.[PurchaseOrderSubLine]
	,PORD.[PurchaseOrderType]
	,PORD.[PurchaseOrderDate]
	/*	,CASE WHEN NULLIF(TRIM(PORD.[PurchaseOrderStatus]),'') IS NULL THEN IIF(PORD.[PurchaseOrderQty] - PORD.[ReceiveQty] > 0, 'Open', 'Closed')  
			ELSE PORD.[PurchaseOrderStatus] END AS PurchaseOrderStatus			*/ --
	,CASE 
		WHEN PORD.[PurchaseOrderStatus] NOT IN ('Open', 'Closed', '1') THEN IIF(PORD.[PurchaseOrderQty] - PORD.[ReceiveQty] > 0, 'Open', 'Closed')
		WHEN PORD.IsClosed = '1' THEN 'Closed'
		ELSE PORD.[PurchaseOrderStatus]	END AS PurchaseOrderStatus
	,IIF(PORD.[OrgReqDelivDate] < '1900-01-01'
		OR PORD.[OrgReqDelivDate] IS NULL, '1900-01-01', PORD.[OrgReqDelivDate]) AS [OrgReqDelivDate]
	,IIF(PORD.[CommittedDelivDate] < '1900-01-01'
		OR PORD.[CommittedDelivDate] IS NULL, '1900-01-01', PORD.[CommittedDelivDate]) AS CommittedDelivDate
	,PORD.[CommittedShipDate]
	,PORD.ActualDelivDate
	,PORD.[ReqDelivDate]
	,PORD.[PurchaseInvoiceNum]
	,PORD.[PartNum]
	,PORD.[SupplierNum]
	,PORD.SupplierPartNum
	,PORD.[SupplierInvoiceNum]
	,PORD.[DelivCustomerNum]
	,PORD.[PartStatus]
	,PORD.[PurchaseOrderQty] AS [OrderQty]
	,PORD.[ReceiveQty]
	,PORD.[InvoiceQty]
	,PORD.MinOrderQty
	,PORD.[UoM]
	,PORD.[UnitPrice]
	,PORD.[DiscountPercent]
	,PORD.[DiscountAmount]
	,PORD.[ExchangeRate]
	,PORD.[Currency]
	,PORD.[PurchaserName]
	,PORD.[WarehouseCode]
	,PORD.[ReceivingNum]
	,PORD.[DelivTime]
	,PORD.[PurchaseChannel]
	,PORD.Documents
	,PORD.[Comments]
	,PORD.PORes1
	,PORD.PORes2
	,PORD.PORes3
	,CASE 
		WHEN PLED.[LastPaymentDate] = '1900-01-01'
			THEN 'Not Paid'
		WHEN PLED.[LastPaymentDate] > '1900-01-01'
			THEN 'Paid'
		END AS InvoiceStatus
	,DATEDIFF(day, [PurchaseOrderDate], GETDATE()) AS DaysSinceOrder
	,PORD.OrgCommittedDelivDate
	,PORD.IsClosed as IsOrderClosed --added 2023-06-12 SB. DW name needs to be changed to "IsOrderClosed".
FROM [dw].[PurchaseOrder] AS PORD
--LEFT JOIN dw.PurchaseLedger AS PLED  --Changed to the join below to avoid duplicates
LEFT JOIN (
	SELECT PurchaseOrderNumID
		,PurchaseInvoiceID
		,SupplierID
		,PurchaseInvoiceDate
		,MAX([PurchaseLastPaymentDate]) AS LastPaymentDate
	FROM dw.PurchaseLedger
	GROUP BY PurchaseOrderNumID
		,PurchaseInvoiceID
		,SupplierID
		,PurchaseInvoiceDate
	) AS PLED ON PORD.PurchaseOrderNumID = PLED.PurchaseOrderNumID
	AND PORD.PurchaseInvoiceID = PLED.PurchaseInvoiceID
	AND PORD.SupplierID = PLED.SupplierID
where PORD.is_deleted != 1 or PORD.is_deleted is null
GO
