IF OBJECT_ID('[stage].[vCER_LV_OLine]') IS NOT NULL
	DROP VIEW [stage].[vCER_LV_OLine];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [stage].[vCER_LV_OLine] AS
--COMMENT EMPTY FIELDS / ADD UPPER()TRIM() INTO PartID,CustomerID 2022-12-21 VA
SELECT
	CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT(lvo.Company, '#', OrderNum, '#', OrderLine, '#', OrderSubLine, '#', OrderRelNum, '#', MAX(InvoiceNum), '#', SalesReturnOrderNum))) AS SalesOrderID
	,CONVERT([binary](32), HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM(lvo.Company), '#', TRIM(CustNum))))) AS CustomerID
	--,CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT(lvo.Company, '#', TRIM(IIF(CustNum IS NULL OR CustNum = '', 'MISSINGCUSTOMER', CustNum) ) ))) AS CustomerID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', lvo.Company)) AS CompanyID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM(lvo.Company), '#', TRIM(PartNum) )))) AS PartID 
	--,CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT(lvo.Company, '#', TRIM(IIF(PartNum IS NULL OR PartNum = '', 'MISSINGPART',  PartNum) )))) AS PartID 
	,CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT(lvo.Company, '#', WarehouseCode))) AS WarehouseID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT(lvo.Company, '#', TRIM(OrderNum)))) AS SalesOrderNumID
	,CONCAT(lvo.Company, '#', OrderNum, '#', OrderLine, '#', TRIM(IIF(PartNum IS NULL OR PartNum = '', 'MISSINGPART',  PartNum) )) AS SalesOrderCode
	,CONVERT(int, replace(convert(date, OrderDate),'-','')) AS SalesOrderDateID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT( lvo.Company,'#','') ))	AS ProjectID
	,lvo.PartitionKey 

	,TRIM(lvo.Company) AS Company
	,TRIM(CustNum) AS CustomerNum 
	--,TRIM(IIF(CustNum IS NULL OR CustNum = '', 'MISSINGCUSTOMER', CustNum) ) AS CustomerNum 
	,TRIM(OrderNum) AS SalesOrderNum
	,TRIM(OrderLine) AS SalesOrderLine
	,TRIM(OrderSubLine) AS SalesOrderSubLine
	,TRIM(OrderType) AS SalesOrderType
	--,'' AS SalesOrderCategory
	,TRIM(OrderRelNum) AS SalesOrderRelNum
	,OrderDate AS SalesOrderDate
	,NeedbyDate
	,DelivDate AS ExpDelivDate
	,CAST('1900-01-01' AS date) AS ActualDelivDate
	,CAST('1900-01-01' AS date) AS ConfirmedDelivDate
	,MAX(InvoiceNum) AS SalesInvoiceNum
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
	,DiscountAmount
	,DiscountPercent
	,TRIM(PartNum) AS PartNum
	--,TRIM(IIF(PartNum IS NULL OR PartNum = '', 'MISSINGPART',  PartNum) ) AS PartNum
	,IIF(OrderSubLine = '000000', 'Main', 'Sub' ) AS PartType
	,PartStatus
	,TRIM(lvo.SalesPerson) AS SalesPersonName
	,CASE WHEN WarehouseCode = '' OR WarehouseCode is NULL THEN 'Other' ELSE WarehouseCode END AS WarehouseCode
	--,'' AS SalesChannel
	,CASE WHEN left(OrderNum, 4) = '0004' THEN 'RFQ'
		WHEN left(OrderNum, 4) = '0005' THEN 'Webshop'
		ELSE 'Normal Order Handling' END AS AxInterSalesChannel
	--,'' AS Department
	--,'' AS ProjectNum
	--,'' AS IndexKey
	--,'0' AS Cancellation
	--,'' AS SORes1
	--,'' AS SORes2
	--,'' AS SORes3
	--,NULL AS [TotalMiscChrg]
FROM stage.CER_LV_OLine lvo


GROUP BY
	lvo.PartitionKey, CustNum, OrderNum, OrderLine, OrderSubLine, OrderType, OrderRelNum, OrderDate, NeedbyDate, DelivDate, OrderQty, DelivQty, RemainingQty, UnitPrice, UnitCost,  CurrExChRate, lvo.Company, OpenRelease, DiscountAmount, DiscountPercent, PartNum, PartStatus, SalesPerson, WarehouseCode, CurrencyCode, SalesReturnOrderNum
GO
