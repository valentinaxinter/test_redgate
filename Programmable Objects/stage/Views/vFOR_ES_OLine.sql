IF OBJECT_ID('[stage].[vFOR_ES_OLine]') IS NOT NULL
	DROP VIEW [stage].[vFOR_ES_OLine];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [stage].[vFOR_ES_OLine] AS
--COMMENT EMPTY FIELD 2022-12-21 VA
SELECT
	CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM(Company),'#',TRIM(SalesOrderNum),'#',TRIM(SalesOrderLine))))) AS SalesOrderID
	,UPPER(CONCAT(Company,'#',SalesOrderNum,'#',SalesOrderLine)) as SalesOrderCode
	,CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM(Company),'#',TRIM(CustomerNum))))) as CustomerID
	,CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(TRIM(Company)))) as CompanyID
	,CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM(Company),'#',TRIM(PartNum))))) AS PartID 
	,CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM([Company]),'#',TRIM([WarehouseCode]))))) AS WarehouseID
	,CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM(Company),'#',TRIM(SalesOrderNum))))) AS SalesOrderNumID  
	,CONVERT(int, replace(convert(date, SalesOrderDate),'-','')) AS SalesOrderDateID  
	,CONVERT([binary](32), HASHBYTES('SHA2_256',CONCAT( Company,'#','') ))	AS ProjectID

	,PartitionKey 
	,Company 
	,UPPER(TRIM(CustomerNum)) AS CustomerNum 
	,UPPER(TRIM(SalesOrderNum)) AS SalesOrderNum
	,UPPER(TRIM(SalesOrderLine)) AS SalesOrderLine
	--,'' AS SalesOrderSubLine
	--,'' AS SalesOrderType
	--,'' AS SalesOrderCategory
	--,'' AS SalesOrderRelNum
	,SalesOrderDate
	,NeedbyDate
	,ExpDelivDate
	,CAST('1900-01-01' AS date) AS ActualDelivDate
	,CAST('1900-01-01' AS date) AS ConfirmedDelivDate
	--,'' AS SalesInvoiceNum
	,SalesOrderQty
	,DelivQty
	,RemainingQty
	--,NULL AS SalesInvoiceQty
	,UoM
	,UnitPrice
	,UnitCost
	,'EUR' AS Currency --Changed from '' to 'SEK' /SM 2021-08-19
	,1 AS ExchangeRate  --CurrExChRate AS ExchangeRate /SM 2021-08-19
	,OpenRelease
	,DiscountAmount
	,DiscountPercent
	,UPPER(TRIM(PartNum)) AS PartNum
	,PartType
	--,''	AS PartStatus
	,SalesPersonName AS SalesPersonName
	,UPPER(TRIM(WarehouseCode)) as WarehouseCode
	,IIF(UPPER(TRIM(CustomerNum)) IN ('C0010380', 'C0011260', 'C0018613'), 'EDI', 'Normal Order Handling') AS SalesChannel
	,IIF(UPPER(TRIM(CustomerNum)) IN ('C0010380', 'C0011260', 'C0018613'), 'EDI', 'Normal Order Handling') AS AxInterSalesChannel
	--,'' AS Department
	--,'' AS ProjectNum
	--,'' AS IndexKey
	,IsCancelled AS Cancellation
	--,'' AS SORes1
	--,'' AS SORes2
	--,'' AS SORes3
--	,ReturnComment
--	,SalesReturnOrderNum
--	,SalesReturnInvoiceNum
	,NULL AS [TotalMiscChrg]
FROM stage.FOR_ES_OLine
GO
