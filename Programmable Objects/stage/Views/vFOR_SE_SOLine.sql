IF OBJECT_ID('[stage].[vFOR_SE_SOLine]') IS NOT NULL
	DROP VIEW [stage].[vFOR_SE_SOLine];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [stage].[vFOR_SE_SOLine] AS
--COMMENT EMPTY FIELD // CustomerID,PartID Adjust 2022-12-20 VA
SELECT 
	CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM(Company), '#', TRIM(InvoiceNum), '#', TRIM(InvoiceLine))))) AS SalesInvoiceID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM(Company), '#', TRIM(OrderNum), '#', TRIM(OrderLine), '#', TRIM(OrderRel), '#', TRIM(InvoiceNum))))) AS SalesOrderID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM(Company), '#', TRIM(IIF(CustNum IS NULL OR CustNum = '', 'MISSINGCUSTOMER', CustNum) ), '#', TRIM(InvoiceNum))))) AS SalesLedgerID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM(Company), '#', TRIM(OrderNum))))) AS SalesOrderNumID  
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(TRIM(Company)))) AS CompanyID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(Company, '#', TRIM(CustNum))))) AS CustomerID 
	--,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(Company, '#', TRIM(IIF(CustNum IS NULL OR CustNum = '', 'MISSINGCUSTOMER', CustNum) ))))) AS CustomerID 
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(Company, '#', TRIM(PartNum))))) AS PartID
	--,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(Company, '#', TRIM(IIF(PartNum IS NULL OR PartNum = '', 'MISSINGPART',  PartNum) ))))) AS PartID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM([Company]), '#', TRIM([WarehouseCode]))))) AS WarehouseID
	,UPPER(CONCAT(Company, '#', OrderNum, '#', OrderLine, '#', InvoiceNum)) as SalesOrderCode
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM(Company), '#', TRIM(InvoiceNum))))) AS SalesInvoiceNumID -- Redundant
	,CONVERT(int, replace(convert(date,InvoiceDate),'-','')) AS SalesInvoiceDateID  --Redundant?
	,UPPER(CONCAT(Company, '#', TRIM(InvoiceNum), '#', TRIM(InvoiceLine))) AS SalesInvoiceCode --Redundant?
	,CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT( Company,'#','') ))	AS ProjectID
	,PartitionKey

	,UPPER(TRIM(Company)) AS Company
	,UPPER(TRIM(CustNum)) AS CustomerNum
	,UPPER(TRIM(PartNum)) AS PartNum
	--,UPPER(TRIM(IIF(CustNum IS NULL OR CustNum = '', 'MISSINGCUSTOMER', CustNum) )) AS CustomerNum
	--,UPPER(TRIM(IIF(PartNum IS NULL OR PartNum = '', 'MISSINGPART',  PartNum) )) AS PartNum
	,TRIM(SalesPerson) AS SalesPersonName
	,CASE WHEN TRIM(OrderNum) = '0' THEN 'PrimaryPart' ELSE 'SubPart' END  AS PartType
	,CASE WHEN OrderNum is not NULL or OrderNum <> '0' THEN UPPER(TRIM(OrderNum)) END AS SalesOrderNum
	,UPPER(TRIM(OrderLine)) AS SalesOrderLine
	,UPPER(TRIM(OrderSubLine)) AS SalesOrderSubLine
	,TRIM(OrderType) AS SalesOrderType
	,UPPER(TRIM(InvoiceNum)) AS SalesInvoiceNum
	,UPPER(TRIM(InvoiceLine)) AS SalesInvoiceLine
	--,'' AS SalesInvoiceType
	,convert(date, InvoiceDate) as SalesInvoiceDate
	,ActualDeliveryDate AS ActualDelivDate
	,SellingShipQty AS SalesInvoiceQty
	--,'' AS UoM
	,UnitPrice
	,CASE WHEN UnitCost < 0 THEN -1*(UnitCost) ELSE UnitCost END AS UnitCost  -- to stress Forankra Sweden return scenario as stated in Emil T email on 2020-08-05
	,IIF(SellingShipQty*UnitPrice <> 0, DiscountAmount/SellingShipQty*UnitPrice, 0) AS DiscountPercent
	,DiscountAmount
	--,0 AS CashDiscountOffered
	--,0 AS CashDiscountUsed
	--,0 AS TotalMiscChrg -- TotalMiscChrg in SO but on the request of Hanna Klasson at Forankra SE this should not be included (mail on 2020-09-30) 
	--,NULL AS VATAmount
	,'SEK' AS Currency
	,1 AS ExchangeRate
	,CreditMemo
	--,'' AS SalesChannel
	--,'' Department
	,TRIM(WarehouseCode) AS WarehouseCode
	--,NULL AS DeliveryAddress
	--,'' AS CostBearerNum
	--,'' AS CostUnitNum
	--,'' AS ReturnComment
	--,'' AS ReturnNum
	--,'' AS ProjectNum
	,IndexKey
	--,'' AS SIRes1
	--,'' AS SIRes2
	--,'' AS SIRes3
FROM stage.FOR_SE_SOLine AS SO
WHERE OrderNum <> '0'
GROUP BY 
	PartitionKey, Company, SalesPerson, CustNum, OrderNum, OrderLine, OrderSubLine, OrderRel, OrderType, InvoiceNum, InvoiceLine, InvoiceDate, SellingShipQty, UnitPrice, UnitCost, DiscountAmount, TotalMiscChrg, PartNum, WarehouseCode, CreditMemo, Indexkey, ActualDeliveryDate --, [Site]
GO
