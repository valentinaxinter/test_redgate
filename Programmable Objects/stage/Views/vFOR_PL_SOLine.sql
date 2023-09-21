IF OBJECT_ID('[stage].[vFOR_PL_SOLine]') IS NOT NULL
	DROP VIEW [stage].[vFOR_PL_SOLine];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [stage].[vFOR_PL_SOLine] AS
--COMMENT EMPTY FIELDS // ADD TRIM() UPPER() INTO CustomerID,WarehouseID 23-01-11 VA
SELECT 
	CONVERT([binary](32),HASHBYTES('SHA2_256',CONCAT(Company,'#',SalesInvoiceNum,'#',SalesInvoiceLine,'#',[SalesInvoiceType]))) AS SalesInvoiceID
	,CONVERT([binary](32),HASHBYTES('SHA2_256',CONCAT(Company,'#',SalesOrderNumber,'#',[SalesOrderLine]))) AS SalesOrderID
	,CONVERT([binary](32),HASHBYTES('SHA2_256',CONCAT(Company,'#', TRIM(SalesInvoiceNum),'#', TRIM(CAST(ObjType AS VARCHAR(10)))))) AS SalesLedgerID
	,CONVERT([binary](32),HASHBYTES('SHA2_256',CONCAT(Company,'#',SalesOrderNumber))) AS SalesOrderNumID  
	,CONVERT([binary](32),HASHBYTES('SHA2_256',Company)) AS CompanyID
	,CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM(Company),'#',TRIM([CustomerCode]))))) AS CustomerID
	--,CONVERT([binary](32),HASHBYTES('SHA2_256',CONCAT(Company,'#',TRIM([CustomerCode])))) AS CustomerID  
	,CONVERT([binary](32), HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM([Company]) ,'#', TRIM(PartNum))))) AS PartID 
	--,CONVERT([binary](32),HASHBYTES('SHA2_256',CONCAT(Company,'#',TRIM(PartNum)))) AS PartID 
	,CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM([Company]),'#',TRIM(Warehouse))))) AS WarehouseID
	--,CONVERT([binary](32),HASHBYTES('SHA2_256',CONCAT([Company],'#',TRIM([Warehouse])))) AS WarehouseID
	,CONCAT(Company,'#',SalesOrderNumber,'#',[SalesOrderLine]) as SalesOrderCode
	,CONVERT([binary](32),HASHBYTES('SHA2_256',CONCAT(Company,'#',TRIM(SalesInvoiceNum)))) AS SalesInvoiceNumID -- Redundant
	,CONVERT(int, REPLACE(CONVERT(date,SalesInvoiceDate),'-','')) AS SalesInvoiceDateID  --Redundant?
	,CONCAT(Company,'#',TRIM(SalesInvoiceNum),'#',TRIM(SalesInvoiceLine)) AS SalesInvoiceCode --Redundant?
	,CONVERT([binary](32), HASHBYTES('SHA2_256',CONCAT( Company,'#','') ))	AS ProjectID

	,PartitionKey
	,UPPER(TRIM(Company)) AS Company
	,Seller AS SalesPersonName
	,TRIM([CustomerCode]) AS CustomerNum
	,TRIM(PartNum) AS PartNum 
	,PartType
	,SalesOrderNumber AS SalesOrderNum
	,[SalesOrderLine] AS SalesOrderLine
	--,NULL AS SalesOrderSubLine
	,[SalesOrderObjectType] AS SalesOrderType
	,SalesInvoiceNum
	,SalesInvoiceLine
	,SalesInvoiceType
	,SalesInvoiceDate
	,COALESCE(ActualDelivDate, '1900-01-01') AS ActualDelivDate
	,CASE	WHEN SalesInvoiceType IN ('14') THEN -1 * ABS(SalesInvoiceQty)
			ELSE SalesInvoiceQty END AS SalesInvoiceQty
	,UoM
	,UnitPrice
	,UnitCost/COALESCE(NULLIF(DocumentExchangeRate,0),1) AS UnitCost
	,DiscountPercent
	,CASE	WHEN SalesInvoiceType IN ('14') THEN -1 * ABS(DiscountAmount) -- Number 14 means a cancellation thats why is the negative
			ELSE DiscountAmount END AS DiscountAmount
	--,0 AS CashDiscountOffered
	--,0 AS CashDiscountUsed
	--,0 AS TotalMiscChrg 
	,VATAmount
	,[DocumentCurrency] AS Currency
	,[DocumentExchangeRate] AS ExchangeRate
	,IIF(SalesInvoiceType IN ('14','166'),'1','0')	AS CreditMemo
	--,NULL AS SalesChannel
	--,NULL Department
	,Warehouse AS WarehouseCode
	--,NULL AS DeliveryAddress
	--,NULL AS CostBearerNum
	--,NULL AS CostUnitNum
	--,NULL	AS ReturnComment
	--,NULL AS ReturnNum
	,[AccountCode] AS ProjectNum
	--,[AccountCode] AS IndexKey
	,[Is/ToVerify] AS SIRes1
	,[SalesInvoiceStatus] AS SIRes2
	,[VATCode] AS SIRes3
FROM stage.FOR_PL_SOLine
--GROUP BY PartitionKey, Company, SalesPerson, CustomerNum, SalesOrderNum, SalesOrderLine, OrderSubLine, OrderRel, OrderType, SalesInvoiceNum, SalesInvoiceLine, SalesInvoiceDate, SellingShipQty, UnitPrice, UnitCost, DiscountAmount, TotalMiscChrg, PartNum, WarehouseCode, CreditMemo, Indexkey, ActualDeliveryDate --, [Site]
GO
