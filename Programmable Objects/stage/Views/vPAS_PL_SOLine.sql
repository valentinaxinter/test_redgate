IF OBJECT_ID('[stage].[vPAS_PL_SOLine]') IS NOT NULL
	DROP VIEW [stage].[vPAS_PL_SOLine];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [stage].[vPAS_PL_SOLine] AS
--COMMENT EMPTY FIELDS // ADD TRIM() INTO CustomerID,PartID 23-01-05 VA
SELECT 
	CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT(company, '#',  TRIM(UPPER(custnum)), '#', TRIM(UPPER(ordernum)), '#', TRIM(UPPER(invoicenum)), '#', TRIM(UPPER(invoiceline)), '#', TRIM(idpozycji) ))) AS SalesInvoiceID --, '#', TRIM(UPPER(partnum)), '#',  TRIM(idpozycji) --, '#', IIF(sellingshipqty < 0, 'Return', '')
	,CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT(company, '#', TRIM(UPPER(ordernum)), '#', TRIM(UPPER(orderline)), '#', TRIM(UPPER(invoicenum))))) AS SalesOrderID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT(company, '#', TRIM(UPPER(custnum)), '#', TRIM(UPPER(invoicenum))))) AS SalesLedgerID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT(company,'#',TRIM(UPPER(ordernum)) ))) AS SalesOrderNumID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', company)) AS CompanyID
	--,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM(company), '#', TRIM(custnum))))) AS CustomerID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT(company, '#', TRIM(UPPER(custnum)) ))) AS CustomerID
	--,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM(company), '#', TRIM(partnum)) ))) AS PartID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT(company, '#', TRIM(UPPER(partnum)) ))) AS PartID
	--,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM(company), '#', TRIM(warehouseid))))) AS WarehouseID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT(company, '#', TRIM(UPPER(warehouseid))))) AS WarehouseID
	,CONCAT(company, '#', TRIM(UPPER(ordernum)), '#', TRIM(UPPER(orderline)), '#', TRIM(UPPER(invoicenum))) AS SalesOrderCode
	,CONVERT(int, replace(convert(date,invoicedate),'-','')) AS SalesInvoiceDateID  
	,CONCAT(company,'#', TRIM(UPPER(invoicenum)), '#', TRIM(UPPER(invoiceline)) ) AS SalesInvoiceCode
	,CONVERT([binary](32), HASHBYTES('SHA2_256',CONCAT( Company,'#','') ))	AS ProjectID
	,PartitionKey

	,company
	,salesperson AS SalesPersonName
	,TRIM(UPPER(custnum)) AS CustomerNum
	,TRIM(UPPER(partnum)) AS PartNum
	,IIF(sellingshipqty < 0, 'Return', '') AS PartType
	,TRIM(UPPER(ordernum)) AS SalesOrderNum
	,TRIM(UPPER(orderline)) AS SalesOrderLine
	,TRIM(ordersubline) AS SalesOrderSubLine
	,TRIM(ordertype) AS SalesOrderType
 	,TRIM(UPPER(invoicenum)) AS SalesInvoiceNum
	,TRIM(UPPER(invoiceline)) AS SalesInvoiceLine
	,TRIM(invoicetype) AS SalesInvoiceType
	,CASE WHEN invoicedate = '' THEN '1900-01-01' ELSE CONVERT(date, invoicedate) END AS SalesInvoiceDate
	,actualdeliverydate AS ActualDelivDate
	,sellingshipqty AS SalesInvoiceQty
	--,'' AS UoM
	,unitprice AS UnitPrice -- ATT.!, the net price
	,unitcost AS UnitCost
	--,0 AS DiscountPercent
	--,0 AS DiscountAmount
	--,0 AS CashDiscountOffered
	--,0 AS CashDiscountUsed
	,totalmiscchrg AS TotalMiscChrg
	--,NULL AS VATAmount
	,'PLN' AS Currency
	,1 AS ExchangeRate
	,TRIM(creditmemo) AS CreditMemo
	--,CASE WHEN TRIM(UPPER(invoicenum)) like '%PP%' THEN 'Over The Counter sales'
	--	WHEN SalesChannel = 'B2B' THEN 'Webshop'
	--	ELSE 'Normal Order Handling' END AS SalesChannel
	,CASE WHEN TRIM(UPPER(invoicenum)) like '%PP%' THEN 'Over-the-Counter'
--		WHEN saleschannel = 'B2B' THEN 'Webshop'
		ELSE 'Normal Order Handling' END AS saleschannel
	,IIF(RIGHT(SUBSTRING(TRIM(UPPER(invoicenum)), 5, 3), 1) = '/', SUBSTRING(TRIM(UPPER(invoicenum)), 5, 2),  SUBSTRING(TRIM(UPPER(invoicenum)), 5, 3)) AS Department
	,IIF(TRIM(UPPER(PartNum)) like 'U%', 'Service', TRIM(UPPER(warehouseID))) AS WarehouseCode
	--,NULL AS DeliveryAddress
	--,'' AS CostBearerNum
	--,'' AS CostUnitNum
	--,'' AS ReturnComment
	--,'' AS ReturnNum
	--,'' AS ProjectNum
	,TRIM(idpozycji) AS IndexKey
	,res1 AS SIRes1
	,res2 AS SIRes2
	,res3 AS SIRes3
FROM 
	stage.PAS_PL_SOLine
WHERE
	TRIM(invoicetype) <> 'Pre-Invoice' -- DZ added based on the new Invoice source data situation
GROUP BY
	PartitionKey, company, SalesPerson, TRIM(UPPER(custnum)), TRIM(UPPER(partnum)), TRIM(UPPER(ordernum)), TRIM(UPPER(orderline)), ordersubline, ordertype, TRIM(UPPER(invoicenum)), TRIM(UPPER(invoiceline)), TRIM(invoicetype), invoicedate, actualdeliverydate, sellingshipqty, unitprice, unitcost, TRIM(creditmemo), discountamount, totalmiscchrg, TRIM(UPPER(warehouseid)), res1, res2, res3, TRIM(idpozycji) --, saleschannel
GO
