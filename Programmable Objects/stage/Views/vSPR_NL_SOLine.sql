IF OBJECT_ID('[stage].[vSPR_NL_SOLine]') IS NOT NULL
	DROP VIEW [stage].[vSPR_NL_SOLine];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [stage].[vSPR_NL_SOLine] AS
--COMMENT EMPTY FIELDS // ADD TRIM() UPPER() INTO PartID,WarehouseID,CustomerID 23-01-09 VA
SELECT 
	CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT(Company, '#', TRIM(CustomerNum), '#', TRIM(SalesOrderNum), '#', TRIM(SalesOrderLine), '#', TRIM(PartNum), '#', TRIM(SalesInvoiceNum), '#', TRIM(SalesInvoiceLine)))) AS SalesInvoiceID --ActualDelivDate is temp fix for duplication --, '#', ActualDelivDate
	,CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT(Company, '#', TRIM(SalesOrderNum), '#', TRIM(SalesOrderLine)))) AS SalesOrderID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT(Company, '#', TRIM(CustomerNum), '#', TRIM(SalesInvoiceNum)))) AS SalesLedgerID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT(Company, '#', TRIM(SalesOrderNum)))) AS SalesOrderNumID
	,CONVERT([binary](32), HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM(Company), '#', TRIM(CustomerNum))))) AS CustomerID
	--,CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT(Company, '#', TRIM(CustomerNum)))) AS CustomerID
    ,CONVERT([binary](32), HASHBYTES('SHA2_256', Company)) AS CompanyID
	,CONVERT([binary](32), HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM(Company), '#', TRIM(PartNum))))) AS PartID
	--,CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT(Company, '#', TRIM(PartNum)))) AS PartID
	,CONVERT([binary](32), HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM(Company), '#', '01')))) AS WareHouseID
	--,CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT(Company, '#', '01'))) AS WareHouseID
	,CONCAT(Company, '#', TRIM(CustomerNum), '#', TRIM(SalesOrderNum), '#', TRIM(SalesOrderLine), '#', TRIM(PartNum)) AS SalesOrderCode
	--,CONCAT(Company, '#', TRIM(SalesOrderNum), '#', TRIM(SalesOrderLine), '#', SUBSTRING(TRIM(SalesInvoiceNum), PATINDEX('%[0-9]%', SalesInvoiceNum ), 50)) AS SalesOrderCode -- Added substring + patindex to fix the needbydate etc. in dm salesInvoice /SM 2021-05-31
	,CONVERT(int, CONCAT('20', SUBSTRING([SalesInvoiceDate], 7,2), SUBSTRING([SalesInvoiceDate], 4,2), SUBSTRING([SalesInvoiceDate], 1,2))) AS SalesInvoiceDateID  --Redundant?
	,CONCAT(Company, '#', TRIM(SalesInvoiceNum)) AS SalesInvoiceCode --Redundant?
	,CONVERT([binary](32), HASHBYTES('SHA2_256',CONCAT( Company,'#','') ))	AS ProjectID
	,PartitionKey

	,Company
	--,'' AS SalesPersonName
	,TRIM(CustomerNum) AS CustomerNum
	,TRIM(PartNum) AS PartNum
	,PartType
	,TRIM(SalesOrderNum) AS SalesOrderNum
	,TRIM(SalesOrderLine) AS SalesOrderLine
	,SalesOrderSubLine
	,SALESORDERTYPE AS SalesOrderType
	,TRIM(SalesInvoiceNum) AS SalesInvoiceNum -- Added substring + patindex to fix the needbydate etc. in dm salesInvoice /SM 2021-05-31
	,TRIM(SalesInvoiceLine) AS SalesInvoiceLine
	,SALESINVOICETYPE AS SalesInvoiceType
	,CAST(CONCAT('20', SUBSTRING([SalesInvoiceDate], 7,2), '-', SUBSTRING([SalesInvoiceDate], 4,2), '-', SUBSTRING([SalesInvoiceDate], 1,2)) AS Date) AS [SalesInvoiceDate]
	,IIF(MAX([ActualDelivDate]) = '?', '1900-01-01', CAST(CONCAT('20', SUBSTRING(MAX([ActualDelivDate]), 7,2), '-', SUBSTRING(MAX([ActualDelivDate]), 4,2), '-', SUBSTRING(MAX([ActualDelivDate]), 1,2)) AS Date)) AS [ActualDelivDate]
	,UoM
	,CONVERT(decimal(18,4), Replace(SalesInvoiceQty, ',', '.')) AS SalesInvoiceQty
	,IIF(UnitPrice = '?', NULL, CONVERT(decimal(18,4), Replace(UNITPRICE, ',', '.'))) AS UnitPrice --MIN
	,CONVERT(decimal(18,4), Replace(UnitCost, ',', '.')) AS UnitCost
	,CONVERT(decimal(18,4), Replace(DiscountPercent, ',', '.')) AS DiscountPercent
	,CONVERT(decimal(18,4), Replace(SalesInvoiceQty, ',', '.'))*CONVERT(decimal(18,4), Replace(UnitPrice, ',', '.'))*CONVERT(decimal(18,4), Replace(DiscountPercent, ',', '.'))/100 AS DiscountAmount --ABS
	,CONVERT(decimal(18,4), Replace(TotalMiscChrg, ',', '.')) AS TotalMiscChrg
	--,0 AS CashDiscountOffered
	--,0 AS CashDiscountUsed
	,CONVERT(decimal(18,4), Replace(VATAmount, ',', '.')) AS VATAmount
	,CONVERT(decimal(18,4), Replace(ExchangeRate, ',', '.')) AS ExchangeRate
	,Currency
	,CreditMemo
	,SalesChannel
	,Department
	,WarehouseCode
	--,NULL AS DeliveryAddress
	--,'' AS CostBearerNum
	--,'' AS CostUnitNum
	--,'' AS ReturnComment
	,LEFT(ReturnNum, 50) AS ReturnNum
	--,'' AS ProjectNum
	--,'' AS IndexKey
	--,'' AS SIRes1
	--,'' AS SIRes2
	--,'' AS SIRes3

FROM stage.SPR_NL_SOLine
GROUP BY
	PartitionKey, Company,  CustomerNum, PartNum, PartType, SalesOrderNum, SalesOrderLine, SalesOrderType, SalesInvoiceNum, SALESINVOICETYPE, SALESORDERTYPE, SalesInvoiceDate, UoM, SalesInvoiceQty, DiscountPercent, Currency, ExchangeRate, CreditMemo, VATAmount, ReturnNum, UnitPrice, UnitCost, SalesChannel, Department, WarehouseCode, TotalMiscChrg, SalesOrderSubLine, SalesInvoiceLine --, (ActualDelivDate)

--raw data has many issues, the above etl is for that the data can pull into dw for further improvement
GO
