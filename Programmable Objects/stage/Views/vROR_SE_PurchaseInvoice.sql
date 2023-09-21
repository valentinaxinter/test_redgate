IF OBJECT_ID('[stage].[vROR_SE_PurchaseInvoice]') IS NOT NULL
	DROP VIEW [stage].[vROR_SE_PurchaseInvoice];

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE VIEW [stage].[vROR_SE_PurchaseInvoice] AS

SELECT 
	CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(pin.Company, '#', TRIM(pin.PurchaseOrderNum), '#', TRIM(pin.PurchaseOrderLine), '#', TRIM(pin.PurchaseOrderSubLine),'#',TRIM(pin.PurchaseInvoiceNum), '#', TRIM(pin.[PartNum]) )))) AS PurchaseInvoiceID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(pin.Company, '#', TRIM(pin.PurchaseOrderNum))))) AS PurchaseOrderNumID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(pin.Company, '#', TRIM(pin.PurchaseOrderNum), '#', TRIM(pin.PurchaseOrderLine))))) AS PurchaseOrderID
    ,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(TRIM(pin.Company)))) AS CompanyID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM(pin.Company), '#', TRIM(pin.SupplierNum))))) AS SupplierID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(trim(pin.Company), '#', TRIM(pin.[PartNum]))))) AS PartID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM(pin.Company), '#', TRIM(pin.WarehouseCode))))) AS WarehouseID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(pin.Company, '#', TRIM(pin.SupplierNum), '#', TRIM(pin.PurchaseInvoiceNum))))) AS PurchaseLedgerID
	,CONVERT(int, REPLACE(PurchaseInvoiceDate, '-', '')) AS PurchaseInvoiceDateID
	,UPPER(CONCAT(pin.Company, '#', TRIM(pin.SupplierNum), '#', TRIM(pin.PurchaseOrderNum), '#', TRIM(pin.PurchaseOrderLine))) AS PurchaseOrderCode
	,UPPER(CONCAT(pin.Company, '#', TRIM(pin.SupplierNum), '#', TRIM(pin.PurchaseInvoiceNum))) AS PurchaseInvoiceCode 
	,pin.PartitionKey

	,UPPER(pin.Company) AS Company
	,TRIM(pin.PurchaseOrderNum) AS PurchaseOrderNum
	,TRIM(pin.PurchaseOrderLine) AS PurchaseOrderLine
	,TRIM(pin.PurchaseOrderSubLine) AS PurchaseOrderSubLine
	,TRIM(pin.PurchaseOrderType) AS PurchaseOrderType 
	,TRIM(pin.PurchaseInvoiceNum) AS PurchaseInvoiceNum
	,TRIM(pin.PurchaseInvoiceLine) PurchaseInvoiceLine
	--,'' PurchaseInvoiceType
	,CONVERT(date, IIF(PurchaseInvoiceDate = '', '1900-01-01', PurchaseInvoiceDate)) AS PurchaseInvoiceDate
	,po.ActualDelivDate AS ActualDelivDate --added 20230620 by request of Elisa Karlsson
	,(CONVERT(date, ActualRecieveDate)) AS ActualShipDate -- take the latest date for invoice --
	,TRIM(UPPER(pin.SupplierNum)) AS SupplierNum
	,TRIM(UPPER(pin.[PartNum])) AS PartNum
	,(CONVERT(decimal(18,4), PurchaseInvoiceQty)) AS PurchaseInvoiceQty --sum different batch payment --
	,TRIM(pin.UoM) AS UoM
	,CONVERT(decimal(18,4), REPLACE(pin.UnitPrice, ',', '.')) AS UnitPrice
	,CONVERT(decimal(18,4), REPLACE(pin.DiscountPercent, ',', '.')) AS DiscountPercent
	,CONVERT(decimal(18,4), REPLACE(pin.DiscountAmount, ',', '.')) AS DiscountAmount
	,CONVERT(decimal(18,4), REPLACE(TotalMiscChrg, ',', '.')) AS TotalMiscChrg
	,CONVERT(decimal(18,4), REPLACE(VATAmount, ',', '.')) AS VATAmount --PIRes4
	,CONVERT(decimal(18,4), REPLACE(PurchaseInvoiceAmountOC, ',', '.')) AS PurchaseInvoiceAmountOC -- after request from Elisa & Sam 20230607 /DZ
	--,NULL AS VATAmount
	,CONVERT(decimal(18,4), REPLACE(pin.ExchangeRate, ',', '.')) AS ExchangeRate -- first date and the latest date invoice can have different curr.rates, not neccessarily who is the lagest, so average them --
	,TRIM(pin.Currency) AS Currency
	,TRIM(pin.[IsCreditMemo]) AS CreditMemo
	,TRIM(pin.PurchaserName) AS PurchaserName
	,TRIM(pin.WarehouseCode) AS WarehouseCode
	,TRIM(pin.PurchaseChannel) AS PurchaseChannel
	,TRIM(Comment) AS Comment
	--,'' AS PIRes1
	--,'' AS PIRes2
	--,'' AS PIRes3
FROM stage.ROR_SE_PurchaseInvoice pin
		LEFT JOIN [stage].[vROR_SE_PurchaseOrder] po ON TRIM(pin.PurchaseOrderNum) = TRIM(po.PurchaseOrderNum) AND TRIM(pin.PurchaseOrderLine) = TRIM(po.PurchaseOrderLine)
GO
