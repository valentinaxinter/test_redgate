IF OBJECT_ID('[stage].[vAXL_DC_SOLine]') IS NOT NULL
	DROP VIEW [stage].[vAXL_DC_SOLine];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [stage].[vAXL_DC_SOLine] AS

SELECT 
	CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT(Company, '#', TRIM(CustNum), '#', (OrderNum), '#', (OrderLine), '#', (InvoiceNum), '#', (PartNum), '#', UPPER(PartDesc)))) AS SalesInvoiceID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT(Company, '#', OrderNum, '#', OrderLine, '#', OrderSubLine))) AS SalesOrderID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT(Company, '#', TRIM(CustNum), '#', InvoiceNum))) AS SalesLedgerID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT(Company, '#', (OrderNum)))) AS SalesOrderNumID
    ,CONVERT([binary](32), HASHBYTES('SHA2_256', Company)) AS CompanyID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT(Company, '#', TRIM(CustNum)))) AS CustomerID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT(Company, '#', PartNum, '#', UPPER(PartDesc)))) AS PartID
	--,CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT(Company, '#', WarehouseCode))) AS WarehouseID 
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(Company, '#', TRIM([WarehouseCode]))))) AS WarehouseID  
	,CONCAT(Company, '#', OrderNum, '#', OrderLine, '#', OrderSubLine) AS SalesOrderCode
	,CONCAT(Company, '#', (InvoiceNum), '#', (InvoiceLine)) AS SalesInvoiceCode
	,CONVERT(int, replace(convert(date,InvoiceDate),'-','')) AS SalesInvoiceDateID
	,PartitionKey

	,Company
	,TRIM(SalesPerson) AS SalesPersonName
	,TRIM(CustNum) AS [CustomerNum]
	,(PartNum) AS PartNum
	,UPPER(PartDesc) AS PartDesc
	,'' AS [PartType]
	,(OrderNum) AS [SalesOrderNum]
	,CAST(OrderLine AS text) AS [SalesOrderLine]
	,OrderSubLine AS [SalesOrderSubLine]
	,OrderType AS [SalesOrderType]
	--,CASE WHEN OrderType = 'MD' THEN 1 
	--		WHEN OrderType = 'MT' THEN 2
	--		WHEN OrderType = 'MR' THEN 3
	--		WHEN OrderType = 'IV' THEN 4
	--		WHEN OrderType = 'Misc. Charges' THEN 5 --added after Ulf changes in the night /DZ
	--	ELSE OrderType END AS [SalesOrderType]
	,InvoiceNum AS [SalesInvoiceNum]
	,InvoiceLine AS [SalesInvoiceLine]
	,InvoiceType AS [SalesInvoiceType]
	,CASE WHEN InvoiceDate = '' THEN '1900-01-01' ELSE CONVERT(date, InvoiceDate) END AS [SalesInvoiceDate]
	,ActualDeliveryDate AS [ActualDelivDate]
	,SellingShipQty AS [SalesInvoiceQty]
	,Unit AS [UoM]
	,UnitPrice
	,UnitCost
	,DiscountAmount
	,IIF(UnitPrice*SellingShipQty = 0, 0, DiscountAmount/UnitPrice*SellingShipQty) AS DiscountPercent
	,CONVERT(decimal(18,4), CashDiscountOffered) AS [CashDiscOffered] 
	,CONVERT(decimal(18,4), CashDiscountUsed) AS [CashDiscUsed] 
	,TotalMiscChrg
	,VAT AS [VATAmount]
	,Currency
	,ExchangeRate
	,CreditMemo
	,[SalesChannel]
	,[BusinessChain] AS [Department]
	,WarehouseCode
	,NULL AS [CostBearerNum]
	,NULL AS [CostUnitNum]
	,NULL AS [ReturnComment]
	,NULL AS [ReturnNum]
	,NULL AS [ProjectNum]
	,'' AS [IndexKey]
	,Res1 AS SIRes1
	,Res2 AS SIRes2
	,Res3 AS SIRes3

FROM stage.AXL_dc_SOLine AS SO

GROUP BY
	PartitionKey, Company, SalesPerson, CustNum, PartNum, PartDesc, OrderNum, OrderLine, OrderSubLine,OrderType, InvoiceNum, InvoiceLine, InvoiceDate, SellingShipQty, UnitPrice, UnitCost, DiscountAmount, TotalMiscChrg, WarehouseCode, CreditMemo, ActualDeliveryDate, Currency, ExchangeRate, InvoiceType, Res1, Res2, Res3, Unit, VAT, SalesChannel, BusinessChain, CashDiscountOffered, CashDiscountUsed
GO
