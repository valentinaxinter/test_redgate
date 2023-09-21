IF OBJECT_ID('[stage].[vCER_LT_SOLine]') IS NOT NULL
	DROP VIEW [stage].[vCER_LT_SOLine];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [stage].[vCER_LT_SOLine] AS
--COMMENT EMPTY FIELDS / ADD TRIM()UPPER() INTO PartID,CustomerID,WarehouseID 2022-12-14 VA
SELECT
	CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT(Company, '#', TRIM(Indexkey)))) AS SalesInvoiceID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT(Company, '#', OrderNum, '#', OrderLine, '#', OrderSubLine, '#', InvoiceNum))) AS SalesOrderID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT(Company, '#', TRIM(IIF(CustNum IS NULL OR CustNum = '', 'MISSINGCUSTOMER', CustNum) ), '#', InvoiceNum))) AS SalesLedgerID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT(Company, '#', TRIM(OrderNum)))) AS SalesOrderNumID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', Company)) AS CompanyID
	--,CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT(Company, '#', TRIM(IIF(CustNum IS NULL OR CustNum = '', 'MISSINGCUSTOMER', CustNum) )))) AS CustomerID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM(Company), '#', TRIM(CustNum))))) AS CustomerID
	--,CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT(Company, '#', TRIM(IIF(PartNum IS NULL OR PartNum = '', 'MISSINGPART',  PartNum) )))) AS PartID 
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM(Company), '#', TRIM(PartNum))))) AS PartID 
	--,CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT(Company, '#', WarehouseCode))) AS WarehouseID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM(Company), '#', TRIM(WarehouseCode))))) AS WarehouseID
	,CONCAT(Company, '#', TRIM(OrderNum), '#', TRIM(OrderLine), '#', TRIM(IIF(PartNum IS NULL OR PartNum = '', 'MISSINGPART',  PartNum) )) AS SalesOrderCode
	,CONVERT(int, replace(convert(date,InvoiceDate),'-','')) AS SalesInvoiceDateID  --Redundant?
	,CONCAT(Company, '#', TRIM(InvoiceNum), '#', TRIM(InvoiceLine)) AS SalesInvoiceCode --Redundant?
	,CONVERT([binary](32), HASHBYTES('SHA2_256',CONCAT( Company,'#','') ))	AS ProjectID
	,PartitionKey

	,TRIM(Company) AS Company
	,TRIM(SalesPerson) AS SalesPersonName
	,TRIM(IIF(CustNum IS NULL OR CustNum = '', 'MISSINGCUSTOMER', CustNum) ) AS CustomerNum
	,TRIM(IIF(PartNum IS NULL OR PartNum = '', 'MISSINGPART',  PartNum) ) AS PartNum
	,IIF(OrderSubLine = '000000',  'Main',  'Sub' ) AS PartType --change from "CASE WHEN TRIM(OrderNum) = '0' THEN 'PrimaryPart' ELSE 'SubPart' END" 20210423 /DZ
	,TRIM(OrderNum) AS SalesOrderNum
	,TRIM(OrderLine) AS SalesOrderLine
	,TRIM(OrderSubLine) AS SalesOrderSubLine -- added 20210423 /DZ
	,CONVERT(nvarchar(50), OrderType) AS SalesOrderType
	,TRIM(InvoiceNum) AS SalesInvoiceNum
	,TRIM(InvoiceLine) AS SalesInvoiceLine
	--,'' AS SalesInvoiceType
	,CASE WHEN InvoiceDate = '' THEN '1901-01-01' ELSE CONVERT(date, InvoiceDate) END AS SalesInvoiceDate
	,ActualDeliveryDate AS ActualDelivDate
	,SellingShipQty AS SalesInvoiceQty
	--,'' AS UoM
	,UnitPrice
	,UnitCost
	,CONVERT(decimal (18,4), IIF(SellingShipQty*UnitPrice = 0, 0, DiscountAmount/SellingShipQty*UnitPrice)) AS DiscountPercent --added calculation 20210423 /DZ
	,DiscountAmount
	--,0 AS CashDiscountOffered
	--,0 AS CashDiscountUsed
	,TotalMiscChrg
	,VATRate
	,(1-COALESCE(VATRate,0)/100) *  (UnitPrice * SellingShipQty - DiscountAmount) VATAmount
	,Currency
	,ExchangeRate
	,CreditMemo
	,CASE WHEN LEFT(TRIM(OrderNum),4) = '7000' THEN 'Webshop'
		WHEN LEFT(TRIM(OrderNum),4) = '0000' THEN 'Normal Order Handling'
		ELSE 'Normal Order Handling' END AS SalesChannel
	--,'' AS [Department]
	,CASE WHEN WarehouseCode = '' OR WarehouseCode is NULL THEN 'Other' ELSE TRIM(WarehouseCode) END AS WarehouseCode
	--,NULL AS DeliveryAddress
	--,'' AS CostBearerNum
	--,'' AS CostUnitNum
	,ReturnComment
	,TRIM(ReturnNum) AS ReturnNum
	--,'' AS ProjectNum
	,Indexkey AS IndexKey
	--,'' AS SIRes1
	--,'' AS SIRes2
	--,'' AS SIRes3

FROM stage.CER_LT_SOLine lts
--	LEFT JOIN dw.Customer ltc ON Company = ltc.Company AND CustNum = ltc.CustomerNum
--GROUP BY
--	PartitionKey, Company, CustNum, OrderNum, OrderLine, OrderSubLine, UnitPrice, UnitCost, DiscountAmount, PartNum, SalesPerson, WarehouseCode, OrderType, InvoiceNum, InvoiceLine
--	, InvoiceDate, ActualDeliveryDate, SellingShipQty, TotalMiscChrg, CreditMemo, IndexKey, Currency, ExchangeRate, ReturnComment, ReturnNum, VATRate
GO
