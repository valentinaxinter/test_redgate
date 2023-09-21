IF OBJECT_ID('[stage].[vTRA_SE_SOLine]') IS NOT NULL
	DROP VIEW [stage].[vTRA_SE_SOLine];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [stage].[vTRA_SE_SOLine] AS
--COMMENT EMPTY FIELDS // ADD TRIM() UPPER() INTO WarehouseID,PartID,CustomerID 2022-12-27 VA
-- DELETE GROUP BY CLAUSE UPPER() IN COMPANY
SELECT 
	CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT(UPPER(Company), '#', TRIM(CustomerNum), '#', TRIM(SalesOrderNum), '#', TRIM(SalesOrderLine), '#', TRIM(SalesInvoiceNum), '#', TRIM(SalesInvoiceLine)))) AS SalesInvoiceID --, '#', TRIM(fakturatypbeskr), '#', TRIM(SalesChannel), '#', TRIM(SalesPersonName), '#', TRIM(WarehouseCode)
	,CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT(UPPER(Company), '#', TRIM(SalesOrderNum), '#', TRIM(SalesOrderLine)))) AS SalesOrderID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT(UPPER(Company), '#', TRIM(CustomerNum), '#', TRIM(SalesInvoiceNum)))) AS SalesLedgerID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT(UPPER(Company), '#', TRIM(SalesOrderNum)))) AS SalesOrderNumID
	--,CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT(UPPER(Company), '#', TRIM(CustomerNum)))) AS CustomerID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM(Company), '#', TRIM(CustomerNum))))) AS CustomerID
    ,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(Company))) AS CompanyID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM(Company), '#', TRIM(PartNum))))) AS PartID 
	--,CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT(UPPER(Company), '#', UPPER(TRIM(PartNum))))) AS PartID 	
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM(Company), '#', TRIM(WarehouseCode))))) AS WareHouseID
	--,CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT(UPPER(Company), '#', TRIM(WarehouseCode)))) AS WareHouseID
	,CONCAT(UPPER(Company), '#', TRIM(SalesOrderNum), '#', TRIM(SalesOrderLine), '#', TRIM(SalesOrderSubLine), '#', TRIM(SalesInvoiceNum)) AS SalesOrderCode
	,CONVERT(int, replace(convert(date,SalesInvoiceDate), '-', '')) AS SalesInvoiceDateID  --Redundant?
	,CONCAT(UPPER(Company), '#', TRIM(SalesInvoiceNum)) AS SalesInvoiceCode --Redundant?
	,CONVERT([binary](32), HASHBYTES('SHA2_256',CONCAT( UPPER(Company),'#','') ))	AS ProjectID
	,PartitionKey

	,UPPER(Company) AS Company
	,TRIM(SalesPersonName) AS SalesPersonName
	,TRIM(CustomerNum) AS CustomerNum
	,UPPER(TRIM(PartNum)) AS PartNum
	,PartType
	,TRIM(SalesOrderNum) AS SalesOrderNum
	,TRIM(SalesOrderLine) AS SalesOrderLine
	,TRIM(SalesOrderSubLine) AS SalesOrderSubLine
	,SalesOrderType
	,TRIM(SalesInvoiceNum) AS SalesInvoiceNum
	,TRIM(SalesInvoiceLine) AS SalesInvoiceLine
	,fakturatypbeskr AS SalesInvoiceType
	,CASE WHEN SalesInvoiceDate = '' THEN '1900-01-01' ELSE CONVERT(date, SalesInvoiceDate) END AS SalesInvoiceDate
	,ActualDelivDate
	,UoM
	,SalesInvoiceQty
	,UnitPrice	
	,UnitCost
	,DiscountPercent
	,DiscountAmount
	--,0 AS CashDiscountOffered
	--,0 AS CashDiscountUsed
	--,NULL AS TotalMiscChrg
	,VATAmount
	,Currency
	,ExchangeRate
	--,'' AS CreditMemo
	,TRIM(SalesChannel) AS SalesChannel
	--,'' AS Department
	,TRIM(WarehouseCode) AS WarehouseCode
	--,NULL AS DeliveryAddress
	--,'' AS CostBearerNum
	--,'' AS CostUnitNum
	--,'' AS ReturnComment
	--,'' AS ReturnNum
	--,'' AS ProjectNum
	--,'' AS IndexKey
	--,'' AS SIRes1
	--,'' AS SIRes2
	--,'' AS SIRes3

FROM stage.TRA_SE_SOLine

GROUP BY
	PartitionKey, Company, SalesPersonName, CustomerNum, PartNum, PartType, SalesOrderNum, SalesOrderLine, SalesOrderSubLine, SalesOrderType, SalesInvoiceNum, SalesInvoiceLine, fakturatypbeskr, SalesInvoiceDate, ActualDelivDate, UoM, SalesInvoiceQty, UnitPrice, UnitCost ,DiscountAmount, DiscountPercent, WarehouseCode, Currency, ExchangeRate, VATAmount, SalesChannel --, Department, CostBearerNum, CostUnitNum, ReturnComment, ReturnNum, ProjectNum, SIRes1, SIRes2, SIRes3, CreditMemo, Indexkey
GO
