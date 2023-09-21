IF OBJECT_ID('[stage].[vJEN_NB_PurchaseInvoice]') IS NOT NULL
	DROP VIEW [stage].[vJEN_NB_PurchaseInvoice];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [stage].[vJEN_NB_PurchaseInvoice] AS
--ADD TRIM() INTO SupplierID 23-01-24 VA
SELECT 
	--CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(Company, '#', TRIM(PurchaseOrderNum), '#', TRIM(PurchaseOrderLine), '#', TRIM(InvoiceNum), '#', PurchaseShipQty, '#', ActualDeliveryDate, '#', TRIM([PartNum]) )))) AS PurchaseInvoiceID
	CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(Company, '#', TRIM(PurchaseOrderNum), '#', TRIM(PurchaseOrderLine), '#', TRIM(InvoiceNum), '#', TRIM([PartNum]) )))) AS PurchaseInvoiceID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(Company, '#', TRIM(PurchaseOrderNum))))) AS PurchaseOrderNumID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(Company, '#', TRIM(PurchaseOrderNum), '#', TRIM(PurchaseOrderLine), '#', TRIM(PurchaseOrderSubLine))))) AS PurchaseOrderID
	,UPPER(CONCAT(Company, '#', TRIM(SupplierCode), '#', TRIM(PurchaseOrderNum), '#', TRIM(PurchaseOrderLine))) AS PurchaseOrderCode
	,UPPER(CONCAT(Company, '#', TRIM(SupplierCode), '#', TRIM(InvoiceNum))) AS PurchaseInvoiceCode
    ,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(Company))) AS CompanyID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM(Company), '#', TRIM(SupplierCode))))) AS SupplierID
	--,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(Company, '#', TRIM(SupplierCode))))) AS SupplierID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(Company, '#', TRIM([PartNum]))))) AS PartID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(Company, '#', TRIM(WarehouseCode))))) AS WarehouseID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(Company, '#', TRIM(SupplierCode), '#', TRIM(InvoiceNum))))) AS PurchaseLedgerID
	,CONVERT(int, replace(InvoiceDate, '-', '')) AS PurchaseInvoiceDateID 
	,PartitionKey

	,UPPER(Company) AS Company
	,UPPER(TRIM([PartNum])) AS PartNum
	,UPPER(TRIM(SupplierCode)) AS SupplierNum
	,TRIM(PurchaseOrderNum) AS PurchaseOrderNum
	,TRIM(PurchaseOrderLine) AS PurchaseOrderLine
	,TRIM(PurchaseOrderSubLine) AS PurchaseOrderSubLine
	--,MIN(TRIM(OrderType)) AS PurchaseOrderType
	,TRIM(OrderType) AS PurchaseOrderType
	,TRIM(InvoiceNum) AS PurchaseInvoiceNum
	,InvoiceLine AS PurchaseInvoiceLine
	,InvoiceType AS PurchaseInvoiceType
	,InvoiceDate AS PurchaseInvoiceDate
	,MAX(ActualDeliveryDate) AS ActualDelivDate -- have to be sum/max/AVG because of partial deliveries
	--,MAX(PurchaseInvoiceQty) AS PurchaseInvoiceQty
	,SUM(PurchaseInvoiceQty) AS PurchaseInvoiceQty -- have to be sum/max/AVG because of partial deliveries
	,'' AS UoM
	,UnitPrice
	,NULL AS DiscountPercent
	,DiscountAmount
	,TotalMiscChrg
	,NULL AS VATAmount
	,AVG(ExchangeRate) AS ExchangeRate -- have to be sum/max/AVG because of partial deliveries
	,CurrencyCode AS Currency
	,TRIM(CreditMemo) AS CreditMemo
	,TRIM(PurchaserName) AS PurchaserName
	,TRIM(WarehouseCode) AS WarehouseCode
	,'' AS PurchaseChannel
	,'' AS Comment
	,'' AS PIRes1
	,'' AS PIRes2
	,'' AS PIRes3
	,LineType
	,'' AS OrderDelivLineNum --
FROM stage.JEN_NB_PurchaseInvoice

GROUP BY
	PartitionKey, Company, PurchaseOrderNum, InvoiceNum, SupplierCode, PartNum, PurchaserName, InvoiceLine, InvoiceType, InvoiceDate, UnitPrice, DiscountAmount, TotalMiscChrg, CreditMemo, WarehouseCode, CurrencyCode, LineType, PurchaseOrderLine , PurchaseOrderSubLine, OrderType
GO
