IF OBJECT_ID('[stage].[vGPI_FR_SOLine]') IS NOT NULL
	DROP VIEW [stage].[vGPI_FR_SOLine];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [stage].[vGPI_FR_SOLine] AS
--COMMENT EMPTY FIELDS // ADD UPPER() TRIM() INTO CustomerID,PartID 22-12-28 VA
SELECT 
	CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT(Company, '#', TRIM(OrderNum), '#', TRIM(OrderLine), '#', TRIM(OrderSubLine), '#', TRIM(InvoiceNum), '#', TRIM(InvoiceLine)))) AS SalesInvoiceID --
	,CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT(Company, '#', TRIM(OrderNum), '#', OrderLine))) AS SalesOrderID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT(Company, '#', TRIM(CustomerNum), '#', TRIM(InvoiceNum)))) AS SalesLedgerID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT(Company, '#', TRIM(OrderNum)))) AS SalesOrderNumID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', Company)) AS CompanyID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM(Company), '#', TRIM(CustomerNum))))) AS CustomerID
	--,CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT(Company, '#', TRIM(CustomerNum)))) AS CustomerID
	,CONVERT([binary](32), HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM(Company), '#', TRIM(PartNum))))) AS PartID
	--,CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT(Company, '#', TRIM(PartNum)))) AS PartID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM([Company]), '#', TRIM([WarehouseCode]))))) AS WarehouseID
	,CONCAT(Company, '#', TRIM(OrderNum), '#', TRIM(OrderLine), '#', TRIM(InvoiceNum)) AS SalesOrderCode
	--CONCAT(Company, '#', TRIM(OrderNum), '#', TRIM(OrderLine), '#', TRIM(OrderSubLine), '#', TRIM(InvoiceNum)) AS SalesOrderCode --OLine
	,CONCAT(Company, '#', TRIM(InvoiceNum), '#', TRIM(InvoiceLine)) AS SalesInvoiceCode  --redundent?
	,CONVERT(int, replace(convert(date, InvoiceDate), '-', '')) AS SalesInvoiceDateID  --redundent?
	,CONVERT([binary](32), HASHBYTES('SHA2_256',CONCAT( Company,'#','') ))	AS ProjectID
	,PartitionKey

	,Company
	,SalesPersonName
	,TRIM(CustomerNum) AS [CustomerNum]
	,TRIM(PartNum) AS [PartNum]
	,CASE WHEN TRIM(OrderNum) = '0' THEN 'Main' ELSE 'Sub' END  AS PartType
	,TRIM(OrderNum) AS [SalesOrderNum]
	,TRIM(OrderLine) AS [SalesOrderLine]
	,TRIM([OrderSubLine]) AS [SalesOrderSubLine]
	,OrderType AS [SalesOrderType]
	,TRIM(InvoiceNum) AS [SalesInvoiceNum]
	,TRIM(InvoiceLine) AS [SalesInvoiceLine]
	--,'' AS [SalesInvoiceType]
	,CONVERT(date, InvoiceDate) AS [SalesInvoiceDate]
	,ActualDeliveryDate AS [ActualDelivDate]
	,SellingShipQty AS [SalesInvoiceQty]
	--,'' AS [UoM]
	,UnitPrice
	,UnitCost
	--,0 AS DiscountAmount
	,IIF((UnitPrice*SellingShipQty) <> 0, DiscountAmount/(UnitPrice*SellingShipQty), 0) AS [DiscountPercent]
	--,0 AS CashDiscountOffered
	--,0 AS CashDiscountUsed
	--,0 AS TotalMiscChrg
	--,0 AS [VATAmount]
	,'EUR' AS Currency
	,CONVERT(decimal (18,4), 1) AS ExchangeRate
	,CreditMemo
	--,'' AS [SalesChannel]
	--,'' AS [Department]
	,TRIM([WarehouseCode]) AS WarehouseCode
	--,NULL AS DeliveryAddress
	--,'' AS [CostBearerNum]
	--,'' AS [CostUnitNum]
	--,'' AS [ReturnComment]
	--,'' AS [ReturnNum]
	--,'' AS [ProjectNum]
	,[IndexKey]
	--,'' AS SIRes1
	--,'' AS SIRes2
	--,'' AS SIRes3

FROM stage.GPI_FR_SOLine

GROUP BY
	PartitionKey,Company,SalesPersonName,CustomerNum,PartNum,OrderNum,OrderLine,OrderSubLine,OrderType,InvoiceNum,InvoiceLine, InvoiceDate,SellingShipQty,UnitPrice,UnitCost,DiscountAmount,TotalMiscChrg,WarehouseCode,CreditMemo, [IndexKey], ActualDeliveryDate--,OrderSubLine --,OrderRel, 
GO
