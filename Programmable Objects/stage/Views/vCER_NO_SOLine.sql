IF OBJECT_ID('[stage].[vCER_NO_SOLine]') IS NOT NULL
	DROP VIEW [stage].[vCER_NO_SOLine];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [stage].[vCER_NO_SOLine] AS
--COMMENT EMPTY FIELDS // ADD TRIM() INTO PartID,CustomerID,WarehouseID 2022-12-16 VA
SELECT 
	CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT(SO.Company, '#', TRIM(InvoiceNum), '#', TRIM(InvoiceLine)))) AS SalesInvoiceID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT(SO.Company, '#', OrderNum, '#', OrderLine, '#', OrderRel, '#', InvoiceNum))) AS SalesOrderID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT(SO.Company, '#', CustNum, '#', InvoiceNum))) AS SalesLedgerID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT(SO.Company, '#', TRIM(OrderNum)))) AS SalesOrderNumID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', SO.Company)) AS CompanyID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM(SO.Company), '#', TRIM(CustNum))))) AS CustomerID
	--,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(SO.Company, '#', TRIM(IIF(CustNum IS NULL OR CustNum = '', 'MISSINGCUSTOMER', CustNum) ))))) AS CustomerID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM(SO.Company), '#', TRIM(PartNum))))) AS PartID
	--,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(SO.Company, '#', TRIM(IIF(PartNum IS NULL OR PartNum = '', 'MISSINGPART',  PartNum) ))))) AS PartID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM(SO.Company), '#', TRIM(WarehouseCode))))) AS WarehouseID
	--,CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT(SO.Company, '#', WarehouseCode))) AS WarehouseID
	,CONCAT(SO.Company,'#',OrderNum,'#',OrderLine) AS SalesOrderCode 
	,CONVERT(int, replace(convert(date,InvoiceDate),'-','')) AS SalesInvoiceDateID  --Redundant?
	,CONCAT(SO.Company, '#', TRIM(InvoiceNum), '#', TRIM(InvoiceLine)) AS SalesInvoiceCode --Redundant?
	,CONVERT([binary](32), HASHBYTES('SHA2_256',CONCAT( SO.Company,'#','') ))	AS ProjectID
	,PartitionKey

	,UPPER(TRIM(SO.Company)) AS Company
	,TRIM(SalesPerson) AS SalesPersonName
	,UPPER(TRIM(CustNum)) AS CustomerNum
	,UPPER(TRIM(PartNum)) AS PartNum
	--,CASE WHEN TRIM(OrderNum) = '0' THEN 'PrimaryPart' ELSE 'SubPart' END  AS PartType
	,LineFlag AS PartType		--Changed to LineFlag since it seems to be a better indicator át request of An /SM 2021-04-28
	,TRIM(OrderNum) AS SalesOrderNum
	,TRIM(OrderLine) AS SalesOrderLine
	,TRIM(OrderSubLine) AS SalesOrderSubLine
--	,OrderRel AS OrderRelNum
	,CONVERT(nvarchar(50), OrderType) AS SalesOrderType
	,TRIM(InvoiceNum) AS SalesInvoiceNum
	,TRIM(InvoiceLine) AS SalesInvoiceLine
	--,'' AS SalesInvoiceType
	,CASE WHEN InvoiceDate = '' THEN '1901-01-01' ELSE CONVERT(date, InvoiceDate) END AS SalesInvoiceDate
	,ActualDeliveryDate AS ActualDelivDate
	,SellingShipQty AS SalesInvoiceQty
	,'' AS UoM
	--,CASE WHEN LineFlag = 'Main' AND UnitPrice = 0 THEN Kit_UnitPrice --was
	--	ELSE UnitPrice
	--	END AS UnitPrice --	
	,UnitPrice
	,IIF(UnitPrice = 0, 0, UnitCost) AS UnitCost
	--,CASE WHEN LineFlag = 'Main' AND UnitPrice = 0 THEN Kit_Discount
	--	ELSE DiscountAmount 
	--	END AS DiscountAmount
	,IIF(UnitPrice = 0, 0, DiscountAmount) AS DiscountAmount
	--,NULL AS DiscountPercent
	--,0 AS CashDiscountOffered
	--,0 AS CashDiscountUsed
	,TotalMiscChrg
	--,NULL AS VATAmount
	,'NOK' AS Currency
	,CONVERT(decimal (18,4), 1) AS ExchangeRate
	,CreditMemo
	--,'' AS [SalesChannel]
	,m.CostUnitGroup AS [Department]
	,CASE WHEN WarehouseCode = '' OR WarehouseCode is NULL THEN 'Other' ELSE WarehouseCode END AS WarehouseCode
	--,NULL AS DeliveryAddress
	,LEFT(m.CostUnitName, 50) AS CostBearerNum 
	,[Site] AS CostUnitNum
	--,'' AS ReturnComment
	--,'' AS ReturnNum
	--,'' AS ProjectNum
	,IndexKey
	,LineFlag AS SIRes1
	--,'' AS SIRes2 
	--,'' AS SIRes3 -- added 20201220 to solve NO sites issue

FROM stage.CER_NO_SOLine SO
	LEFT JOIN [stage].[CER_NO_mapSite] m ON SO.Site = m.CostUnitNum
WHERE InvoiceNum IS NOT NULL --LineFlag = 'Main'
--GROUP BY PartitionKey, Company, CustNum, OrderNum, OrderLine, OrderSubLine, OrderRel, UnitPrice, UnitCost, DiscountAmount, PartNum, SalesPerson, WarehouseCode, LineFlag,OrderType, InvoiceNum, InvoiceLine, InvoiceDate, ActualDeliveryDate, SellingShipQty, TotalMiscChrg, CreditMemo, Indexkey, Kit_UnitPrice, Kit_Discount, [Site]
GO
