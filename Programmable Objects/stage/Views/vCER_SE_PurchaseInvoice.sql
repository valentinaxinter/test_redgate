IF OBJECT_ID('[stage].[vCER_SE_PurchaseInvoice]') IS NOT NULL
	DROP VIEW [stage].[vCER_SE_PurchaseInvoice];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [stage].[vCER_SE_PurchaseInvoice] AS
--ADD TRIM() INTO SupplierID 23-01-23 VA // COMMENT EMPTY FIELDS
SELECT 
	--CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(Company, '#', TRIM(UPPER(SupplierCode)), '#', TRIM(PurchaseOrderNum), '#', TRIM(PurchaseOrderLine), '#', TRIM(PurchaseOrderSubLine), '#', OrderDelivLineNum, '#', TRIM(InvoiceNum), '#',TRIM(UPPER([PartNum])), '#',PurchaserName, '#', WarehouseCode, '#', ActualDeliveryDate, '#', UnitPrice, '#', PurchaseShipQty, '#', DiscountAmount, '#', TotalMiscChrg, '#', ExchangeRate)))) AS PurchaseInvoiceID 
	CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(Company, '#', TRIM(SupplierCode), '#', TRIM(OrderType), '#', TRIM(PurchaseOrderNum), '#', TRIM(PurchaseOrderLine), '#', TRIM(PurchaseOrderSubLine), '#', TRIM(InvoiceNum), '#', TRIM(PurchaseInvoiceLine), '#', TRIM([PartNum]), '#', TRIM(PurchaserName), '#', TRIM(WarehouseCode))))) AS PurchaseInvoiceID 
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(Company, '#', TRIM(PurchaseOrderNum))))) AS PurchaseOrderNumID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(Company, '#', TRIM(PurchaseOrderNum), '#', TRIM(PurchaseOrderLine), '#', TRIM(PurchaseOrderSubLine))))) AS PurchaseOrderID
	
	,UPPER(CONCAT(Company, '#', TRIM(SupplierCode), '#', TRIM(PurchaseOrderNum), '#', TRIM(PurchaseOrderLine), '#', TRIM(PurchaseOrderSubLine), '#', TRIM(InvoiceNum))) AS PurchaseOrderCode
	,UPPER(CONCAT(Company, '#', TRIM(SupplierCode), '#', TRIM(InvoiceNum))) AS PurchaseInvoiceCode --Redundant?

    ,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(TRIM(Company)))) AS CompanyID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM(Company), '#', TRIM(SupplierCode))))) AS SupplierID
	--,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(Company, '#', TRIM(SupplierCode))))) AS SupplierID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(Company, '#', TRIM([PartNum]))))) AS PartID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(Company, '#', TRIM(WarehouseCode))))) AS WarehouseID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(Company, '#', TRIM(SupplierCode), '#', TRIM(InvoiceNum))))) AS PurchaseLedgerID
	,CONVERT(int, replace(InvoiceDate, '-', '')) AS PurchaseInvoiceDateID --Redundant?
	,PartitionKey

	,UPPER(TRIM(Company)) AS Company
	,TRIM(PurchaseOrderNum) AS PurchaseOrderNum
	,TRIM(PurchaseOrderLine) AS PurchaseOrderLine
	,TRIM(PurchaseOrderSubLine) AS PurchaseOrderSubLine
	,(TRIM(OrderType)) AS PurchaseOrderType --MIN
	,TRIM(InvoiceNum) AS PurchaseInvoiceNum
	,TRIM(PurchaseInvoiceLine) AS PurchaseInvoiceLine
	,TRIM(InvoiceType) AS PurchaseInvoiceType
	,InvoiceDate AS PurchaseInvoiceDate
	,ActualDeliveryDate AS ActualDelivDate
	,TRIM(UPPER(SupplierCode)) AS SupplierNum
	,TRIM(UPPER([PartNum])) AS PartNum
	,PurchaseInvoiceQty --MAX
	--,'' AS UoM
	,UnitPrice
	,0 AS DiscountPercent
	,DiscountAmount
	,TotalMiscChrg
	,0 AS VATAmount
	,ExchangeRate
	,TRIM(CurrencyCode) AS Currency
	,TRIM(CreditMemo) AS CreditMemo
	,TRIM(PurchaserName) AS PurchaserName
	,TRIM(WarehouseCode) AS WarehouseCode
	--,'' AS PurchaseChannel
	--,'' AS Comment
	--,'' AS PIRes1
	--,'' AS PIRes2
	--,'' AS PIRes3
	,LineType
--	,TRIM(PurchaseOrderDelivLine) AS OrderDelivLineNum --

FROM stage.CER_SE_PurchaseInvoice

--GROUP BY
--	PartitionKey, Company, PurchaseOrderNum, InvoiceNum, SupplierCode, PartNum, PurchaserName, InvoiceLine, InvoiceType, InvoiceDate, ActualDeliveryDate, UnitPrice, DiscountAmount, TotalMiscChrg, CreditMemo, WarehouseCode, CurrencyCode, ExchangeRate, LineType, OrderDelivLineNum, PurchaseOrderLine , PurchaseOrderSubLine, PurchaseShipQty
GO
