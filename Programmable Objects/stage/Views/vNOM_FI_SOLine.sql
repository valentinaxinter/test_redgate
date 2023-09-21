IF OBJECT_ID('[stage].[vNOM_FI_SOLine]') IS NOT NULL
	DROP VIEW [stage].[vNOM_FI_SOLine];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO








CREATE VIEW [stage].[vNOM_FI_SOLine] AS
-- NomoFI data occasionally has duplicate rows due to "illegal price posts", meaning a part will get two prices for the same day/duration creating duplicate rows.
-- Not including UnitPrice in PK will result in merge error and no daily data is loaded.
-- Including UnitPrice in PK will result in about the double Order Amount for affected orders
-- This method wi
WITH CTE AS (
SELECT 
	--CONVERT([binary](32),HASHBYTES('SHA2_256',CONCAT(Company,'#',TRIM(InvoiceNum),'#',TRIM(InvoiceLine)))) AS SalesOrderID
	CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM(Company),'#',TRIM(CustNum), '#', TRIM(OrderNum), '#', TRIM(PartNum), '#', TRIM(InvoiceNum), '#', TRIM(InvoiceLine))))) AS SalesInvoiceID
	,CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM(Company),'#',TRIM(OrderNum),'#',TRIM(OrderLine),'#',TRIM(InvoiceNum))))) AS SalesOrderID
	,CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM(Company),'#',TRIM(CustNum), '#', TRIM(InvoiceNum))))) AS SalesLedgerID
	,CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM(Company),'#',TRIM(OrderNum))))) AS SalesOrderNumID  
	,CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(TRIM(Company)))) AS CompanyID
	,CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM(Company),'#',TRIM(CustNum))))) AS CustomerID
	,CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM(Company),'#',TRIM(PartNum))))) AS PartID 
	,CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM([Company]),'#',TRIM([WarehouseCode]))))) AS WarehouseID
	,UPPER(CONCAT(TRIM(Company),'#',TRIM(OrderNum),'#',TRIM(OrderLine))) AS SalesOrderCode 
	,CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM(Company),'#',TRIM(InvoiceNum))))) AS SalesInvoiceNumID --Redundant?
	,CONVERT(int, replace(convert(date,InvoiceDate),'-','')) AS SalesInvoiceDateID										--Redundant?
	,UPPER(CONCAT(TRIM(Company),'#',TRIM(InvoiceNum),'#',TRIM(InvoiceLine))) AS SalesInvoiceCode						--Redundant?
	,CONVERT([binary](32), HASHBYTES('SHA2_256',CONCAT( Company,'#','') ))	AS ProjectID
	,PartitionKey

	,UPPER(TRIM(Company)) AS Company
	,SalesPerson AS SalesPersonName
	,UPPER(TRIM(CustNum)) AS CustomerNum
	,UPPER(TRIM(PartNum)) AS PartNum
	,CASE WHEN TRIM(OrderNum) = '0' THEN 'PrimaryPart' ELSE 'SubPart' END  AS PartType
	,UPPER(TRIM(OrderNum)) AS SalesOrderNum
	,UPPER(TRIM(OrderLine)) AS SalesOrderLine
	,UPPER(TRIM(OrderSubLine)) AS SalesOrderSubLine-- '0' as OrderSubLine
	,OrderType AS SalesOrderType
	,InvoiceNum AS SalesInvoiceNum
	,UPPER(TRIM(InvoiceLine)) AS SalesInvoiceLine
	,'' AS SalesInvoiceType
	,CONVERT(date, InvoiceDate) AS SalesInvoiceDate
	,CONVERT(date, ActualDeliveryDate) AS ActualDelivDate
	,CASE WHEN CreditMemo = '1' THEN -1*ABS(SellingShipQty)
--		WHEN UnitCost = 0 THEN 0 
		ELSE SellingShipQty END AS SalesInvoiceQty
	,ABS(UnitPrice) AS UnitPrice 
	,ABS(UnitCost) AS UnitCost 
	,'' AS UoM
	,0 AS DiscountPercent
	,DiscountAmount --CASE WHEN UnitPrice < 0 THEN ABS(DiscountAmount) ELSE -1*ABS(DiscountAmount) END AS 
	,0 AS CashDiscountOffered
	,0 AS CashDiscountUsed
	,TotalMiscChrg
	,0 AS VATAmount
	,Currency
	,ExchangeRate
	,CreditMemo
	,SalesChannel
	,UpdateStock AS IsUpdatingStock
	,'' AS Department
	,UPPER(TRIM(WarehouseCode)) AS WarehouseCode
	,NULL AS DeliveryAddress
	,'' AS CostBearerNum
	,'' AS CostUnitNum
	,'' AS ReturnComment
	,'' AS ReturnNum
	,TRIM(PartClass) AS ProjectNum
	,MAX(Indexkey) AS IndexKey
	,'' AS SIRes1
	,'' AS SIRes2
	,'' AS SIRes3
	,ROW_NUMBER() OVER (PARTITION BY Company,CustNum,OrderNum,PartNum,InvoiceNum,InvoiceLine ORDER BY UnitPrice) AS RowNum
FROM 
	stage.NOM_FI_SOLine AS SO
GROUP BY
	PartitionKey, Company, CustNum, OrderNum, OrderLine, OrderSubLine, OrderType, InvoiceNum, InvoiceLine, InvoiceDate, SellingShipQty, UnitPrice, UnitCost, Currency, ExchangeRate, TotalMiscChrg, DiscountAmount,PartNum, SalesPerson,  WarehouseCode, CreditMemo, SalesChannel, UpdateStock, PartClass, ActualDeliveryDate
)

SELECT [SalesInvoiceID], [SalesOrderID], [SalesLedgerID], [SalesOrderNumID], [CompanyID], [CustomerID], [PartID], [WarehouseID], [SalesOrderCode], [SalesInvoiceNumID], [SalesInvoiceDateID], [SalesInvoiceCode], [ProjectID], [PartitionKey], [Company], [SalesPersonName], [CustomerNum], [PartNum], [PartType], [SalesOrderNum], [SalesOrderLine], [SalesOrderSubLine], [SalesOrderType], [SalesInvoiceNum], [SalesInvoiceLine], [SalesInvoiceType], [SalesInvoiceDate], [ActualDelivDate], [SalesInvoiceQty], [UnitPrice], [UnitCost], [UoM], [DiscountPercent], [DiscountAmount], [CashDiscountOffered], [CashDiscountUsed], [TotalMiscChrg], [VATAmount], [Currency], [ExchangeRate], [CreditMemo], [SalesChannel], [IsUpdatingStock], [Department], [WarehouseCode], [DeliveryAddress], [CostBearerNum], [CostUnitNum], [ReturnComment], [ReturnNum], [ProjectNum], [IndexKey], [SIRes1], [SIRes2], [SIRes3], [RowNum]
FROM CTE
WHERE RowNum = 1
GO
