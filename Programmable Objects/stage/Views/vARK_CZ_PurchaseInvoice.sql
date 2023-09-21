IF OBJECT_ID('[stage].[vARK_CZ_PurchaseInvoice]') IS NOT NULL
	DROP VIEW [stage].[vARK_CZ_PurchaseInvoice];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [stage].[vARK_CZ_PurchaseInvoice] AS

SELECT 
	CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM(Company), '#', TRIM(SupplierNum), '#', TRIM(PurchaseOrderNum), '#', TRIM(PurchaseOrderLine), '#', TRIM(PurchaseOrderSubLine), '#', TRIM(PurchaseInvoiceNum), '#', TRIM(PurchaseInvoiceLine), '#', TRIM(PartNum), '#', TRIM(WarehouseCode))))) AS PurchaseInvoiceID
	,UPPER(CONCAT(TRIM(Company),'#',TRIM(PurchaseInvoiceNum), '#', TRIM(PurchaseInvoiceLine), '#', PartNum)) AS PurchaseInvoiceCode
	,UPPER(CONCAT(TRIM(Company),'#',TRIM(PurchaseOrderNum))) AS PurchaseOrderNumCode
	,CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM(Company), '#', TRIM(PurchaseOrderNum))))) AS PurchaseOrderNumID
	,CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM(Company),'#',TRIM(PurchaseOrderNum),'#',TRIM(PurchaseOrderLine),'#',TRIM(PurchaseInvoiceNum))))) AS PurchaseOrderID
	,CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM(Company),'#',TRIM(SupplierNum))))) AS SupplierID
    ,CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(TRIM(Company)))) AS CompanyID
	,CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM(Company),'#',TRIM(PartNum))))) AS PartID
	,CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM(Company),'#',TRIM(WarehouseCode))))) AS WarehouseID
	,CONVERT(int, replace(PurchaseInvoiceDate,'-','')) AS PurchaseInvoiceDateID
	,CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM(Company),'#', TRIM(SupplierNum), '#', TRIM(PurchaseInvoiceNum),'#',TRIM(PurchaseOrderNum))))) AS PurchaseLedgerID --match PurchaseLedgerID in [vSCM_FI_PurchaseLedger]
	,UPPER(CONCAT(TRIM(Company),'#',TRIM(SupplierNum),'#',TRIM(PurchaseOrderNum), '#', TRIM(PurchaseOrderLine))) AS PurchaseOrderCode
	,PartitionKey

	,UPPER(TRIM(Company)) AS Company
	,CASE WHEN UPPER(TRIM(PurchaseOrderNum)) IS NULL AND UPPER(TRIM(PartNum)) = '-NULL-' THEN 'ServiceOrder' ELSE UPPER(TRIM(PurchaseOrderNum)) END AS PurchaseOrderNum --UPPER(TRIM(PurchaseOrderNum))
	,UPPER(TRIM(PurchaseOrderLine)) AS PurchaseOrderLine
	,UPPER(TRIM(PurchaseOrderSubLine)) AS PurchaseOrderSubLine
	,CASE WHEN UPPER(TRIM(PurchaseOrderType)) IS NULL AND UPPER(TRIM(PartNum)) = '-NULL-' THEN 'Service' ELSE UPPER(TRIM(PurchaseOrderType)) END AS PurchaseOrderType
	,UPPER(TRIM(PurchaseInvoiceNum)) AS PurchaseInvoiceNum
	,UPPER(TRIM(PurchaseInvoiceLine)) AS PurchaseInvoiceLine
	,PurchaseInvoiceType
	,PurchaseInvoiceDate
	,ActualDelivDate
	,UPPER(TRIM(SupplierNum)) AS SupplierNum
--	,UPPER(TRIM(PartNum)) AS PartNum
	,CASE WHEN UPPER(TRIM(PartNum)) = '-NULL-' AND UPPER(TRIM(PurchaseOrderNum)) IS NULL THEN 'ServicePurchase' ELSE UPPER(TRIM(PartNum)) END AS PartNum
	,PurchaseInvoiceQty
	,CASE WHEN UPPER(TRIM(UoM)) = '-NULL-' AND UPPER(TRIM(PurchaseOrderNum)) IS NULL THEN 'Unit' ELSE UPPER(TRIM(UoM)) END AS UoM
	,UnitPrice
	,DiscountPercent
	,DiscountAmount
	,TotalMiscChrg
	,VATAmount
	,ExchangeRate
	,Currency
	,CreditMemo
	,PurchaserName
	,UPPER(TRIM(WarehouseCode)) AS WarehouseCode
	,PurchaseChannel
	,PIRes1
	,PIRes2
	,PIRes3
	,'' AS LineType
	,'' AS OrderDelivLineNum
	,Comment
FROM stage.ARK_CZ_PurchaseInvoice
--WHERE PurchaseInvoiceDate >= DATEADD(year, -1, GETDATE()) --Added this where clause as semi-incremental load functinoality since it doesn't work easily on meta-param table. /SM 2021-10-01
--GROUP BY
--	PartitionKey, Company, PurchaseOrderNum, PurchaseInvoiceNum, SupplierNum, PartNum, PurchaseOrderLine, PurchaseOrderSubLine, PurchaseInvoiceQty, UnitPrice, WarehouseCode,PurchaserName, PurchaseInvoiceLine, PurchaseInvoiceType, PurchaseInvoiceDate, ActualDelivDate, TotalMiscChrg, CreditMemo, PurchaseOrderType, DiscountPercent, DiscountAmount,Currency, ExchangeRate, UoM, VATAmount, PurchaseChannel, PIRes1, PIRes2, PIRes3, Comment --, OrderType, [Site], OrderDelivLineNum, , DiscountPercent, PurchaserName, InvoiceLine, InvoiceType, InvoiceDate, ActualDeliveryDate, TotalMiscChrg, CreditMemo
GO
