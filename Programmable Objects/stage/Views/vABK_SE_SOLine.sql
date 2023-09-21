IF OBJECT_ID('[stage].[vABK_SE_SOLine]') IS NOT NULL
	DROP VIEW [stage].[vABK_SE_SOLine];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [stage].[vABK_SE_SOLine] AS
--WITH tmp AS (
--SELECT *, ROW_NUMBER() OVER (PARTITION BY JNo, TrNo ORDER BY DeliveryDate) AS RowNum --Temporary added to push through data despite there being many duplicates to be able to show all rows in Power BI. Will definitely be needing a full reload /SM 2021-12-17
--FROM stage.ABK_SE_SOLine
--)
--COMMENT EMPTY FIELDS 2022-12-21 VA
SELECT 
	--CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT(Company, '#', JNo, '#', TrNo, '#', RowNum))) AS SalesInvoiceID
	CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT(Company, '#', MAX(TRIM(SalesPerson)), '#', TRIM(CustNum), '#', TRIM(ProdNo), '#', TRIM(OrderNum), '#', TRIM(OrderLine), '#', TRIM(InvoiceNum), '#', CONCAT(JNo, '#', TrNo)))) AS SalesInvoiceID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT(Company, '#', OrderNum, '#', OrderLine, '#', InvoiceNum))) AS SalesOrderID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT(Company,'#', InvoiceNum))) AS SalesLedgerID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT(Company, '#', TRIM(OrderNum)))) AS SalesOrderNumID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', Company)) AS CompanyID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM(Company), '#', TRIM(CustNum))))) AS CustomerID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM(Company), '#', TRIM(ProdNo))))) AS PartID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM([Company]), '#', TRIM([WarehouseCode]))))) AS WarehouseID
	,CONCAT(Company, '#', OrderNum, '#', OrderLine) AS SalesOrderCode
	,CONCAT(Company, '#', TRIM(InvoiceNum), '#', TRIM(OrderLine)) AS SalesInvoiceCode --redundent?
	,CONVERT(int, replace(convert(date, InvoiceDate), '-', '')) AS SalesInvoiceDateID --redundent?
	,CONVERT([binary](32), HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM(Company),'#','') )))	AS ProjectID
	,PartitionKey

	,Company
	,MAX(TRIM(SalesPerson)) AS SalesPersonName
	,TRIM(CustNum) AS CustomerNum
	,TRIM(ProdNo) AS PartNum
	--,'' AS PartType
	,TRIM(OrderNum) AS SalesOrderNum
	,OrderLine AS SalesOrderLine
	--,'' AS SalesOrderSubLine
	--,'' AS SalesOrderType
	--,'' AS OrderCategory
	,InvoiceNum AS SalesInvoiceNum
	,OrderLine AS SalesInvoiceLine
	--,'' AS SalesInvoiceType
	,IIF(InvoiceDate = '',  CONVERT(date, '1900-01-01'),  CONVERT(date, InvoiceDate)) AS SalesInvoiceDate
	,IIF(DeliveryDate = '0', CONVERT(date, '1900-01-01'), CONVERT(date, DeliveryDate)) AS ActualDelivDate
	,Qty AS SalesInvoiceQty
	,[Unit] AS UoM
	,UnitPriceSEK	AS UnitPrice
	,UnitCostSEK	AS UnitCost
	,1 - (1 - DiscountPercent/100)*(1 - DiscountPercent2/100)*(1 - DiscountPercent3/100) AS DiscountPercent
	,UnitPriceSEK*Qty*(1 - (1 - DiscountPercent/100)*(1 - DiscountPercent2/100)*(1 - DiscountPercent3/100))	AS DiscountAmount
	--,0 AS CashDiscountOffered
	--,0 AS CashDiscountUsed
	--,0 AS TotalMiscChrg
	--,0 AS VATAmount
	,'SEK' AS Currency
	,1 AS ExchangeRate
	,IIF(Qty<0, 1, 0)	AS CreditMemo
	--,'' AS SalesChannel
	--,''AS Department
	,WarehouseCode
	--,NULL AS DeliveryAddress
	--,'' AS CostBearerNum
	--,'' AS CostUnitNum
	--,'' AS ReturnComment
	--,'' AS ReturnNum
	--,'' AS ProjectNum
	,CONCAT(JNo, '#', TrNo) AS IndexKey
	--,'' AS SIRes1
	--,'' AS SIRes2
	--,'' AS SIRes3
FROM [stage].[ABK_SE_SOLine]
--tmp
GROUP BY
	PartitionKey, Company,/* TRIM(SalesPerson),*/ CustNum, ProdNo, OrderNum, OrderLine, InvoiceNum, InvoiceDate, DeliveryDate, Qty, UnitPriceSEK, UnitCostSEK, WarehouseCode,  ExchangeRate, Currency, [Unit], CONCAT(JNo, '#', TrNo), DiscountPercent, DiscountPercent2, DiscountPercent3 --, OrderType, InvoiceLine, TotalMiscChrg, CreditMemo, InvoiceType, [ProjectNum], [VAT], [SalesChannel], [BusinessChain]
GO
