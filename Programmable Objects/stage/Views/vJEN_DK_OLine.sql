IF OBJECT_ID('[stage].[vJEN_DK_OLine]') IS NOT NULL
	DROP VIEW [stage].[vJEN_DK_OLine];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE VIEW [stage].[vJEN_DK_OLine]  AS
--COMMENT EMPTY FIELDS // ADD TRIM() INTO CustomerID,WarehouseID,PartID 2022-12-29 VA
--CUSTOMERNUM / PARTNUM 23-02-17 VA
SELECT
	CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(Company, '#', TRIM(OrderNum), '#', TRIM(OrderLine), '#', TRIM(OrderSubLine), '#', TRIM(OrderRelNum), '#', TRIM(InvoiceNum), '#', TRIM(SalesReturnOrderNum), '#', TRIM(SalesReturnInvoiceNum))))) AS SalesOrderID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(Company))) AS CompanyID
	--,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(Company,'#',TRIM(IIF(CustNum IS NULL OR CustNum = '', 'MISSINGCUSTOMER', CustNum) ))))) AS CustomerID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM(Company),'#',TRIM(CustNum))))) AS CustomerID
	--,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(Company, '#', TRIM(IIF(PartNum IS NULL OR PartNum = '', 'MISSINGPART',  PartNum) ))))) AS PartID 
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM(Company), '#', TRIM(PartNum))))) AS PartID 
	--,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(Company, '#', TRIM(WarehouseCode))))) AS WarehouseID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM(Company), '#', TRIM(WarehouseCode))))) AS WarehouseID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(Company, '#', TRIM(OrderNum))))) AS SalesOrderNumID
	,UPPER(CONCAT(Company, '#', OrderNum, '#', OrderLine, '#', OrderSubLine, '#', InvoiceNum)) AS SalesOrderCode
	,CONVERT(int, replace(convert(date, OrderDate), '-', '')) AS SalesOrderDateID   --Redundant?
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(Company, '#', '') )))	AS ProjectID
	,PartitionKey 

	,UPPER(Company) AS Company 
	,TRIM(CustNum) AS CustomerNum
	,TRIM(OrderNum)		AS SalesOrderNum
	,TRIM(OrderLine)		AS SalesOrderLine
	,TRIM(OrderSubLine)	AS SalesOrderSubLine
	,TRIM(OrderType)		AS SalesOrderType
	,TRIM(ERPOrderStatus)	AS SalesOrderCategory	--Added ERPOrderStatus here because SalesOrderCategory is unused field for JENS S.
	,TRIM(OrderRelNum)	AS SalesOrderRelNum
	,OrderDate		AS SalesOrderDate
	,NeedbyDate
	,DelivDate		AS ExpDelivDate
	,CAST('1900-01-01' AS date) AS ActualDelivDate
	,ConfirmedDelivDate AS ConfirmedDelivDate
	,TRIM(InvoiceNum)		AS SalesInvoiceNum
	,OrderQty		AS SalesOrderQty
	,DelivQty
	,RemainingQty
	--,NULL AS SalesInvoiceQty
	--,''				AS UoM
	,UnitPrice
	,UnitCost
	,SumUnitPrice
	,SumUnitCost
	,CurrencyCode	AS Currency
	,CurrExchRate	AS ExchangeRate
	,OpenRelease
	,DiscountAmount
	,DiscountPercent
	,TRIM(PartNum) AS PartNum
	--,''				AS PartType
	--,'0'				AS PartStatus
	,TRIM(SalesPerson)	AS SalesPersonName
	,TRIM(WarehouseCode) AS WarehouseCode
	--,'' AS SalesChannel
	,'Normal Order Handling' AS AxInterSalesChannel
	--,'' AS Department
	--,'' AS ProjectNum
	--,'' AS IndexKey
	--,'0' AS Cancellation
	,CustNumDel AS SORes1
	--,'' AS SORes2
	--,'' AS SORes3
	,ReturnComment
	,TRIM(SalesReturnOrderNum) AS SalesReturnOrderNum
	,TRIM(SalesReturnInvoiceNum) AS SalesReturnInvoiceNum
	--,NULL AS [TotalMiscChrg]
FROM stage.JEN_DK_OLine
GO
