IF OBJECT_ID('[stage].[vNOM_SEIND_SOLine]') IS NOT NULL
	DROP VIEW [stage].[vNOM_SEIND_SOLine];

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE VIEW [stage].[vNOM_SEIND_SOLine] AS

SELECT 
	CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM(Company),'#',TRIM(CustNum), '#', TRIM(OrderNum), '#', TRIM(PartNum), '#', TRIM(InvoiceNum), '#', TRIM(InvoiceLine))))) AS SalesInvoiceID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM(Company), '#', TRIM(OrderNum), '#', TRIM(OrderLine), '#', TRIM(OrderSubLine))))) AS SalesOrderID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM(Company), '#', TRIM(CustNum), '#', TRIM(InvoiceNum))))) AS SalesLedgerID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM(Company), '#', TRIM(OrderNum))))) AS SalesOrderNumID  
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(TRIM(Company)))) AS CompanyID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM(Company), '#', TRIM(CustNum))))) AS CustomerID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM(Company), '#', TRIM(PartNum))))) AS PartID 
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM([Company]), '#', TRIM([WarehouseCode]))))) AS WarehouseID
	,UPPER(CONCAT(TRIM(Company), '#', TRIM(OrderNum), '#', TRIM(OrderLine))) AS SalesOrderCode 
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM(Company), '#', TRIM(InvoiceNum))))) AS SalesInvoiceNumID 
	,CONVERT(int, replace(convert(date,InvoiceDate), '-', '')) AS SalesInvoiceDateID
	,UPPER(CONCAT(TRIM(Company), '#', TRIM(InvoiceNum), '#', TRIM(InvoiceLine))) AS SalesInvoiceCode
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT( Company, '#', '') ))) AS ProjectID
	,PartitionKey

	,UPPER(TRIM(Company)) AS Company
	,TRIM(SalesPerson) AS SalesPersonName
	,UPPER(TRIM(CustNum)) AS CustomerNum
	,UPPER(TRIM(PartNum)) AS PartNum
	,CASE WHEN TRIM(OrderNum) = '0' THEN 'PrimaryPart' ELSE 'SubPart' END  AS PartType
	,UPPER(TRIM(OrderNum)) AS SalesOrderNum
	,UPPER(TRIM(OrderLine)) AS SalesOrderLine
	,UPPER(TRIM(OrderSubLine)) AS SalesOrderSubLine-- '0' as OrderSubLine
	,UPPER(TRIM(OrderType)) AS SalesOrderType
	,UPPER(TRIM(InvoiceNum)) AS SalesInvoiceNum
	,UPPER(TRIM(InvoiceLine)) AS SalesInvoiceLine
	--,'' AS SalesInvoiceType
	,CONVERT(date, InvoiceDate) AS SalesInvoiceDate
	,CONVERT(date, ActualDeliveryDate) AS ActualDelivDate
	,CASE WHEN CreditMemo = '1' THEN -1*ABS(SellingShipQty)
--		WHEN UnitCost = 0 THEN 0 
		ELSE SellingShipQty END AS SalesInvoiceQty
	,ABS(UnitPrice) AS UnitPrice 
	,ABS(UnitCost) AS UnitCost 
	--,'' AS UoM
	--,0 AS DiscountPercent
	,DiscountAmount
	--,0 AS CashDiscountOffered
	--,0 AS CashDiscountUsed
	,TotalMiscChrg
	--,0 AS VATAmount
	,Currency
	,ExchangeRate
	,CreditMemo
	--,CASE WHEN LEFT(SalesPerson, 7) = 'WEBSHOP' THEN 'Webshop'
	--	WHEN SUBSTRING(SalesPerson, 2, 5) = 'BUTIK' OR SUBSTRING(SalesPerson, 1, 7) = 'KONTANT' THEN 'Over-the-Counter'
	--	ELSE 'Normal Order Handling' END AS SalesChannel
	,SalesChannel
	,UpdateStock AS IsUpdatingStock
	--,'' AS Department
	,UPPER(TRIM(WarehouseCode)) AS WarehouseCode
	--,NULL AS DeliveryAddress
	--,'' AS CostBearerNum
	--,'' AS CostUnitNum
	--,'' AS ReturnComment
	--,'' AS ReturnNum
	,TRIM(PartClass) AS ProjectNum
	,MAX(Indexkey) AS IndexKey
	--,'' AS SIRes1
	--,'' AS SIRes2
	--,'' AS SIRes3
FROM 
	stage.NOM_SEIND_SOLine AS SO
GROUP BY
	PartitionKey, Company, CustNum, OrderNum, OrderLine, OrderSubLine, OrderType, InvoiceNum, InvoiceLine, InvoiceDate, SellingShipQty, UnitPrice, UnitCost, Currency, ExchangeRate, TotalMiscChrg, DiscountAmount,PartNum, SalesPerson,  WarehouseCode, CreditMemo, SalesChannel, UpdateStock, PartClass, ActualDeliveryDate
GO
