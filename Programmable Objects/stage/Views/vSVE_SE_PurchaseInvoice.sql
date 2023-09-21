IF OBJECT_ID('[stage].[vSVE_SE_PurchaseInvoice]') IS NOT NULL
	DROP VIEW [stage].[vSVE_SE_PurchaseInvoice];

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE VIEW [stage].[vSVE_SE_PurchaseInvoice] AS

SELECT 
	CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(Company, '#', TRIM(PurchaseOrderNum), '#', TRIM(PurchaseOrderLine), '#', TRIM(PurchaseOrderSubLine), '#', TRIM(PurchaseInvoiceNum), '#', CreatedTime )))) AS PurchaseInvoiceID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(Company, '#', TRIM(PurchaseOrderNum))))) AS PurchaseOrderNumID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(Company, '#', TRIM(PurchaseOrderNum), '#', TRIM(PurchaseOrderLine))))) AS PurchaseOrderID
    ,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(TRIM(Company)))) AS CompanyID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM(Company), '#', TRIM(SupplierNum))))) AS SupplierID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(trim(Company), '#', TRIM([PartNum]))))) AS PartID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM(Company), '#', TRIM(WarehouseCode))))) AS WarehouseID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(Company, '#', TRIM(SupplierNum), '#', TRIM(PurchaseInvoiceNum))))) AS PurchaseLedgerID
	,CONVERT(int, ActualRecieveDate) AS PurchaseInvoiceDateID
	,UPPER(CONCAT(Company, '#', TRIM(SupplierNum), '#', TRIM(PurchaseOrderNum), '#', TRIM(PurchaseOrderLine))) AS PurchaseOrderCode
	,UPPER(CONCAT(Company, '#', TRIM(SupplierNum), '#', TRIM(PurchaseInvoiceNum))) AS PurchaseInvoiceCode 
	,PartitionKey

	,UPPER(Company) AS Company
	,TRIM(PurchaseOrderNum) AS PurchaseOrderNum
	,TRIM(PurchaseOrderLine) AS PurchaseOrderLine
	,TRIM(PurchaseOrderSubLine) AS PurchaseOrderSubLine
	,TRIM(PurchaseOrderType) AS PurchaseOrderType 
	,TRIM(PurchaseInvoiceNum) AS PurchaseInvoiceNum
	,TRIM(PurchaseInvoiceLine) PurchaseInvoiceLine
	--,'' PurchaseInvoiceType
	,CONVERT(date, IIF(PurchaseInvoiceDate = '', '1900-01-01', PurchaseInvoiceDate)) AS PurchaseInvoiceDate
	,CONVERT(date, IIF(ActualShipDate = '', '1900-01-01', ActualShipDate)) AS ActualShipDate 
	,CONVERT(date, IIF(ActualRecieveDate = '', '1900-01-01', ActualRecieveDate)) AS ActualRecieveDate
	,CONVERT(date, IIF(ActualRecieveDate = '', '1900-01-01', ActualRecieveDate)) AS ActualDelivDate
	,TRIM(UPPER(SupplierNum)) AS SupplierNum
	,IIF(TRIM(UPPER([PartNum])) = '' OR [PartNum] IS NULL, '99', TRIM(UPPER([PartNum]))) AS PartNum
	,SUM(CONVERT(decimal(18,4), PurchaseInvoiceQty)) AS PurchaseInvoiceQty --sum different batch payment --
	,TRIM(UoM) AS UoM
	,IIF(CONVERT(decimal(18,4), ExchangeRate) = 0
		, IIF(SUM(CONVERT(decimal(18,4), PurchaseInvoiceQty)) = 0, UnitPrice, SUM(CONVERT(decimal(18,4), Kost))/SUM(CONVERT(decimal(18,4), PurchaseInvoiceQty)))/1
		, IIF(SUM(CONVERT(decimal(18,4), PurchaseInvoiceQty)) = 0, UnitPrice, SUM(CONVERT(decimal(18,4), Kost))/SUM(CONVERT(decimal(18,4), PurchaseInvoiceQty)))/(CONVERT(decimal(18,4), ExchangeRate))
		) AS UnitPrice
	,CONVERT(decimal(18,4), DiscountPercent) AS DiscountPercent
	,CONVERT(decimal(18,4), DiscountAmount) AS DiscountAmount
	,CONVERT(decimal(18,4), TotalMiscChrg) AS TotalMiscChrg
	--,NULL AS VATAmount
	,CONVERT(decimal(18,4), ExchangeRate) AS ExchangeRate -- first date and the latest date invoice can have different curr.rates, not neccessarily who is the lagest, so average them --
	,TRIM(Currency) AS Currency
	,IIF(SUM(CONVERT(decimal(18,4), PurchaseInvoiceQty)) < 0, '1', '0') AS CreditMemo
	,TRIM(PurchaserName) AS PurchaserName
	,TRIM(WarehouseCode) AS WarehouseCode
	,TRIM(PurchaseChannel) AS PurchaseChannel
	,TRIM(Comment) AS Comment
	,(CreatedTime) AS PIRes1
	--,'' AS PIRes2
	--,'' AS PIRes3
FROM stage.SVE_SE_PurchaseInvoice
WHERE TRIM(PurchaseInvoiceNum) <> '' AND ActualRecieveDate > '20180101' --and (CONVERT(decimal(18,4), PurchaseInvoiceQty)) != 0

GROUP BY
	PartitionKey, Company, PurchaseOrderNum, PurchaseOrderLine, PurchaseOrderSubLine, PurchaseOrderType, PurchaseInvoiceNum, PurchaseInvoiceLine, PurchaseInvoiceDate, ActualRecieveDate, ActualShipDate, CreatedTime
	, SupplierNum, PartNum, UoM, PurchaserName, ExchangeRate, PurchaseChannel, Currency, Comment, CreditMemo, WarehouseCode, DiscountPercent, DiscountAmount, TotalMiscChrg, Kost, UnitPrice
--HAVING SUM(CONVERT(decimal(18,4), PurchaseInvoiceQty)) != 0
	--, PurchaseInvoiceQty, ActualDelivDate, CreatedTime
GO
