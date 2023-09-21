IF OBJECT_ID('[stage].[vFOR_FR_OLine_Test]') IS NOT NULL
	DROP VIEW [stage].[vFOR_FR_OLine_Test];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO







CREATE VIEW [stage].[vFOR_FR_OLine_Test] AS

SELECT
	CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT(Company, '#', TRIM(OrderNum), '#', TRIM(OrderLine), '#', TRIM(OrderSubLine), '#', TRIM(SalesChannel) ))) AS SalesOrderID --, '#', NeedByDate, '#', PartNum --, '#', DelivQty, '#', UnitPrice, '#', UnitCost /*, '#', TRIM(OrderSubLine) */
	,CONVERT([binary](32), HASHBYTES('SHA2_256', Company)) AS CompanyID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT(Company, '#', TRIM(CustomerNum)))) AS CustomerID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT(Company, '#', TRIM([PartNum])))) AS PartID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM([Company]), '#', TRIM([WarehouseCode]))))) AS WarehouseID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT(Company, '#', TRIM(OrderNum)))) AS SalesOrderNumID

	,CONCAT(Company, '#', TRIM(OrderNum), '#', TRIM(OrderSubLine), '#', TRIM(InvoiceNum)) AS SalesOrderCode

	,CONVERT(int, replace(convert(date, OrderDate), '-', '')) AS SalesOrderDateID  --redundent?
	,CONVERT([binary](32), HASHBYTES('SHA2_256',CONCAT( Company,'#','') ))	AS ProjectID
	,PartitionKey 

	,Company 
	,TRIM(CustomerNum) AS CustomerNum
	,TRIM(OrderNum) AS [SalesOrderNum]
	,TRIM(OrderLine) AS [SalesOrderLine]
	,MIN(OrderSubLine) AS [SalesOrderSubLine]
	,LabelQuotations AS [SalesOrderType]
	,QuotationNum AS [SalesOrderCategory] -- QuotationNum - Reference num to a quotating. Putting it in SalesOrderCategory since it is not used for Forankra FR
	,OrderDate AS [SalesOrderDate]
	,NeedByDate AS [NeedbyDate]
	,DelivDate AS [ExpDelivDate]
	,CAST('1900-01-01' AS date) AS ActualDelivDate
	,CAST('1900-01-01' AS date) AS ConfirmedDelivDate
	,TRIM(InvoiceNum) AS [SalesInvoiceNum]
	,OrderQty AS [SalesOrderQty]

	--	RemainingQty=OrderQty when LabelQuotation=2
--		DelivQty=OrderQty when LabelQuotation IN (3,4)
--		InvoicedQty=OrderQty when LabelQuotation=4
	,IIF(LabelQuotations IN ('3','4'), OrderQty, 0) AS DelivQty -- DZ 20211130
	,IIF(LabelQuotations ='2', OrderQty, 0) AS RemainingQty -- DZ 20211130
	,IIF(LabelQuotations ='4', OrderQty, 0) AS SalesInvoiceQty
	,'' AS [UoM]
	,UnitPrice
	,AVG(UnitCost) as UnitCost
	,COALESCE(Currency, 'EUR') AS Currency
	,COALESCE(ExchangeRate, 1) AS ExchangeRate
	,CASE WHEN LabelQuotations IN ('3','4') THEN '0' ELSE '1' END  AS OpenRelease  --LabelQuotations = 4 means Closed order
	,DiscountAmount
	,DiscountPercent
	,TRIM([PartNum]) AS PartNum
	,'' AS [PartType]
	,PartStatus
	,SalesPersonName
	,TRIM(WarehouseCode) AS WarehouseCode
	,SalesChannel
	,'Normal Order Handling' AS AxInterSalesChannel
	,BusinessChannel AS [Department]
	,SuspendingFlag AS [ProjectNum] -- Since BackOrder needs this flag=1, so use [ProjectNum] for SuspendingFlag for ACK. /DZ. 20211104
	,'' AS [IndexKey]
	,'0' AS Cancellation
	,'' AS SORes1
	,'' AS SORes2
	,'' AS SORes3
	,'' AS ReturnComment
	,'' AS SalesReturnOrderNum
	,'' AS SalesReturnInvoiceNum
	,NULL AS [TotalMiscChrg]
FROM stage.FOR_FR_OLine
WHERE SuspendingFlag <> 2 --since these are orders that they do not consider 'real' unless they are reactivated. by John D 20210902 -- /DZ
GROUP BY PartitionKey ,Company, CustomerNum, OrderNum, OrderLine,/*OrderSubLine,*/OrderType,OrderDate, NeedByDate,DelivDate,InvoiceNum,OrderQty
	/*,DelivQty */ ,RemainingQty, UnitPrice, /*UnitCost,*/ Currency, ExchangeRate, DiscountAmount, DiscountPercent, PartNum, PartStatus
	,SalesPersonName,WarehouseCode, SalesChannel, BusinessChannel, LabelQuotations,QuotationNum, OrderSubLine, SuspendingFlag
--	order by OpenRelease desc
GO
