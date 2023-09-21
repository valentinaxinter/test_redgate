IF OBJECT_ID('[stage].[vCER_FI_OLine]') IS NOT NULL
	DROP VIEW [stage].[vCER_FI_OLine];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [stage].[vCER_FI_OLine] AS
--COMMENT EMPTY FIELD // ADD TRIM() INTO CustomerID,PartID,WarehouseID 2022-12-20 VA
SELECT
	CONVERT([binary](32),HASHBYTES('SHA2_256',CONCAT(Company,'#',OrderNum,'#',OrderLine,'#',OrderSubLine,'#',InvoiceNum))) AS SalesOrderID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(TRIM(Company)))) AS CompanyID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM(Company), '#', TRIM(CustNum))))) AS CustomerID
	--,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(Company, '#', TRIM(IIF(CustNum IS NULL OR CustNum = '', 'MISSINGCUSTOMER', CustNum) ))))) AS CustomerID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM(Company), '#', TRIM(PartNum))))) AS PartID
	--,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(Company, '#', TRIM(IIF(PartNum IS NULL OR PartNum = '', 'MISSINGPART',  PartNum) ))))) AS PartID
	,CONVERT([binary](32), HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM(Company),'#',TRIM(WarehouseCode))))) AS WarehouseID
	--,CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT(Company,'#',WarehouseCode))) AS WarehouseID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT(Company,'#',TRIM(OrderNum)))) AS SalesOrderNumID
	--,UPPER(CONCAT(Company, '#', TRIM(OrderNum), '#', TRIM(OrderLine), '#', TRIM(IIF(PartNum IS NULL OR PartNum = '', 'MISSINGPART',  PartNum) ))) AS SalesOrderCode
	,UPPER(CONCAT(Company, '#', TRIM(OrderNum), '#', TRIM(OrderLine), '#', TRIM(OrderSubLine),'#',InvoiceNum )) AS SalesOrderCode
	,CONVERT(int, replace(convert(date, OrderDate),'-','')) AS SalesOrderDateID  --Redundant?
	,CONVERT([binary](32), HASHBYTES('SHA2_256',CONCAT( Company,'#','') ))	AS ProjectID
	,PartitionKey 

	,UPPER(TRIM(Company)) AS Company 
	,UPPER(TRIM(CustNum)) AS CustomerNum  
	--,UPPER(TRIM(IIF(CustNum IS NULL OR CustNum = '', 'MISSINGCUSTOMER', CustNum))) AS CustomerNum  
	,TRIM(OrderNum) AS SalesOrderNum
	,TRIM(OrderLine) AS SalesOrderLine
	,TRIM(OrderSubLine) AS SalesOrderSubLine
	,TRIM(OrderType) AS SalesOrderType
	--,'' AS SalesOrderCategory
	,OrderDate AS SalesOrderDate
	,NeedbyDate
	,DelivDate AS ExpDelivDate
	,ActualDelivDate
	,ConfirmedDelivDate
	--,'0' AS Cancellation
	,TRIM(InvoiceNum) AS SalesInvoiceNum
	,OrderQty AS SalesOrderQty
	,DelivQty
	,RemainingQty
	--,NULL AS SalesInvoiceQty
	--,'' AS UoM
	,UnitPrice
	,UnitCost
	,CurrencyCode AS Currency
	,1/CurrExChRate AS ExchangeRate  --Testing out 1/CurrExChRate because ExchangeRate seemed to be reversed for CFICERT /SM 2021-07-08
	,OpenRelease
	,DiscountAmount
	,DiscountPercent
	--,UPPER(TRIM(IIF(PartNum IS NULL OR PartNum = '', 'MISSINGPART',  PartNum) )) AS PartNum
	,UPPER(TRIM(PartNum)) AS PartNum
	,IIF(OrderSubLine = '000000',  'Main',  'Sub' ) AS PartType -- added 20210422 /DZ
	,PartStatus
	,TRIM(SalesPerson) AS SalesPersonName
	,TRIM(WarehouseCode) AS WarehouseCode
	,'Normal Order Handling' AS SalesChannel
	,'Normal Order Handling' AS AxInterSalesChannel
	--,'' AS Department
	--,'' AS ProjectNum
	--,'' AS IndexKey
	--,'' AS SORes1
	--,'' AS SORes2
	--,'' AS SORes3
	--,NULL AS [TotalMiscChrg]
FROM stage.CER_FI_OLine
GROUP BY
	PartitionKey, Company, CustNum, OrderNum, OrderLine, OrderSubLine, OrderDate, NeedbyDate, DelivDate, InvoiceNum, OrderQty, DelivQty, RemainingQty, UnitPrice, UnitCost, CurrExChRate, CurrencyCode, OpenRelease, DiscountAmount, DiscountPercent, PartNum, PartStatus, SalesPerson, WarehouseCode, OrderType,ActualDelivDate
	,ConfirmedDelivDate
GO
