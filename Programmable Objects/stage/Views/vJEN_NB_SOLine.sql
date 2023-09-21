IF OBJECT_ID('[stage].[vJEN_NB_SOLine]') IS NOT NULL
	DROP VIEW [stage].[vJEN_NB_SOLine];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [stage].[vJEN_NB_SOLine] AS
--COMMENT EMPTY FIELDS // ADD TRIM() INTO CustomerID,PartID 23-01-03 VA
SELECT 
	CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(Company, '#', TRIM(CustNum), '#', TRIM(OrderNum), '#', TRIM(PartNum), '#', TRIM(InvoiceNum), '#', TRIM(InvoiceLine), '#', Indexkey)))) AS SalesInvoiceID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(Company, '#', OrderNum, '#', OrderLine, '#', InvoiceNum)))) AS SalesOrderID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(Company, '#', TRIM(IIF(CustNum IS NULL OR CustNum = '', 'MISSINGCUSTOMER', CustNum) ), '#', InvoiceNum)))) AS SalesLedgerID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(Company, '#', TRIM(OrderNum))))) AS SalesOrderNumID
	--,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(Company, '#', TRIM(IIF(CustNum IS NULL OR CustNum = '', 'MISSINGCUSTOMER', CustNum) ))))) AS CustomerID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM(Company), '#', TRIM(CustNum))))) AS CustomerID
    ,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(Company))) AS CompanyID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM(Company), '#',TRIM(PartNum))))) AS PartID 
	--,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(Company, '#', TRIM(IIF(PartNum IS NULL OR PartNum = '', 'MISSINGPART',  PartNum) ))))) AS PartID 
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM(Company), '#', TRIM(WarehouseCode))))) AS WarehouseID
	--,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(Company, '#', TRIM(WarehouseCode))))) AS WarehouseID
	,UPPER(CONCAT(Company, '#', OrderNum, '#', OrderLine, '#', OrderSubLine, '#', InvoiceNum)) AS SalesOrderCode
	,UPPER(CONCAT(Company, '#', TRIM(InvoiceNum), '#', TRIM(InvoiceLine))) AS SalesInvoiceCode 
	,CONVERT(int, replace(convert(date,InvoiceDate),'-','')) AS SalesInvoiceDateID  
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT( Company,'#','') )))	AS ProjectID
	,PartitionKey

	,UPPER(Company) AS Company
	,UPPER(TRIM(IIF(CustNum IS NULL OR CustNum = '', 'MISSINGCUSTOMER', CustNum)) ) AS CustomerNum
	,UPPER(TRIM(IIF(PartNum IS NULL OR PartNum = '', 'MISSINGPART',  PartNum)) ) AS PartNum
	,TRIM(SalesPerson) AS SalesPersonName
	,CASE WHEN TRIM(OrderNum) = '0' THEN 'PrimaryPart' ELSE 'SubPart' END  AS PartType
	,TRIM(OrderNum) AS SalesOrderNum
	,OrderLine		AS SalesOrderLine
	,OrderSubLine	AS SalesOrderSubLine
	,OrderType AS SalesOrderType
	,InvoiceNum	AS SalesInvoiceNum
	,InvoiceLine	AS SalesInvoiceLine
	--,'' AS SalesInvoiceType
	,CASE WHEN InvoiceDate = '' THEN '1901-01-01' ELSE CONVERT(date, InvoiceDate) END AS SalesInvoiceDate
	,ActualDeliveryDate		AS ActualDelivDate
	--,'' AS UoM
	,SellingShipQty			AS SalesInvoiceQty
	,UnitPrice	
	,UnitCost
	--,NULL AS DiscountPercent
	,DiscountAmount
	--,0 AS CashDiscountOffered
	--,0 AS CashDiscountUsed
	,TotalMiscChrg
	--,NULL AS VATAmount
	,[CurrencyCode] AS Currency
	,[ExchangeRate] AS ExchangeRate
	,CreditMemo
	--,'' AS SalesChannel
	--,'' AS Department
	,TRIM(WarehouseCode) AS WarehouseCode
	--,NULL AS DeliveryAddress
	--,'' AS CostBearerNum
	--,''AS CostUnitNum
	--,'' AS ReturnComment
	--,'' AS ReturnNum
	--,'' AS ProjectNum
	,IndexKey
	--,'' AS SIRes1
	--,'' AS SIRes2
	--,'' AS SIRes3

FROM stage.JEN_NB_SOLine

--GROUP BY
--	PartitionKey,Company,SalesPerson, CustNum, PartNum, OrderNum,OrderLine,OrderSubLine, OrderType,InvoiceNum,InvoiceLine, InvoiceDate,ActualDeliveryDate,SellingShipQty,UnitPrice ,UnitCost ,DiscountAmount,TotalMiscChrg,WarehouseCode, [CurrencyCode], [ExchangeRate], CreditMemo, Indexkey, OrderType
GO
