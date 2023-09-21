IF OBJECT_ID('[stage].[vARK_PI_OLine]') IS NOT NULL
	DROP VIEW [stage].[vARK_PI_OLine];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [stage].[vARK_PI_OLine] AS
--COMMENT EMPTY FIELDS // ADD TRIM()UPPER()INTO CustomerID 2022-12-16 VA
SELECT
	CONVERT([binary](32),HASHBYTES('SHA2_256',CONCAT(Company,'#',OrderNum,'#',OrderLine,'#',OrderSubLine,'#',InvoiceNum))) AS SalesOrderID
	,CONCAT(Company,'#',OrderNum,'#',OrderLine) AS SalesOrderCode
	,CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM(Company),'#',TRIM(CustNum))))) AS CustomerID
	--,CONVERT([binary](32),HASHBYTES('SHA2_256',CONCAT(Company,'#',TRIM(CustNum)))) AS CustomerID
	,CONVERT([binary](32),HASHBYTES('SHA2_256',Company)) AS CompanyID
	,CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM(Company),'#',TRIM(PartNum))))) AS PartID 
	,CONVERT([binary](32), HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM([Company]), '#', TRIM([WarehouseCode]))))) AS WarehouseID
	,CONVERT([binary](32),HASHBYTES('SHA2_256',CONCAT(Company,'#',TRIM(OrderNum)))) AS SalesOrderNumID
	,CONVERT(int, replace(convert(date, OrderDate),'-','')) AS SalesOrderDateID  
	,CONVERT([binary](32), HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM(Company),'#',''))))	AS ProjectID
	,PartitionKey 

	,Company 
	,TRIM(CustNum) AS CustomerNum 
	,OrderNum AS [SalesOrderNum]
	,OrderLine AS [SalesOrderLine]
	,OrderSubLine AS [SalesOrderSubLine]
	,OrderType AS [SalesOrderType]
	--,'' AS [SalesOrderCategory]
	,OrderDate AS [SalesOrderDate]
	,NeedbyDate
	,CASE WHEN CAST(DelivDate AS date) < '1753-01-01' THEN CAST('1900-01-01' AS date) ELSE CAST(DelivDate AS date) END  AS [ExpDelivDate]
	,CAST('1900-01-01' AS date) AS ActualDelivDate
	,CAST('1900-01-01' AS date) AS ConfirmedDelivDate
	,InvoiceNum AS [SalesInvoiceNum]
	,OrderQty AS [SalesOrderQty]
	,DelivQty
	,RemainingQty
	--,NULL AS SalesInvoiceQty
	--,'' AS [UoM]
	,UnitPrice
	,UnitCost
	,Currency
	,CurrExChRate AS [ExchangeRate]
	,OpenRelease
	,DiscountAmount
	,DiscountPercent
	,PartNum
	,Res1 AS [PartType]
	,PartStatus
	,SalesPerson AS [SalesPersonName]
	,ReturnComment
	,SalesReturnOrderNum
	,MAX(SalesReturnInvoiceNum) AS SalesReturnInvoiceNum
	,TRIM(WarehouseCode) AS WarehouseCode
	,CASE WHEN SalesChannel = 'POS' OR SalesChannel = 'WMS' THEN 'Over-the-counter'
		WHEN SalesChannel = 'WEBSHOP' OR SalesChannel = 'www.arkov.cz' THEN 'www.arkov.cz'
		WHEN SalesChannel = 'www.arkov.sk' THEN 'www.arkov.sk'
		WHEN SalesChannel = 'EDI' THEN 'EDI'
		ELSE 'Normal Order Handling' END AS SalesChannel
	,CASE WHEN SalesChannel = 'POS' OR SalesChannel = 'WMS' THEN 'Over-the-counter'
		WHEN SalesChannel = 'WEBSHOP' OR SalesChannel = 'www.arkov.cz' OR SalesChannel = 'www.arkov.sk' THEN 'Webshop'
		WHEN SalesChannel = 'EDI' THEN 'EDI'
		ELSE 'Normal Order Handling' END AS AxInterSalesChannel
	--,'' AS Cancellation
	,BusinessChain AS [Department]
	--,'' AS [ProjectNum]
	--,'' AS [IndexKey]
	--,'' AS SORes1
	--,'' AS SORes2
	--,'' AS SORes3
	--,NULL AS [TotalMiscChrg]
FROM stage.ARK_PI_OLine
--WHERE OrderDate >= DATEADD(year, -1, GETDATE()) --Added this where clause as semi-incremental load functinoality since it doesn't work easily on meta-param table. /SM 2021-10-01
GROUP BY
	PartitionKey, Company, CustNum, OrderNum, OrderLine, OrderSubLine, OrderType, OrderRelNum, OrderDate, NeedbyDate, DelivDate, InvoiceNum, OrderQty, DelivQty, RemainingQty, UnitPrice, UnitCost, Currency, CurrExChRate, BusinessChain, OpenRelease, DiscountAmount, DiscountPercent, PartNum, PartStatus, SalesPerson, ReturnComment, SalesReturnOrderNum, WarehouseCode, SalesChannel, BusinessChain, Res1
GO
