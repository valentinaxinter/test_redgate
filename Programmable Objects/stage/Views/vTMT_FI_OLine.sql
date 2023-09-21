IF OBJECT_ID('[stage].[vTMT_FI_OLine]') IS NOT NULL
	DROP VIEW [stage].[vTMT_FI_OLine];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE VIEW [stage].[vTMT_FI_OLine] AS
--COMMENT EMPTY FIELDS // ADDTRIM()INTO CustomerID,PartID 23-01-09 VA
SELECT
	CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(Company, '#', OrderNum, '#', OrderLine, '#', OrderSubLine)))) AS SalesOrderID -- ext OrderRelNum
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(Company))) AS CompanyID	
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM(Company), '#', TRIM(CustNum))))) AS CustomerID
	--,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(Company, '#', TRIM(CustNum))))) AS CustomerID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM([Company]),'#',TRIM([PartNum]))))) AS PartID
	--,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT([Company],'#',TRIM([PartNum]))))) AS PartID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM([Company]), '#', TRIM([WarehouseCode]))))) AS WarehouseID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(Company, '#', TRIM(OrderNum))))) AS SalesOrderNumID
	,UPPER(CONCAT(Company, '#', TRIM(OrderNum), '#', TRIM(OrderLine), '#', TRIM(OrderSubLine), '#', TRIM(InvoiceNum))) AS SalesOrderCode
	,CONVERT(int, replace(convert(date, OrderDate),'-','')) AS SalesOrderDateID 
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT( Company,'#','')) ))	AS ProjectID
	,PartitionKey 

	,UPPER(Company) AS Company
	,UPPER(TRIM(CustNum)) AS CustomerNum 
	,TRIM(OrderNum) AS SalesOrderNum
	,TRIM(OrderLine) AS SalesOrderLine
	,TRIM(OrderSubLine) AS SalesOrderSubLine
	,TRIM(OrderType) AS SalesOrderType
	--,''	AS SalesOrderCategory
	,isnull(OrderDate, cast('1900-01-01' as date)) AS SalesOrderDate
	,NeedbyDate
	,DelivDate AS ExpDelivDate
	,CAST('1900-01-01' AS date) AS ActualDelivDate
	,CAST([Confirmed delivery date] AS date) AS ConfirmedDelivDate
	,TRIM(InvoiceNum) AS SalesInvoiceNum
	,OrderQty AS SalesOrderQty
	,DelivQty
	,OrderQty-DelivQty AS RemainingQty   -- RemainingQty  || RemaingQty was always 0, so calculation was added | SB 2023-01-31
	--,NULL AS SalesInvoiceQty
	--,'' AS UoM
	,UnitPrice*CurrExchRate as UnitPrice-- Have received local net unitprice, changing to ordered unit price witih the initial current exchange rate we recieved UnitPrice
	,UnitCost*CurrExchRate as UnitCost -- Have received local unitcost, changing to ordered unit cost witih the initial current exchange rate we recieved UnitCost SB 2023-02-02
	,currencyCode AS Currency
	,1/CurrExChRate AS ExchangeRate -- inverted so that it is the currency rate from ordered currency to local (EUR) SB 2023-01-31
	,OpenRelease
	,0 as DiscountAmount -- DiscountAmount  || Setting to 0 as we are receiving net unitprice, so the discount has already been applied || SB 2023-02-01
	,DiscountPercent
	,UPPER(TRIM(PartNum)) AS PartNum
	--,'' AS PartType
	,PartStatus
	,IIF(LEFT(SalesChannel, 2) = 'NT', 'WebShop', SalesPersonName) AS SalesPersonName
	,TRIM(WarehouseCode) AS WarehouseCode
	,SalesChannel
	,IIF(LEFT(SalesChannel, 2) = 'NT', 'WebShop', 'Normal Order Handling') AS AxInterSalesChannel
	--,'' AS Department
	--,'' AS [ProjectNum]
	--,'' AS [IndexKey]
	--,'' AS Cancellation
	,[Version] AS SORes1
	--,'' AS SORes2
	--,'' AS SORes3
	--,NULL AS [TotalMiscChrg]
FROM stage.TMT_FI_OLine

--GROUP BY
--	PartitionKey, Company, CustNum, OrderNum, OrderLine, OrderSubLine, OrderType, OrderRelNum, OrderDate, NeedbyDate, DelivDate, InvoiceNum, OrderQty, DelivQty, RemainingQty, UnitPrice, UnitCost, SumUnitPrice, SumUnitCost, currencyCode, CurrExChRate, OpenRelease, DiscountAmount, DiscountPercent, PartNum, PartStatus, SalesPersonName, WarehouseCode, SalesChannel, SalesReturnOrderNum, SalesReturnInvoiceNum, [Confirmed delivery date]
GO
