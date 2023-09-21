IF OBJECT_ID('[stage].[vTMT_FI_SOLine]') IS NOT NULL
	DROP VIEW [stage].[vTMT_FI_SOLine];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [stage].[vTMT_FI_SOLine] AS
--COMMENT EMPTY FIELD // ADD TRIM() INTO CustomerID,PartID 23-01-09 VA
SELECT 
	CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(Company, '#', TRIM(CustNum), '#', TRIM(OrderNum), '#', TRIM(PartNum), '#', TRIM(InvoiceNum), '#', TRIM(InvoiceLine))))) AS SalesInvoiceID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(Company, '#', OrderNum, '#', OrderLine, '#', InvoiceNum)))) AS SalesOrderID --redundent?
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(Company, '#', CustNum, '#', InvoiceNum)))) AS SalesLedgerID -- Same as in Invoice view
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(Company, '#', TRIM(OrderNum))))) AS SalesOrderNumID --redundent?
    ,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(Company))) AS CompanyID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM(Company), '#', TRIM(CustNum))))) AS CustomerID
	--,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(Company, '#', TRIM(CustNum))))) AS CustomerID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM([Company]),'#',TRIM([PartNum]))))) AS PartID
	--,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT([Company],'#',TRIM([PartNum]))))) AS PartID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM([Company]), '#', TRIM([WarehouseCode]))))) AS WarehouseID
	,UPPER(CONCAT(Company, '#', TRIM(OrderNum), '#', TRIM(OrderLine), '#', TRIM(OrderSubLine), '#', TRIM(InvoiceNum))) AS SalesOrderCode
	,CONCAT(Company, '#', TRIM(InvoiceNum), '#', TRIM(InvoiceLine)) AS SalesInvoiceCode --redundent?
	,CONVERT(int, replace(convert(date,InvoiceDate),'-','')) AS SalesInvoiceDateID  --redundent?
	,CONVERT([binary](32), HASHBYTES('SHA2_256',CONCAT( Company,'#','') ))	AS ProjectID
	,PartitionKey

	,UPPER(Company) AS Company
	,TRIM(OrderHandler) AS SalesPersonName
	,UPPER(TRIM(CustNum)) AS CustomerNum
	,UPPER(TRIM(PartNum)) AS PartNum
	,CASE WHEN TRIM(OrderNum) = '0' THEN 'PrimaryPart' ELSE 'SubPart' END  AS PartType
	,TRIM(OrderNum) AS SalesOrderNum
	,TRIM(OrderLine) AS SalesOrderLine
	,TRIM(OrderSubLine) AS SalesOrderSubLine
	,CASE WHEN OrderType = '1' THEN 'Eur Tilaus'
		WHEN OrderType = '2' THEN 'Hyvitys'
		WHEN OrderType = '3' THEN 'Käteismyynti'
		WHEN OrderType = '4' THEN 'Käthyvitys'
		WHEN OrderType = '5' THEN 'Toim.hyvitys'
		WHEN OrderType = '6' THEN 'Toimitus'
		WHEN OrderType = '7' THEN 'Ulk EURHyvit'
		WHEN OrderType = '8' THEN 'Ulk.Eur Til'
		WHEN OrderType = '9' THEN 'Ulk.Toim.hyv'
		ELSE COALESCE(CAST(OrderType AS NVARCHAR), '0')
		END AS SalesOrderType 
	,TRIM(InvoiceNum) AS [SalesInvoiceNum]
	,TRIM(InvoiceLine) AS [SalesInvoiceLine]
	--,'' AS SalesInvoiceType
	,CASE WHEN InvoiceDate = '' THEN '1901-01-01' ELSE CONVERT(date, InvoiceDate) END AS SalesInvoiceDate
	,ActualDeliveryDate AS [ActualDelivDate]
	,SellingShipQty AS [SalesInvoiceQty]
	--,'' AS [UoM]
	,UnitPrice
	,UnitCost
	,DiscountAmount
	,IIF(UnitPrice*SellingShipQty <> 0, DiscountAmount/UnitPrice*SellingShipQty, 0) AS [DiscountPercent]
	--,0 AS CashDiscountOffered
	--,0 AS CashDiscountUsed
	--,0 AS TotalMiscChrg -- There is data in the stage table for TotalMiscChrg. However, it shouldn't be used to calculate the invoice amount as there "can be eg. transport costs, additional labour costs, custom clearance cost and additional material costs from completely another company." according to Petri Seppänen - SB 2022-11-17
	--,0 AS [VATAmount]
	,TRIM(WarehouseCode) AS WarehouseCode
	--,NULL AS DeliveryAddress
	,Currency
	,ExchangeRate
	,CreditMemo
	--,'' AS [SalesChannel]
	--,'' AS [Department]
	--,'' AS [CostBearerNum]
	--,'' AS [CostUnitNum]
	--,'' AS [ReturnComment]
	--,'' AS [ReturnNum]
	--,'' AS [ProjectNum]
	,MAX(Indexkey) AS Indexkey
	,SalesPersonNumber_real AS SIRes1
	,SalesPersonName_real AS SIRes2
	--,'' AS SIRes3
FROM stage.TMT_FI_SOLine AS SO

GROUP BY
	PartitionKey, Company, OrderHandler, CustNum, PartNum, OrderNum, OrderLine, OrderSubLine, OrderType, InvoiceNum, InvoiceLine, InvoiceDate, ActualDeliveryDate, SellingShipQty, UnitPrice, UnitCost, DiscountAmount, TotalMiscChrg, WarehouseCode, Currency, ExchangeRate, CreditMemo, SalesPersonNumber_real, SalesPersonName_real

--	,[Site]
--	,OrderRel AS OrderRelNum
	--,CASE WHEN OrderType Like 'Eur Tilaus' THEN CONVERT(INT, 1)
	--	WHEN OrderType='Hyvitys' THEN CONVERT(INT, 2)
	--	WHEN OrderType='Käteismyynti' THEN CONVERT(INT, 3)
	--	WHEN OrderType='Käthyvitys' THEN CONVERT(INT, 4)
	--	WHEN OrderType='Toim.hyvitys' THEN CONVERT(INT, 5)
	--	WHEN OrderType='Toimitus' THEN CONVERT(INT, 6)
	--	WHEN OrderType='Ulk EURHyvit' THEN CONVERT(INT, 7)
	--	WHEN OrderType='Ulk.Eur Til' THEN CONVERT(INT, 8)
	--	WHEN OrderType='Ulk.Toim.hyv' THEN CONVERT(INT, 9)
	--	ELSE CONVERT(INT, 0) END AS OrderType
GO
