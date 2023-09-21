IF OBJECT_ID('[stage].[vCER_SE_OLine]') IS NOT NULL
	DROP VIEW [stage].[vCER_SE_OLine];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE VIEW [stage].[vCER_SE_OLine] AS
--COMMENT empty fields / ADD TRIM(Company) into PartID/CustomerID VA - 12-13-2022
SELECT
	CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(Company, '#', OrderNum, '#', OrderLine, '#', OrderSubLine, '#', InvoiceNum)))) AS SalesOrderID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(TRIM(Company)))) AS CompanyID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM(Company), '#', TRIM(CustNum))))) AS CustomerID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM(Company), '#', TRIM(PartNum))))) AS PartID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM(Company), '#', TRIM(WarehouseCode))))) AS WarehouseID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(Company, '#', TRIM(OrderNum))))) AS SalesOrderNumID
	,UPPER(CONCAT(Company, '#', TRIM(OrderNum), '#', TRIM(OrderLine), '#', UPPER(TRIM(PartNum)))) AS SalesOrderCode 
	--,UPPER(CONCAT(Company, '#', TRIM(OrderNum), '#', TRIM(OrderLine), '#', UPPER(TRIM(IIF(PartNum IS NULL OR PartNum = '', 'MISSINGPART',  PartNum) )))) AS SalesOrderCode -- important to match SalesInvoice's SalesOrderCode
	,CONVERT(int, replace(convert(date, OrderDate),'-','')) AS SalesOrderDateID   --redundent
	,CONVERT([binary](32), HASHBYTES('SHA2_256',CONCAT( Company,'#','') ))	AS ProjectID
	,PartitionKey 

	,UPPER(TRIM(Company)) AS Company
	,UPPER(TRIM(CustNum)) AS CustomerNum 
	--,UPPER(TRIM(IIF(CustNum IS NULL OR CustNum = '', 'MISSINGCUSTOMER', CustNum))) AS CustomerNum 
	,TRIM(OrderNum) AS SalesOrderNum
	,TRIM(OrderLine) AS SalesOrderLine
	,TRIM(OrderSubLine) AS SalesOrderSubLine
	,TRIM(OrderType) AS SalesOrderType
	--,'' AS SalesOrderCategory
	,OrderDate AS SalesOrderDate
	,NeedbyDate
	,DelivDate AS ExpDelivDate
	,CAST('1900-01-01' AS date) AS ActualDelivDate
	,CAST('1900-01-01' AS date) AS ConfirmedDelivDate
	,TRIM(InvoiceNum) AS SalesInvoiceNum
	,OrderQty AS SalesOrderQty
	,DelivQty	
	,RemainingQty
	--,NULL AS SalesInvoiceQty
	--,'' AS UoM
	,UnitPrice
	,UnitCost
	,TRIM(CurrencyCode) AS Currency
	,CurrExChRate AS ExchangeRate
	,OpenRelease
--	,OrderQty*UnitPrice AS LineAmt --temp
	,OrderQty*UnitPrice*DiscountPercent/100 AS DiscountAmount
	,DiscountPercent
	,UPPER(TRIM(PartNum)) AS PartNum
	--,UPPER(TRIM(IIF(PartNum IS NULL OR PartNum = '', 'MISSINGPART',  PartNum))) AS PartNum
	,IIF(OrderSubLine = '000000', 'Main', 'Sub' ) AS PartType -- changed from '' on 20210422 after ET
	,PartStatus
	,TRIM(SalesPerson) AS SalesPersonName
	,TRIM(WarehouseCode) AS WarehouseCode
	--,'' AS SalesChannel
	,CASE WHEN TRIM(SalesPerson) = 'Order entered through EDI' THEN 'EDI'
		WHEN TRIM(SalesPerson) = 'docparser' THEN 'PDF Scan'
		WHEN TRIM(SalesPerson) = 'Webshop Order' THEN 'Webshop'
		ELSE 'Normal Order Handling' END AS AxInterSalesChannel
	--,'' AS Department
	--,'' AS ProjectNum
	--,'' AS IndexKey
	--,'' AS Cancellation
	--,'' AS SORes1
	--,'' AS SORes2
	--,'' AS SORes3
	--,NULL AS [TotalMiscChrg]
FROM stage.CER_SE_OLine

GROUP BY
	PartitionKey, Company, CustNum, OrderNum, OrderLine, OrderSubLine, OrderRelNum, OrderRelNum, OrderDate, NeedbyDate, DelivDate, InvoiceNum, OrderQty, DelivQty, RemainingQty, UnitPrice, UnitCost, CurrExChRate, OpenRelease, DiscountAmount, DiscountPercent, PartNum, PartStatus, SalesPerson, WarehouseCode, CurrencyCode, OrderType
GO
