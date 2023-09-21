IF OBJECT_ID('[stage].[vWID_FI_OLine]') IS NOT NULL
	DROP VIEW [stage].[vWID_FI_OLine];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE VIEW [stage].[vWID_FI_OLine] AS
--COMMENT EMPTY FIELDS / ADD UPPER()TRIM() INTO PartID,CustomerID,WarehouseID 2022-12-15 VA
--CHANGE PARTNUM / CUSTNUM VA 23-02-17 VA
SELECT
	CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT(Company, '#', TRIM(OrderNum), '#', TRIM(OrderLine), '#', TRIM(InvoiceNum)))) AS SalesOrderID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(Company, '#', TRIM(CustNum))))) AS CustomerID
	--,CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT(Company, '#', TRIM(IIF(CustNum IS NULL OR CustNum = '', 'MISSINGCUSTOMER', CustNum))))) AS CustomerID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', Company)) AS CompanyID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM(Company), '#', TRIM(PartNum))))) AS PartID 
	--,CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT(Company, '#', TRIM(IIF(PartNum IS NULL OR PartNum = '', 'MISSINGPART',  PartNum))))) AS PartID 
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM(Company), '#', TRIM(WarehouseCode))))) AS WarehouseID
	--,CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT(Company, '#', TRIM(WarehouseCode)))) AS WarehouseID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT(Company, '#', TRIM(OrderNum)))) AS SalesOrderNumID
	,CONVERT(int, REPLACE(CONVERT(date, OrderDate), '-', '')) AS SalesOrderDateID
	,CONCAT(Company, '#', TRIM(OrderNum), '#', TRIM(OrderLine), '#', TRIM(InvoiceNum))  AS SalesOrderCode
	,CONVERT([binary](32), HASHBYTES('SHA2_256',CONCAT( Company,'#','') ))	AS ProjectID
	,PartitionKey 

	,TRIM(Company) AS Company
	,TRIM(CustNum) AS CustomerNum  
	,TRIM(OrderNum) AS SalesOrderNum
	,TRIM(OrderLine) AS SalesOrderLine
	,TRIM(OrderSubLine) AS SalesOrderSubLine
	,TRIM(OrderType) AS SalesOrderType
	--,'' AS SalesOrderCategory
	,TRIM(OrderRelNum) AS SalesOrderRelNum
	,OrderDate AS SalesOrderDate
	,NeedbyDate
	,DelivDate AS ExpDelivDate
	,DelivDate AS ActualDelivDate --CAST('1900-01-01' AS date) -- DZ 20210825
	,CAST(ConfirmedDelivDate AS date) AS ConfirmedDelivDate
	,TRIM(InvoiceNum) AS SalesInvoiceNum
	,OrderQty AS SalesOrderQty
	,DelivQty
	,RemainingQty
	--,NULL AS SalesInvoiceQty
	--,'' AS UoM
	,UnitPrice
	,UnitCost
	,Currency
	,ExchangeRate
	,OpenRelease
	,DiscountAmount
	,DiscountPercent
	,TRIM(PartNum) AS PartNum
	,IIF(OrderSubLine = '000000', 'Main', 'Sub' )  AS PartType
	,PartStatus
	,TRIM(SalesPerson) AS SalesPersonName
	,TRIM(WarehouseCode) AS WarehouseCode
	,CASE WHEN TRIM(CustNum) = 'CFIN' THEN 'Cash Customer' 
			WHEN TRIM(CustNum) = 'CEX' THEN 'Cash Customer Export'
			WHEN TRIM(CustNum) = 'CEU' THEN 'Cash Customer EU'
			ELSE 'Normal' END AS SalesChannel
	,CASE WHEN LEFT(CustNum, 1) = 'C' THEN 'Over-the-Counter'
		WHEN SalesPerson = 'Verkkokauppa' THEN 'Webshop'
		ELSE 'Normal Order Handling' END AS AxInterSalesChannel
	--,'' AS Department
	--,'' AS ProjectNum
	--,'' AS IndexKey
	--,'' AS Cancellation
	--,'' AS SORes1
	--,'' AS SORes2
	--,'' AS SORes3
	,ReturnComment
	,TRIM(SalesReturnOrderNum) AS SalesReturnOrderNum
	,TRIM(SalesReturnInvoiceNum) AS SalesReturnInvoiceNum
	--,NULL AS [TotalMiscChrg]
FROM stage.WID_FI_OLine
where TRIM(CustNum) not in ('2379','1336','2067','2069','2361','2447','2967','2968','2969','INTR01','K0001','54311','54312','K51093')
--WHERE OrderType = '1'
--GROUP BY
--	PartitionKey,Company,CustNum,OrderNum,OrderLine,OrderSubLine,OrderRelNum,OrderRelNum,OrderDate,NeedbyDate,DelivDate,OrderQty,DelivQty,RemainingQty,UnitPrice,UnitCost, ExchangeRate, OpenRelease,DiscountAmount,DiscountPercent,PartNum,PartStatus, SalesPerson, ReturnComment, SalesReturnOrderNum,WarehouseCode,Currency, SalesReturnInvoiceNum, InvoiceNum, OrderType
GO
