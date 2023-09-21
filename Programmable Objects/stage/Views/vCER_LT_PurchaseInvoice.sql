IF OBJECT_ID('[stage].[vCER_LT_PurchaseInvoice]') IS NOT NULL
	DROP VIEW [stage].[vCER_LT_PurchaseInvoice];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [stage].[vCER_LT_PurchaseInvoice] AS
--COMMENT EMPTY FIELDS 2022-12-14 VA
SELECT 
	--CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM(Company),'#',TRIM(SupplierNum),'#',TRIM(PurchaseOrderNum),'#',TRIM(PurchaseOrderLine),'#'
	--	,TRIM(PurchaseOrderSubLine),'#',TRIM(PurchaseInvoiceNum), '#', PartNum, '#', UnitPrice, '#', DiscountAmount
	--	, '#', PurchaseInvoiceQty, '#', ActualDelivDate, '#', TRIM(WarehouseCode))))) AS PurchaseInvoiceID --'#', PurchaseOrderType
	CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM(Company), '#', TRIM(SupplierNum), '#', TRIM(PurchaseOrderNum), '#', TRIM(PurchaseOrderLine), '#'
		,TRIM(PurchaseOrderSubLine), '#', TRIM(PurchaseInvoiceNum), '#', TRIM(PurchaseInvoiceLine), '#', TRIM(PartNum), '#', TRIM(WarehouseCode))))) AS PurchaseInvoiceID 
	,UPPER(CONCAT(TRIM(Company),'#',TRIM(PurchaseInvoiceNum), '#', PartNum)) AS PurchaseInvoiceCode
	,UPPER(CONCAT(TRIM(Company),'#',TRIM(PurchaseOrderNum))) AS PurchaseOrderNumCode
	,CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM(Company), '#', TRIM(PurchaseOrderNum))))) AS PurchaseOrderNumID
	,CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM(Company),'#',TRIM(PurchaseOrderNum),'#',TRIM(PurchaseOrderLine),'#',TRIM(PurchaseInvoiceNum))))) AS PurchaseOrderID
	,CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM(Company),'#',TRIM(SupplierNum))))) AS SupplierID
    ,CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(TRIM(Company)))) AS CompanyID
	,CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM(Company),'#',TRIM(PartNum))))) AS PartID
	,CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM(Company),'#',TRIM(WarehouseCode))))) AS WarehouseID
	,CONVERT(int, replace(PurchaseInvoiceDate,'-','')) AS PurchaseInvoiceDateID
	,CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM(Company),'#', TRIM(SupplierNum), '#', TRIM(PurchaseInvoiceNum),'#',TRIM(PurchaseOrderNum))))) AS PurchaseLedgerID --match PurchaseLedgerID in [vSCM_FI_PurchaseLedger]
	,UPPER(CONCAT(TRIM(Company),'#',TRIM(SupplierNum),'#',TRIM(PurchaseOrderNum))) AS PurchaseOrderCode
	,PartitionKey

	,UPPER(TRIM(Company)) AS Company
	,UPPER(TRIM(PurchaseOrderNum)) AS PurchaseOrderNum
	,UPPER(TRIM(PurchaseOrderLine)) AS PurchaseOrderLine
	,UPPER(TRIM(PurchaseOrderSubLine)) AS PurchaseOrderSubLine
	,PurchaseOrderType
	,UPPER(TRIM(PurchaseInvoiceNum)) AS PurchaseInvoiceNum
	,PurchaseInvoiceLine -- deliv line
	--,'' AS PurchaseInvoiceType
	,PurchaseInvoiceDate
	,ActualDelivDate
	,UPPER(TRIM(SupplierNum)) AS SupplierNum
	,UPPER(TRIM(PartNum)) AS PartNum
	,PurchaseInvoiceQty
	--,'' AS UoM
	,UnitPrice
	--,0 AS DiscountPercent
	,DiscountAmount
	,TotalMiscChrg
	--,0 AS VATAmount
	,Currency
	,ExchangeRate
	--,'' AS CreditMemo
	,PurchaserName
	,UPPER(TRIM(WarehouseCode)) AS WarehouseCode
	--,'' AS PurchaseChannel
	--,'' AS Comment
	--,'' AS PIRes1
	--,'' AS PIRes2
	--,'' AS PIRes3
	--,'' AS OrderDelivLineNum
FROM stage.CER_LT_PurchaseInvoice

--GROUP BY
--	PartitionKey, Company, PurchaseOrderNum, PurchaseInvoiceNum, SupplierNum, PartNum, PurchaseOrderLine, PurchaseOrderSubLine, PurchaseInvoiceQty, UnitPrice, WarehouseCode,PurchaserName, 
--	PurchaseInvoiceDate, ActualDelivDate, TotalMiscChrg, PurchaseOrderType,DiscountAmount,Currency,ExchangeRate 
	
	--, PurchaseOrderType, [Site], OrderDelivLineNum, , DiscountPercent, PurchaserName, PurchaseInvoiceLine, PurchaseInvoiceType, PurchaseInvoiceDate, ActualDelivDate, TotalMiscChrg, CreditMemo,UoM,PurchaseChannel, LastPaymentNum, VATAmount, CreditMemo, PurchaseInvoiceLine, PurchaseInvoiceType, 
GO
