IF OBJECT_ID('[stage].[vJEN_SE_PurchaseInvoice]') IS NOT NULL
	DROP VIEW [stage].[vJEN_SE_PurchaseInvoice];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [stage].[vJEN_SE_PurchaseInvoice] AS
--COMMENT EMPTY FIELD / ADD TRIM() INTO PartID,WarehouseID 2022-12-19 VA
SELECT 
	CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(Company, '#', TRIM(SupplierNum), '#', TRIM(InvoiceNum), '#', TRIM(InvoiceLine), '#', TRIM(InvoiceType), '#', TRIM(PurchaseOrderNum), '#', TRIM(PurchaseOrderLine), '#', TRIM(OrderType), '#', TRIM(PartNum) )))) AS PurchaseInvoiceID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(Company, '#', TRIM(PurchaseOrderNum))))) AS PurchaseOrderNumID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(Company, '#', TRIM(PurchaseOrderNum), '#', TRIM(PurchaseOrderLine))))) AS PurchaseOrderID --, '#', TRIM(PurchaseOrderSubLine)
	,UPPER(CONCAT(Company, '#', TRIM(SupplierNum), '#', TRIM(PurchaseOrderNum))) AS PurchaseOrderCode
	,UPPER(CONCAT(Company, '#', TRIM(SupplierNum), '#', TRIM(InvoiceNum))) AS PurchaseInvoiceCode
    ,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(Company))) AS CompanyID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM(Company), '#', TRIM(SupplierNum))))) AS SupplierID
	--,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(Company, '#', TRIM(SupplierCode))))) AS SupplierID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM(Company), '#', TRIM([PartNum]))))) AS PartID
	--,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(Company, '#', TRIM([PartNum]))))) AS PartID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM(Company), '#', TRIM(WarehouseCode))))) AS WarehouseID
	--,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(Company, '#', TRIM(WarehouseCode))))) AS WarehouseID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(Company, '#', TRIM(SupplierNum), '#', TRIM(InvoiceNum))))) AS PurchaseLedgerID
	,CONVERT(int, replace(InvoiceDate, '-', '')) AS PurchaseInvoiceDateID 
	,PartitionKey

	,UPPER(Company) AS Company
	,UPPER(TRIM([PartNum])) AS PartNum
	,UPPER(TRIM(SupplierNum)) AS SupplierNum
	,TRIM(PurchaseOrderNum) AS PurchaseOrderNum
	,TRIM(PurchaseOrderLine) AS PurchaseOrderLine
	,'' AS PurchaseOrderSubLine 
	,(TRIM(OrderType)) AS PurchaseOrderType --MIN
	,TRIM(InvoiceNum) AS PurchaseInvoiceNum
	,InvoiceLine AS PurchaseInvoiceLine
	,InvoiceType AS PurchaseInvoiceType
	,InvoiceDate AS PurchaseInvoiceDate
	,MAX(ActualDeliveryDate) AS ActualDelivDate
--	,IIF(TRIM(InvoiceNum) = '9783531' AND TRIM([PartNum]) = 'Q18008MCXPIII50', 0, MAX(PurchaseShipQty)) AS PurchaseInvoiceQty -- accumulated qty therefore max; --exclude outlier after meeting with Christoffer & Sam 20230214, actually the economic report says 12 pcs or 24 642 EUR for this line)
	--,'' AS UoM
	,SUM(PurchaseInvoiceQty) AS PurchaseInvoiceQty -- was deliveredQTY earlier
	,AVG(UnitPrice) AS UnitPrice
	--,0 AS DiscountPercent
	,(IIF(SUM(PurchaseInvoiceQty) < 0, -1*ABS(SUM(DiscountAmount)), ABS(SUM(DiscountAmount)))) AS DiscountAmount
	,(IIF(SUM(PurchaseInvoiceQty) < 0, -1*ABS(SUM(TotalMiscChrg)), ABS(SUM(TotalMiscChrg)))) AS TotalMiscChrg --SUM
	--,0 AS VATAmount
	,AVG(ExchangeRate) AS ExchangeRate
	,CurrencyCode AS Currency
	,IIF(SUM(PurchaseInvoiceQty) < 0, 1, 0) AS CreditMemo -- was 0 berfore 20230214; according Christoffer, not credit tran in JensS SE/DK /DZ
	,TRIM(PurchaserName) AS PurchaserName
	,TRIM(WarehouseCode) AS WarehouseCode
	--,'' AS PurchaseChannel
	--,'' AS Comment
	--,'' AS PIRes1
	--,'' AS PIRes2
	--,'' AS PIRes3
	,LineType
--	,TRIM(OrderDelivLineNum) AS OrderDelivLineNum --
FROM stage.JEN_SE_PurchaseInvoice

GROUP BY
	PartitionKey, Company, PurchaseOrderNum, InvoiceNum, SupplierNum, PartNum, PurchaserName, InvoiceLine, InvoiceType, InvoiceDate, CreditMemo, WarehouseCode, CurrencyCode, LineType, PurchaseOrderLine, OrderType -- , TotalMiscChrg, PurchaseInvoiceQty, ExchangeRateUnitPrice, DiscountAmount, ActualDeliveryDate
GO
