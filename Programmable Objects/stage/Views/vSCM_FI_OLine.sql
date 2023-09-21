IF OBJECT_ID('[stage].[vSCM_FI_OLine]') IS NOT NULL
	DROP VIEW [stage].[vSCM_FI_OLine];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [stage].[vSCM_FI_OLine] AS
--COMMENT EMPTY FIELDS // ADD TRIM() UPPER() INTO PartID,CustomerID 2022-12-21 VA
SELECT distinct
	CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT(Company, '#', OrderNum, '#', OrderLine))) AS SalesOrderID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', Company)) AS CompanyID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM(Company), '#', TRIM(CustNum))))) AS CustomerID
	--,CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT(Company, '#', TRIM(IIF(CustNum = '' OR CustNum IS NULL, 'MISSINGCUSTOMER', CustNum))))) AS CustomerID
	,CONVERT([binary](32), HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM(Company), '#', TRIM(PartNum))))) AS PartID
	--,CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT(Company, '#', TRIM(IIF(PartNum = '' OR PartNum IS NULL, 'MISSINGPART', PartNum))))) AS PartID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM([Company]), '#', TRIM([WarehouseCode]))))) AS WarehouseID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT(Company, '#', TRIM(OrderNum)))) AS SalesOrderNumID
	,CONCAT(Company, '#', OrderNum, '#', OrderLine, '#', InvoiceNum) AS SalesOrderCode
	,CONVERT(int, replace(convert(date, OrderDate), '-', '')) AS SalesOrderDateID  
	,CONVERT([binary](32), HASHBYTES('SHA2_256',CONCAT( Company,'#','') ))	AS ProjectID
	,PartitionKey 

	,TRIM(Company) AS Company 
	,TRIM(CustNum) AS CustomerNum 
	,TRIM(OrderNum) AS SalesOrderNum
	,TRIM(OrderLine) AS SalesOrderLine
	,TRIM(OrderRelNum) AS SalesOrderSubLine
	,TRIM(OrderType) AS SalesOrderType
	--,'' AS SalesOrderCategory
	,TRIM(OrderRelNum) AS SalesOrderRelNum
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
	,Currency
	,CurrExChRate AS ExchangeRate
	,OpenRelease
	,DiscountAmount
	,DiscountPercent
	,TRIM(PartNum) AS PartNum
	,LineFlag AS PartType -- DZ changed to LineFlag, it was ''
	,PartStatus
	,TRIM(SalesPerson) AS SalesPersonName
	,TRIM(WarehouseCode) AS WarehouseCode
	,'Normal Order Handling' AS SalesChannel
	,'Normal Order Handling' AS AxInterSalesChannel
	--,'' AS Department
	--,'' AS ProjectNum
	--,'' AS IndexKey
	--,'0' AS Cancellation
	--,'' AS SORes1
	--,'' AS SORes2
	--,'' AS SORes3
	--,NULL AS [TotalMiscChrg]
FROM stage.SCM_FI_OLine
GO
