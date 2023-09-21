IF OBJECT_ID('[stage].[vSCM_FI_SOLine]') IS NOT NULL
	DROP VIEW [stage].[vSCM_FI_SOLine];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [stage].[vSCM_FI_SOLine] AS
--COMMENT EMPTY FIELD // ADD UPPER()TRIM() INTO PartID 2022-12-21 VA
SELECT 
	CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT(Company, '#', TRIM(CustNum), '#', TRIM(OrderNum), '#', TRIM(PartNum), '#', TRIM(InvoiceNum), '#', TRIM(InvoiceLine)))) AS SalesInvoiceID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT(Company, '#', OrderNum, '#', OrderLine, '#', OrderRel, '#', InvoiceNum))) AS SalesOrderID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT(Company, '#', TRIM(IIF(CustNum = '' OR CustNum IS NULL, 'MISSINGCUSTOMER', CustNum)), '#', InvoiceNum))) AS SalesLedgerID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT(Company, '#', TRIM(OrderNum)))) AS SalesOrderNumID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', Company)) AS CompanyID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM(Company), '#', TRIM(CustNum))))) AS CustomerID
	--,CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT(Company, '#', TRIM(IIF(CustNum = '' OR CustNum IS NULL, 'MISSINGCUSTOMER', CustNum))))) AS CustomerID
	,CONVERT([binary](32), HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM(Company), '#', TRIM(PartNum))))) AS PartID  
	--,CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT(Company, '#', TRIM(IIF(PartNum = '' OR PartNum IS NULL, 'MISSINGPART', PartNum))))) AS PartID  
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM([Company]), '#', TRIM([WarehouseCode]))))) AS WarehouseID
	,CONVERT(int, replace(convert(date,InvoiceDate),'-','')) AS SalesInvoiceDateID  
	,CONCAT(Company,'#',OrderNum,'#',OrderLine, '#',InvoiceNum) AS SalesOrderCode
	,CONCAT(Company,'#',TRIM(InvoiceNum),'#',TRIM(InvoiceLine)) AS SalesInvoiceCode
	,CONVERT([binary](32), HASHBYTES('SHA2_256',CONCAT( Company,'#','') ))	AS ProjectID
	,PartitionKey

	,TRIM(Company) AS Company
	,TRIM(SalesPerson) AS SalesPersonName
	,TRIM(CustNum) AS CustomerNum
	,TRIM(PartNum) AS PartNum
	,[LineFlag] AS PartType --Changed av DZ 2021-05-06, it was CASE WHEN TRIM(OrderNum) = '0' THEN 'PrimaryPart' ELSE 'SubPart' END
	,TRIM(OrderNum) AS SalesOrderNum
	,TRIM(OrderLine) AS SalesOrderLine
	,TRIM(OrderSubLine) AS SalesOrderSubLine
--	,OrderRel AS OrderRelNum
	,TRIM(OrderType) AS SalesOrderType
	,TRIM(InvoiceNum) AS SalesInvoiceNum
	,TRIM(InvoiceLine) AS SalesInvoiceLine
	--,'' AS SalesInvoiceType
	,CASE WHEN InvoiceDate = '' THEN '1900-01-01' ELSE CONVERT(date, InvoiceDate) END AS SalesInvoiceDate
	,ActualDeliveryDate	 AS ActualDelivDate
	,SellingShipQty	AS SalesInvoiceQty
	--,'' AS UoM
	,UnitPrice	
	,UnitCost
	,IIF(SellingShipQty*UnitPrice = 0, 0, DiscountAmount/SellingShipQty*UnitPrice) AS DiscountPercent ----Changed av DZ 2021-05-06, it was "0"
	,DiscountAmount
	--,0 AS CashDiscountOffered
	--,0 AS CashDiscountUsed
	,TotalMiscChrg
	--,NULL AS VATAmount --Changed av DZ 2021-05-06, it was "0"
	,CASE WHEN ExchangeRate = 1 THEN 'EUR' ELSE '' END AS Currency
	,CONVERT(decimal (18,4), ExchangeRate) AS ExchangeRate
	,CreditMemo
	--,'' AS SalesChannel
	--,'' AS Department
	,TRIM(WarehouseCode) AS WarehouseCode
	--,NULL AS DeliveryAddress
	--,'' AS CostBearerNum
	--,'' AS CostUnitNum
	,ReturnComment
	--,'' AS ReturnNum
	--,'' AS ProjectNum
	,MAX(Indexkey) AS Indexkey
	--,'' AS SIRes1
	--,'' AS SIRes2
	--,'' AS SIRes3
FROM stage.SCM_FI_SOLine 
GROUP BY
	PartitionKey, Company, SalesPerson, CustNum, PartNum, OrderNum, OrderLine, OrderSubLine, OrderType, InvoiceNum, InvoiceLine, InvoiceDate, ActualDeliveryDate, SellingShipQty, UnitPrice, UnitCost, DiscountAmount, TotalMiscChrg, WarehouseCode, CreditMemo, [Site], OrderRel, LineFlag, ReturnComment, ExchangeRate
GO
