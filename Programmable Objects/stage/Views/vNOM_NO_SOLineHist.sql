IF OBJECT_ID('[stage].[vNOM_NO_SOLineHist]') IS NOT NULL
	DROP VIEW [stage].[vNOM_NO_SOLineHist];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [stage].[vNOM_NO_SOLineHist] AS

SELECT
	CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM(Company),'#',TRIM(IssuerReceiverNum), '#', TRIM(OrderNum), '#', TRIM(PartNum), '#', TRIM(InvoiceNum), '#', TRIM(InvoiceLine))))) AS SalesInvoiceID
	,CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM(Company),'#',TRIM(OrderNum),'#',TRIM(OrderLine),'#',TRIM(InvoiceNum))))) AS SalesOrderID
	,CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM(Company),'#',TRIM(IssuerReceiverNum), '#', TRIM(InvoiceNum))))) AS SalesLedgerID
	,CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM(Company),'#',TRIM(OrderNum))))) AS SalesOrderNumID  
	,CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(TRIM(Company)))) AS CompanyID
	,CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM(Company),'#',TRIM(IssuerReceiverNum))))) AS CustomerID
	,CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM(Company),'#',TRIM(PartNum))))) AS PartID 
	,CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM([Company]),'#',TRIM([WarehouseCode]))))) AS WarehouseID
	,UPPER(CONCAT(TRIM(Company),'#',TRIM(OrderNum),'#',TRIM(OrderLine))) AS SalesOrderCode 
	,CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM(Company),'#',TRIM(InvoiceNum))))) AS SalesInvoiceNumID 
	,CONVERT(int, replace(convert(date,TransactionDate),'-','')) AS SalesInvoiceDateID
	,UPPER(CONCAT(TRIM(Company),'#',TRIM(InvoiceNum),'#',TRIM(InvoiceLine))) AS SalesInvoiceCode
	,CONVERT([binary](32), HASHBYTES('SHA2_256',CONCAT( Company,'#','') ))	AS ProjectID
	,'2022-04-05 10:00' AS PartitionKey

	,UPPER(TRIM(Company)) AS Company
	,'' AS SalesPersonName
	,UPPER(TRIM(IssuerReceiverNum)) AS CustomerNum
	,UPPER(TRIM(PartNum)) AS PartNum
	,CASE WHEN TRIM(OrderNum) = '0' THEN 'PrimaryPart' ELSE 'SubPart' END  AS PartType
	,UPPER(TRIM(OrderNum)) AS SalesOrderNum
	,UPPER(TRIM(OrderLine)) AS SalesOrderLine
	,'' AS SalesOrderSubLine-- '0' as OrderSubLine
	,'' AS SalesOrderType
	,TRIM(InvoiceNum) AS SalesInvoiceNum
	,UPPER(TRIM(InvoiceLine)) AS SalesInvoiceLine
	,'' AS SalesInvoiceType
	,CONVERT(date, TransactionDate) AS SalesInvoiceDate
	,CONVERT(date, TransactionDate) AS ActualDelivDate
	,IIF(TransactionQty IS NULL, 0, TRY_CONVERT(decimal(18,2), REPLACE(REPLACE(TransactionQty, ' ', ''), ',', '.')))*-1 AS SalesInvoiceQty
	,'' AS UoM
	,IIF(SalesUnitPrice IS NULL, 0, TRY_CONVERT(decimal(18,4), REPLACE(REPLACE(SalesUnitPrice, ' ', ''), ',', '.'))) AS UnitPrice
	,IIF(CostPrice IS NULL, 0, TRY_CONVERT(decimal(18,4), REPLACE(REPLACE(CostPrice, ' ', ''), ',', '.'))) AS UnitCost
	,0 AS DiscountPercent
	,0 AS DiscountAmount
	,0 AS CashDiscountOffered
	,0 AS CashDiscountUsed
	,0 AS TotalMiscChrg
	,NULL AS VATAmount
	,'NOK' AS Currency
	,1 AS ExchangeRate
	,'0' AS CreditMemo
	,'Normal Order Handling' AS SalesChannel
	,'' AS Department
	,UPPER(TRIM(WarehouseCode)) AS WarehouseCode
	,NULL AS DeliveryAddress
	,'' AS CostBearerNum
	,'' AS CostUnitNum
	,'' AS ReturnComment
	,'' AS ReturnNum
	,'' AS ProjectNum
	,IndexKey
	,'' AS SIRes1
	,'' AS SIRes2
	,'history data import' AS SIRes3
FROM stage.Nom_NO_StockTransactionOB
WHERE TransactionDate > '2014-12-31'
--GROUP BY
--	PartitionKey, Company, CustNum, OrderNum, OrderLine, OrderSubLine, OrderType, InvoiceNum, InvoiceLine, InvoiceDate, SellingShipQty, UnitPrice, UnitCost, Currency, ExchangeRate, TotalMiscChrg, DiscountAmount,PartNum, SalesPerson,  WarehouseCode, CreditMemo,SalesChannel
GO
