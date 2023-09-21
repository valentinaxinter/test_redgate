IF OBJECT_ID('[stage].[vJEN_NO_OLine]') IS NOT NULL
	DROP VIEW [stage].[vJEN_NO_OLine];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [stage].[vJEN_NO_OLine] AS
--COMMENT EMPTY FIELDS // ADD UPPER()TRIM() INTO WarehouseID,PartID,CustomerID 2022-12-22 VA
SELECT
	CONVERT([binary](32),HASHBYTES('SHA2_256',CONCAT(Company,'#',OrderNum,'#',OrderLine,'#',OrderSubLine,'#',OrderRelNum,'#',InvoiceNum,'#',SalesReturnOrderNum,'#',SalesReturnInvoiceNum))) AS SalesOrderID -- ext OrderRelNum
	,CONVERT([binary](32),HASHBYTES('SHA2_256',Company)) AS CompanyID
	,CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM(Company),'#',TRIM(CustNum))))) AS CustomerID
	--,CONVERT([binary](32),HASHBYTES('SHA2_256',CONCAT(Company,'#',TRIM(IIF(CustNum IS NULL OR CustNum = '', 'MISSINGCUSTOMER', CustNum) )))) AS CustomerID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM(Company), '#', TRIM(PartNum))))) AS PartID 
	--,CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT(Company, '#', TRIM(IIF(PartNum IS NULL OR PartNum = '', 'MISSINGPART',  PartNum) )))) AS PartID 
	,CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM(Company),'#',TRIM(WarehouseCode))))) AS WarehouseID
	--,CONVERT([binary](32),HASHBYTES('SHA2_256',CONCAT(Company,'#',TRIM(WarehouseCode)))) AS WarehouseID
	,CONVERT([binary](32),HASHBYTES('SHA2_256',CONCAT(Company,'#',TRIM(OrderNum)))) AS SalesOrderNumID
	,CONCAT(Company,'#',OrderNum,'#',OrderLine,'#',OrderSubLine, '#',InvoiceNum) AS SalesOrderCode
	,CONVERT(int, replace(convert(date, OrderDate),'-','')) AS SalesOrderDateID   --Redundant?
	,CONVERT([binary](32), HASHBYTES('SHA2_256',CONCAT( Company,'#','') ))	AS ProjectID
	,PartitionKey 

	,Company 
	,TRIM(CustNum) AS CustomerNum 
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
	,TRIM(PartNum) AS PartNum
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
FROM stage.JEN_NO_OLine
GO
