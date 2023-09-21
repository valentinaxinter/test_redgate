IF OBJECT_ID('[stage].[vSUM_UK_SOLine]') IS NOT NULL
	DROP VIEW [stage].[vSUM_UK_SOLine];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [stage].[vSUM_UK_SOLine] AS
SELECT
	 CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM(dbo.summers()), '#', TRIM(CustNum), '#',TRIM(OrderNum), '#',TRIM(OrderLine), '#',TRIM(PartNum), '#',TRIM(InvoiceNum), '#',TRIM(InvoiceLine))))) AS SalesInvoiceID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM(dbo.summers()), '#', TRIM(OrderNum), '#',TRIM(OrderLine), '#', TRIM(InvoiceNum))))) AS SalesOrderID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM(dbo.summers()), '#', TRIM(CustNum), '#', TRIM(InvoiceNum))))) AS SalesLedgerID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM(dbo.summers()), '#', TRIM(OrderNum))))) AS SalesOrderNumID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(TRIM(dbo.summers())))) AS CompanyID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM(dbo.summers()), '#', TRIM(CustNum))))) AS CustomerID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM(dbo.summers()) ,'#', TRIM(PartNum))))) AS PartID  
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM(dbo.summers()), '#', TRIM(WarehouseCode))))) AS WareHouseID
	,CONCAT(UPPER(TRIM(dbo.summers())), '#', UPPER(TRIM(CustNum)), '#', UPPER(TRIM(OrderNum)), '#', UPPER(TRIM(InvoiceLine))) AS SalesOrderCode 
	,CONVERT(int, replace(convert(date,InvoiceDate), '-', '')) AS SalesInvoiceDateID  --Redundant??
	,CONCAT(UPPER(TRIM(dbo.summers())), '#', UPPER(TRIM(InvoiceNum)), '#', UPPER(TRIM(InvoiceType))) AS SalesInvoiceCode --Redundant??
	,CONVERT([binary](32), HASHBYTES('SHA2_256',CONCAT(UPPER(TRIM(dbo.summers())),'#','') ))	AS ProjectID
	,PartitionKey

	,UPPER(TRIM(dbo.summers())) AS Company
	,[dbo].[ProperCase](SalesPerson) AS SalesPersonName
	,UPPER(TRIM(CustNum)) AS CustomerNum
	,UPPER(TRIM(PartNum)) AS PartNum
	,CASE WHEN TRIM(OrderNum) = '0' THEN 'PrimaryPart' ELSE 'SubPart' END  AS PartType
	,UPPER(TRIM(OrderNum)) AS SalesOrderNum
	--,UPPER(TRIM(OrderLine)) AS SalesOrderLine
	,OrderType AS SalesOrderType
	,TRIM(InvoiceNum) AS SalesInvoiceNum
	,TRIM(InvoiceLine) AS SalesInvoiceLine
	,InvoiceType AS SalesInvoiceType
	,CASE WHEN InvoiceDate = '' THEN '1901-01-01' ELSE CONVERT(date, InvoiceDate) END AS SalesInvoiceDate
	,ActualDeliveryDate	AS ActualDelivDate
	,SellingShipQty	AS SalesInvoiceQty
	,UnitPrice
	,UnitCost
	,IIF(SellingShipQty*UnitPrice = 0, 0, DiscountAmount/SellingShipQty*UnitPrice) AS DiscountPercent
	,DiscountAmount
	,TotalMiscChrg
	,LEFT(Currency, 3) AS Currency
	,IIF(LEFT(Currency, 3) = 'GBP', 1, ExchangeRate) AS ExchangeRate
	--,CreditMemo
	,IIF(OrderType = '4', 1, 0) AS  CreditMemo
	,CASE	WHEN LEN(SalesChannel) = 8 THEN 'EXPRESS'	
			WHEN LEN(SalesChannel) = 12 THEN 'ADVANCE'
			WHEN CustNum LIKE 'RSCOMP%' THEN 'EDI'
			WHEN SalesPerson = '' THEN 'IMPORTED'
			ELSE SalesChannel END AS SalesChannel
	,CASE WHEN NULLIF(TRIM(SalesPerson),'') IS NULL THEN 'Digital'
			ELSE 'Manual' END	AS Department
	,TRIM(WarehouseCode) AS WarehouseCode
	--,Res1	AS SIRes1
	--,Res2	AS SIRes2
	--,Res3	AS SIRes3
FROM [stage].[SUM_UK_SOLine] 
;
GO
