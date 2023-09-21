IF OBJECT_ID('[stage].[vBELL_SI_SOLine]') IS NOT NULL
	DROP VIEW [stage].[vBELL_SI_SOLine];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [stage].[vBELL_SI_SOLine] AS
--COMMENT EMPTY FIELDS // ADD UPPER() INTO PartID,CustomerID,WarehouseID 2022-12-27
WITH CTE AS (
-- The company has requested that they do not want the invoices that have these characteristics -AV / -SAV
--ticket INC-96774 VA 2023-03-16
SELECT [PartitionKey], [Company], [InvoiceDate], [ActualDeliveryDate], [SalesPersonName], [CustNum], [OrderNum], [OrderLine], [OrderSubLine], [OrderRel], [InvoiceNum], [InvoiceLine], [CreditMemo], [PartNum], [SellingShipQty], [UnitPrice], [UnitCost], [DiscountAmount], [TotalMiscChrg], [Currency], [ExchangeRate], [VAT], [WarehouseCode], [Indexkey], [Site], [LineType] FROM stage.BELL_SI_SOLine where InvoiceNum not like '%-AV%' and InvoiceNum not like '%-SAV%'
)
SELECT 
	CONVERT([binary](32),HASHBYTES('SHA2_256',CONCAT(Company,'#',TRIM(CustNum), '#', TRIM(OrderNum), '#', IIF(LEFT(TRIM([PartNum]), 1) = 'I', SUBSTRING(TRIM([PartNum]), 2, 50), TRIM([PartNum])), '#', TRIM(InvoiceNum), '#', TRIM(InvoiceLine)))) AS SalesInvoiceID --, '#', TRIM(OrderLine)
	,CONVERT([binary](32),HASHBYTES('SHA2_256',CONCAT(Company,'#',OrderNum,'#',InvoiceNum))) AS SalesOrderID
	,CONVERT([binary](32),HASHBYTES('SHA2_256',CONCAT(Company,'#',CustNum, '#', InvoiceNum))) AS SalesLedgerID 
	,CONVERT([binary](32),HASHBYTES('SHA2_256',CONCAT(Company,'#',TRIM(OrderNum)))) AS SalesOrderNumID
	,CONVERT([binary](32),HASHBYTES('SHA2_256',Company)) AS CompanyID
	,CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM(Company),'#',TRIM(CustNum))))) AS CustomerID
	--,CONVERT([binary](32),HASHBYTES('SHA2_256',CONCAT(Company,'#',TRIM(CustNum)))) AS CustomerID
	,CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM(Company),'#',IIF(LEFT(TRIM([PartNum]), 1) = 'I', SUBSTRING(TRIM([PartNum]), 2, 50), TRIM([PartNum])))))) AS PartID 
	--,CONVERT([binary](32),HASHBYTES('SHA2_256',CONCAT(Company,'#',IIF(LEFT(TRIM([PartNum]), 1) = 'I', SUBSTRING(TRIM([PartNum]), 2, 50), TRIM([PartNum]))))) AS PartID 
	,CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM(Company),'#', TRIM(WarehouseCode))))) AS WarehouseID
	--,CONVERT([binary](32),HASHBYTES('SHA2_256',CONCAT(Company,'#', WarehouseCode))) AS WarehouseID
	,CONCAT(Company,'#', OrderNum,'#', IIF(LEFT(TRIM([PartNum]), 1) = 'I', SUBSTRING(TRIM([PartNum]), 2, 50), TRIM([PartNum]))) AS SalesOrderCode -- should be identical as in Order table
	,CONVERT(int, replace(convert(date,InvoiceDate),'-','')) AS SalesInvoiceDateID --Redundant?
	,CONCAT(Company,'#',TRIM(InvoiceNum),'#',TRIM(InvoiceLine)) AS SalesInvoiceCode --Redundant?
	,CONVERT([binary](32), HASHBYTES('SHA2_256',CONCAT( Company,'#','') ))	AS ProjectID

	,PartitionKey
	,Company
	,SalesPersonName
	,CustNum	AS CustomerNum
	,IIF(LEFT(TRIM([PartNum]), 1) = 'I', SUBSTRING(TRIM([PartNum]), 2, 50), TRIM([PartNum])) AS PartNum
	,CASE WHEN TRIM(OrderNum) = '0' THEN 'PrimaryPart' ELSE 'SubPart' END  AS PartType
	,OrderNum	AS SalesOrderNum
	,LineType AS SalesOrderLine
	,OrderSubLine	AS SalesOrderSubLine
	--,'' AS SalesOrderType
	,InvoiceNum		AS SalesInvoiceNum
	,InvoiceLine	AS SalesInvoiceLine
	--,'' AS SalesInvoiceType
	,convert(date, InvoiceDate) as SalesInvoiceDate
	,ActualDeliveryDate	AS ActualDelivDate
	,SellingShipQty		AS SalesInvoiceQty
	--,'' AS UoM
	,UnitPrice	
	,UnitCost
	--,0 AS DiscountPercent
	,DiscountAmount
	--,0 AS CashDiscountOffered
	--,0 AS CashDiscountUsed
	,TotalMiscChrg
	,VAT AS VATAmount
	,Currency
	,ExchangeRate
	,CreditMemo
	--,'' AS SalesChannel
	--,'' AS Department
	,WarehouseCode
	--,NULL AS DeliveryAddress
	--,'' AS CostBearerNum
	--,'' AS CostUnitNum
	--,'' AS ReturnComment
	--,'' AS ReturnNum
	--,'' AS ProjectNum
	,Indexkey
	--,'' AS SIRes1
	--,'' AS SIRes2
	,VAT AS SIRes3
FROM 
	CTE
GO
