IF OBJECT_ID('[stage].[vWID_EE_PurchaseInvoice]') IS NOT NULL
	DROP VIEW [stage].[vWID_EE_PurchaseInvoice];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [stage].[vWID_EE_PurchaseInvoice] AS
--COMMENT EMPTY FIELDS // ADD TRIM()UPPER()INTO PartID 2022-12-23 VA
--ADD TRIM() UPPER() INTO SupplierID 23-01-24 VA
SELECT 
	CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT(Company, '#', TRIM(IndexKey)))) AS PurchaseInvoiceID
	,CONCAT(Company, '#', TRIM(SupplierCode), '#', TRIM(InvoiceNum)) AS PurchaseInvoiceCode
--	CONCAT(Company,'#',TRIM(SupplierCode),'#',TRIM(PurchaseOrderNum),'#',TRIM(PurchaseOrderLine)) AS PurchaseOrderCode
	,CONCAT(Company, '#', TRIM(SupplierCode), '#', TRIM(PurchaseOrderNum), '#', TRIM(PartNum), '#', TRIM(InvoiceNum)) AS PurchaseOrderCode
	,CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT(Company, '#', TRIM(PurchaseOrderNum)))) AS PurchaseOrderNumID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT(Company, '#', TRIM(PurchaseOrderNum), '#', TRIM(InvoiceNum)))) AS PurchaseOrderID
	--,CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT(Company, '#', TRIM(SupplierCode)))) AS SupplierID
	,CONVERT([binary](32), HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM(Company), '#', TRIM(SupplierCode))))) AS SupplierID
    ,CONVERT([binary](32), HASHBYTES('SHA2_256', Company)) AS CompanyID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM(Company), '#', TRIM(PartNum))))) AS PartID
	--,CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT(Company, '#', TRIM(PartNum)))) AS PartID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM([Company]), '#', TRIM([WarehouseCode]))))) AS WarehouseID
	,CONVERT(int, replace(convert(date, InvoiceDate), '-', '')) AS PurchaseInvoiceDateID
	,CONVERT([binary](32), HASHBYTES('SHA2_256',CONCAT(Company, '#', TRIM(SupplierCode), '#', TRIM(InvoiceNum), '#', TRIM(PurchaseOrderNum)))) AS PurchaseLedgerID
	,PartitionKey

	,Company
	,TRIM(PurchaseOrderNum) AS PurchaseOrderNum
	,TRIM(PurchaseOrderLine) AS PurchaseOrderLine
	,TRIM(PurchaseOrderSubLine) AS PurchaseOrderSubLine
	,TRIM(OrderType) AS PurchaseOrderType
	,TRIM(InvoiceNum) AS PurchaseInvoiceNum
	,InvoiceLine AS PurchaseInvoiceLine
	,InvoiceType AS PurchaseInvoiceType
	,InvoiceDate AS PurchaseInvoiceDate
	,ActualDeliveryDate AS ActualDelivDate
	,TRIM(SupplierCode) AS SupplierNum
	,TRIM(PartNum) AS PartNum
	,PurchaseShipQty AS PurchaseInvoiceQty
	--,NULL AS UoM
	,UnitPrice
	,DiscountAmount -- since it is invoiceed price, not listed price, so the discount should be zero
	,IIF(PurchaseShipQty*UnitPrice = 0, 0, DiscountAmount/(PurchaseShipQty*UnitPrice)) AS DiscountPercent -- since it is invoiceed price, not listed price, so the discount should be zero
	,TotalMiscChrg
	--,NULL AS VATAmount
	,Currency
	,ExchangeRate
	,TRIM(CreditMemo) AS CreditMemo
	,TRIM(PurchaserName) AS PurchaserName
	,TRIM(WarehouseCode) AS WarehouseCode
	,LineType AS PurchaseChannel
	--,'' AS Comment
	,IndexKey AS PIRes1
	,FullyShipp01 AS PIRes2
	,ReqDelivDate AS PIRes3
FROM stage.WID_EE_PurchaseInvoice

--GROUP BY
--	PartitionKey, Company, PurchaseOrderNum, InvoiceNum, SupplierCode, PartNum, OrderDelivLineNum, PurchaseOrderLine, PurchaseOrderSubLine, PurchaserName, InvoiceLine, InvoiceType, InvoiceDate, ActualDeliveryDate, PurchaseShipQty, UnitPrice, DiscountAmount, TotalMiscChrg, CreditMemo, WarehouseCode, Currency, ExchangeRate, OrderType, LineType, IndexKey, FullyShipp01, ReqDelivDate
  --, OrderType, [Site]
GO
