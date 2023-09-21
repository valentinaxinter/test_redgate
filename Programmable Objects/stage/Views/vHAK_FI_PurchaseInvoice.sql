IF OBJECT_ID('[stage].[vHAK_FI_PurchaseInvoice]') IS NOT NULL
	DROP VIEW [stage].[vHAK_FI_PurchaseInvoice];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE     VIEW [stage].[vHAK_FI_PurchaseInvoice] AS
--COMMENT EMPTY FIELDS 2022-12-21 VA
SELECT 
	CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM(Company),'#',TRIM(SupplierNum),'#',TRIM(PurchaseOrderNum),'#',TRIM(PurchaseOrderLine),'#'
		,TRIM(PurchaseOrderSubLine),'#',TRIM(PurchaseInvoiceNum), '#', TRIM(PurchaseInvoiceLine), '#', PartNum, '#', UnitPrice, '#', DiscountAmount
		, '#', PurchaseInvoiceQty, '#', TRIM(WarehouseCode),'#',TRIM(LastPaymentNum))))) AS PurchaseInvoiceID --'#', PurchaseOrderType
	,UPPER(CONCAT(TRIM(Company),'#',TRIM(PurchaseInvoiceNum), '#', TRIM(PurchaseInvoiceLine), '#', PartNum)) AS PurchaseInvoiceCode
	,UPPER(CONCAT(TRIM(Company),'#',TRIM(PurchaseOrderNum))) AS PurchaseOrderNumCode
	,CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM(Company), '#', TRIM(PurchaseOrderNum))))) AS PurchaseOrderNumID
	,CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM(Company),'#',TRIM(PurchaseOrderNum),'#',TRIM(PurchaseOrderLine),'#',TRIM(PurchaseInvoiceNum))))) AS PurchaseOrderID
	,CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM(Company),'#',TRIM(SupplierNum))))) AS SupplierID
    ,CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(TRIM(Company)))) AS CompanyID
	,CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM(Company),'#',TRIM(PartNum))))) AS PartID
	,CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM(Company),'#',TRIM(WarehouseCode))))) AS WarehouseID
	,CONVERT(int, replace(PurchaseInvoiceDate,'-','')) AS PurchaseInvoiceDateID
	,CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM(Company),'#', TRIM(SupplierNum), '#', TRIM(PurchaseInvoiceNum),'#',TRIM(PurchaseOrderNum),'#',TRIM(LastPaymentNum))))) AS PurchaseLedgerID --match PurchaseLedgerID in [vSCM_FI_PurchaseLedger]
	,UPPER(CONCAT(TRIM(Company),'#',TRIM(SupplierNum),'#',TRIM(PurchaseOrderNum))) AS PurchaseOrderCode
	,PartitionKey

	,UPPER(TRIM(Company)) AS Company
	,UPPER(TRIM(PurchaseOrderNum)) AS PurchaseOrderNum
	,UPPER(TRIM(PurchaseOrderLine)) AS PurchaseOrderLine
	,UPPER(TRIM(PurchaseOrderSubLine)) AS PurchaseOrderSubLine
	,PurchaseOrderType
	,UPPER(TRIM(PurchaseInvoiceNum)) AS PurchaseInvoiceNum
	,UPPER(TRIM(PurchaseInvoiceLine)) AS PurchaseInvoiceLine
	,PurchaseInvoiceType
	,PurchaseInvoiceDate
	,ActualDelivDate
	,UPPER(TRIM(SupplierNum)) AS SupplierNum
	,UPPER(TRIM(PartNum)) AS PartNum
	,PurchaseInvoiceQty
	,UoM
	,UnitPrice
	--,0 AS DiscountPercent
	,DiscountAmount
	,TotalMiscChrg
	,VATAmount
	,Currency
	,ExchangeRate
	,CreditMemo
	,PurchaserName
	,UPPER(TRIM(WarehouseCode)) AS WarehouseCode
	,PurchaseChannel
	--,'' AS Comment
	--,'' AS PIRes1
	--,'' AS PIRes2
	--,'' AS PIRes3
	--,'' AS OrderDelivLineNum
FROM stage.HAK_FI_PurchaseInvoice

GROUP BY
	PartitionKey, Company, PurchaseOrderNum, PurchaseInvoiceNum, SupplierNum, PartNum, PurchaseOrderLine, PurchaseOrderSubLine, PurchaseInvoiceQty,UoM, UnitPrice, WarehouseCode,PurchaserName, 
	PurchaseInvoiceLine, PurchaseInvoiceType, PurchaseInvoiceDate, ActualDelivDate, TotalMiscChrg, VATAmount, CreditMemo, PurchaseOrderType,DiscountAmount,Currency,ExchangeRate,PurchaseChannel, LastPaymentNum --, PurchaseOrderType, [Site], OrderDelivLineNum, , DiscountPercent, PurchaserName, PurchaseInvoiceLine, PurchaseInvoiceType, PurchaseInvoiceDate, ActualDelivDate, TotalMiscChrg, CreditMemo
GO
