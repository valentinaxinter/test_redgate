IF OBJECT_ID('[stage].[vFOR_SE_PurchaseInvoice]') IS NOT NULL
	DROP VIEW [stage].[vFOR_SE_PurchaseInvoice];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [stage].[vFOR_SE_PurchaseInvoice] AS
--COMMENT EMPTY FIELDS 
SELECT 
	CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM(Company), '#', TRIM(PurchaseOrderNum), '#', TRIM(PurchaseOrderLine), '#'
		,TRIM(PurchaseOrderSubLine), '#', TRIM(InvoiceNum), '#', TRIM(InvoiceLine))))) AS PurchaseInvoiceID 
	,UPPER(CONCAT(TRIM(Company),'#',TRIM(InvoiceNum), '#', TRIM(InvoiceLine), '#', PartNum)) AS PurchaseInvoiceCode
	,UPPER(CONCAT(TRIM(Company),'#',TRIM(PurchaseOrderNum))) AS PurchaseOrderNumCode
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM(Company), '#', TRIM(PurchaseOrderNum))))) AS PurchaseOrderNumID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM(Company), '#', TRIM(PurchaseOrderNum), '#', TRIM(PurchaseOrderLine), '#', TRIM(InvoiceNum))))) AS PurchaseOrderID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM(Company), '#', TRIM(SupplierCode))))) AS SupplierID
    ,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(TRIM(Company)))) AS CompanyID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM(Company), '#', TRIM(PartNum))))) AS PartID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM(Company), '#', TRIM(WarehouseCode))))) AS WarehouseID
	,CONVERT(int, replace(InvoiceDate,'-','')) AS PurchaseInvoiceDateID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM(Company), '#', TRIM(SupplierCode), '#', TRIM(InvoiceNum), '#', TRIM(PurchaseOrderNum), '#', TRIM(LastPaymentNum))))) AS PurchaseLedgerID --match PurchaseLedgerID in [vSCM_FI_PurchaseLedger]
	,UPPER(CONCAT(TRIM(Company), '#', TRIM(SupplierCode), '#', TRIM(PurchaseOrderNum), '#', TRIM(PurchaseOrderLine), '#', TRIM(PurchaseOrderSubLine) )) AS PurchaseOrderCode
	,PartitionKey

	,UPPER(TRIM(Company)) AS Company
	,UPPER(TRIM(SupplierCode)) AS SupplierNum
	,UPPER(TRIM(PartNum)) AS PartNum
	,UPPER(TRIM(PurchaseOrderNum)) AS PurchaseOrderNum
	,UPPER(TRIM(PurchaseOrderLine)) AS PurchaseOrderLine
	,UPPER(TRIM(PurchaseOrderSubLine)) AS PurchaseOrderSubLine
	,UPPER(TRIM(InvoiceNum)) AS PurchaseInvoiceNum
	,UPPER(TRIM(InvoiceLine)) AS PurchaseInvoiceLine
	,OrderType AS PurchaseOrderType
	,InvoiceType AS PurchaseInvoiceType
	,InvoiceDate AS PurchaseInvoiceDate
	,ActualDeliveryDate AS ActualDelivDate
	,PurchaseShipQty AS PurchaseInvoiceQty
	--,'' AS UoM
	,UnitPrice
	--,0 AS DiscountPercent
	,DiscountAmount
	,TotalMiscChrg
	--,0 AS VATAmount
	,ExchangeRate
	,CurrencyCode AS Currency
	,CreditMemo
	,PurchaserName
	,UPPER(TRIM(WarehouseCode)) AS WarehouseCode
	--,'' AS PurchaseChannel
	--,'' AS Comment
	--,'' AS PIRes1
	--,'' AS PIRes2
	--,'' AS PIRes3
	,LineType
	--,'' AS OrderDelivLineNum
FROM stage.FOR_SE_PurchaseInvoice

GROUP BY
	PartitionKey, Company, PurchaseOrderNum, InvoiceNum, SupplierCode, PartNum, PurchaseOrderLine, PurchaseOrderSubLine, PurchaseShipQty, UnitPrice, WarehouseCode,PurchaserName, InvoiceLine, InvoiceType, InvoiceDate, ActualDeliveryDate, TotalMiscChrg, CreditMemo, OrderType,DiscountAmount,CurrencyCode,ExchangeRate,LineType, LastPaymentNum --, OrderType, [Site], OrderDelivLineNum, , DiscountPercent, PurchaserName, InvoiceLine, InvoiceType, InvoiceDate, ActualDeliveryDate, TotalMiscChrg, CreditMemo
GO
