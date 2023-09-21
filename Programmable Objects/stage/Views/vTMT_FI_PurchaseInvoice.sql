IF OBJECT_ID('[stage].[vTMT_FI_PurchaseInvoice]') IS NOT NULL
	DROP VIEW [stage].[vTMT_FI_PurchaseInvoice];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [stage].[vTMT_FI_PurchaseInvoice] AS
--ADD TRIM() INTO SupplierID 23-01-24 VA
SELECT 
	CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(Company, '#', TRIM(PurchaseOrderNum), '#', TRIM(PurchaseOrderLine), '#', TRIM(PurchaseInvoiceNum), '#', TRIM(PurchaseInvoiceLine), '#', TRIM(PartNum) )))) AS PurchaseInvoiceID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(Company, '#', TRIM(PurchaseOrderNum))))) AS PurchaseOrderNumID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(Company, '#', TRIM(PurchaseOrderNum), '#', TRIM(PurchaseOrderLine), '#', TRIM(PurchaseOrderSubLine))))) AS PurchaseOrderID
	,UPPER(CONCAT(Company, '#', TRIM(SupplierNum), '#', TRIM(PurchaseOrderNum), '#', TRIM(PurchaseOrderLine))) AS PurchaseOrderCode
	,UPPER(CONCAT(Company, '#', TRIM(SupplierNum), '#', TRIM(PurchaseInvoiceNum))) AS PurchaseInvoiceCode 
    ,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(Company))) AS CompanyID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM(Company), '#', TRIM(SupplierNum))))) AS SupplierID
	--,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(Company, '#', TRIM(SupplierNum))))) AS SupplierID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM(Company), '#', TRIM(PartNum))))) AS PartID
	--,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(Company, '#', TRIM(PartNum))))) AS PartID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM(Company), '#', TRIM(WarehouseCode))))) AS WarehouseID
	--,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(Company, '#', TRIM(WarehouseCode))))) AS WarehouseID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(Company, '#', TRIM(SupplierNum), '#', TRIM(PurchaseInvoiceNum))))) AS PurchaseLedgerID
	,CONVERT(int, replace(PurchaseInvoiceDate, '-', '')) AS PurchaseInvoiceDateID 
	,PartitionKey

	,UPPER(Company) AS Company
	,UPPER(TRIM(PartNum)) AS PartNum
	,UPPER(TRIM(SupplierNum)) AS SupplierNum
	,TRIM(PurchaseOrderNum) AS PurchaseOrderNum
	,TRIM(PurchaseOrderLine) AS PurchaseOrderLine
	,TRIM(PurchaseOrderSubLine) AS PurchaseOrderSubLine
	,(TRIM(PurchaseOrderType)) AS PurchaseOrderType --MIN
	,TRIM(PurchaseInvoiceNum) AS PurchaseInvoiceNum
	,PurchaseInvoiceLine
	,PurchaseInvoiceType
	,PurchaseInvoiceDate
	,ActualDelivDate
	,PurchaseInvoiceQty
	,UoM
	,IIF(PurchaseInvoiceQty = 0, UnitPrice, (UnitPrice*PurchaseInvoiceQty-TransportFee)/PurchaseInvoiceQty) AS UnitPrice -- ref invoicenum = 23070
	,DiscountPercent
	,DiscountAmount
	,(TotalMiscChrg * (1/ExchangeRate)) AS TotalMiscChrg -- Is always originally in EUR, has been converted to invoiced currency SB 2023-02-10
	,VATAmount
	,IIF(ExchangeRate = 0, 0, 1/ExchangeRate) AS ExchangeRate --AS 
	,Currency
	,TRIM(CreditMemo) AS CreditMemo
	,TRIM(PurchaserName) AS PurchaserName
	,TRIM(WarehouseCode) AS WarehouseCode
	,PurchaseChannel
	,Comment
	,[Version] AS PIRes1
	,PIRes2
	,TransportFee AS PIRes4 -- Always in invoiced currency.added to numeric extra field 2023-03-16 SB

FROM stage.TMT_FI_PurchaseInvoice
--GROUP BY
--	PartitionKey, Company, PurchaseOrderNum, InvoiceNum, SupplierCode, PartNum, PurchaserName, InvoiceLine, InvoiceType, InvoiceDate, ActualDeliveryDate, UnitPrice, DiscountAmount, TotalMiscChrg, CreditMemo, WarehouseCode, CurrencyCode, ExchangeRate, LineType, OrderDelivLineNum, PurchaseOrderLine , PurchaseOrderSubLine, PurchaseShipQty
GO
