IF OBJECT_ID('[stage].[vIOW_PL_SOLine]') IS NOT NULL
	DROP VIEW [stage].[vIOW_PL_SOLine];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO





CREATE VIEW [stage].[vIOW_PL_SOLine] AS

SELECT 
	CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(Company, '#', TRIM(CustomerNum), '#', TRIM(SalesOrderNum), '#', TRIM(SalesOrderLine), '#', TRIM(PartNum), '#', TRIM(SalesInvoiceNum), '#', TRIM(SalesInvoiceLine))))) AS SalesInvoiceID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(Company, '#', TRIM(SalesOrderNum), '#', TRIM(SalesOrderLine))))) AS SalesOrderID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(Company, '#', TRIM(CustomerNum), '#', TRIM(SalesInvoiceNum))))) AS SalesLedgerID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(Company, '#', TRIM(SalesOrderNum))))) AS SalesOrderNumID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(Company, '#', TRIM(CustomerNum))))) AS CustomerID
    ,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(Company))) AS CompanyID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(Company, '#', TRIM(PartNum))))) AS PartID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(Company, '#', WarehouseCode)))) AS WarehouseID
	,UPPER(CONCAT(Company, '#', TRIM(CustomerNum), '#', TRIM(SalesOrderNum), '#', TRIM(SalesOrderLine), '#', TRIM(SalesInvoiceNum))) AS SalesOrderCode
	,UPPER(CONVERT(int, IIF([SalesInvoiceDate] is null, '19000101', REPLACE(SalesInvoiceDate, '-', '')))) AS SalesInvoiceDateID
	,UPPER(CONCAT(Company, '#', TRIM(SalesInvoiceNum))) AS SalesInvoiceCode
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT( Company, '#', ProjectNum) ))) AS ProjectID
	,PartitionKey  --getdate() AS 

	,UPPER(Company) AS Company
	,UPPER(TRIM(CustomerNum)) AS CustomerNum
	,UPPER(TRIM(PartNum)) AS PartNum
	,TRIM(InvoiceHandler) AS SalesPersonName
	,PartType
	,TRIM(SalesOrderNum) AS SalesOrderNum
	,TRIM(SalesOrderLine) AS SalesOrderLine
	,LEFT(TRIM(SalesOrderSubLine), 50) AS SalesOrderSubLine
	,TRIM(SalesOrderType) AS SalesOrderType
	,TRIM(SalesInvoiceNum) AS SalesInvoiceNum 
	,TRIM(SalesInvoiceLine) AS SalesInvoiceLine
	,TRIM(SalesInvoiceType) AS SalesInvoiceType 
	,IIF([SalesInvoiceDate] is null, '1900-01-01', CAST(SalesInvoiceDate AS date)) AS [SalesInvoiceDate]
	,IIF([ActualDelivDate] is null, '1900-01-01', CAST(ActualDelivDate as date)) AS [ActualDelivDate]
	,UoM
	,IIF(SalesInvoiceType = 'Credit Note/Invoice reversal', -1*CONVERT(decimal(18,4),  REPLACE(SalesInvoiceQty, ',', '.')), CONVERT(decimal(18,4),  REPLACE(SalesInvoiceQty, ',', '.'))) AS SalesInvoiceQty --IIF(SalesInvoiceType = 'Credit Note/Invoice reversal', -1*REPLACE(SalesInvoiceQty, ',', '.'),
	,CONVERT(decimal(18,4), REPLACE(UNITPRICE, ',', '.')) AS UnitPrice
	,CONVERT(decimal(18,4), REPLACE(UnitCost, ',', '.')) AS UnitCost
	--,CONVERT(decimal(18,4), (CONVERT(decimal(18,4), REPLACE(UnitCost, ',', '.'))/CONVERT(decimal(18,4), REPLACE(ExchangeRate, ',', '.'))))  AS UnitCost  -- convert to original currency cost
	,CONVERT(decimal(18,4), REPLACE(DiscountPercent, ',', '.')) AS DiscountPercent
	,CONVERT(decimal(18,4), REPLACE(DiscountAmount, ',', '.')) AS DiscountAmount
	,NULL AS TotalMiscChrg -- the differences between UnitCost and Unitcost2, taken in consideration of its currency rate to PLN --CONVERT(decimal(18,4), (CONVERT(decimal(18,4), REPLACE(UnitCost, ',', '.'))/IIF(ExchangeRate2 IS NULL, NULL, CONVERT(decimal(18,4), REPLACE(ExchangeRate2, ',', '.'))) - CONVERT(decimal(18,4), REPLACE(UnitCost, ',', '.'))/CONVERT(decimal(18,4), REPLACE(ExchangeRate, ',', '.'))))*-1
	,NULL AS CashDiscountOffered
	,NULL AS CashDiscountUsed
	,CONVERT(decimal(18,4), REPLACE(VATAmount, ',', '.')) AS VATAmount
	,CONVERT(decimal(18,4), REPLACE([ExchangeRate], ',', '.')) AS [ExchangeRate]--IIF(Currency = 'EUR', CONVERT(decimal(18,4), REPLACE(sysCurrency, ',', '.')), CONVERT(decimal(18,4), REPLACE(ExchangeRate, ',', '.'))) AS ExchangeRate
	,LEFT([Currency], 50) AS [Currency] --CASE WHEN CONVERT(decimal(18,4), REPLACE(ExchangeRate, ',', '.')) = 1 THEN  'PLN'
										--	WHEN UnitCost2Curr = 'EUR' THEN 'EUR'
										--	WHEN Currency IS NULL AND CONVERT(decimal(18,4), REPLACE(ExchangeRate, ',', '.')) > 4 AND sysCurrency = '1.0' THEN 'EUR'
										--	ELSE Currency END AS Currency
	,IIF(TRIM(SalesInvoiceType) = 'Correction Invoice', '1', TRIM(CreditMemo)) AS CreditMemo
	,SalesChannel
	,Department
	,WarehouseCode
	,AddressLine AS DeliveryAddress
	,CostBearerNum
	,CostUnitNum
	,ReturnComment
	,ReturnNum
	,ProjectNum
	,IndexKey
	,UnitCost2Curr AS SIRes1
	,'' AS SIRes2
	,'' AS SIRes3
	,IIF(UnitCost2 IS NULL, NULL, CONVERT(decimal(18,4), REPLACE(UnitCost2, ',', '.'))) AS SIRes4
	,IIF(ExchangeRate2 IS NULL AND UnitCost2Curr = 'EUR', 1, CONVERT(decimal(18,4), REPLACE(ExchangeRate2, ',', '.'))) AS SIRes5 -- previously IIF(ExchangeRate2 IS NULL, NULL,...) | SB 2023-02-10
	,sysCurrency AS SIRes6 --for system currency

FROM axbus.IOW_PL_SOLine
--GROUP BY
--	PartitionKey, Company, CustomerNum, PartNum, PartType, SalesOrderNum, SalesOrderLine, SalesOrderType, SalesInvoiceNum, SALESINVOICETYPE, SALESORDERTYPE, SalesInvoiceDate, UoM, SalesInvoiceQty, DiscountPercent, Currency, ExchangeRate, CreditMemo, VATAmount, ReturnNum, UnitPrice, UnitCost, SalesChannel, Department, WarehouseCode, TotalMiscChrg, SalesOrderSubLine, SalesInvoiceLine, ActualDelivDate, ProjectNum, InvoiceHandler, DiscountAmount, DiscountPercent, UnitCost2, ExchangeRate2, AddressLine, CostBearerNum, CostUnitNum, ReturnComment, IndexKey, UnitCost2Curr,sysCurrency

--raw data has many issues, the above etl is for that the data can pull into dw for further improvement
GO
