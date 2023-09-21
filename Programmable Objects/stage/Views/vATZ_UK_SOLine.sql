IF OBJECT_ID('[stage].[vATZ_UK_SOLine]') IS NOT NULL
	DROP VIEW [stage].[vATZ_UK_SOLine];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [stage].[vATZ_UK_SOLine] AS
--COMMENT EMPTY FIELDS // ADD UPPER()TRIM() INTO PartID,CustomerID,WarehouseID 2022-12-27 VA
--Problem with the group by clause,need to resolve. 2022-12-27 VA
SELECT 
	CONVERT([binary](32),HASHBYTES('SHA2_256',CONCAT(Company,'#',TRIM(OrderNum),'#',TRIM(OrderLine),'#',TRIM(OrderSubLine),'#',TRIM(InvoiceNum)))) AS SalesInvoiceID
	,CONVERT([binary](32),HASHBYTES('SHA2_256',CONCAT(Company,'#',TRIM(OrderNum),'#',TRIM(OrderLine),'#',TRIM(OrderSubLine),'#',TRIM(InvoiceNum)))) AS SalesOrderID --were SakesOrderID
	,CONVERT([binary](32),HASHBYTES('SHA2_256',CONCAT(Company,'#',TRIM(IIF(CustNum IS NULL OR CustNum = '', 'MISSINGCUSTOMER', CustNum) ), '#', TRIM(InvoiceNum)))) AS SalesLedgerID
	,CONVERT([binary](32),HASHBYTES('SHA2_256',CONCAT(Company,'#',TRIM(OrderNum)))) AS SalesOrderNumID
	,CONVERT([binary](32),HASHBYTES('SHA2_256',Company)) AS CompanyID
	,CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM(Company),'#',TRIM(IIF(CustNum IS NULL OR CustNum = '', 'MISSINGCUSTOMER', CustNum)))))) AS CustomerID
	--,CONVERT([binary](32),HASHBYTES('SHA2_256',CONCAT(Company,'#',TRIM(IIF(CustNum IS NULL OR CustNum = '', 'MISSINGCUSTOMER', CustNum) ) ))) AS CustomerID
	,CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM(Company),'#',TRIM(IIF(PartNum IS NULL OR PartNum = '', 'MISSINGPART',  PartNum)))))) AS PartID
	--,CONVERT([binary](32),HASHBYTES('SHA2_256',CONCAT(Company,'#',TRIM(IIF(PartNum IS NULL OR PartNum = '', 'MISSINGPART',  PartNum) ) ))) AS PartID 
	,CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM(Company),'#',TRIM(WarehouseCode))))) AS WarehouseID
	--	,CONVERT([binary](32),HASHBYTES('SHA2_256',CONCAT(Company,'#',TRIM(WarehouseCode)))) AS WarehouseID
	,CONCAT(Company,'#',TRIM(OrderNum),'#',TRIM(OrderLine),'#',TRIM(OrderSubLine),'#',TRIM(InvoiceNum)) AS SalesOrderCode
	,CONVERT(int, replace(convert(date,InvoiceDate),'-','')) AS SalesInvoiceDateID 
	,CONCAT(Company,TRIM(OrderNum),TRIM(OrderLine),TRIM(OrderSubLine),TRIM(InvoiceNum)) AS SalesInvoiceCode -- Redundant and possible not correct
	,CONVERT([binary](32), HASHBYTES('SHA2_256',CONCAT( Company,'#','') ))	AS ProjectID
	,PartitionKey

	,TRIM(Company) AS Company
	,TRIM(SalesPersonName) AS SalesPersonName
	,TRIM(IIF(CustNum IS NULL OR CustNum = '', 'MISSINGCUSTOMER', CustNum) ) AS CustomerNum
	,TRIM(IIF(PartNum IS NULL OR PartNum = '', 'MISSINGPART',  PartNum) ) AS PartNum
	,CASE WHEN TRIM(OrderNum) = '0' THEN 'PrimaryPart' ELSE 'SubPart' END  AS PartType
	,TRIM(OrderNum) AS SalesOrderNum
	,TRIM(OrderLine) AS SalesOrderLine
	,TRIM(OrderSubLine) AS SalesOrderSubLine
	--,'' AS SalesOrderType
	,TRIM(InvoiceNum) AS SalesInvoiceNum
	--,'' AS SalesInvoiceLine
	--,'' AS SalesInvoiceType
	,convert(date, InvoiceDate) AS SalesInvoiceDate
	,ActualDeliveryDate		AS ActualDelivDate
	,SUM(SellingShipQty) AS SalesInvoiceQty
	--,'' AS UoM
	,UnitPrice
	,UnitCost
	--,NULL AS DiscountPercent
	,SUM(DiscountAmount) AS DiscountAmount
	--,0 AS CashDiscountOffered
	--,0 AS CashDiscountUsed
	,TotalMiscChrg
	--,NULL AS VATAmount
	,Currency
	,CurrExchRate AS ExchangeRate
	,CreditMemo
	,'ATZ All products' AS SalesChannel --Used as a "mother" category of Department /Sm 2021-06-18
	,COALESCE(Department,'ATZ All products')  AS Department
	,TRIM(WarehouseCode) AS WarehouseCode
	--,NULL AS DeliveryAddress
	--,'' AS CostBearerNum
	--,'' AS CostUnitNum
	--,'' AS ReturnComment
	--,'' AS ReturnNum
	--,'' AS ProjectNum
	--,'' AS IndexKey
	--,'' AS SIRes1 -- DZ added "SI" prefix 20210324
	--,'' AS SIRes2 -- DZ added "SI" prefix 20210324
	--,'' AS SIRes3 -- DZ added "SI" prefix 20210324

FROM stage.ATZ_UK_SOLine AS SO
GROUP BY PartitionKey, Company, SalesPersonName, TRIM(IIF(CustNum IS NULL OR CustNum = '', 'MISSINGCUSTOMER', CustNum) ), TRIM(IIF(PartNum IS NULL OR PartNum = '', 'MISSINGPART',  PartNum) ) ,OrderNum, OrderLine, OrderSubLine, InvoiceNum, InvoiceDate, ActualDeliveryDate, UnitPrice, UnitCost, TotalMiscChrg,Department, WarehouseCode, CurrExchRate, Currency, CreditMemo
GO
