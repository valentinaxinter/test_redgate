IF OBJECT_ID('[stage].[vCER_UK_SOLine]') IS NOT NULL
	DROP VIEW [stage].[vCER_UK_SOLine];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [stage].[vCER_UK_SOLine] AS
--COMMENT EMPTY FIELD // ADD UPPER() TRIM() INTO CustomerID,PartID 2022-12-20 VA
SELECT 
	CONVERT([binary](32),HASHBYTES('SHA2_256',CONCAT(Company, '#', IndexKey))) AS SalesInvoiceID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT(Company, '#', OrderNum, '#', OrderLine, '#', OrderSubLine))) AS SalesOrderID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT(Company, '#', CustNum, '#', InvoiceNum))) AS SalesLedgerID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT(Company, '#', TRIM(OrderNum)))) AS SalesOrderNumID
    ,CONVERT([binary](32), HASHBYTES('SHA2_256', Company)) AS CompanyID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM(Company), '#', TRIM(CustNum))))) AS CustomerID
	--,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(Company, '#', TRIM(IIF(CustNum IS NULL OR CustNum = '', 'MISSINGCUSTOMER', CustNum) ))))) AS CustomerID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM(Company), '#', TRIM((PartNum)))))) AS PartID
	--,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(Company, '#', TRIM((IIF(PartNum IS NULL OR PartNum = '', 'MISSINGPART',  PartNum) )))))) AS PartID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM([Company]), '#', TRIM([WarehouseCode]))))) AS WarehouseID
	,CONCAT(Company, '#', OrderNum, '#', OrderLine, '#', OrderSubLine, '#', InvoiceNum) AS SalesOrderCode
	,CONVERT(int, replace(convert(date, InvoiceDate), '-', '')) AS SalesInvoiceDateID
	,CONCAT(Company, '#', InvoiceNum, '#', InvoiceLine) AS SalesInvoiceCode
	,CONVERT([binary](32), HASHBYTES('SHA2_256',CONCAT( Company,'#','') ))	AS ProjectID
	,PartitionKey

	,UPPER(TRIM(Company)) AS Company
	,TRIM(SalesPerson) AS SalesPersonName
	,UPPER(TRIM(CustNum)) AS CustomerNum
	,UPPER(TRIM(PartNum)) AS PartNum
	--,UPPER(TRIM(IIF(CustNum IS NULL OR CustNum = '', 'MISSINGCUSTOMER', CustNum))) AS CustomerNum
	--,UPPER(TRIM(IIF(PartNum IS NULL OR PartNum = '', 'MISSINGPART',  PartNum))) AS PartNum
	,IIF(OrderSubLine = '000000', 'Main', 'Sub' ) AS [PartType]
	,TRIM(OrderNum) AS [SalesOrderNum]
	,TRIM(OrderLine) AS [SalesOrderLine]
	,TRIM(OrderSubLine) AS [SalesOrderSubLine]
	,TRIM(OrderType) AS [SalesOrderType]
	,TRIM(InvoiceNum) AS [SalesInvoiceNum]
	,TRIM(InvoiceLine) AS [SalesInvoiceLine]
	,'' AS [SalesInvoiceType]
	,CONVERT(date, InvoiceDate) AS SalesInvoiceDate
	,ActualDeliveryDate AS [ActualDelivDate]
	,SellingShipQty AS [SalesInvoiceQty]
	--,'' AS UoM
	,UnitPrice
	,UnitCost
	,IIF((UnitPrice*SellingShipQty) <> 0, DiscountAmount/(UnitPrice*SellingShipQty), 0) AS [DiscountPercent]
	,DiscountAmount
	--,0 AS CashDiscountOffered
	--,0 AS CashDiscountUsed
	,TotalMiscChrg
	--,NULL AS [VATAmount]
	,Currency
	,CONVERT(decimal (18,4), ExchangeRate) AS ExchangeRate
	,CreditMemo
	,CASE WHEN LEFT(OrderNum, 4) = '0006' THEN 'Webshop'
		WHEN SalesPerson = 'Blake Barlow' or SalesPerson = 'Ashley Grist' THEN  'RFQ'
--		WHEN SalesPerson = '????' THEN 'PDF'
		ELSE 'Normal Order Handling' END AS SalesChannel
	--,'' AS [Department]
	,TRIM(WarehouseCode) AS WarehouseCode
	--,NULL AS DeliveryAddress
	--,'' AS [CostBearerNum]
	--,'' AS [CostUnitNum]
	,[ReturnComment]
	,TRIM([ReturnNum]) AS [ReturnNum]
	--,'' AS [ProjectNum]
	, Indexkey
	--,'' AS SIRes1
	--,'' AS SIRes2
	--,'' AS SIRes3
FROM
	stage.CER_UK_SOLine
GROUP BY
	PartitionKey, Company, SalesPerson, CustNum, PartNum, OrderNum, OrderLine, OrderSubLine, OrderType, InvoiceNum, InvoiceLine, InvoiceDate, SellingShipQty, UnitPrice, UnitCost, DiscountAmount, TotalMiscChrg, WarehouseCode, CreditMemo, ActualDeliveryDate, ExchangeRate, Currency, ReturnComment, [ReturnNum], IndexKey
GO
