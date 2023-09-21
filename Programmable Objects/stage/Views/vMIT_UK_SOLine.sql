IF OBJECT_ID('[stage].[vMIT_UK_SOLine]') IS NOT NULL
	DROP VIEW [stage].[vMIT_UK_SOLine];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [stage].[vMIT_UK_SOLine] AS
--COMMENT EMPTY FIELDS // ADD UPPER() INTO PartID,CustomerID,WarehouseID 22-12-28 VA
SELECT 
	CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT(Company, '#', TRIM(OrderNum), '#', TRIM(OrderLine), '#', TRIM(OrderSubLine), '#', TRIM(InvoiceNum) ))) AS SalesInvoiceID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT(Company, '#', TRIM(OrderNum), '#', TRIM(OrderLine), '#', TRIM(OrderSubLine), '#', TRIM(InvoiceNum)))) AS SalesOrderID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT(Company, '#', TRIM(IIF(CustNum IS NULL OR CustNum = '', 'MISSINGCUSTOMER', CustNum) ), '#', TRIM(InvoiceNum)))) AS SalesLedgerID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT(Company, '#', TRIM(OrderNum)))) AS SalesOrderNumID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', Company)) AS CompanyID
	,CONVERT([binary](32), HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM(Company), '#', TRIM(CustNum))))) AS CustomerID
	--,CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT(Company, '#', TRIM(IIF(CustNum IS NULL OR CustNum = '', 'MISSINGCUSTOMER', CustNum) ) ))) AS CustomerID
	,CONVERT([binary](32), HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM(Company), '#', TRIM(PartNum))))) AS PartID 
	--,CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT(Company, '#', TRIM(IIF(PartNum IS NULL OR PartNum = '', 'MISSINGPART',  PartNum) ) ))) AS PartID 
	,CONVERT([binary](32), HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM(Company), '#', TRIM(WarehouseCode))))) AS WareHouseID
	--,CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT(Company, '#', TRIM(WarehouseCode)))) AS WareHouseID
	,CONCAT(Company, '#', TRIM(OrderNum), '#', TRIM(OrderLine), '#', TRIM(OrderSubLine), '#', TRIM(InvoiceNum)) AS SalesOrderCode
	,CONVERT(int, replace(convert(date,InvoiceDate),'-','')) AS SalesInvoiceDateID   -- Redundant
	,CONCAT(Company, TRIM(OrderNum), TRIM(OrderLine), TRIM(OrderSubLine), TRIM(InvoiceNum)) AS SalesInvoiceCode
	,CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT(Company, '#', TRIM(InvoiceNum)))) AS SalesInvoiceNumID --Redundant?
	,CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT( Company, '#', '') )) AS ProjectID
	,PartitionKey

	,TRIM(Company) AS Company
	,TRIM(SalesPersonName) AS SalesPersonName
	,TRIM(IIF(CustNum IS NULL OR CustNum = '', 'MISSINGCUSTOMER', CustNum) ) AS CustomerNum
	,TRIM(IIF(PartNum IS NULL OR PartNum = '', 'MISSINGPART',  PartNum) ) AS PartNum
	,CASE WHEN TRIM(OrderNum) = '0' THEN 'PrimaryPart' ELSE 'SubPart' END  AS PartType --DZ added 20210324. SM added dm logic to stage 20210325
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
	--,NULL VATAmount
	,Currency
	,CurrExchRate AS ExchangeRate
	,CreditMemo
	,CASE WHEN TRIM(Department) IN ('HSL SERV','QB Service Fire Div', 'QUEENBOROUGH SERVICE') THEN 'Service' 
		  WHEN TRIM(Department) IN ('HSLPARTS', 'QB PARTS') THEN 'Parts' 
		  WHEN TRIM(Department) IN ('QB UNITS') THEN 'Units' 	
		  WHEN TRIM(Department) IN ('Peter Fenton') THEN 'Sundry'
		  ELSE 'Other'	END		AS SalesChannel  --Uses this field as "mother" category for department /SM 2021-06-18
	,CASE TRIM(Department) 
		WHEN 'Hensall WIP'			THEN 'HS WIP'
		WHEN 'HSL SERV'				THEN 'HS Service'
		WHEN 'HSLPARTS'				THEN 'HS Parts'
		WHEN 'QB Service Fire Div'	THEN 'QB Service Fire Division'
		WHEN 'QUEENBOROUGH SERVICE'	THEN 'QB Service'
		WHEN 'Queenborough WIP'		THEN 'QB WIP'
		ELSE dbo.ProperCase(TRIM(Department)) END	AS [Department]
	,TRIM(WarehouseCode) AS WarehouseCode
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
--	,[Site]
FROM stage.MIT_UK_SOLine AS SO
GROUP BY PartitionKey, Company, SalesPersonName, CustNum, PartNum ,OrderNum, OrderLine, OrderSubLine, InvoiceNum, InvoiceDate, ActualDeliveryDate, UnitPrice, UnitCost, TotalMiscChrg,Department, WarehouseCode, CurrExchRate, Currency, CreditMemo
GO
