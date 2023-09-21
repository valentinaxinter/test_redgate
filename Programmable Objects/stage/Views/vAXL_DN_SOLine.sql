IF OBJECT_ID('[stage].[vAXL_DN_SOLine]') IS NOT NULL
	DROP VIEW [stage].[vAXL_DN_SOLine];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [stage].[vAXL_DN_SOLine] AS

SELECT 
	CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(Company, '#', TRIM(InvoiceNum), '#', TRIM(InvoiceLine), '#', TRIM(CustNum), '#', TRIM(OrderNum), '#', TRIM(OrderLine), '#', TRIM(PartNum), '#', TRIM(PartDesc))))) AS SalesInvoiceID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(Company, '#', TRIM(CustNum), '#', TRIM(OrderNum), '#', TRIM(OrderLine), '#', TRIM(OrderSubLine), '#', TRIM(PartDesc))))) AS SalesOrderID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(Company, '#', TRIM(CustNum), '#', TRIM(InvoiceNum))))) AS SalesLedgerID
    ,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(Company))) AS CompanyID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(Company, '#', TRIM(CustNum))))) AS CustomerID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(Company, '#', TRIM(PartNum), '#', (IIF(TRIM([PartNum]) LIKE 'IACO%' , 'MISC. CHARGES', TRIM([PartDesc]))))))) AS PartID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(Company, '#', TRIM(OrderNum))))) AS SalesOrderNumID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(Company, '#', TRIM([WarehouseCode]))))) AS WarehouseID
	,CONVERT(int, IIF(InvoiceDate = '', 19900101, replace(convert(date, InvoiceDate), '-', ''))) AS SalesInvoiceDateID
	,UPPER(CONCAT(Company, '#', TRIM(InvoiceNum), '#', TRIM(InvoiceLine))) AS SalesInvoiceCode
	,UPPER(CONCAT(Company, '#', TRIM(OrderNum), '#', TRIM(OrderLine), '#', TRIM(OrderSubLine))) AS SalesOrderCode
	,PartitionKey

	,UPPER(Company) AS Company
	,TRIM(SalesPerson) AS SalesPersonName
	,TRIM(CustNum) AS [CustomerNum]
	,TRIM(PartNum) AS PartNum
	,UPPER(PartDesc) AS PartDesc
	,'' AS [PartType]
	,TRIM(OrderNum) AS [SalesOrderNum]
	,CAST(OrderLine AS text) AS [SalesOrderLine]
	,TRIM(OrderSubLine) AS [SalesOrderSubLine]
	,TRIM(OrderType) AS [SalesOrderType]
	,TRIM(InvoiceNum) AS [SalesInvoiceNum]
	,TRIM(InvoiceLine) AS [SalesInvoiceLine]
	,TRIM(InvoiceType) AS [SalesInvoiceType]
	,CASE WHEN InvoiceDate = '' THEN '1900-01-01' ELSE CONVERT(date, InvoiceDate) END AS [SalesInvoiceDate]
	,ActualDeliveryDate AS [ActualDelivDate]
	,SellingShipQty AS [SalesInvoiceQty]
	,TRIM(Unit) AS [UoM]
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
	,TRIM(CreditMemo) AS CreditMemo
	,TRIM([SalesChannel]) AS [SalesChannel]
	,TRIM([BusinessChain]) AS [Department]
	,TRIM(WarehouseCode) AS WarehouseCode
	,NULL AS [CostBearerNum]
	,NULL AS [CostUnitNum]
	,NULL AS [ReturnComment]
	,NULL AS [ReturnNum]
	,NULL AS [ProjectNum]
	,'' AS [IndexKey]
	,Res1 AS SIRes1
	,Res2 AS SIRes2
	,Res3 AS SIRes3
FROM stage.AXL_DN_SOLine


	--,CASE WHEN OrderType = 'MD' THEN 1 
	--		WHEN OrderType = 'MT' THEN 2
	--		WHEN OrderType = 'MR' THEN 3
	--		WHEN OrderType = 'IV' THEN 4
	--		WHEN OrderType = 'Misc. Charges' THEN 5 --added after Ulf changes in the night /DZ
	--	ELSE OrderType END AS [SalesOrderType]

--GROUP BY
--	PartitionKey, Company, SalesPerson, CustNum, PartNum, PartDesc, OrderNum, OrderLine, OrderSubLine,OrderType, InvoiceNum, InvoiceLine, InvoiceDate, SellingShipQty, UnitPrice, UnitCost, DiscountAmount, TotalMiscChrg, WarehouseCode, CreditMemo, ActualDeliveryDate, Currency, ExchangeRate, InvoiceType, Res1, Res2, Res3, Unit, VAT, SalesChannel, BusinessChain, CashDiscountOffered, CashDiscountUsed
GO
