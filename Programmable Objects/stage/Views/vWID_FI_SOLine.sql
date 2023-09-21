IF OBJECT_ID('[stage].[vWID_FI_SOLine]') IS NOT NULL
	DROP VIEW [stage].[vWID_FI_SOLine];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE VIEW [stage].[vWID_FI_SOLine] AS
-- COMMENT EMPTY FIELDS / ADD UPPER()TRIM() INTO PartID,CustomerID,WarehouseID 2022-12-15 VA
--PARTNUM / CUSTNUM / salesledgerid 23-02-17 VA
SELECT 
	CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT(Company, '#', TRIM(CustNum), '#', TRIM(OrderNum), '#', TRIM(InvoiceNum), '#', TRIM(Indexkey)))) AS SalesInvoiceID --, '#', TRIM(OrderLine), '#', TRIM(PartNum)
	,CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT(Company, '#', TRIM(OrderNum), '#', TRIM(OrderLine), '#', TRIM(InvoiceNum)))) AS SalesOrderID --, '#', OrderRel
	,CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT(Company, '#', TRIM(CustNum), '#', TRIM(InvoiceNum)))) AS SalesLedgerID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT(Company, '#', TRIM(OrderNum)))) AS SalesOrderNumID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', Company)) AS CompanyID
	--,CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT(Company, '#', TRIM(IIF(CustNum IS NULL OR CustNum = '', 'MISSINGCUSTOMER', CustNum)) ))) AS CustomerID
	,CONVERT([binary](32), HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM(Company), '#', TRIM(CustNum))))) AS CustomerID
	--,CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT(Company, '#', TRIM(IIF(PartNum IS NULL OR PartNum = '', 'MISSINGPART',  PartNum) )))) AS PartID 
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM(Company), '#', TRIM(PartNum))))) AS PartID 
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM(Company), '#', TRIM(WarehouseCode))))) AS WarehouseID
	--,CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT(Company, '#', TRIM(WarehouseCode)))) AS WarehouseID
	,CONCAT(Company, '#', TRIM(OrderNum), '#', TRIM(OrderLine), '#', TRIM(InvoiceNum)) AS SalesOrderCode
	,CONVERT(int, replace(convert(date,InvoiceDate), '-', '')) AS SalesInvoiceDateID  --Redundant?
	,CONCAT(Company, '#', TRIM(InvoiceNum), '#', TRIM(InvoiceLine)) AS SalesInvoiceCode --Redundant?
	,CONVERT([binary](32), HASHBYTES('SHA2_256',CONCAT( Company,'#','') ))	AS ProjectID
	,PartitionKey

	,TRIM(Company) AS Company
	,TRIM(SalesPerson) AS SalesPersonName
	,TRIM(CustNum) AS CustomerNum
	,TRIM(PartNum) AS PartNum
	,IIF(OrderRel = '000000', 'Main', 'Sub' )  AS PartType
	,TRIM(OrderNum) AS SalesOrderNum
	,TRIM(OrderLine) AS SalesOrderLine
	,TRIM(OrderRel) AS SalesOrderSubLine
	,TRIM(OrderType) AS SalesOrderType
	,TRIM(InvoiceNum) AS SalesInvoiceNum
	,TRIM(InvoiceLine) AS SalesInvoiceLine
	--,'' AS SalesInvoiceType
	,CASE WHEN InvoiceDate = '' THEN '1900-01-01' ELSE CONVERT(date, InvoiceDate) END AS SalesInvoiceDate
	,ActualDeliveryDate	AS ActualDelivDate
	,SellingShipQty	AS SalesInvoiceQty
	--,'' AS UoM
	,UnitPrice
	,UnitCost
	,IIF(UnitPrice*SellingShipQty = 0, 0, DiscountAmount/UnitPrice*SellingShipQty) AS DiscountPercent
	,DiscountAmount
	--,0 AS CashDiscountOffered
	--,0 AS CashDiscountUsed
	,TotalMiscChrg
	--,NULL AS VATAmount
	,Currency
	,ExchangeRate
	,CreditMemo
	,TRIM(WarehouseCode) AS WarehouseCode
	--,NULL AS DeliveryAddress
	,IndexKey
	,CASE WHEN TRIM(CustNum) = 'CFIN' THEN 'Cash Customer' 
		WHEN TRIM(CustNum) = 'CEX' THEN 'Cash Customer Export'
		WHEN TRIM(CustNum) = 'CEU' THEN 'Cash Customer EU'
		ELSE 'Normal' END AS SalesChannel
	--,'' AS Department
	--,'' AS CostBearerNum
	--,'' AS CostUnitNum
	--,'' AS ReturnComment
	--,'' AS ReturnNum
	--,'' AS ProjectNum
	--,'' AS SIRes1
	--,'' AS SIRes2
	--,'' AS SIRes3

FROM stage.WID_FI_SOLine AS SO
where trim(CustNum) not in ('2379','1336','2067','2069','2361','2447','2967','2968','2969','INTR01','K0001','54311','54312','K51093')

--GROUP BY
--	PartitionKey, Company, SalesPerson, CustNum, PartNum, OrderNum, OrderLine, OrderType, InvoiceNum, InvoiceLine, InvoiceDate, SellingShipQty, UnitPrice, UnitCost, DiscountAmount, TotalMiscChrg, WarehouseCode, CreditMemo, ActualDeliveryDate,Indexkey, OrderRel,Currency,ExchangeRate
GO
