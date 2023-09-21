IF OBJECT_ID('[stage].[vHAK_FI_SOLine]') IS NOT NULL
	DROP VIEW [stage].[vHAK_FI_SOLine];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [stage].[vHAK_FI_SOLine] AS
--COMMENT EMPTY FIELD // ADD TRIM() UPPER() INTO WarehouseID,CustomerID 2022-12-21 VA 
-- CHANGE SALESORDERCODE AND SalesLedgerID 23-02-20 VA
SELECT 
	CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT(Company, '#', TRIM(UPPER(CustNum)), '#', TRIM(UPPER(OrderNum)), '#', TRIM(UPPER(PartNum)), '#', TRIM(UPPER(InvoiceNum)), '#', TRIM(UPPER(InvoiceLine)) ))) AS SalesInvoiceID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT(Company, '#', TRIM(UPPER(OrderNum)), '#', TRIM(UPPER(OrderLine)), '#', TRIM(UPPER(InvoiceNum))))) AS SalesOrderID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM(Company), '#', TRIM(CustNum), '#', TRIM(InvoiceNum))))) AS SalesLedgerID
	--,CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT(Company, '#', TRIM(UPPER(IIF(CustNum = '' OR CustNum IS NULL, 'MissingCustomer', CustNum))), '#', TRIM(UPPER(InvoiceNum))))) AS SalesLedgerID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT(Company, '#', TRIM(UPPER(OrderNum)) ))) AS SalesOrderNumID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', Company)) AS CompanyID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM(Company), '#', TRIM(CustNum))))) AS CustomerID
	--,CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT(Company, '#', TRIM(UPPER(IIF(CustNum = '' OR CustNum IS NULL, 'MissingCustomer', CustNum))) ))) AS CustomerID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM(Company), '#', TRIM(PartNum))))) AS PartID
	--,CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT(Company, '#', TRIM(UPPER(IIF(PartNum = '' OR PartNum IS NULL, 'MissingPart', PartNum))) ))) AS PartID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM(Company), '#', TRIM(WarehouseCode))))) AS WarehouseID
	--,CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT(Company, '#', WarehouseCode))) AS WarehouseID
	--,UPPER(CONCAT(TRIM(Company), '#', TRIM(OrderNum), '#', TRIM(PartNum))) AS SalesOrderCode
	,CONCAT(Company, '#', TRIM(UPPER(OrderNum)), '#', TRIM(UPPER(IIF(PartNum = '' OR PartNum IS NULL, 'MissingPart', PartNum)))) AS SalesOrderCode
	,CONVERT(int, replace(convert(date,InvoiceDate),'-','')) AS SalesInvoiceDateID  
	,CONCAT(Company, '#', TRIM(UPPER(InvoiceNum)), '#', TRIM(UPPER(InvoiceLine)) ) AS SalesInvoiceCode
	,CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT( Company,'#','') ))	AS ProjectID
	,PartitionKey

	,TRIM(Company) AS Company
	,TRIM(SalesPerson) AS SalesPersonName
	,TRIM(UPPER(CustNum)) AS CustomerNum -- IIF(CustNum = '' OR CustNum IS NULL, 'MissingCustomer', CustNum)
	,TRIM(UPPER(PartNum)) AS PartNum -- IIF(PartNum = '' OR PartNum IS NULL, 'MissingPart', PartNum)
	,CASE WHEN TRIM(UPPER(OrderNum)) = '0' THEN 'PrimaryPart' ELSE 'SubPart' END  AS PartType
	,TRIM(UPPER(OrderNum)) AS SalesOrderNum
	,TRIM(UPPER(OrderLine)) AS SalesOrderLine
	,OrderSubLine AS SalesOrderSubLine
--	,OrderRel AS OrderRelNum
	,OrderType AS SalesOrderType
 	,TRIM(UPPER(InvoiceNum)) AS SalesInvoiceNum
	,TRIM(UPPER(InvoiceLine)) AS SalesInvoiceLine
	--,'' AS SalesInvoiceType
	,CASE WHEN InvoiceDate = '' THEN '1901-01-01' ELSE CONVERT(date, InvoiceDate) END AS SalesInvoiceDate
	,ActualDeliveryDate AS ActualDelivDate
	,SellingShipQty AS SalesInvoiceQty
	--,'' AS UoM
	,UnitPrice
	,CASE WHEN CreditMemo = '1' THEN UnitCost*-1 ELSE UnitCost END AS UnitCost
	--,0 AS DiscountPercent
	,DiscountAmount
	--,0 AS CashDiscountOffered
	--,0 AS CashDiscountUsed
	,TotalMiscChrg
	--,0 AS VATAmount
	,'EUR' AS Currency
	,CONVERT(decimal (18,4), 1) AS ExchangeRate
	,CreditMemo
	--,'' AS SalesChannel
	--,'' AS Department
	,WarehouseCode
	--,NULL AS DeliveryAddress
	--,'' AS CostBearerNum
	--,'' AS CostUnitNum
	--,'' AS ReturnComment
	--,'' AS ReturnNum
	--,'' AS ProjectNum
	--,'' AS IndexKey
	--,'' AS SIRes1
	--,'' AS SIRes2
	--,'' AS SIRes3
FROM 
	stage.HAK_FI_SOLine
GROUP BY
	PartitionKey, Company, SalesPerson, CustNum, PartNum, TRIM(UPPER(OrderNum)), TRIM(UPPER(OrderLine)), OrderSubLine, OrderType,InvoiceNum, TRIM(UPPER(InvoiceLine)), InvoiceDate, ActualDeliveryDate, SellingShipQty, UnitPrice, UnitCost, CreditMemo, DiscountAmount, TotalMiscChrg, WarehouseCode--, TRIM(UPPER([Site]))
GO
