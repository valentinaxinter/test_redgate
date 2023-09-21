IF OBJECT_ID('[stage].[vOCS_SE_OLine]') IS NOT NULL
	DROP VIEW [stage].[vOCS_SE_OLine];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [stage].[vOCS_SE_OLine] AS
--COMMENT EMPTY FIELDS // ADD UPPER()TRIM() INTO PartID,CustomerID 2022-12-21 VA
SELECT
	CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT(Company, '#', OrderNum, '#', OrderLine, '#', InvoiceNum))) AS SalesOrderID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', Company)) AS CompanyID
	--,CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT(Company, '#', TRIM(CustNum)))) AS CustomerID
	,CONVERT([binary](32), HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM(Company), '#', TRIM(CustNum))))) AS CustomerID
	--,CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT(Company, '#', TRIM(PartNum)))) AS PartID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM(Company), '#', TRIM(PartNum))))) AS PartID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT(Company, '#', WarehouseCode))) AS WarehouseID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT(Company, '#', TRIM(OrderNum)))) AS SalesOrderNumID
	,CONVERT(int, replace(convert(date, OrderDate), '-', '')) AS SalesOrderDateID  --redundent?
	,CONCAT(Company, '#', OrderNum, '#', OrderLine, '#', InvoiceNum) AS SalesOrderCode
	,CONVERT([binary](32), HASHBYTES('SHA2_256',CONCAT( Company,'#',[ProjectNum]) ))	AS ProjectID
	,PartitionKey

	,Company
	,TRIM(CustNum) AS CustomerNum
	,OrderNum AS SalesOrderNum
	,OrderLine AS SalesOrderLine
	,OrderSubLine AS SalesOrderSubLine
	,CONVERT(nvarchar(50), OrderType) AS SalesOrderType
	,Res1_PriceGroup AS [SalesOrderCategory]
	,OrderDate AS SalesOrderDate
	,NeedByDate AS NeedbyDate
	,DelivDate AS ExpDelivDate
	,CAST('1900-01-01' AS date) AS ActualDelivDate
	,CAST('1900-01-01' AS date) AS ConfirmedDelivDate
	,InvoiceNum AS SalesInvoiceNum
	,OrderQty AS SalesOrderQty
	,DelivQty
	,RemainingQty
	--,NULL AS SalesInvoiceQty
	,Unit AS UoM
	,UnitPrice
	,UnitCost
	,Currency
	,ExchangeRate
	,OpenRelease
	,DiscountAmount
	,DiscountPercent
	,TRIM(PartNum) AS PartNum
	--,'' AS PartType
	,PartStatus
	,SalesPerson_Seller AS SalesPersonName
	,TRIM(WarehouseCode) AS WarehouseCode
	,SalesChannel
	,'Normal Order Handling' AS AxInterSalesChannel
	,BusinessChain AS Department
	,[ProjectNum]
	--,'' AS [IndexKey]
	--,'0' AS Cancellation
	,[SalesPerson_Seller] AS SORes1
	--,'' AS SORes2
	--,'' AS SORes3
	--,NULL AS [TotalMiscChrg]
FROM stage.OCS_SE_OLine
GO
