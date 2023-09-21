IF OBJECT_ID('[stage].[vFOR_ES_SOLine]') IS NOT NULL
	DROP VIEW [stage].[vFOR_ES_SOLine];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE VIEW [stage].[vFOR_ES_SOLine] AS
--COMMENT EMPTY FIELDS 2022-12-21 VA
SELECT 
	CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM(Company),'#',TRIM(SalesInvoiceNum),'#',TRIM(SalesInvoiceLine))))) AS SalesInvoiceID
	,CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM(Company),'#',TRIM(OrderSaleNumber),'#',TRIM(OrderSaleLineNumber))))) AS SalesOrderID
	,CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM(Company),'#',TRIM(CustomerNum), '#', TRIM(SalesInvoiceNum))))) AS SalesLedgerID
	,CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM(Company),'#',OrderSaleNumber)))) AS SalesOrderNumID  
	,CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(TRIM(Company)))) AS CompanyID
	,CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM(Company),'#',TRIM(CustomerNum))))) AS CustomerID  
	,CASE WHEN PartNum IS NOT NULL THEN	CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM(Company),'#',TRIM(PartNum)))))
			ELSE CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT('FSEFORA','#','TEXTLINE')))) END	AS PartID --Added Coalesce and Nullif to take care of empty partnum so they are included in report after RLS  /SM 20210325
	,CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM([Company]),'#',TRIM([Warehouse]))))) AS WarehouseID
	,UPPER(CONCAT(Company,'#',OrderSaleNumber,'#',OrderSaleLineNumber)) as SalesOrderCode
	,CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM(Company),'#',TRIM(SalesInvoiceNum))))) AS SalesInvoiceNumID -- Redundant
	,CONVERT(int, replace(convert(date,SalesInvoiceDate),'-','')) AS SalesInvoiceDateID  --Redundant?
	,UPPER(CONCAT(Company,'#',TRIM(SalesInvoiceNum),'#',TRIM(SalesInvoiceLine))) AS SalesInvoiceCode --Redundant?
	,CONVERT([binary](32), HASHBYTES('SHA2_256',CONCAT( Company,'#','') ))	AS ProjectID

	,PartitionKey
	,UPPER(TRIM(Company)) AS Company
	,SalesPerson AS SalesPersonName
	,UPPER(TRIM(CustomerNum)) AS CustomerNum
	,UPPER(TRIM(PartNum)) AS PartNum 
	,PartType
	,UPPER(TRIM(OrderSaleNumber)) AS SalesOrderNum
	,UPPER(TRIM(OrderSaleLineNumber)) AS SalesOrderLine
	--,'' AS SalesOrderSubLine
	,DOCUMENTKIND AS SalesOrderType
	,UPPER(TRIM(SalesInvoiceNum)) AS SalesInvoiceNum
	,UPPER(TRIM(SalesInvoiceLine)) AS SalesInvoiceLine
	--,'' AS SalesInvoiceType
	,convert(date, SalesInvoiceDate) as SalesInvoiceDate
	,ActualDelivDate
	,SalesInvoiceQty
	--,'' AS UoM
	,UnitPrice
	,UnitCost  
	,DiscountPercent
	,DiscountAmount
	--,0 AS CashDiscountOffered
	--,0 AS CashDiscountUsed
	, 0 as TotalMiscChrg
	, VATAmount as VATAmount
	,'EUR' AS Currency
	, ExchangeRate
	, CreditMemo
	--,'' AS SalesChannel
	--,'' Department
	,Warehouse AS WarehouseCode
	--,NULL AS DeliveryAddress
	--,'' AS CostBearerNum
	--,'' AS CostUnitNum
	--,'' AS ReturnComment
	--,'' AS ReturnNum
	--,'' AS ProjectNum
	,CONCAT(DocumentNum,'-', DocumentLine) AS IndexKey
	,DeliveryNoteNum AS SIRes1
	,[DOCUMENTKIND] AS SIRes2
	--,'' AS SIRes3
FROM stage.FOR_ES_SOLine AS SO
--GROUP BY PartitionKey, Company, SalesPerson, CustomerNum, SalesOrderNum, SalesOrderLine, OrderSubLine, OrderRel, OrderType, SalesInvoiceNum, SalesInvoiceLine, SalesInvoiceDate, SellingShipQty, UnitPrice, UnitCost, DiscountAmount, TotalMiscChrg, PartNum, WarehouseCode, CreditMemo, Indexkey, ActualDeliveryDate --, [Site]
GO
