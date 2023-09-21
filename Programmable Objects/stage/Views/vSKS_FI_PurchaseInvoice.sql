IF OBJECT_ID('[stage].[vSKS_FI_PurchaseInvoice]') IS NOT NULL
	DROP VIEW [stage].[vSKS_FI_PurchaseInvoice];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [stage].[vSKS_FI_PurchaseInvoice] AS
--ADD TRIM()UPPER() INTO PartID,WarehouseID 2022-12-16 VA
--ADD TRIM() UPPER() INTO SupplierID 23-01-24 VA
SELECT 
	CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT(BUKRS, '#', TRIM(PURCHASEINVOICENUM), '#', TRIM(INVOICELINE)))) AS PurchaseInvoiceID 
	,CONCAT(BUKRS, '#', TRIM(PURCHASEINVOICENUM), '#', TRIM(PURCHASEORDERLINE), '#', TRIM(PARTNUM)) AS PurchaseInvoiceCode
	,CONCAT(BUKRS, '#', TRIM(PURCHASEORDERNUM)) AS PurchaseOrderNumCode
	,CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT(BUKRS, '#', TRIM(PURCHASEORDERNUM)))) AS PurchaseOrderNumID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT(BUKRS, '#', TRIM(PURCHASEORDERNUM), '#', TRIM(PURCHASEORDERLINE)))) AS PurchaseOrderID
	,CONVERT([binary](32), HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM(BUKRS), '#', TRIM(SUPPLIERNUM), '#', TRIM(EKORG))))) AS SupplierID
	--,CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT(BUKRS, '#', TRIM(SUPPLIERNUM), '#', EKORG ))) AS SupplierID
    ,CONVERT([binary](32), HASHBYTES('SHA2_256', BUKRS)) AS CompanyID
	--,CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT(BUKRS, '#', TRIM(PARTNUM), '#', EKORG))) AS PartID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM(BUKRS), '#', TRIM(PARTNUM), '#', TRIM(EKORG))))) AS PartID
	--,CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT(BUKRS, '#', TRIM(WAREHOUSECODE)))) AS WarehouseID
	,CONVERT([binary](32), HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM(BUKRS), '#', TRIM(WAREHOUSECODE))))) AS WarehouseID
	,CONVERT(int, replace(INVOICEDATE, '-', '')) AS PurchaseInvoiceDateID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT(BUKRS, '#', TRIM(SUPPLIERNUM), '#', TRIM(PURCHASEINVOICENUM), '#', TRIM(PURCHASEORDERNUM)))) AS PurchaseLedgerID --match PurchaseLedgerID in [vSKS_FI_PurchaseLedger]
	,CONCAT(EKORG, '#', TRIM(SUPPLIERNUM) ,'#', PURCHASEORDERNUM, '#', PURCHASEORDERLINE, '#', TRIM(PURCHASEINVOICENUM)) AS PurchaseOrderCode
	,PartitionKey

--	,CASE WHEN BUKRS = 'SKSSWE' THEN 'JSESKSSW' WHEN EKORG = 'SE10' THEN 'JSESKSSW' ELSE BUKRS END  AS Company
	,BUKRS AS Company
	,TRIM(PURCHASEORDERNUM) AS PurchaseOrderNum
	,TRIM(PURCHASEORDERLINE) AS PurchaseOrderLine
	,ORDERDELIVLINENUM AS PurchaseOrderSubLine
	,[ORDERTYPE] AS PurchaseOrderType
	,TRIM(PURCHASEINVOICENUM) AS PurchaseInvoiceNum
	,TRIM(INVOICELINE) AS PurchaseInvoiceLine
	,INVOICETYPE AS PurchaseInvoiceType
	,IIF(INVOICEDATE = '00000000', '1900-01-01', CONVERT(date, INVOICEDATE)) AS PurchaseInvoiceDate 
	,IIF(ACTUALDELIVDATE = '00000000', '1900-01-01', CONVERT(date, ACTUALDELIVDATE)) AS ACTUALDELIVDATE
	,TRIM(SUPPLIERNUM) AS SupplierNum
	,IIF(ISNUMERIC([PARTNUM]) = 1,CAST(CAST(trim([PARTNUM]) AS int)as nvarchar(50)),(trim([PARTNUM]))) AS PartNum
	,iif(INVOICETYPE = '2',PURCHASESHIPQTY * -1,PURCHASESHIPQTY) AS PurchaseInvoiceQty
	,UNIT AS UoM
	,UNITPRICE + COALESCE(DISCOUNTAMOUNT/NULLIF(PURCHASESHIPQTY,0),0)	AS UNITPRICE
	,IIF(UnitPrice*PURCHASESHIPQTY = 0, 0, DISCOUNTAMOUNT/(UnitPrice*PURCHASESHIPQTY)) AS DiscountPercent
	,DISCOUNTAMOUNT
	,CONVERT(decimal(18,4), NULL) AS TOTALMISCCHRG
	,CONVERT(decimal(18,0), VAT) AS VATAmount
	,COALESCE(1/NULLIF(EXCHANGERATE,0),1) AS EXCHANGERATE
	,CURRENCY
	,CREDITMEMO
	,PURCHASERNAME
	,TRIM(WarehouseCode) AS WarehouseCode
	,PURCHASECHANNEL
	--,'' AS Comment
	,MANDT AS PIRES1
	,BUKRS AS PIRES2
	,GJAHR AS PIRES3
FROM stage.SKS_FI_PurchaseInvoice
WHERE EKORG NOT IN ('FI00','SE10')
GROUP BY
	PartitionKey, BUKRS, EKORG, PURCHASEORDERNUM, PURCHASEINVOICENUM, SUPPLIERNUM, PARTNUM, PURCHASEORDERLINE, PURCHASESHIPQTY, UNITPRICE, WAREHOUSECODE, PURCHASERNAME, INVOICELINE, INVOICETYPE, INVOICEDATE, ACTUALDELIVDATE, TOTALMISCCHRG, CREDITMEMO, [ORDERTYPE], DISCOUNTAMOUNT, CURRENCY, EXCHANGERATE, UNIT, VAT, PURCHASECHANNEL, ORDERDELIVLINENUM, MANDT, GJAHR
GO