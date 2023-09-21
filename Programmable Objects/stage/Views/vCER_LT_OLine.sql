IF OBJECT_ID('[stage].[vCER_LT_OLine]') IS NOT NULL
	DROP VIEW [stage].[vCER_LT_OLine];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [stage].[vCER_LT_OLine] AS
--COMMENT EMPTY FIELDS / ADD UPPER()TRIM() INTO PartID,CustomerID,WarehouseID 2022-12-14 VA
SELECT
	CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT(Company, '#', OrderNum, '#', OrderLine, '#', OrderSubLine, '#', OrderRelNum, '#', MAX(InvoiceNum), '#', SalesReturnOrderNum))) AS SalesOrderID
	,CONVERT([binary](32), HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM(Company), '#', TRIM(CustNum))))) AS CustomerID
	--,CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT(Company, '#', TRIM(IIF(CustNum IS NULL OR CustNum = '', 'MISSINGCUSTOMER', CustNum) ) ))) AS CustomerID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', Company)) AS CompanyID
	--,CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT(Company, '#', TRIM(IIF(PartNum IS NULL OR PartNum = '', 'MISSINGPART',  PartNum) )))) AS PartID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM(Company), '#', TRIM(PartNum))))) AS PartID
	--,CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT(Company, '#', WarehouseCode))) AS WarehouseID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM(Company), '#', TRIM(WarehouseCode))))) AS WarehouseID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT(Company, '#', TRIM(OrderNum)))) AS SalesOrderNumID
	,CONCAT(Company, '#', TRIM(OrderNum), '#', TRIM(OrderLine), '#', TRIM(IIF(PartNum IS NULL OR PartNum = '', 'MISSINGPART',  PartNum) )) AS SalesOrderCode
	,CONVERT(int, replace(convert(date, OrderDate),'-','')) AS SalesOrderDateID
	,CONVERT([binary](32), HASHBYTES('SHA2_256',CONCAT( Company,'#','') ))	AS ProjectID
	,PartitionKey 

	,TRIM(Company) AS Company
	,TRIM(IIF(CustNum IS NULL OR CustNum = '', 'MISSINGCUSTOMER', CustNum) ) AS CustomerNum 
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
	,MAX(InvoiceNum) AS SalesInvoiceNum
	,OrderQty AS SalesOrderQty
	,DelivQty
	,RemainingQty
	--,NULL AS SalesInvoiceQty
	--,'' AS UoM
	,UnitPrice
	,UnitCost
	,CurrencyCode AS Currency
	,CurrExChRate AS ExchangeRate
	,OpenRelease
	,DiscountAmount
	,DiscountPercent
	,TRIM(IIF(PartNum IS NULL OR PartNum = '', 'MISSINGPART',  PartNum) ) AS PartNum
	,IIF(OrderSubLine = '000000', 'Main', 'Sub' ) AS PartType
	,PartStatus
	,TRIM(SalesPerson) AS SalesPersonName
	,CASE WHEN WarehouseCode = '' OR WarehouseCode is NULL THEN 'Other' ELSE WarehouseCode END AS WarehouseCode
	,'' AS SalesChannel
	,CASE WHEN left(OrderNum, 4) = '7000' THEN 'Webshop' -- incl. very little RFQ orders
		ELSE 'Normal Order Handling' END AS AxInterSalesChannel
	--,'' AS Department
	--,'' AS ProjectNum
	--,'' AS IndexKey
	--,'0' AS Cancellation
	--,'' AS SORes1
	--,'' AS SORes2
	--,'' AS SORes3
	,ReturnComment
	,SalesReturnOrderNum
	--,'' AS SalesReturnInvoiceNum
	--,NULL AS [TotalMiscChrg]
FROM stage.CER_LT_OLine lto
--	LEFT JOIN dw.Customer ltc ON Company = ltc.Company AND CustNum = ltc.CustomerNum
GROUP BY
	PartitionKey, CustNum, OrderNum, OrderLine, OrderSubLine, OrderType, OrderRelNum, OrderDate, NeedbyDate, DelivDate, OrderQty, DelivQty, RemainingQty, UnitPrice, UnitCost, CurrExChRate, Company, OpenRelease, DiscountAmount, DiscountPercent, PartNum, PartStatus, SalesPerson, ReturnComment, SalesReturnOrderNum, WarehouseCode,CurrencyCode
GO
