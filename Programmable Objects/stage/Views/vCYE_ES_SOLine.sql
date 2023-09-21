IF OBJECT_ID('[stage].[vCYE_ES_SOLine]') IS NOT NULL
	DROP VIEW [stage].[vCYE_ES_SOLine];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [stage].[vCYE_ES_SOLine] AS
--COMMENT EMPTY FIELD // ADD TRIM() INTO CustomerID,WarehouseID  23-01-03 VA
SELECT 
	CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(Company, '#', TRIM(InvoiceNum), '#', TRIM(InvoiceLine), '#', TRIM(OrderNum), '#', TRIM(ReturnNum))))) AS SalesInvoiceID --,'#',UnitCost
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(Company, '#', TRIM(OrderNum), '#', TRIM(OrderLine), '#', TRIM(OrderRel), '#', TRIM(InvoiceNum))))) AS SalesOrderID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(Company, '#', TRIM(IIF(CustNum IS NULL OR CustNum = '', 'MISSINGCUSTOMER', TRIM(CustNum)) ), '#', InvoiceNum)))) AS SalesLedgerID 
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(Company, '#', TRIM(OrderNum))))) AS SalesOrderNumID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(Company))) AS CompanyID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM(Company), '#', TRIM(TRIM(CustNum)))))) AS CustomerID
	--,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(Company, '#', TRIM(IIF(CustNum IS NULL OR CustNum = '', 'MISSINGCUSTOMER', TRIM(CustNum)) ) )))) AS CustomerID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(Company, '#', TRIM(PartNum))))) AS PartID
	--,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(Company, '#', TRIM(IIF(PartNum IS NULL OR PartNum = '', 'MISSINGPART',  TRIM(PartNum)) ))))) AS PartID 
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM(Company), '#', TRIM(SalesOfficeDescrip))))) AS WarehouseID
	--,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(Company, '#', TRIM(SalesOfficeDescrip))))) AS WarehouseID --temp solution to replace WarehouseCode
	,UPPER(CONCAT(Company, '#',  TRIM(OrderNum), '#', TRIM(OrderLine))) AS SalesOrderCode
	,CONVERT(int, replace(convert(date,InvoiceDate),'-','')) AS SalesInvoiceDateID  
	,UPPER(CONCAT(Company, '#', TRIM(InvoiceNum), '#', TRIM(InvoiceLine), '#', TRIM(OrderNum))) AS SalesInvoiceCode
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT( Company, '#', '') )))	AS ProjectID
	,PartitionKey

	,UPPER(Company) AS Company
	,UPPER(TRIM(CustNum)) AS CustomerNum
	,UPPER(TRIM(PartNum)) AS PartNum
	,TRIM(SalesGroupDescrip) AS SalesPersonName --25/5
	,TRIM(OrderNum) AS SalesOrderNum
	,TRIM(OrderLine) AS SalesOrderLine
	,TRIM(OrderRel) AS SalesOrderSubLine
	--,'' AS SalesOrderType
	--,'' AS PartType
	,TRIM(InvoiceNum) AS SalesInvoiceNum
	,TRIM(InvoiceLine) AS SalesInvoiceLine
	,TRIM(InvoiceType) AS SalesInvoiceType -- added by Capgemani 20210622 /DZ
	,CONVERT(date, InvoiceDate) AS SalesInvoiceDate
	,CONVERT(date, ActualDeliveryDate) AS ActualDelivDate
	,IIF(ReturnNum IS NOT NULL OR InvoiceType in ('RE', 'S1','G2'), -1*SellingShipQty/1000, SellingShipQty/1000) AS SalesInvoiceQty --change 20210510 /DZ --: SalesInvoiceType in (’RE’, ’S1’,’G2’) then qty * -1 and DiscountAmount * -1 ET epost 20210630
	--,'' AS UoM
	,UnitPrice/10000 AS UnitPrice --change 20210510 /DZ
	,UnitCost/10000 AS UnitCost --change 20210510 /DZ
	,IIF(UnitPrice*SellingShipQty = 0, 0, DiscountAmount/(UnitPrice/10000)*(SellingShipQty/1000)) AS DiscountPercent --change 20210510 /DZ
	,IIF(InvoiceType in ('RE', 'S1','G2'), -1*DiscountAmount/100, DiscountAmount/100) AS DiscountAmount --change 20210510 /DZ
	--,0 AS CashDiscountOffered
	--,0 AS CashDiscountUsed
	,IIF(ReturnNum IS NOT NULL, -1*TotalMiscChrg/100, TotalMiscChrg/100) AS TotalMiscChrg --change 20210510 /DZ -- SalesInvoiceType in (’RE’, ’S1’,’G2’) then DiscountAmount * -1 ET epost 20210630
	--,NULL AS VATAmount
	,'EUR' AS Currency
	,1 AS ExchangeRate
	,IIF(ReturnNum IS NOT NULL OR InvoiceType in ('RE', 'S1','G2'), 1, 0) AS CreditMemo
	--,'' AS SalesChannel
	,TRIM(SalesOfficeDescrip) AS Department
	,TRIM(SalesOfficeDescrip) AS WarehouseCode -- real one is WarehouseCode, use officedescrip for temp solution --/DZ + ET 2022-03-18
	--,NULL AS DeliveryAddress
	--,'' AS CostBearerNum
	--,'' AS CostUnitNum
	,ReturnComment
	,TRIM(ReturnNum) AS ReturnNum
	--,'' AS ProjectNum
	,IndexKey
	--,'' AS SIRes1
	--,'' AS SIRes2
	--,'' AS SIRes3

FROM 
	[stage].[CYE_ES_SOLine] AS SO

GROUP BY PartitionKey, Company, SalesPerson, CustNum, OrderLine, InvoiceNum, InvoiceLine, InvoiceDate, ActualDeliveryDate, SellingShipQty, UnitPrice, UnitCost, DiscountAmount, PartNum, TotalMiscChrg, CreditMemo, WarehouseCode, IndexKey, UnitCostEK02, SalesOfficeDescrip, SalesGroupCode, SalesGroupDescrip, OrderNum, OrderRel, ReturnNum, ReturnComment, InvoiceType
GO
