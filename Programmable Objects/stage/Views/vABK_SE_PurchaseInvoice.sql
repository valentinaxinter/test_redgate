IF OBJECT_ID('[stage].[vABK_SE_PurchaseInvoice]') IS NOT NULL
	DROP VIEW [stage].[vABK_SE_PurchaseInvoice];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [stage].[vABK_SE_PurchaseInvoice] AS
--COMMENT EMPTY FIELDS // ADD TRIM() INTO PartID,WarehouseID 2022-12-21 VA
--ADD TRIM() INTO SupplierID 23-01-24 VA
SELECT 
	CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(Company, '#', TRIM(PurchaseOrderNum), '#', TRIM(PurchaseOrderLine), '#', TRIM(PurchaseOrderSubLine),'#',TRIM(PurchaseInvoiceNum),'#',TRIM(PurchaseInvoiceLine), '#', TRIM([PartNum]) )))) AS PurchaseInvoiceID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(Company, '#', TRIM(PurchaseOrderNum))))) AS PurchaseOrderNumID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(Company, '#', TRIM(PurchaseOrderNum), '#', TRIM(PurchaseOrderLine))))) AS PurchaseOrderID
    ,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(TRIM(Company)))) AS CompanyID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM(Company), '#', TRIM(SupplierNum))))) AS SupplierID
	--,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(Company, '#', TRIM(SupplierNum))))) AS SupplierID
	--,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(Company, '#', TRIM([PartNum]))))) AS PartID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(trim(Company), '#', TRIM([PartNum]))))) AS PartID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM(Company), '#', TRIM(WarehouseCode))))) AS WarehouseID
	--,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(Company, '#', TRIM(WarehouseCode))))) AS WarehouseID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(Company, '#', TRIM(SupplierNum), '#', TRIM(PurchaseInvoiceNum))))) AS PurchaseLedgerID
	,CONVERT(int, replace(PurchaseInvoiceDate, '-', '')) AS PurchaseInvoiceDateID
	,UPPER(CONCAT(Company, '#', TRIM(SupplierNum), '#', TRIM(PurchaseOrderNum), '#', TRIM(PurchaseOrderLine))) AS PurchaseOrderCode
	,UPPER(CONCAT(Company, '#', TRIM(SupplierNum), '#', TRIM(PurchaseInvoiceNum))) AS PurchaseInvoiceCode 
	,getdate() AS PartitionKey

	,UPPER(Company) AS Company
	,TRIM(PurchaseOrderNum) AS PurchaseOrderNum
	,TRIM(PurchaseOrderLine) AS PurchaseOrderLine
	,TRIM(PurchaseOrderSubLine) AS PurchaseOrderSubLine
	--,'' AS PurchaseOrderType --MIN
	,TRIM(PurchaseInvoiceNum) AS PurchaseInvoiceNum
	,TRIM(PurchaseInvoiceLine) PurchaseInvoiceLine
	--,'' PurchaseInvoiceType
	,CONVERT(date, IIF(PurchaseInvoiceDate = '0', '1900-01-01', PurchaseInvoiceDate)) AS PurchaseInvoiceDate
	,MAX(CONVERT(date, ActualDelivDate)) AS ActualDelivDate -- take the latest date for invoice --
	,TRIM(UPPER(SupplierNum)) AS SupplierNum
	,TRIM(UPPER([PartNum])) AS PartNum
	,SUM(CONVERT(decimal(18,4), PurchaseInvoiceQty)) AS PurchaseInvoiceQty --sum different batch payment --
	--,'' AS UoM
	,CONVERT(decimal(18,4), UnitPrice) AS UnitPrice
	,CONVERT(decimal(18,4), DiscountPercent) AS DiscountPercent
	,SUM(CONVERT(decimal(18,4), PurchaseInvoiceQty))*CONVERT(decimal(18,4), UnitPrice)*CONVERT(decimal(18,4), DiscountPercent)/100 AS DiscountAmount
	--,NULL AS TotalMiscChrg
	--,NULL AS VATAmount
	,IIF(ISOCode IN ('SEK', 'DKK', 'NOK'), AVG(CONVERT(decimal(18,4), ExchangeRate))/100, AVG(CONVERT(decimal(18,4), ExchangeRate))) AS ExchangeRate -- first date and the latest date invoice can have different curr.rates, not neccessarily who is the lagest, so average them --
	,TRIM(ISOCode) AS Currency
	,TRIM(CreditMemo) AS CreditMemo
	,TRIM(PurchaserName) AS PurchaserName
	,TRIM(WarehouseCode) AS WarehouseCode
	--,'' AS PurchaseChannel
	--,'' AS Comment
	--,'' AS PIRes1
	--,'' AS PIRes2
	--,'' AS PIRes3
FROM stage.ABK_SE_PurchaseInvoice
GROUP BY
	PartitionKey, Company, PurchaseOrderNum, PurchaseInvoiceNum, SupplierNum, PartNum, PurchaserName, PurchaseInvoiceLine,  PurchaseInvoiceDate, UnitPrice, CreditMemo, WarehouseCode, ISOCode, PurchaseOrderLine, PurchaseOrderSubLine, DiscountPercent--, PurchaseInvoiceQty, ActualDelivDate, ExchangeRate
GO
