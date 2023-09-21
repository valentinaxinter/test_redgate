IF OBJECT_ID('[stage].[vOCS_SE_SOLine]') IS NOT NULL
	DROP VIEW [stage].[vOCS_SE_SOLine];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [stage].[vOCS_SE_SOLine] AS
--COMMENT EMPTY FIELD // ADD UPPER()TRIM() INTO PartID,CustomerID,WarehouseID 2022-12-21 VA
SELECT 
	CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT(Company, '#', TRIM(CustNum), '#', TRIM(OrderNum), '#', TRIM(PartNum), '#', TRIM(InvoiceNum), '#', TRIM(InvoiceLine), '#', SellingShipQty,'#', UnitPrice, '#', UnitCost))) AS SalesInvoiceID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT(Company, '#', OrderNum, '#', OrderLine, '#', InvoiceNum))) AS SalesOrderID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT(Company, '#', CustNum, '#', InvoiceNum))) AS SalesLedgerID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT(Company, '#', TRIM(OrderNum)))) AS SalesOrderNumID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', Company)) AS CompanyID
	,CONVERT([binary](32), HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM(Company), '#', TRIM(CustNum))))) AS CustomerID
	--,CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT(Company, '#', TRIM(CustNum)))) AS CustomerID
	,CONVERT([binary](32), HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM(Company), '#', TRIM(PartNum))))) AS PartID
	--,CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT(Company, '#', PartNum))) AS PartID
	,CONVERT([binary](32), HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM(Company), '#', TRIM(WarehouseCode))))) AS WarehouseID
	--,CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT(Company, '#', WarehouseCode))) AS WarehouseID
	,CONCAT(Company, '#', OrderNum, '#', OrderLine, '#', InvoiceNum) AS SalesOrderCode
	,CONCAT(Company, '#', TRIM(InvoiceNum), '#', TRIM(InvoiceLine)) AS SalesInvoiceCode --redundent?
	,CONVERT(int, replace(convert(date, InvoiceDate), '-', '')) AS SalesInvoiceDateID --redundent?
	,CONVERT([binary](32), HASHBYTES('SHA2_256',CONCAT( Company,'#',[ProjectNum]) ))	AS ProjectID
	,PartitionKey

	,Company
	,[dbo].[ProperCase](SalesPerson) AS SalesPersonName
	,TRIM(CustNum) AS CustomerNum
	,TRIM(PartNum) AS PartNum
	--,'' AS PartType
	,TRIM(OrderNum) AS SalesOrderNum
	,OrderLine AS SalesOrderLine
	--,'' AS SalesOrderSubLine
	,[OrderType] AS SalesOrderType
	--,'' AS OrderCategory
	,InvoiceNum AS SalesInvoiceNum
	,InvoiceLine AS SalesInvoiceLine
	,InvoiceType AS SalesInvoiceType
	,IIF(InvoiceDate = '',  CONVERT(date, '1901-01-01'),  CONVERT(date, InvoiceDate)) AS SalesInvoiceDate
	,IIF(ActualDeliveryDate = '0', CONVERT(date, '1901-01-01'), CONVERT(date, ActualDeliveryDate)) AS ActualDelivDate
	,SellingShipQty AS SalesInvoiceQty
	,[Unit] AS UoM
	,UnitPrice
	,UnitCost
	,IIF( (UnitPrice*SellingShipQty) = 0, 0, DiscountAmount/(UnitPrice*SellingShipQty) ) AS DiscountPercent
	,DiscountAmount
	--,0 AS CashDiscountOffered
	--,0 AS CashDiscountUsed
	,TotalMiscChrg
	,[VAT] AS VATAmount
	,Currency
	,CONVERT(decimal (18,4), ExchangeRate) AS ExchangeRate
	,IIF(SellingShipQty < 0, '1', '0') AS CreditMemo
	,[SalesChannel] AS SalesChannel
	,[BusinessChain] AS Department
	,WarehouseCode
	--,NULL AS DeliveryAddress
	--,'' AS CostBearerNum
	--,'' AS CostUnitNum
	--,'' AS ReturnComment
	--,'' AS ReturnNum
	,[ProjectNum] AS ProjectNum
	--,'' AS IndexKey
	--,'' AS SIRes1
	--,'' AS SIRes2
	--,'' AS SIRes3
FROM stage.OCS_SE_SOLine
GROUP BY
	PartitionKey, Company, SalesPerson, CustNum, PartNum, OrderNum, OrderLine, OrderType, InvoiceNum, InvoiceLine, InvoiceDate, ActualDeliveryDate, SellingShipQty, UnitPrice, UnitCost, DiscountAmount, TotalMiscChrg, WarehouseCode, CreditMemo,  ExchangeRate, InvoiceType, Currency, [ProjectNum], [VAT], [Unit], [SalesChannel], [BusinessChain]
GO
