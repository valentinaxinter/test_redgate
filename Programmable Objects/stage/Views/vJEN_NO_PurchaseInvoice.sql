IF OBJECT_ID('[stage].[vJEN_NO_PurchaseInvoice]') IS NOT NULL
	DROP VIEW [stage].[vJEN_NO_PurchaseInvoice];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [stage].[vJEN_NO_PurchaseInvoice] AS
--COMMENT EMPTY FIELDS // ADD TRIM() INTO WarehouseID,PartID 2022-12-22 VA
--ADD TRIM() INTO SupplierID 23-01-24 VA
SELECT 
	--CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(Company, '#', TRIM(PurchaseOrderNum), '#', TRIM(PurchaseOrderLine), '#', TRIM(InvoiceNum), '#', TRIM([PartNum]), '#', TRIM([PurchaserName]), '#', TRIM(OrderDelivLineNum), '#', TRIM(OrderType) )))) AS PurchaseInvoiceID
	CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(Company, '#', TRIM(SupplierCode), '#', TRIM(PurchaseOrderNum), '#', TRIM(PurchaseOrderLine), '#', TRIM(OrderType), '#', TRIM(InvoiceNum), '#', TRIM(InvoiceType), '#', TRIM(WarehouseCode))))) AS PurchaseInvoiceID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(Company, '#', TRIM(PurchaseOrderNum))))) AS PurchaseOrderNumID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(Company, '#', TRIM(PurchaseOrderNum), '#', TRIM(PurchaseOrderLine), '#', TRIM(PurchaseOrderSubLine), '#', TRIM(OrderType), '#', TRIM(InvoiceNum))))) AS PurchaseOrderID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM(Company), '#', TRIM(SupplierCode))))) AS SupplierID
	--,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(Company, '#', TRIM(SupplierCode))))) AS SupplierID
    ,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(Company))) AS CompanyID
	--,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(Company, '#', TRIM(PartNum))))) AS PartID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM(Company), '#', TRIM(PartNum))))) AS PartID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM(Company), '#', TRIM(WarehouseCode))))) AS WareHouseID
	--,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(Company, '#', TRIM(WarehouseCode))))) AS WareHouseID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(Company,'#', TRIM(SupplierCode), '#', TRIM(InvoiceNum))))) AS PurchaseLedgerID
	,CONVERT(int, replace(convert(date,InvoiceDate), '-', '')) AS PurchaseInvoiceDateID
	,UPPER(CONCAT(Company,'#',TRIM(InvoiceNum))) AS PurchaseInvoiceCode
	,UPPER(CONCAT(Company,'#',TRIM(SupplierCode),'#',TRIM(PurchaseOrderNum))) AS PurchaseOrderCode
	,PartitionKey

	,UPPER(Company) AS Company
	,TRIM(PurchaseOrderNum) AS PurchaseOrderNum
	,TRIM(PurchaseOrderLine) AS PurchaseOrderLine
	,TRIM(PurchaseOrderSubLine) AS PurchaseOrderSubLine
	,TRIM(OrderType) AS PurchaseOrderType
	,TRIM(InvoiceNum) AS PurchaseInvoiceNum
	,TRIM(InvoiceLine) AS PurchaseInvoiceLine
	,TRIM(InvoiceType) AS PurchaseInvoiceType
	,InvoiceDate AS PurchaseInvoiceDate
	,MAX(ActualDeliveryDate) AS ActualDelivDate
	,TRIM(UPPER(SupplierCode)) AS SupplierNum
	,TRIM(UPPER([PartNum])) AS PartNum
	,SUM(PurchaseInvoiceQty) AS PurchaseInvoiceQty
	--,'' AS UoM
	,AVG(UnitPrice) AS UnitPrice
	--,0 AS DiscountPercent
	,SUM(DiscountAmount) AS DiscountAmount
	,SUM(TotalMiscChrg) AS TotalMiscChrg
	--,0 AS VATAmount
	,AVG(ExchangeRate) AS ExchangeRate
	,TRIM(CurrencyCode) AS Currency
	,TRIM(CreditMemo) AS CreditMemo
	,TRIM(PurchaserName) AS PurchaserName
	,TRIM(WarehouseCode) AS WarehouseCode
	--,'' AS PurchaseChannel
	--,'' AS Comment
	--,'' AS PIRes1
	--,'' AS PIRes2
	--,'' AS PIRes3
	--,'' AS LineType
	--,'' AS OrderDelivLineNum --
FROM stage.JEN_NO_PurchaseInvoice

GROUP BY
	PartitionKey, Company, PurchaseOrderNum, InvoiceNum, SupplierCode, PartNum, PurchaseOrderLine, PurchaseOrderSubLine, PurchaserName, InvoiceLine, InvoiceType, InvoiceDate, CreditMemo, WarehouseCode, CurrencyCode, OrderType, PurchaseOrderLine
GO
