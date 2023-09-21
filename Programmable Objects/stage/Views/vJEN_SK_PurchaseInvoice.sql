IF OBJECT_ID('[stage].[vJEN_SK_PurchaseInvoice]') IS NOT NULL
	DROP VIEW [stage].[vJEN_SK_PurchaseInvoice];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [stage].[vJEN_SK_PurchaseInvoice] AS
--COMMENT empty fields // ADD TRIM()INTO PartID,WarehouseID 2022-12-13 VA
--ADD TRIM() INTO SupplierID 23-01-24 VA
SELECT 
	CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(Company, '#', TRIM(SupplierCode), '#', TRIM(PurchaseOrderNum), '#', TRIM(PurchaseOrderLine), '#', TRIM(OrderType), '#', TRIM(InvoiceNum), '#', TRIM(InvoiceType), '#', TRIM(WarehouseCode))))) AS PurchaseInvoiceID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(Company, '#', TRIM(PurchaseOrderNum))))) AS PurchaseOrderNumID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(Company, '#', TRIM(PurchaseOrderNum), '#', TRIM(PurchaseOrderLine), '#', TRIM(PurchaseOrderSubLine))))) AS PurchaseOrderID
	,UPPER(CONCAT(Company, '#', TRIM(SupplierCode), '#', TRIM(PurchaseOrderNum), '#', TRIM(PurchaseOrderLine))) AS PurchaseOrderCode
	,UPPER(CONCAT(Company, '#', TRIM(SupplierCode), '#', TRIM(InvoiceNum))) AS PurchaseInvoiceCode --Redundant?
    ,CONVERT([binary](32), HASHBYTES('SHA2_256', TRIM(Company))) AS CompanyID
	--,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(Company, '#', TRIM(SupplierCode))))) AS SupplierID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM(Company), '#', TRIM(SupplierCode))))) AS SupplierID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM(Company), '#', TRIM([PartNum]))))) AS PartID
	--,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(Company, '#', TRIM([PartNum]))))) AS PartID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM(Company), '#', TRIM(WarehouseCode))))) AS WarehouseID
	--,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(Company, '#', TRIM(WarehouseCode))))) AS WarehouseID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(Company, '#', TRIM(SupplierCode), '#', TRIM(InvoiceNum))))) AS PurchaseLedgerID
	,CONVERT(int, replace(InvoiceDate, '-', '')) AS PurchaseInvoiceDateID --Redundant?
	,PartitionKey

	,TRIM(UPPER(Company)) AS Company
	,TRIM(PurchaseOrderNum) AS PurchaseOrderNum
	,TRIM(PurchaseOrderLine) AS PurchaseOrderLine
	,TRIM(PurchaseOrderSubLine) AS PurchaseOrderSubLine
	,(TRIM(OrderType)) AS PurchaseOrderType --MIN
	,TRIM(InvoiceNum) AS PurchaseInvoiceNum
	,InvoiceLine AS PurchaseInvoiceLine
	,InvoiceType AS PurchaseInvoiceType
	,InvoiceDate AS PurchaseInvoiceDate
	,MAX(ActualDeliveryDate) AS ActualDelivDate
	,TRIM(UPPER(SupplierCode)) AS SupplierNum
	,TRIM(UPPER([PartNum])) AS PartNum
	,SUM(PurchaseInvoiceQty) AS PurchaseInvoiceQty --MAX(PurchaseShipQty)
	--,'' AS UoM
	,AVG(UnitPrice) AS UnitPrice
	--,0 AS DiscountPercent
	,SUM(DiscountAmount) AS DiscountAmount
	,SUM(TotalMiscChrg) AS TotalMiscChrg
	--,0 AS VATAmount
	,AVG(ExchangeRate) AS ExchangeRate
	,CurrencyCode AS Currency
	,TRIM(CreditMemo) AS CreditMemo
	,TRIM(PurchaserName) AS PurchaserName
	,TRIM(WarehouseCode) AS WarehouseCode
	--,'' AS PurchaseChannel
	--,'' AS Comment
	--,'' AS PIRes1
	--,'' AS PIRes2
	--,'' AS PIRes3
	,LineType
	--,'' AS OrderDelivLineNum --
FROM stage.JEN_SK_PurchaseInvoice

GROUP BY
	PartitionKey, Company, PurchaseOrderNum, InvoiceNum, SupplierCode, PartNum, PurchaserName, InvoiceLine, InvoiceType, InvoiceDate, CreditMemo, WarehouseCode, CurrencyCode, LineType, PurchaseOrderLine , PurchaseOrderSubLine, OrderType
GO
