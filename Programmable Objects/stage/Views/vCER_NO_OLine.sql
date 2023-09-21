IF OBJECT_ID('[stage].[vCER_NO_OLine]') IS NOT NULL
	DROP VIEW [stage].[vCER_NO_OLine];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [stage].[vCER_NO_OLine] AS
--COMMENT EMPTY FIELDS // ADD TRIM() INTO PartID,CustomerID,WarehouseID 2022-12-16 VA
SELECT
	CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT(Company, '#', OrderNum, '#', OrderLine))) AS SalesOrderID -- ext OrderRelNum --,'#',SalesReturnInvoiceNum , '#', InvoiceNum
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM(Company), '#', TRIM(CustNum))))) AS CustomerID
	--,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(Company, '#', TRIM(IIF(CustNum IS NULL OR CustNum = '', 'MISSINGCUSTOMER', CustNum) ))))) AS CustomerID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', Company)) AS CompanyID
	--,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(Company, '#', TRIM(IIF(PartNum IS NULL OR PartNum = '', 'MISSINGPART',  PartNum) ))))) AS PartID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM(Company), '#', TRIM(PartNum))))) AS PartID 
	--,CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT(Company, '#', WarehouseCode))) AS WarehouseID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM(Company), '#', TRIM(WarehouseCode))))) AS WarehouseID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT(Company, '#', TRIM(OrderNum)))) AS SalesOrderNumID
	,CONCAT(Company,'#',OrderNum,'#',OrderLine) AS SalesOrderCode 
	,CONVERT(int, replace(convert(date, OrderDate),'-','')) AS SalesOrderDateID  
	,CONVERT([binary](32), HASHBYTES('SHA2_256',CONCAT( Company,'#','') ))	AS ProjectID
	,PartitionKey 

	,UPPER(TRIM(Company)) AS Company
	,UPPER(TRIM(CustNum)) AS CustomerNum
	,TRIM(OrderNum) AS SalesOrderNum
	,TRIM(OrderLine) AS SalesOrderLine
	--,'' AS SalesOrderSubLine
	--,'' AS SalesOrderType
	--,'' AS SalesOrderCategory
	,TRIM(OrderRelNum) AS SalesOrderRelNum
	,OrderDate AS SalesOrderDate
	,NeedbyDate
	,DelivDate AS ExpDelivDate
	,CAST('1900-01-01' AS date) AS ActualDelivDate
	,CAST('1900-01-01' AS date) AS ConfirmedDelivDate
	,TRIM(InvoiceNum) AS SalesInvoiceNum --MAX
	,OrderQty AS SalesOrderQty
	,DelivQty
	,RemainingQty
	--,NULL AS SalesInvoiceQty
	--,'' AS UoM
	,UnitPrice
	,UnitCost
	,'NOK' AS Currency
	,CurrExChRate AS ExchangeRate
	,OpenRelease
	,DiscountAmount
	,DiscountPercent
	,UPPER(TRIM(PartNum)) AS PartNum
	,LineFlag AS PartType
	,PartStatus
	,TRIM(SalesPerson) AS SalesPersonName
	,CASE WHEN WarehouseCode = '' OR WarehouseCode is NULL THEN 'Other' ELSE WarehouseCode END AS WarehouseCode
	--,'' AS SalesChannel
	,'Normal Order Handling' AS AxInterSalesChannel
	--,'' AS Department
	--,'' AS ProjectNum
	--,'' AS IndexKey
	--,'0' AS Cancellation
	,LineFlag AS SORes1
	--,'' AS SORes2
	--,'' AS SORes3
	--,NULL AS [TotalMiscChrg]
FROM stage.CER_NO_OLine

--GROUP BY
--	PartitionKey, CustNum, OrderNum, OrderLine, OrderRelNum, OrderDate, NeedbyDate, DelivDate, OrderQty, DelivQty, RemainingQty, UnitPrice, UnitCost, SumUnitPrice, SumUnitCost, CurrExChRate, Company, OpenRelease, DiscountAmount, DiscountPercent, PartNum, PartStatus, SalesPerson/*, ReturnComment, SalesReturnOrderNum*/, WarehouseCode, LineFlag--, SalesReturnInvoiceNum,InvoiceNum,Currency
GO
