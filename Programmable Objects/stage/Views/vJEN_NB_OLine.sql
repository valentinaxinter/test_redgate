IF OBJECT_ID('[stage].[vJEN_NB_OLine]') IS NOT NULL
	DROP VIEW [stage].[vJEN_NB_OLine];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [stage].[vJEN_NB_OLine] AS
--COMMENT EMPTY FIELDS // ADD TRIM() INTO CustomerID,WarehouseID, PartID 23-01-03 VA
SELECT
	CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(Company, '#', OrderType, '#', OrderNum, '#', OrderLine, '#', OrderSubLine, '#', SalesReturnOrderNum, '#', SalesReturnInvoiceNum)))) AS SalesOrderID -- ext , '#', OrderRelNum, '#', InvoiceNum
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(Company))) AS CompanyID
	--,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(Company, '#', TRIM(IIF(CustNum IS NULL OR CustNum = '', 'MISSINGCUSTOMER', CustNum) ))))) AS CustomerID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM(Company), '#', TRIM(CustNum))))) AS CustomerID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM(Company), '#', TRIM(PartNum))))) AS PartID 
	--,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(Company, '#', TRIM(IIF(PartNum IS NULL OR PartNum = '', 'MISSINGPART',  PartNum) ))))) AS PartID 
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM(Company), '#', TRIM(WarehouseCode))))) AS WarehouseID
	--,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(Company, '#', TRIM(WarehouseCode))))) AS WarehouseID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(Company, '#', TRIM(OrderNum))))) AS SalesOrderNumID
	,UPPER(CONCAT(Company, '#', OrderNum, '#', OrderLine, '#', OrderSubLine, '#', InvoiceNum)) AS SalesOrderCode
	,CONVERT(int, replace(convert(date, OrderDate),'-','')) AS SalesOrderDateID   --Redundant?
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT( Company,'#','') )))	AS ProjectID
	,PartitionKey 

	,UPPER(Company) AS Company 
	,UPPER(TRIM(IIF(CustNum IS NULL OR CustNum = '', 'MISSINGCUSTOMER', CustNum) )) AS CustomerNum
	,UPPER(TRIM(IIF(PartNum IS NULL OR PartNum = '', 'MISSINGPART',  PartNum) )) AS PartNum
	,OrderNum		AS SalesOrderNum
	,OrderLine		AS SalesOrderLine
	,OrderSubLine	AS SalesOrderSubLine
	,OrderType		AS SalesOrderType
	,ERPOrderStatus	AS SalesOrderCategory	--Added ERPOrderStatus here because SalesOrderCategory is unused field for JENS S.
	,OrderRelNum	AS SalesOrderRelNum
	,OrderDate		AS SalesOrderDate
	,NeedbyDate
	,DelivDate		AS ExpDelivDate
	,CAST('1900-01-01' AS date) AS ActualDelivDate
	,ConfirmedDelivDate
	,InvoiceNum		AS SalesInvoiceNum
	,OrderQty		AS SalesOrderQty
	,DelivQty
	,RemainingQty
	--,NULL AS SalesInvoiceQty
	--,''				AS UoM
	,UnitPrice
	,UnitCost
	,SumUnitPrice
	,SumUnitCost
	,CurrencyCode	AS Currency
	,CurrExchRate	AS ExchangeRate
	,OpenRelease
	,DiscountAmount
	,DiscountPercent
	--,''				AS PartType
	--,'0'				AS PartStatus
	,SalesPerson	AS SalesPersonName
	,TRIM(WarehouseCode) AS WarehouseCode
	--,'' AS SalesChannel
	,'Normal Order Handling' AS AxInterSalesChannel
	--,'' AS Department
	--,'' AS ProjectNum
	--,'' AS IndexKey
	--,'0' AS Cancellation
	--,'' AS SORes1
	--,'' AS SORes2
	--,'' AS SORes3
	,ReturnComment
	,SalesReturnOrderNum
	,SalesReturnInvoiceNum
	--,NULL AS [TotalMiscChrg]
FROM stage.JEN_NB_OLine
GO
