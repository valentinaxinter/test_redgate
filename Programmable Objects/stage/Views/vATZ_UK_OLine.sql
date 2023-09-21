IF OBJECT_ID('[stage].[vATZ_UK_OLine]') IS NOT NULL
	DROP VIEW [stage].[vATZ_UK_OLine];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [stage].[vATZ_UK_OLine] AS
--COMMENT EMPTY FIELDS // ADD UPPER()TRIM () INTO PartID,CustomerID,WarehouseID 2022-12-27 VA
SELECT
	CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT(Company, '#', TRIM(OrderNum), '#', TRIM(OrderLine), '#', TRIM(OrderSubLine), '#', TRIM(InvoiceNum)))) AS SalesOrderID
	,CONCAT(Company, '#', TRIM(OrderNum), '#', TRIM(OrderLine), '#', TRIM(OrderSubLine), '#', TRIM(InvoiceNum)) AS SalesOrderCode
	,CONVERT([binary](32), HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM(Company), '#', TRIM(CustNum))))) AS CustomerID
	--,CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT(Company, '#', TRIM(IIF(CustNum IS NULL OR CustNum = '', 'MISSINGCUSTOMER', CustNum) ) ))) AS CustomerID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', Company)) AS CompanyID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM(Company), '#', TRIM(PartNum))))) AS PartID 
	--,CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT(Company, '#', TRIM(IIF(PartNum IS NULL OR PartNum = '', 'MISSINGPART',  PartNum) ) ))) AS PartID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM(Company), '#', TRIM(WarehouseCode))))) AS WarehouseID
	--,CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT(Company, '#', TRIM(WarehouseCode)))) AS WarehouseID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT(Company, '#', TRIM(OrderNum)))) AS SalesOrderNumID
	,CONVERT(int, replace(convert(date, OrderDate),'-','')) AS SalesOrderDateID  
	,CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT( Company, '#', '') ))	AS ProjectID
	,PartitionKey

	,TRIM(Company) AS Company 
	,TRIM(IIF(CustNum IS NULL OR CustNum = '', 'MISSINGCUSTOMER', CustNum) ) AS CustomerNum 
	,TRIM(OrderNum) AS SalesOrderNum
	,TRIM(OrderLine) AS SalesOrderLine
	,TRIM(OrderSubLine) AS SalesOrderSubLine
	--,'' AS SalesOrderType
	--,'' AS SalesOrderCategory
	,OrderRelNum AS SalesOrderRelNum
	,OrderDate	AS SalesOrderDate
	,NeedbyDate
	,DelivDate	AS ExpDelivDate
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
	,SumUnitPrice
	,SumUnitCost
	,Currency
	,CurrExChRate AS ExchangeRate
	,OpenRelease
	,DiscountAmount
	,DiscountPercent
	,TRIM(IIF(PartNum IS NULL OR PartNum = '', 'MISSINGPART',  PartNum) ) AS PartNum
	--,'' AS PartType
	,PartStatus
	,TRIM(SalesPerson) AS SalesPersonName
	,TRIM(WarehouseCode) AS WarehouseCode
	,'Normal Order Handling' AS SalesChannel
	,'Normal Order Handling' AS AxInterSalesChannel
	--,'' AS Department
	--,'' AS ProjectNum
	--,'' AS [IndexKey] --DZ added 20210324
	,IIF(OrderQty < 0, 'R', '0') AS Cancellation --? Return or Cancellation
	--,'' AS SORes1
	--,'' AS SORes2
	--,'' AS SORes3
	,ReturnComment
	,TRIM(SalesReturnOrderNum) AS SalesReturnOrderNum
	,TRIM(SalesReturnInvoiceNum) AS SalesReturnInvoiceNum
	--,NULL AS [TotalMiscChrg]
FROM stage.ATZ_UK_OLine
GO
