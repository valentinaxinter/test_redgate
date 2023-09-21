IF OBJECT_ID('[stage].[vROR_SE_SOLine]') IS NOT NULL
	DROP VIEW [stage].[vROR_SE_SOLine];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE VIEW [stage].[vROR_SE_SOLine] AS
--COMMENT EMPTY FIELDS // ADD UPPER() TRIM() INTO CustomerID,WarehouseID 2022-12-22 VA
--CUSTOMERNUM / PARTNUM 23-02-17 VA
SELECT 

	CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT(Company, '#', TRIM(CustomerNum), '#', TRIM(SalesOrderNum), '#', TRIM(SalesOrderLine), '#', TRIM(SalesOrderSubLine), '#', TRIM(PartNum), '#', TRIM(SalesInvoiceNum), '#', TRIM(SalesOrderType), '#', TRIM(WarehouseCode)))) AS SalesInvoiceID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(Company, '#', TRIM(SalesOrderNum), '#', TRIM(SalesOrderLine))))) AS SalesOrderID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT(Company, '#', TRIM(SalesInvoiceNum)))) AS SalesLedgerID --, '#', TRIM(CustomerNum)
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(Company, '#', TRIM(SalesOrderNum))))) AS SalesOrderNumID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM(Company), '#', TRIM(CustomerNum))))) AS CustomerID
	--,CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT(Company, '#', TRIM(IIF(CustomerNum IS NULL OR CustomerNum = '', 'MISSINGCUSTOMER', CustomerNum))))) AS CustomerID
    ,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(Company))) AS CompanyID
	--,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM(Company), '#', TRIM(PartNum))))) AS PartID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(Company, '#', TRIM(PartNum))))) AS PartID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM(Company), '#', TRIM(WarehouseCode))))) AS WareHouseID
	--,CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT(Company, '#', WarehouseCode))) AS WareHouseID

	,CONCAT(Company, '#', TRIM(CustomerNum), '#', TRIM(SalesOrderNum), '#', TRIM(SalesOrderLine), '#', TRIM(PartNum)) AS SalesOrderCode 

	,CONVERT(int, replace(convert(date,SalesInvoiceDate), '-', '')) AS SalesInvoiceDateID  --Redundant?
	,CONCAT(Company, '#', TRIM(REPLACE(SalesInvoiceNum, ' ', ''))) AS SalesInvoiceCode --Redundant?
	,CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT( Company, '#', '') ))	AS ProjectID
	,PartitionKey

	,TRIM(Company) AS Company
	,TRIM(SalesPersonName) AS SalesPersonName
	,TRIM(CustomerNum) AS CustomerNum
	,TRIM(PartNum) AS PartNum
	,TRIM(PartType) AS PartType
	,TRIM(SalesOrderNum) AS SalesOrderNum
	,TRIM(SalesOrderLine) AS SalesOrderLine
	,TRIM(SalesOrderSubLine) AS SalesOrderSubLine
	,TRIM(SalesOrderType) AS SalesOrderType
	,SalesInvoiceNum 
	,SalesInvoiceLine
	,SalesInvoiceType
	,CASE WHEN SalesInvoiceDate = '' THEN '1900-01-01' ELSE TRY_CONVERT(date, SalesInvoiceDate) END AS SalesInvoiceDate
	,ActualDelivDate
	,UoM
	,IIF(UnitPrice < 0, -1*SalesInvoiceQty, SalesInvoiceQty) AS SalesInvoiceQty
	,ABS(UnitPrice) AS UnitPrice
	,ABS(UnitCost) AS UnitCost 
	,DiscountPercent 
	,DiscountAmount 
	,CashDiscountOffered
	,CashDiscountUsed
	,(TotalMiscChrg) AS TotalMiscChrg
	,(VATAmount) AS VATAmount
	,IIF([ExchangeRate] = 1, 'SEK', [Currency]) AS [Currency] --'SEK' AS 
	,ExchangeRate --(ExchangeRate/ExchangeRate) AS 
	,CreditMemo
	,SalesChannel
	,SalesChannel AS AxInterSalesChannel
	--,'' AS Department
	,TRIM(WarehouseCode) AS WarehouseCode
	--,NULL AS DeliveryAddress
	--,'' AS CostBearerNum
	--,'' AS CostUnitNum
	,ReturnComment
	,ReturnNum
	--,'' AS ProjectNum
	,IndexKey
	--,'' AS SIRes1
	--,'' AS SIRes2
	--,'' AS SIRes3

FROM stage.ROR_SE_SOLine
where SalesInvoiceNum is not null
--GROUP BY
--	PartitionKey, Company, SalesPersonName, CustomerNum, PartNum, PartType, SalesOrderNum, SalesOrderLine, SalesOrderSubLine, SalesOrderType, SalesInvoiceNum, SalesInvoiceDate, ActualDelivDate, UoM, WarehouseCode, Currency, CreditMemo, Indexkey, SalesChannel, Department, CostBearerNum, CostUnitNum, ReturnComment, ReturnNum, ProjectNum, SIRes1, SIRes2, SIRes3, TotalMiscChrg, VATAmount, ExchangeRate--, UnitCost, LinePrice, SalesInvoiceQty
GO
