IF OBJECT_ID('[stage].[vTRA_FR_SOLine]') IS NOT NULL
	DROP VIEW [stage].[vTRA_FR_SOLine];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [stage].[vTRA_FR_SOLine] AS
--ADD UPPER() INTO PartID,CustomerID,WarehouseID 22-12-29 VA
SELECT 
	CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT(UPPER(Company), '#', TRIM(CustomerNum), '#', TRIM(SalesOrderNum), '#', TRIM(SalesOrderLine), '#', TRIM(SalesOrderSubLine), '#', TRIM(PartNum), '#', TRIM(SalesInvoiceNum), '#', TRIM(SalesOrderType), '#', TRIM(WarehouseCode)))) AS SalesInvoiceID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT(UPPER(Company), '#', TRIM(SalesOrderNum), '#', TRIM(SalesOrderLine)))) AS SalesOrderID
--	,CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT(Company, '#', TRIM(SalesInvoiceNum)))) AS SalesLedgerID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT(UPPER(Company), '#', TRIM(CustomerNum), '#', TRIM(SalesInvoiceNum)))) AS SalesLedgerID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT(UPPER(Company), '#', TRIM(SalesOrderNum)))) AS SalesOrderNumID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM(Company), '#', TRIM(CustomerNum))))) AS CustomerID
	--,CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT(UPPER(Company), '#', TRIM(IIF(CustomerNum IS NULL OR CustomerNum = '', 'MISSINGCUSTOMER', CustomerNum))))) AS CustomerID
    ,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(Company))) AS CompanyID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM(Company), '#', TRIM(PartNum))))) AS PartID
	--,CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT(UPPER(Company), '#', TRIM(IIF(PartNum IS NULL OR PartNum = '', 'MISSINGPART',  PartNum))))) AS PartID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM(Company), '#', TRIM(WarehouseCode))))) AS WareHouseID
	--,CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT(UPPER(Company), '#', WarehouseCode))) AS WareHouseID
	,CONCAT(UPPER(Company), '#', TRIM(IIF(CustomerNum IS NULL OR CustomerNum = '', 'MISSINGCUSTOMER', CustomerNum)), '#', TRIM(SalesOrderNum), '#', TRIM(SalesOrderLine), '#', SUBSTRING(TRIM(SalesInvoiceNum), 2, 50)) AS SalesOrderCode 
	,CONVERT(int, replace(convert(date,SalesInvoiceDate), '-', '')) AS SalesInvoiceDateID 
	,CONCAT(UPPER(Company), '#', TRIM(REPLACE(SalesInvoiceNum, ' ', ''))) AS SalesInvoiceCode
	,CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT( UPPER(Company), '#', '') ))	AS ProjectID
	,PartitionKey

	,TRIM(UPPER(Company)) AS Company
	,TRIM(SalesPersonName) AS SalesPersonName
	,TRIM(IIF(CustomerNum IS NULL OR CustomerNum = '', 'MISSINGCUSTOMER', CustomerNum)) AS CustomerNum
	,TRIM(IIF(PartNum IS NULL OR PartNum = '', 'MISSINGPART',  PartNum)) AS PartNum
	,TRIM(PartType) AS PartType
	,TRIM(SalesOrderNum) AS SalesOrderNum
	,TRIM(SalesOrderLine) AS SalesOrderLine
	,TRIM(SalesOrderSubLine) AS SalesOrderSubLine
	,TRIM(SalesOrderType) AS SalesOrderType
	,TRIM(REPLACE(SalesInvoiceNum, ' ', '')) AS SalesInvoiceNum
	,TRIM(SalesInvoiceLine) AS SalesInvoiceLine
	,TRIM(SalesInvoiceType) AS SalesInvoiceType
	,SalesInvoiceDate
	,ActualDelivDate
	,UoM
	,SalesInvoiceQty
	,UnitPrice
	,UnitCost
	,DiscountPercent 
	,DiscountAmount 
	,CashDiscountOffered
	,CashDiscountUsed
	,(TotalMiscChrg) AS TotalMiscChrg
	,(VATAmount) AS VATAmount
	,Currency
	,(ExchangeRate) AS ExchangeRate
	,IIF(TRIM(SalesOrderType) = 'Avoir', 1, 0) AS CreditMemo
	,TRIM(SalesChannel) AS SalesChannel
	,CASE WHEN SalesPersonName = 'Cessions Inter Agences' THEN 'Traction Levage Internal'
		WHEN CustomerNum in ('20589', '21842', '24961', '26612', '26663', '26725', '26805', '26899', '27161', '27175', '27252', '27318', '27382', '27410', '27488', '27633', '27747', '27981', '28140', '28553', '28559', '28591', '28597', '28599', '28608', '28631', '28651', '9251') THEN 'AxInter Internal Sales'
		ELSE 'External Sales' END AS Department
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

FROM stage.TRA_FR_SOLine
WHERE SalesInvoiceNum <> ''

--GROUP BY
--	PartitionKey, Company, SalesPersonName, CustomerNum, PartNum, PartType, SalesOrderNum, SalesOrderLine, SalesOrderSubLine, SalesOrderType, SalesInvoiceNum, SalesInvoiceDate, ActualDelivDate, UoM, WarehouseCode, Currency, CreditMemo, Indexkey, SalesChannel, Department, CostBearerNum, CostUnitNum, ReturnComment, ReturnNum, ProjectNum, SIRes1, SIRes2, SIRes3, TotalMiscChrg, VATAmount, ExchangeRate--, UnitCost, LinePrice, SalesInvoiceQty
GO
