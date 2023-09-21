IF OBJECT_ID('[stage].[vHAK_FI_OLine]') IS NOT NULL
	DROP VIEW [stage].[vHAK_FI_OLine];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE VIEW [stage].[vHAK_FI_OLine] AS
--COMMENT EMPTY FIELDS // ADD UPPER()TRIM() INTO WarehouseID,CustomerID,PartID 2022-12-21 VA
--CHANGE SALESORDERCODE  

SELECT
	CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT(Company, '#', TRIM(OrderNum), '#', TRIM(OrderLine) ))) AS SalesOrderID
	,CONVERT([binary](32), HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM(Company), '#', TRIM(CustNum))))) AS CustomerID
	--,CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT(Company, '#', TRIM(UPPER(IIF(CustNum = '' OR CustNum IS NULL, 'MISSINGCUSTOMER', CustNum))) ))) AS CustomerID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', Company)) AS CompanyID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM(Company), '#', TRIM(PartNum))))) AS PartID 
	--,CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT(Company, '#', TRIM(UPPER(IIF(PartNum = '' OR PartNum IS NULL, 'MISSINGPART', PartNum))) ))) AS PartID  --, '#', TRIM(UPPER([Site]))
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM(Company), '#', TRIM(WarehouseCode))))) AS WarehouseID
	--,CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT(Company, '#', TRIM(WarehouseCode)))) AS WarehouseID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT(Company, '#', TRIM(UPPER(OrderNum)) ))) AS SalesOrderNumID
	,UPPER(CONCAT(TRIM(Company), '#', TRIM(OrderNum), '#', TRIM(PartNum))) AS SalesOrderCode
	--,CONCAT(Company, '#', TRIM(UPPER(OrderNum)), '#', TRIM(UPPER(IIF(PartNum = '' OR PartNum IS NULL, 'MissingPart', PartNum)))) AS SalesOrderCode
	,CONVERT(int, replace(convert(date, OrderDate),'-','')) AS SalesOrderDateID  
	,CONVERT([binary](32), HASHBYTES('SHA2_256',CONCAT( Company,'#','') ))	AS ProjectID
	,PartitionKey 

	,TRIM(Company) AS Company
	,UPPER(TRIM(CustNum)) AS CustomerNum 
	,UPPER(TRIM(OrderNum)) AS SalesOrderNum
	,UPPER(TRIM(OrderLine)) AS SalesOrderLine
	,UPPER(TRIM(OrderSubLine)) AS SalesOrderSubLine
	--,'' AS SalesOrderType
	--,'' AS SalesOrderCategory
	,UPPER(TRIM(OrderRelNum)) AS SalesOrderRelNum
	,OrderDate AS SalesOrderDate
	,MAX(NeedbyDate) AS NeedbyDate
	,MAX(DelivDate) AS ExpDelivDate
	,CAST('1900-01-01' AS date) AS ActualDelivDate
	,CAST('1900-01-01' AS date) AS ConfirmedDelivDate
	,TRIM(UPPER(InvoiceNum)) AS SalesInvoiceNum
	,OrderQty AS SalesOrderQty
	,DelivQty
	,RemainingQty
	--,NULL AS SalesInvoiceQty
	--,'' AS UoM
	,UnitPrice
	,UnitCost
	,SumUnitPrice
	,SumUnitCost
	,'EUR' AS Currency
	,1 AS ExchangeRate
	,OpenRelease
	,DiscountAmount
	,DiscountPercent
	,UPPER(TRIM(PartNum)) AS PartNum
	--,'' AS PartType
	,PartStatus
	,SalesPerson AS SalesPersonName
	,MAX(TRIM(ReturnComment)) AS ReturnComment
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
	,MAX(TRIM(SalesReturnOrderNum)) AS SalesReturnOrderNum
	,MAX(TRIM(SalesReturnInvoiceNum)) AS SalesReturnInvoiceNum
	--,NULL AS [TotalMiscChrg]
FROM 
	stage.HAK_FI_OLine
GROUP BY
	PartitionKey, Company, CustNum, OrderNum, OrderLine, OrderSubLine, OrderRelNum, OrderDate, InvoiceNum, OrderQty, DelivQty, DelivQty, RemainingQty, UnitPrice, UnitCost, SumUnitPrice, SumUnitCost, OpenRelease, DiscountAmount, DiscountPercent, PartNum, PartStatus, SalesPerson, WarehouseCode--, TRIM(UPPER([Site]))
GO
