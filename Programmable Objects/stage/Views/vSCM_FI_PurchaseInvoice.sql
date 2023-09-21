IF OBJECT_ID('[stage].[vSCM_FI_PurchaseInvoice]') IS NOT NULL
	DROP VIEW [stage].[vSCM_FI_PurchaseInvoice];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [stage].[vSCM_FI_PurchaseInvoice] AS
--COMMENT EMPTY FIELDS // ADD TRIM()UPPER() INTO PartID 2022-12-21 VA
--ADD TRIM() UPPER() INTO SupplierID 23-01-24 VA
SELECT 
	CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT(Company, '#', TRIM(InvoiceNum), '#', TRIM(InvoiceLine), '#', TRIM(PurchaseOrderNum),  '#', TRIM(PurchaseOrderLine), '#', TRIM(PurchaseOrderSubLine) ))) AS PurchaseInvoiceID
	,CONCAT(Company, '#', TRIM(SupplierCode), '#', TRIM(PurchaseOrderNum), TRIM(PurchaseOrderLine), TRIM(PurchaseOrderSubLine), TRIM(InvoiceNum)) AS PurchaseOrderCode
	,CONCAT(Company,'#',SupplierCode,'#',InvoiceNum) AS PurchaseInvoiceCode
	,CONVERT([binary](32),HASHBYTES('SHA2_256',CONCAT(Company, '#', TRIM(PurchaseOrderNum)))) AS PurchaseOrderNumID
	,CONVERT([binary](32),HASHBYTES('SHA2_256',CONCAT(Company, '#', PurchaseOrderNum, '#', PurchaseOrderLine))) AS PurchaseOrderID
	,CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM(Company),'#',TRIM(SupplierCode))))) AS SupplierID
	--,CONVERT([binary](32),HASHBYTES('SHA2_256',CONCAT(Company,'#',TRIM(SupplierCode)))) AS SupplierID
    ,CONVERT([binary](32),HASHBYTES('SHA2_256',Company)) AS CompanyID
	,CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM(Company),'#',TRIM(PartNum))))) AS PartID
	--,CONVERT([binary](32),HASHBYTES('SHA2_256',CONCAT(Company,'#',PartNum))) AS PartID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM([Company]), '#', TRIM([WarehouseCode]))))) AS WarehouseID
	,CONVERT(int, replace(InvoiceDate,'-','')) AS PurchaseInvoiceDateID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT(Company, '#', TRIM(SupplierCode), '#', TRIM(InvoiceNum), '#', TRIM(PurchaseOrderNum), '#', TRIM(LastPaymentNum)))) AS PurchaseLedgerID --match PurchaseLedgerID in [vSCM_FI_PurchaseLedger]
	,PartitionKey

	,Company
	,TRIM(PurchaseOrderNum) AS PurchaseOrderNum
	,TRIM(PurchaseOrderLine) AS PurchaseOrderLine
	,TRIM(PurchaseOrderSubLine) AS PurchaseOrderSubLine
	,OrderType AS [PurchaseOrderType]
	,TRIM(InvoiceNum) AS [PurchaseInvoiceNum]
	,InvoiceLine AS [PurchaseInvoiceLine]
	,InvoiceType AS [PurchaseInvoiceType]
	,InvoiceDate AS [PurchaseInvoiceDate]
	,CASE WHEN ActualDeliveryDate <= '1900-01-01' or ActualDeliveryDate = '' or ActualDeliveryDate is null THEN '1900-01-01' 
	      ELSE ActualDeliveryDate END AS [ActualDelivDate]
	,TRIM(SupplierCode) AS [SupplierNum]
	,TRIM(PartNum) AS PartNum
	,PurchaseShipQty AS [PurchaseInvoiceQty]
	--,'' AS [UoM]
	,UnitPrice
	,DiscountAmount
	,IIF((UnitPrice*PurchaseShipQty) = 0, 0, DiscountAmount/(UnitPrice*PurchaseShipQty)) AS [DiscountPercent]
	,TotalMiscChrg
	--,NULL AS [VATAmount]
	,ExchangeRate
	,CurrencyCode AS [Currency]
	,CreditMemo
	,PurchaserName
	,TRIM(WarehouseCode) AS WarehouseCode
	--,'' AS [PurchaseChannel]
	--,'' AS Comment
	--,'' AS PIRes1
	--,'' AS PIRes2
	--,'' AS PIRes3
FROM stage.SCM_FI_PurchaseInvoice
/*
GROUP BY
	PartitionKey, Company, PurchaseOrderNum, InvoiceNum, SupplierCode, PartNum, PurchaseOrderLine, PurchaseOrderSubLine, PurchaseShipQty, UnitPrice, WarehouseCode,PurchaserName, InvoiceLine, InvoiceType, InvoiceDate, ActualDeliveryDate, TotalMiscChrg, CreditMemo, OrderType, DiscountAmount, CurrencyCode, ExchangeRate, LastPaymentNum 
 */
GO
