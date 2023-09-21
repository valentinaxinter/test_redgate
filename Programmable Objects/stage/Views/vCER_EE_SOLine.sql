IF OBJECT_ID('[stage].[vCER_EE_SOLine]') IS NOT NULL
	DROP VIEW [stage].[vCER_EE_SOLine];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [stage].[vCER_EE_SOLine] AS
--COMMENT EMPTY FIELDS / ADJUST PartID,CustomerID 2022-12-14 VA
SELECT 
	CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT(Company, '#', Indexkey))) AS SalesInvoiceID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT(Company, '#', OrderNum, '#', OrderLine, '#', InvoiceNum))) AS SalesOrderID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT(Company, '#', CustNum, '#', InvoiceNum))) AS SalesLedgerID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT(Company, '#', TRIM(OrderNum)))) AS SalesOrderNumID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', Company)) AS CompanyID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM(Company), '#', TRIM(CustNum))))) AS CustomerID
	--,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(Company, '#', TRIM(IIF(CustNum IS NULL OR CustNum = '', 'MISSINGCUSTOMER', CustNum) ))))) AS CustomerID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(Company, '#', TRIM(PartNum))))) AS PartID
	--,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(Company, '#', TRIM(IIF(PartNum IS NULL OR PartNum = '', 'MISSINGPART',  PartNum) ))))) AS PartID
	,CONVERT([binary](32), HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM(Company), '#', TRIM(WarehouseCode))))) AS WarehouseID
	--,CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT(Company, '#', WarehouseCode))) AS WarehouseID
	,CONCAT(Company, '#', OrderNum, '#', PartNum, '#', InvoiceNum) AS SalesOrderCode
	,CONVERT(int, replace(convert(date,InvoiceDate),'-','')) AS SalesInvoiceDateID  
	,CONCAT(Company, '#', OrderNum, '#', OrderLine) AS SalesInvoiceCode --Redundant?
	,CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT( Company, '#', '') ))	AS ProjectID
	,PartitionKey

	,UPPER(TRIM(Company)) AS Company
	,TRIM(SalesPerson) AS SalesPersonName
	,UPPER(TRIM(CustNum)) AS CustomerNum
	,UPPER(TRIM(PartNum)) AS PartNum
	,IIF(OrderSubLine = '000000',  'Main',  'Sub' ) AS PartType -- changed on 20210422 /DZ
	,TRIM(OrderNum) AS SalesOrderNum
	,TRIM(OrderLine) AS SalesOrderLine
	,TRIM(OrderSubLine) AS SalesOrderSubLine 
	,TRIM(OrderType) AS SalesOrderType
	,TRIM(InvoiceNum) AS SalesInvoiceNum
	,TRIM(InvoiceLine) AS SalesInvoiceLine
	--,'' AS SalesInvoiceType
	,convert(date, InvoiceDate) AS SalesInvoiceDate
	,[ActualDeliveryDate] AS ActualDelivDate
	,SellingShipQty	AS SalesInvoiceQty
	--,'' AS UoM
	,UnitPrice
	,UnitCost
	,CONVERT(decimal (18,4), IIF(SellingShipQty*UnitPrice = 0, 0, DiscountAmount/SellingShipQty*UnitPrice)) AS DiscountPercent
	,DiscountAmount
	--,0 AS CashDiscountOffered
	--,0 AS CashDiscountUsed
	,TotalMiscChrg
	,COALESCE(VATRate,0)/100 * (UnitPrice * SellingShipQty - DiscountAmount)  AS VATAmount
	,'EUR' AS Currency
	,CONVERT(decimal (18,4), 1) AS ExchangeRate
	,CreditMemo
	--,'' AS SalesChannel
	,Department
	,TRIM(WarehouseCode) AS WarehouseCode
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
FROM stage.CER_EE_SOLine
--GROUP BY
--	PartitionKey, Company, SalesPerson, CustNum, PartNum, OrderNum, OrderLine, OrderSubLine, OrderType, InvoiceNum, InvoiceLine, InvoiceDate, SellingShipQty, UnitPrice, UnitCost, DiscountAmount, TotalMiscChrg, WarehouseCode, CreditMemo, [ActualDeliveryDate], Indexkey, ReturnComment, ReturnNum, VATRate, Department
GO
