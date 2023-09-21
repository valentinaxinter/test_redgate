IF OBJECT_ID('[stage].[vCER_UK_OLine]') IS NOT NULL
	DROP VIEW [stage].[vCER_UK_OLine];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [stage].[vCER_UK_OLine] AS
--COMMENT EMPTY FIELDS // ADD  TRIP() UPPER() INTO CustomerID,PartID 2022-12-19 VA
SELECT
	CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT(Company, '#', OrderNum, '#', OrderLine, '#', OrderSubLine, '#', InvoiceNum))) AS SalesOrderID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', Company)) AS CompanyID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM(Company), '#', TRIM(CustNum))))) AS CustomerID
	--,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(Company, '#', TRIM(IIF(CustNum IS NULL OR CustNum = '', 'MISSINGCUSTOMER', CustNum) ))))) AS CustomerID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM(Company), '#', TRIM(PartNum))))) AS PartID
	--,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(Company, '#', TRIM((IIF(PartNum IS NULL OR PartNum = '', 'MISSINGPART',  PartNum) )))))) AS PartID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM([Company]), '#', TRIM([WarehouseCode]))))) AS WarehouseID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT(Company, '#', TRIM(OrderNum)))) AS SalesOrderNumID
	,CONCAT(Company, '#', OrderNum, '#', OrderLine, '#', OrderSubLine, '#', InvoiceNum) AS SalesOrderCode
	,CONVERT(int, replace(convert(date, OrderDate), '-', '')) AS SalesOrderDateID
	,CONVERT([binary](32), HASHBYTES('SHA2_256',CONCAT( Company,'#','') ))	AS ProjectID
	,PartitionKey

	,UPPER(TRIM(Company)) AS Company 
	,UPPER(TRIM(CustNum)) AS CustomerNum
	--,UPPER(TRIM(IIF(CustNum IS NULL OR CustNum = '', 'MISSINGCUSTOMER', CustNum))) AS CustomerNum
	,TRIM(OrderNum) AS [SalesOrderNum]
	,TRIM(OrderLine) AS [SalesOrderLine]
	,TRIM(OrderSubLine) AS [SalesOrderSubLine]
	,TRIM(OrderType) AS [SalesOrderType]
	--,'' AS [SalesOrderCategory]
	,OrderDate AS [SalesOrderDate]
	,NeedbyDate AS [NeedbyDate]
	,DelivDate AS [ExpDelivDate]
	,CAST('1900-01-01' AS date) AS ActualDelivDate
	,CAST('1900-01-01' AS date) AS ConfirmedDelivDate
	,TRIM(InvoiceNum) AS [SalesInvoiceNum]
	,OrderQty AS [SalesOrderQty]
	,DelivQty
	,RemainingQty
	--,NULL AS SalesInvoiceQty
	--,'' AS [UoM]
	,UnitPrice 
	,UnitCost
	,TRIM(CurrencyCode) AS Currency
	,[CurrExchRate] AS [ExchangeRate]
	,OpenRelease
	,DiscountAmount
	,DiscountPercent
	,UPPER(TRIM(PartNum)) AS PartNum
	--,UPPER(TRIM(IIF(PartNum IS NULL OR PartNum = '', 'MISSINGPART',  PartNum))) AS PartNum
	,IIF(OrderSubLine = '000000', 'Main', 'Sub' ) AS [PartType]
	,PartStatus
	,TRIM(SalesPerson) AS [SalesPersonName]
	,TRIM(WarehouseCode) AS WarehouseCode
	,'' AS SalesChannel
	,CASE WHEN LEFT(OrderNum, 4) = '0006' AND SalesPerson = 'Website' OR LEFT(OrderNum, 4) = '0001' AND SalesPerson = 'House - Pritchard/TRS' THEN 'Webshop' -- uncertain
		  WHEN LEFT(OrderNum, 4) = '0006' AND SalesPerson = 'Blake Barlow' OR LEFT(OrderNum, 4) = '0006' AND SalesPerson = 'Ashley Grist' THEN  'RFQ'  -- very uncertain
		  -- Patric Cummins thinks other "Normal" Sales also from quotation, so, the classification is not exact 
		  WHEN LEFT(OrderNum, 4) = '0002' AND SalesPerson = 'Imported' THEN 'PDF Scan' --updated according to PM email 2022-05-10
		  ELSE 'Normal Order Handling' END AS AxInterSalesChannel
	--,'' AS [Department]
	--,'' AS [ProjectNum]
	--,'' AS [IndexKey]
	--,'0' AS Cancellation
	--,'' AS SORes1
	--,'' AS SORes2
	--,'' AS SORes3
	--,NULL AS [TotalMiscChrg]
FROM stage.CER_UK_OLine
GO
