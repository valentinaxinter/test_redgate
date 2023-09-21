IF OBJECT_ID('[stage].[vCER_DK_OLine]') IS NOT NULL
	DROP VIEW [stage].[vCER_DK_OLine];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [stage].[vCER_DK_OLine] AS
-- COMMENT empty fields / Add TRIM(Company) into WarehouseID/CustomerID/PartID 12-12-2022 VA
SELECT
	CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(Company, '#', TRIM(OrderNum), '#', OrderLine, '#', OrderRelNum, '#', TRIM(InvoiceNum), '#', SalesReturnOrderNum, '#', SalesReturnInvoiceNum)))) AS SalesOrderID
	,UPPER(CONCAT(Company, '#', TRIM(OrderNum), '#', TRIM(OrderLine), '#', TRIM(InvoiceNum))) AS SalesOrderCode
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(TRIM(Company)))) AS CompanyID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM(Company), '#', TRIM(CustNum))))) AS CustomerID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM(Company), '#', TRIM(PartNum))))) AS PartID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM(Company), '#',  TRIM(WarehouseCode))))) AS WareHouseID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(Company, '#', TRIM(OrderNum))))) AS SalesOrderNumID
	,CONVERT(int, replace(CONVERT(date, OrderDate),'-','')) AS SalesOrderDateID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT(upper(TRIM([COMPANY])), '#', UPPER(trim([ProjectNum]))))) AS ProjectID
	,PartitionKey

	,UPPER(Company) AS Company
	,UPPER(TRIM(IIF(CustNum IS NULL OR CustNum = '', 'MISSINGCUSTOMER', CustNum) )) AS CustomerNum
	,UPPER(TRIM(OrderNum)) AS SalesOrderNum
	,UPPER(TRIM(IIF(PartNum IS NULL OR PartNum = '', 'MISSINGPART',  PartNum) )) AS PartNum
	,UPPER(TRIM(InvoiceNum)) AS SalesInvoiceNum
	,UPPER(TRIM(OrderLine)) AS SalesOrderLine
	,UPPER(TRIM(OrderSubLine)) AS SalesOrderSubLine
	--,'' AS SalesOrderType
	,OrderDate AS SalesOrderDate
	,NeedbyDate
	,DelivDate AS [ExpDelivDate]
	,CAST('1900-01-01' AS date) AS ActualDelivDate
	,CAST('1900-01-01' AS date) AS ConfirmedDelivDate
	--,'' AS [SalesOrderCategory]
	,OrderQty AS SalesOrderQty
	,DelivQty
	,RemainingQty
	--,NULL AS SalesInvoiceQty
	--,'' AS [UoM]
	,UnitPrice
	,UnitCost
	,Currency
	,CurrExChRate AS [ExchangeRate]
	,CASE	WHEN OpenRelease = '1' THEN '0' 
			WHEN OpenRelease = '0' THEN '1'
			ELSE OpenRelease END AS OpenRelease	--This is reversed from source (=1 should be open and =0 should be closed)
	,DiscountAmount
	,DiscountPercent
	--,'' AS [PartType]
	,PartStatus
	,TRIM(SalesPersonName) AS SalesPersonNAme
	,TRIM(WarehouseCode) AS WarehouseCode
	,SalesChannel
	,CASE WHEN SalesChannel = 'WEB-RFQ' THEN 'RFQ'
		WHEN SalesChannel = 'WEB-ORDRE' THEN 'Webshop'
		WHEN SalesChannel = 'DC-ORDRE' THEN 'PDF Scan'
		ELSE 'Normal Order Handling' END AS AxInterSalesChannel
	--,'' AS [Department]
	,UPPER(trim(ProjectNum)) as [ProjectNum]
	--,'' AS [IndexKey]
	--,'0' AS Cancellation
	--,'' AS SORes1
	--,'' AS SORes2
	--,'' AS SORes3
	--,NULL AS [TotalMiscChrg]
FROM stage.CER_DK_OLine
GO
