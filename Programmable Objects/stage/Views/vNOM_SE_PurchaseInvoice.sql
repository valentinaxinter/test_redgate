IF OBJECT_ID('[stage].[vNOM_SE_PurchaseInvoice]') IS NOT NULL
	DROP VIEW [stage].[vNOM_SE_PurchaseInvoice];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [stage].[vNOM_SE_PurchaseInvoice] AS
--COMMENT EMPTY FIELD 2022-12-20 VA
--ADD TRIM() INTO SupplierID 23-01-24 VA
SELECT
	CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(Company,'#', TRIM(PurchaseOrderNum),'#', TRIM(PurchaseOrderLine),'#', TRIM(PurchaseOrderSubLine), '#', TRIM(PurchaseInvoiceNum), '#', TRIM(PurchaseInvoiceLine))))) AS PurchaseInvoiceID 
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(Company, '#', TRIM(PurchaseOrderNum))))) AS PurchaseOrderNumID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(Company, '#', TRIM(PurchaseOrderNum), '#', TRIM(PurchaseOrderLine), '#', TRIM(PurchaseInvoiceNum))))) AS PurchaseOrderID
	--,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(Company, '#', TRIM(SupplierNum))))) AS SupplierID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM(Company), '#', TRIM(SupplierNum))))) AS SupplierID
    ,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(Company))) AS CompanyID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(Company, '#', TRIM(PartNum))))) AS PartID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(Company, '#', TRIM(WarehouseCode))))) AS WarehouseID
	,CONVERT(int, replace(PurchaseInvoiceDate,'-','')) AS PurchaseInvoiceDateID
	,CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(Company,'#', TRIM(SupplierNum), '#', TRIM(PurchaseInvoiceNum),'#',TRIM(PurchaseOrderNum))))) AS PurchaseLedgerID --match PurchaseLedgerID in [vSCM_FI_PurchaseLedger]
	,UPPER(CONCAT(Company, '#', TRIM(SupplierNum), '#', TRIM(PurchaseOrderNum), '#', TRIM(PurchaseOrderLine) )) AS PurchaseOrderCode
	,UPPER(CONCAT(Company,'#',TRIM(PurchaseInvoiceNum), '#', TRIM(PurchaseInvoiceLine), '#', PartNum)) AS PurchaseInvoiceCode
	,UPPER(CONCAT(Company,'#',TRIM(PurchaseOrderNum))) AS PurchaseOrderNumCode
	,PartitionKey

	,UPPER(Company) AS Company
	,UPPER(TRIM(SupplierNum)) AS SupplierNum
	,UPPER(TRIM(PartNum)) AS PartNum
	,UPPER(TRIM(WarehouseCode)) AS WarehouseCode
	,UPPER(TRIM(PurchaseOrderNum)) AS PurchaseOrderNum
	,UPPER(TRIM(PurchaseOrderLine)) AS PurchaseOrderLine
	,UPPER(TRIM(PurchaseOrderSubLine)) AS PurchaseOrderSubLine
	,PurchaseOrderType
	,UPPER(TRIM(PurchaseInvoiceNum)) AS PurchaseInvoiceNum
	,UPPER(TRIM(PurchaseInvoiceLine)) AS PurchaseInvoiceLine
	,PurchaseInvoiceType
	,PurchaseInvoiceDate
	,ActualDelivDate
	,PurchaseInvoiceQty
	,UoM
	,UnitPrice
	,DiscountPercent
	,DiscountAmount
	,TotalMiscChrg
	,VATAmount
	,IIF(TRIM(PurchaseInvoiceNum) = '174224', 10.64, ExchangeRate) AS ExchangeRate  --special case wrong rate
	,Currency
	,CreditMemo
	,PurchaserName
	,PurchaseChannel
	--,'' AS Comment
	--,'' AS PIRes1
	--,'' AS PIRes2
	--,'' AS PIRes3
	--,'' AS LineType
	--,'' AS OrderDelivLineNum
FROM stage.NOM_SE_PurchaseInvoice

GROUP BY
	PartitionKey, Company, PurchaseOrderNum, PurchaseInvoiceNum, SupplierNum, PartNum, PurchaseOrderLine, PurchaseOrderSubLine, PurchaseInvoiceQty, UnitPrice, WarehouseCode,PurchaserName, PurchaseInvoiceLine, PurchaseInvoiceType, PurchaseInvoiceDate, ActualDelivDate, TotalMiscChrg, CreditMemo, PurchaseOrderType,DiscountAmount,Currency,ExchangeRate, UoM, VATAmount, PurchaseChannel, DiscountPercent, DiscountAmount--, LastPaymentNum --, OrderType, [Site], OrderDelivLineNum, , DiscountPercent, PurchaserName, InvoiceLine, InvoiceType, InvoiceDate, ActualDeliveryDate, TotalMiscChrg, CreditMemo
GO
