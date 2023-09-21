IF OBJECT_ID('[stage].[vSVE_SE_SOLine]') IS NOT NULL
	DROP VIEW [stage].[vSVE_SE_SOLine];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [stage].[vSVE_SE_SOLine] AS
--COMMENT EMPTY FIELDS //ADD TRIM()UPPER() INTO PartID,WarehouseID 23-01-03 VA
SELECT 
	CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT(Company, '#', TRIM(CustomerNum), '#', TRIM(SalesOrderNum), '#', TRIM(SalesOrderLine), '#', TRIM(SalesOrderSubLine), '#', TRIM(PartNum), '#', TRIM(SalesInvoiceNum), '#', TRIM(SalesOrderType), '#', TRIM(WarehouseCode)))) AS SalesInvoiceID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT(Company, '#', TRIM(SalesOrderNum), '#', TRIM(SalesOrderLine)))) AS SalesOrderID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT(Company, '#', TRIM(SalesInvoiceNum)))) AS SalesLedgerID --, '#', TRIM(CustomerNum)
	,CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT(Company, '#', TRIM(SalesOrderNum)))) AS SalesOrderNumID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM(Company), '#', TRIM(CustomerNum))))) AS CustomerID
	--,CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT(Company, '#', TRIM(IIF(CustomerNum IS NULL OR CustomerNum = '', 'MISSINGCUSTOMER', CustomerNum))))) AS CustomerID
    ,CONVERT([binary](32), HASHBYTES('SHA2_256', Company)) AS CompanyID
	,CONVERT([binary](32), HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM(Company), '#', TRIM(PartNum))))) AS PartID
	--,CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT(Company, '#', TRIM(IIF(PartNum IS NULL OR PartNum = '', 'MISSINGPART',  PartNum))))) AS PartID
	,CONVERT([binary](32), HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM(Company), '#', TRIM(WarehouseCode))))) AS WareHouseID
	--,CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT(Company, '#', WarehouseCode))) AS WareHouseID
	,CONCAT(Company, '#', TRIM(CustomerNum), '#', TRIM(SalesOrderNum), '#', TRIM(SalesOrderLine), '#', SUBSTRING(TRIM(SalesInvoiceNum), 2, 50)) AS SalesOrderCode 
	-- CONCAT(Company, '#', TRIM(SalesOrderNum), '#', TRIM(SalesOrderLine), '#', SUBSTRING(TRIM(SalesInvoiceNum), PATINDEX('%[0-9]%', SalesInvoiceNum ), 50)) AS SalesOrderCode --otiginal; Added substring + patindex to fix the needbydate etc. in dm salesInvoice /SM 2021-05-31
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
	,TRIM(REPLACE(SalesInvoiceNum, ' ', '')) AS SalesInvoiceNum -- Added substring + patindex to fix the needbydate etc. in dm salesInvoice /SM 2021-05-31
	--,'' AS SalesInvoiceLine
	--,'' AS SalesInvoiceType
	,CASE WHEN SalesInvoiceDate = '' THEN '1900-01-01' ELSE TRY_CONVERT(date, SalesInvoiceDate) END AS SalesInvoiceDate
	,TRY_CONVERT(date, ActualDelivDate) as ActualDelivDate
	,UoM
	,SUM(SalesInvoiceQty) AS SalesInvoiceQty
	,IIF(SUM(SalesInvoiceQty) <> 0, SUM(LinePrice)/SUM(SalesInvoiceQty), NULL ) AS UnitPrice
	,IIF(SUM(SalesInvoiceQty) <> 0, (CONVERT(decimal(18,4), SUM(UnitCost)/SUM(SalesInvoiceQty))), NULL) AS UnitCost
	--,0 AS DiscountPercent --AVG(CONVERT(decimal(18,4), DiscountPercent))
	--,0 AS DiscountAmount --SUM(CONVERT(decimal(18,4), ABS(DiscountAmount)))
	--,0 AS CashDiscountOffered
	--,0 AS CashDiscountUsed
	,(TotalMiscChrg) AS TotalMiscChrg
	,(VATAmount) AS VATAmount
	,Currency
	,(ExchangeRate) AS ExchangeRate
	,IIF(SalesOrderType = 'Kredit', 1, 0) AS CreditMemo
	,TRIM(SalesChannel) AS SalesChannel
	,TRIM(Department) AS Department
	,TRIM(WarehouseCode) AS WarehouseCode
	--,NULL AS DeliveryAddress
	,CostBearerNum
	,CostUnitNum
	,ReturnComment
	,TRIM(ReturnNum) AS ReturnNum
	,TRIM(ProjectNum) AS ProjectNum
	,TRIM(IndexKey) AS IndexKey
	,SIRes1
	,SIRes2
	,SIRes3
FROM stage.SVE_SE_SOLine

GROUP BY
	PartitionKey, Company, SalesPersonName, CustomerNum, PartNum, PartType, SalesOrderNum, SalesOrderLine, SalesOrderSubLine, SalesOrderType, SalesInvoiceNum, SalesInvoiceDate, ActualDelivDate, UoM, WarehouseCode, Currency, CreditMemo, Indexkey, SalesChannel, Department, CostBearerNum, CostUnitNum, ReturnComment, ReturnNum, ProjectNum, SIRes1, SIRes2, SIRes3, TotalMiscChrg, VATAmount, ExchangeRate--, UnitCost, LinePrice, SalesInvoiceQty
GO
