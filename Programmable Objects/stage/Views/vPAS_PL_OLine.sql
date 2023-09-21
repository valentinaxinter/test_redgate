IF OBJECT_ID('[stage].[vPAS_PL_OLine]') IS NOT NULL
	DROP VIEW [stage].[vPAS_PL_OLine];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [stage].[vPAS_PL_OLine] AS
--COMMENT EMPTY FIELDS // ADD TRIM() INTO CustomerID,PartID 23-01-05 VA
SELECT
	CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT(company, '#', ordernum, '#', orderline, '#', ordersubline, '#', invoicenum, '#', warehousecode ))) AS SalesOrderID  --, '#', [saleschannel] --, '#', discountamount --, '#', openrelease
	,CONVERT([binary](32), HASHBYTES('SHA2_256', company)) AS CompanyID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM(company), '#', TRIM(custnum))))) AS CustomerID
	--,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(company, '#', TRIM(custnum))))) AS CustomerID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM(company), '#', TRIM((partnum)))))) AS PartID
	--,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(company, '#', TRIM((partnum)))))) AS PartID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM(company), '#', TRIM(warehousecode))))) AS WarehouseID
	--,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(company, '#', TRIM(warehousecode))))) AS WarehouseID
	,CONVERT([binary](32), HASHBYTES('SHA2_256',UPPER(CONCAT(company,'#',TRIM(ordernum)) ))) AS SalesOrderNumID
	,CONVERT(int, replace(convert(date, orderdate),'-','')) AS SalesOrderDateID 
	,CONCAT(company, '#', TRIM(UPPER(ordernum)), '#', TRIM(UPPER(orderline)), '#', TRIM(UPPER(invoicenum))) AS SalesOrderCode
	,CONVERT([binary](32), HASHBYTES('SHA2_256',CONCAT( Company,'#','') ))	AS ProjectID
	,PartitionKey 

	,company AS Company
	,TRIM(UPPER(custnum)) AS CustomerNum
	,TRIM(UPPER(ordernum)) AS SalesOrderNum
	,TRIM(UPPER(orderline)) AS SalesOrderLine
	,ordersubline AS SalesOrderSubLine
	,CONVERT(nvarchar(50), ordertype) AS SalesOrderType
	--,'' AS [SalesOrderCategory]
	,try_convert(date,orderdate) AS SalesOrderDate
	,try_convert(date,needbydate) AS NeedbyDate
	,try_convert(date,delivdate) AS ExpDelivDate
	,CAST('1900-01-01' AS date) AS ActualDelivDate
	,CAST('1900-01-01' AS date) AS ConfirmedDelivDate
	,TRIM(UPPER(invoicenum)) AS SalesInvoiceNum
	,Convert(decimal(18,4), orderqty) AS SalesOrderQty
	,Convert(decimal(18,4), delivqty) AS DelivQty
	,Convert(decimal(18,4), remainingqty) AS RemainingQty
	--,NULL AS SalesInvoiceQty
	--,'' AS UoM
	,Convert(decimal(18,4), UnitPrice)/Convert(decimal(18,4), currexchrate) AS UnitPrice -- netprice for Passerotti, i.e. price is after the discount (this is in original currency)
	,Convert(decimal(18,4), UnitCost)/Convert(decimal(18,4), currexchrate) AS UnitCost --
	,currency AS Currency
	,Convert(decimal(18,4), currexchrate)/1 AS ExchangeRate --cIIF(Convert(decimal(18,4), currexchrate) = 0, 0, Convert(decimal(18,4), currexchrate)/Convert(decimal(18,4), currexchrate)) AS 
	,IIF(openrelease = 1, 0, 1) AS OpenRelease
	--,0 AS DiscountAmount
	--,0 AS DiscountPercent
	,TRIM(UPPER(partnum)) AS PartNum
	--,'' AS PartType
	,partstatus AS PartStatus
	,trim([salesperson]) AS SalesPersonName
	,IIF(PartNum like 'U%', 'Service', TRIM(UPPER(warehousecode))) AS WarehouseCode
	,SalesChannel
	,CASE WHEN invoicenum like '%PP%' THEN 'Over-the-Counter'
		WHEN SalesChannel = 'B2B' THEN 'Webshop'
		ELSE 'Normal Order Handling' END AS AxInterSalesChannel
	,[businesschain] AS Department
	--,'' AS [ProjectNum]
	--,'' AS [IndexKey]
	,[res2] AS Cancellation
	,left([res1],100) AS SORes1
	--,'' AS SORes2
	,[res3] AS SORes3
	--,NULL AS [TotalMiscChrg]
FROM stage.PAS_PL_OLine
WHERE [res2] IS NULL
--GROUP BY
--	PartitionKey, company, custnum, ordernum, orderline, ordersubline, ordertype, orderdate, needbydate, delivdate, invoicenum, unitprice, unitcost, currency, currexchrate, openrelease, partnum, partstatus, [salesperson], warehousecode, [businesschain], [res1], [res2], [res3], DiscountAmount, DiscountPercent, SalesChannel
GO
