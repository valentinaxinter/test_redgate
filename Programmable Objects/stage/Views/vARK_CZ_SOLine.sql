IF OBJECT_ID('[stage].[vARK_CZ_SOLine]') IS NOT NULL
	DROP VIEW [stage].[vARK_CZ_SOLine];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [stage].[vARK_CZ_SOLine] AS
--COMMENT EMPTY FIELDS // ADD UPPER()TRIM() INTO CustomerID 2022-12-16 VA
SELECT 
	CONVERT([binary](32),HASHBYTES('SHA2_256',CONCAT(SO.Company,'#',SO.CustNum,'#',SO.PartNum,'#',SO.OrderNum,'#',SO.InvoiceNum,'#',SO.InvoiceLine))) AS SalesInvoiceID
	,CONVERT([binary](32),HASHBYTES('SHA2_256',CONCAT(SO.Company,'#',SO.CustNum, '#', SO.InvoiceNum))) AS SalesLedgerID
    ,CONVERT([binary](32),HASHBYTES('SHA2_256',SO.Company)) AS CompanyID
	,CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM(SO.Company),'#',TRIM(SO.CustNum))))) AS CustomerID
	--,CONVERT([binary](32),HASHBYTES('SHA2_256',CONCAT(SO.Company,'#',TRIM(SO.CustNum)))) AS CustomerID
	,CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM(SO.Company),'#',TRIM(SO.PartNum))))) AS PartID
	,CONVERT([binary](32), HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM(SO.Company), '#', TRIM(SO.WarehouseCode))))) AS WarehouseID
	,CONVERT([binary](32),HASHBYTES('SHA2_256',CONCAT(SO.Company,'#',SO.OrderNum,'#',SO.OrderSubLine))) AS SalesOrderID --OrderRelNum Not OrderSubLine --,'#',SO.InvoiceNum --Redundent?
	,CONVERT([binary](32),HASHBYTES('SHA2_256',CONCAT(SO.Company,'#',TRIM(SO.OrderNum)))) AS SalesOrderNumID --Redundent?
	,CONCAT(SO.Company,'#', SO.OrderNum,'#', SO.OrderLine) AS SalesOrderCode -- should match dw.SalesOrder.SalesOrderCode
	,CONCAT(SO.Company,'#',SO.InvoiceNum,'#',SO.InvoiceLine) AS SalesInvoiceCode --IndexKey  --Redundent?
	,CONVERT(int, replace(convert(date,SO.InvoiceDate),'-','')) AS SalesInvoiceDateID  --Redundent?
	,CONVERT([binary](32), HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM(Company),'#',''))))	AS ProjectID
	,SO.PartitionKey

	,SO.Company
	,[dbo].[ProperCase](SO.SalesPerson) AS SalesPersonName
	,TRIM(SO.CustNum) AS CustomerNum
	,CASE WHEN TRIM(SO.PartNum) = '-NULL-' AND TRIM(SO.OrderNum) IS NULL THEN 'TextLine' ELSE TRIM(SO.PartNum) END AS PartNum -- ref TEAMS chat AxInter BI - Onboaring Arkov (Validation feedback & Way forward) fr Jiri 20210310
	,Res1 AS [PartType]
	,TRIM(SO.OrderNum) AS SalesOrderNum
	,SO.OrderLine AS [SalesOrderLine]
	,SO.OrderSubLine AS [SalesOrderSubLine]
	,CASE WHEN SO.OrderType = 'webshop' THEN 1 ELSE 0 END AS SalesOrderType
	,SO.InvoiceNum AS [SalesInvoiceNum]
	,SO.InvoiceLine AS [SalesInvoiceLine]
	,InvoiceType AS [SalesInvoiceType]
	,CONVERT(date, SO.InvoiceDate) AS SalesInvoiceDate
	,ActualDeliveryDate AS [ActualDelivDate]
	,SO.SellingShipQty AS [SalesInvoiceQty]
	--,'' AS [UoM]
	,SO.UnitPrice
	,SO.UnitCost
	,CASE WHEN (SO.UnitPrice * SO.SellingShipQty) = 0 THEN 0 ELSE SO.DiscountAmount / (SO.UnitPrice * SO.SellingShipQty) END AS [DiscountPercent]
	,SO.DiscountAmount
	--,0 AS CashDiscountOffered
	--,0 AS CashDiscountUsed
	,SO.TotalMiscChrg
	,0 AS [VATAmount]
	,Currency
	,ExchangeRate
	,SO.WarehouseCode
	,SO.CreditMemo
	,CASE WHEN SalesChannel = 'POS' OR SalesChannel = 'WMS' THEN 'Over-the-counter'
		WHEN SalesChannel = 'WEBSHOP' OR SalesChannel = 'www.arkov.cz' THEN 'www.arkov.cz'
		WHEN SalesChannel = 'WEBSHOP' OR SalesChannel = 'www.arkov.sk' THEN 'www.arkov.sk'
		WHEN SalesChannel = 'EDI' THEN 'EDI'
		ELSE 'Normal Order Handling' END AS SalesChannel
	,SO.BusinessChain AS [Department]
	--,NULL AS DeliveryAddress
	--,'' AS [CostBearerNum]
	--,'' AS [CostUnitNum]
	--,'' AS [ReturnComment]
	--,'' AS [ReturnNum]
	--,'' AS [ProjectNum]
--	,SO.Indexkey -- ta inte in så längre
	--,'' AS [IndexKey]
	--,'' AS SIRes1
	--,'' AS SIRes2
	--,'' AS SIRes3

FROM 
	stage.ARK_CZ_SOLine AS SO
--WHERE [InvoiceDate] >= DATEADD(year, -1, GETDATE()) --Added this where clause as semi-incremental load functinoality since it doesn't work easily on meta-param table. /SM 2021-10-01	
--GROUP BY
--	SO.PartitionKey, SO.Company, SO.SalesPerson, SO.CustNum, SO.PartNum, SO.OrderNum, SO.OrderLine, SO.OrderSubLine, SO.OrderType, SO.InvoiceNum, SO.InvoiceLine, SO.InvoiceType, SO.InvoiceDate, SO.ActualDeliveryDate, SO.SellingShipQty, SO.UnitPrice, SO.UnitCost, SO.DiscountAmount, SO.TotalMiscChrg, SO.WarehouseCode, SO.[Site], SO.CreditMemo, SO.ExchangeRate, SO.Currency, SO.SalesChannel, SO.BusinessChain, Res1
GO
