IF OBJECT_ID('[stage].[vTRA_FR_PurchaseInvoice]') IS NOT NULL
	DROP VIEW [stage].[vTRA_FR_PurchaseInvoice];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [stage].[vTRA_FR_PurchaseInvoice] AS

SELECT 
	CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM(Company), '#', TRIM(SupplierNum), '#', TRIM(PurchaseOrderNum), '#', TRIM(PurchaseOrderLine), '#', TRIM(PurchaseOrderSubLine), '#', TRIM(PurchaseInvoiceNum), '#', TRIM(PurchaseInvoiceLine), '#', PartNum, '#', TRIM(WarehouseCode))))) AS PurchaseInvoiceID 
	,UPPER(CONCAT(TRIM(Company),'#',TRIM(PurchaseInvoiceNum), '#', TRIM(PurchaseInvoiceLine), '#', PartNum)) AS PurchaseInvoiceCode
	,UPPER(CONCAT(TRIM(Company),'#',TRIM(PurchaseOrderNum))) AS PurchaseOrderNumCode
	,CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM(Company), '#', TRIM(PurchaseOrderNum))))) AS PurchaseOrderNumID
	,CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM(Company),'#',TRIM(PurchaseOrderNum),'#',TRIM(PurchaseOrderLine),'#',TRIM(PurchaseInvoiceNum))))) AS PurchaseOrderID
	,CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM(Company),'#',TRIM(SupplierNum))))) AS SupplierID
    ,CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(TRIM(Company)))) AS CompanyID
	,CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM(Company),'#',TRIM(PartNum))))) AS PartID
	,CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM(Company),'#',TRIM(WarehouseCode))))) AS WarehouseID
	,CONVERT(int, CONCAT(SUBSTRING(PurchaseInvoiceDate, 7,4), SUBSTRING(PurchaseInvoiceDate, 4,2), SUBSTRING(PurchaseInvoiceDate, 1,2))) AS PurchaseInvoiceDateID
	,CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM(Company),'#', TRIM(SupplierNum), '#', TRIM(PurchaseInvoiceNum),'#',TRIM(PurchaseOrderNum))))) AS PurchaseLedgerID
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
	,TRY_CONVERT(date, CONCAT(SUBSTRING(PurchaseInvoiceDate, 7,4), '-', SUBSTRING(PurchaseInvoiceDate, 4,2),  '-', SUBSTRING(PurchaseInvoiceDate, 1,2))) AS PurchaseInvoiceDate
	,TRY_CONVERT(date, CONCAT(SUBSTRING(ActualDelivDate, 7,4), '-', SUBSTRING(ActualDelivDate, 4,2), '-', SUBSTRING(ActualDelivDate, 1,2))) AS ActualDelivDate
	,UPPER(TRIM(SupplierNum)) AS SupplierNum
	,UPPER(TRIM(PartNum)) AS PartNum
	,CONVERT(decimal(18, 4), PurchaseInvoiceQty) AS PurchaseInvoiceQty
	,UoM
	,CONVERT(decimal(18, 4), UnitPrice) AS UnitPrice
	,CONVERT(decimal(18, 4), DiscountPercent) AS DiscountPercent
	,CONVERT(decimal(18, 4), DiscountAmount) AS DiscountAmount
	,CONVERT(decimal(18, 4), TotalMiscChrg) AS TotalMiscChrg
	,CONVERT(decimal(18, 4), VATAmount) AS VATAmount
	,Currency
	,CONVERT(decimal(18, 4), ExchangeRate) AS ExchangeRate
	,CreditMemo
	,PurchaserName
	,UPPER(TRIM(WarehouseCode)) AS WarehouseCode
	,PurchaseChannel
	,Comment
	,PIRes1
	,PIRes2
	,PIRes3
	--,'' AS OrderDelivLineNum
FROM stage.TRA_FR_PurchaseInvoice

--GROUP BY
--	PartitionKey, Company, PurchaseOrderNum, PurchaseInvoiceNum, SupplierNum, PartNum, PurchaseOrderLine, PurchaseOrderSubLine, PurchaseInvoiceQty,UoM, UnitPrice, WarehouseCode,PurchaserName, 
--	PurchaseInvoiceLine, PurchaseInvoiceType, PurchaseInvoiceDate, ActualDelivDate, TotalMiscChrg, VATAmount, CreditMemo, PurchaseOrderType,DiscountAmount,Currency,ExchangeRate,PurchaseChannel, LastPaymentNum --, PurchaseOrderType, [Site], OrderDelivLineNum, , DiscountPercent, PurchaserName, PurchaseInvoiceLine, PurchaseInvoiceType, PurchaseInvoiceDate, ActualDelivDate, TotalMiscChrg, CreditMemo
GO
