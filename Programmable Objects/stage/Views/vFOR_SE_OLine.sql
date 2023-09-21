IF OBJECT_ID('[stage].[vFOR_SE_OLine]') IS NOT NULL
	DROP VIEW [stage].[vFOR_SE_OLine];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [stage].[vFOR_SE_OLine] AS
--COMMENT EMPTY FIELD // CustomerID,PartID Adjust 2022-12-20 VA
SELECT
	CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM(Company), '#', TRIM(OrderNum), '#', TRIM(OrderLine), '#', TRIM(OrderRelNum))))) AS SalesOrderID
	,UPPER(CONCAT(Company, '#', OrderNum, '#', OrderLine, '#', InvoiceNum)) AS SalesOrderCode
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM(Company), '#', TRIM(CustNum))))) AS CustomerID
	--,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM(Company), '#', TRIM(IIF(CustNum IS NULL OR CustNum = '', 'MISSINGCUSTOMER', CustNum) ) )))) AS CustomerID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(TRIM(Company)))) AS CompanyID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM(Company), '#', TRIM(PartNum))))) AS PartID
	--,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM(Company), '#', TRIM(IIF(PartNum IS NULL OR PartNum = '', 'MISSINGPART',  PartNum) ) )))) AS PartID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM([Company]), '#', TRIM([WarehouseCode]))))) AS WarehouseID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM(Company), '#', TRIM(OrderNum))))) AS SalesOrderNumID  
	,CONVERT(int, replace(convert(date, OrderDate),'-','')) AS SalesOrderDateID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT( Company,'#','') ))	AS ProjectID
	,PartitionKey

	,UPPER(TRIM(Company)) AS Company 
	,UPPER(TRIM(CustNum)) AS CustomerNum 
	--,UPPER(TRIM(IIF(CustNum IS NULL OR CustNum = '', 'MISSINGCUSTOMER', CustNum) )) AS CustomerNum 
	,CASE WHEN OrderNum is not NULL or OrderNum > '0' THEN UPPER(TRIM(OrderNum)) END AS SalesOrderNum
	,UPPER(TRIM(OrderLine)) AS SalesOrderLine
	,UPPER(TRIM(OrderSubLine)) AS SalesOrderSubLine
	--,'' AS SalesOrderType
	--,'' AS SalesOrderCategory
	,UPPER(TRIM(OrderRelNum)) AS SalesOrderRelNum --Currently just set = '1'
	,OrderDate AS SalesOrderDate
	,NeedbyDate
	,DelivDate AS ExpDelivDate
	,CAST('1900-01-01' AS date) AS ActualDelivDate
	,CAST('1900-01-01' AS date) AS ConfirmedDelivDate
	,UPPER(TRIM(InvoiceNum)) AS SalesInvoiceNum
	,OrderQty AS SalesOrderQty
	,DelivQty
	,RemainingQty
	--,NULL AS SalesInvoiceQty
	--,'' AS UoM
	,UnitPrice
	,UnitCost
	,'SEK' AS Currency --Changed from '' to 'SEK' /SM 2021-08-19
	,1 AS ExchangeRate  --CurrExChRate AS ExchangeRate /SM 2021-08-19
	,OpenRelease
	,DiscountAmount
	,DiscountPercent
	,UPPER(TRIM(PartNum)) AS PartNum
	--,UPPER(TRIM(IIF(PartNum IS NULL OR PartNum = '', 'MISSINGPART',  PartNum) )) AS PartNum
	--,'' AS PartType
	,PartStatus
	,TRIM(SalesPerson) AS SalesPersonName
	,UPPER(TRIM(WarehouseCode)) as WarehouseCode
	,SalesChannel
	,iif(SalesChannel = 'EDI', 'EDI', 'Normal Order Handling') AS AxInterSalesChannel
	--,'' AS Department
	--,'' AS ProjectNum
	--,'' AS IndexKey
	--,'0' AS Cancellation
	--,'' AS SORes1
	--,'' AS SORes2
	--,'' AS SORes3
	--,NULL AS [TotalMiscChrg]
FROM stage.FOR_SE_OLine
GROUP BY PartitionKey,Company, CustNum, OrderNum, OrderLine, OrderSubLine, OrderRelNum, OrderDate, NeedbyDate, DelivDate, InvoiceNum, OrderQty, DelivQty, RemainingQty, UnitPrice, UnitCost, SumUnitCost, SumUnitPrice, CurrExChRate, OpenRelease, DiscountAmount, DiscountPercent, PartNum, PartStatus, SalesPerson, WarehouseCode, SalesChannel

	--1:07
GO
