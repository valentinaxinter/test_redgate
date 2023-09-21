IF OBJECT_ID('[stage].[vCER_SE_SOLine]') IS NOT NULL
	DROP VIEW [stage].[vCER_SE_SOLine];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




CREATE VIEW [stage].[vCER_SE_SOLine] AS
--COMMENT empty fields / ADD TRIM(Company) into PartID/CustomerID VA
SELECT 
	CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(Company, '#', TRIM(Indexkey))))) AS SalesInvoiceID 
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(Company, '#', OrderNum, '#', OrderLine, '#', InvoiceNum)))) AS SalesOrderID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(Company, '#', TRIM(CustNum), '#', TRIM(InvoiceNum))))) AS SalesLedgerID
	--,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(Company, '#', IIF(CustNum IS NULL OR CustNum = '', 'MISSINGCUSTOMER', CustNum), '#', InvoiceNum)))) AS SalesLedgerID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(Company, '#', TRIM(OrderNum))))) AS SalesOrderNumID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(TRIM(Company)))) AS CompanyID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM(Company), '#', TRIM(CustNum))))) AS CustomerID	
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM(Company), '#', TRIM(PartNum))))) AS PartID 
	--,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(Company, '#', TRIM(IIF(CustNum IS NULL OR CustNum = '', 'MISSINGCUSTOMER', CustNum) ))))) AS CustomerID	
	--,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(Company, '#', TRIM(IIF(PartNum IS NULL OR PartNum = '', 'MISSINGPART',  PartNum) ))))) AS PartID 
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM(Company), '#', TRIM(WarehouseCode))))) AS WarehouseID
	,UPPER(CONCAT(Company, '#', TRIM(OrderNum), '#', TRIM(OrderLine), '#', TRIM(PartNum))) AS SalesOrderCode
	,CONVERT(int, REPLACE(CONVERT(date, InvoiceDate), '-', '')) AS SalesInvoiceDateID  --Redundant
	,CONCAT(Company, '#', InvoiceNum, '#', InvoiceLine) AS SalesInvoiceCode --Reduntant
	,CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT( Company, '#', '') ))	AS ProjectID
	,PartitionKey

	,UPPER(TRIM(Company)) AS Company
	,TRIM(SalesPerson) AS SalesPersonName
	,UPPER(TRIM(CustNum)) AS CustomerNum
	,UPPER(TRIM(PartNum)) AS PartNum
	--,UPPER(TRIM(IIF(CustNum IS NULL OR CustNum = '', 'MISSINGCUSTOMER', CustNum) )) AS CustomerNum
	--,UPPER(TRIM(IIF(PartNum IS NULL OR PartNum = '', 'MISSINGPART',  PartNum) )) AS PartNum
	,IIF(OrderSubLine = '000000', 'Main', 'Sub' ) AS [PartType] --DZ changed on 20210422 --CASE WHEN TRIM(OrderNum) = '0' THEN 'PrimaryPart' ELSE 'SubPart' END  AS PartType
	,UPPER(TRIM(OrderNum)) AS SalesOrderNum
	,TRIM(OrderLine) AS SalesOrderLine
	,TRIM(OrderSubLine) AS SalesOrderSubLine
	,TRIM(OrderType) AS SalesOrderType
	,UPPER(TRIM(InvoiceNum)) AS SalesInvoiceNum
	,TRIM(InvoiceLine) AS SalesInvoiceLine
	--,'' AS SalesInvoiceType
	,CONVERT(date, InvoiceDate) AS SalesInvoiceDate
	,ActualDeliveryDate AS ActualDelivDate
	,SellingShipQty AS SalesInvoiceQty
	--,'' AS UoM
	,UnitPrice 
	,UnitCost
	,IIF(UnitPrice*SellingShipQty = 0, 0, DiscountAmount/UnitPrice*SellingShipQty) AS DiscountPercent -- added calc on 20210414
	,DiscountAmount
	,0 AS CashDiscountOffered
	,0 AS CashDiscountUsed
	,TotalMiscChrg
	--,NULL AS VATAmount
	,'SEK' AS Currency
	,1 AS ExchangeRate
	,CreditMemo
	,CASE WHEN TRIM(SalesPerson) = 'Order entered through EDI' THEN 'EDI'
		WHEN TRIM(SalesPerson) = 'docparser' THEN 'PDF'
		WHEN TRIM(SalesPerson) = 'Webshop Order' THEN 'Webshop'
		ELSE 'Normal Order Handling' END AS SalesChannel
	--,'' AS Department
	,WarehouseCode
	--,NULL AS DeliveryAddress
	--,'' AS CostBearerNum
	,CostUnitNum AS CostUnitNum
	,ReturnComment
	,TRIM(ReturnNum) AS ReturnNum
	--,'' AS ProjectNum
	,Indexkey --MAX(Indexkey) AS before 20210414 ID change
	--,'' AS SIRes1
	--,'' AS SIRes2
	--,'' AS SIRes3
FROM 
	stage.CER_SE_SOLine AS SO
--GROUP BY
--	PartitionKey, Company, SalesPerson, CustNum, PartNum, OrderNum, OrderLine, OrderSubLine, OrderType, InvoiceNum, InvoiceLine, InvoiceDate, SellingShipQty, UnitPrice, UnitCost, DiscountAmount, TotalMiscChrg, WarehouseCode, CreditMemo, ActualDeliveryDate, Indexkey, ReturnComment, ReturnNum, CostUnitNum
GO
