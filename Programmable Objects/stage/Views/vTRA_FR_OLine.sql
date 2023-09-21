IF OBJECT_ID('[stage].[vTRA_FR_OLine]') IS NOT NULL
	DROP VIEW [stage].[vTRA_FR_OLine];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [stage].[vTRA_FR_OLine] AS
--COMMENT EMPTY FIELDS // ADD UPPER()TRIM() INTO PartID,CustomerID,WarehouseID 22-12-29 VA
SELECT 
	CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT(UPPER(Company), '#', TRIM(CustomerNum), '#', TRIM(SalesOrderNum), '#', TRIM(SalesOrderLine), '#', TRIM(SalesOrderSubLine), '#', TRIM(PartNum), '#', TRIM(SalesOrderType), '#', TRIM(WarehouseCode)))) AS SalesOrderID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT(UPPER(Company), '#', TRIM(SalesOrderNum)))) AS SalesOrderNumID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM(Company), '#', TRIM(CustomerNum))))) AS CustomerID
	--,CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT(UPPER(Company), '#', TRIM(IIF(CustomerNum IS NULL OR CustomerNum = '', 'MISSINGCUSTOMER', CustomerNum))))) AS CustomerID
    ,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(Company))) AS CompanyID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM(Company), '#', TRIM(PartNum))))) AS PartID
	--,CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT(UPPER(Company), '#', TRIM(IIF(PartNum IS NULL OR PartNum = '', 'MISSINGPART',  PartNum))))) AS PartID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM(Company), '#',TRIM(WarehouseCode))))) AS WareHouseID
	,CONCAT(Company, '#', TRIM(IIF(CustomerNum IS NULL OR CustomerNum = '', 'MISSINGCUSTOMER', CustomerNum)), '#', TRIM(SalesOrderNum), '#', TRIM(SalesOrderLine), '#', SUBSTRING(TRIM(SalesInvoiceNum), 2, 50)) AS SalesOrderCode 
	,CONVERT(int, replace(convert(date,SalesOrderDate), '-', '')) AS SalesOrderDateID 
	,CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT( Company, '#', '') ))	AS ProjectID
	,PartitionKey

	,TRIM(UPPER(Company)) AS Company
	,IIF(TRIM(SalesPersonName) = 'Cessions Inter Agences', 'Traction Levage Internal', TRIM(SalesPersonName)) AS SalesPersonName
	,TRIM(IIF(CustomerNum IS NULL OR CustomerNum = '', 'MISSINGCUSTOMER', CustomerNum)) AS CustomerNum
	,TRIM(IIF(PartNum IS NULL OR PartNum = '', 'MISSINGPART',  PartNum)) AS PartNum
	,TRIM(PartType) AS PartType
	,TRIM(SalesOrderNum) AS SalesOrderNum
	,TRIM(SalesOrderLine) AS SalesOrderLine
	,TRIM(SalesOrderSubLine) AS SalesOrderSubLine
	,TRIM(SalesOrderType) AS SalesOrderType
	,CASE WHEN Right(TRIM(SalesOrderNum), 2) = '.0' THEN 'InitialOrder'
		WHEN Right(TRIM(SalesOrderNum), 2) = '.1' THEN 'OrderPartialDeliv2'
		WHEN Right(TRIM(SalesOrderNum), 2) = '.2' THEN 'OrderPartialDeliv3'
		WHEN Right(TRIM(SalesOrderNum), 2) = '.3' THEN 'OrderPartialDeliv4'
		WHEN Right(TRIM(SalesOrderNum), 2) = '.4' THEN 'OrderPartialDeliv5'
		WHEN Right(TRIM(SalesOrderNum), 2) = '.5' THEN 'OrderPartialDeliv6'
		WHEN Right(TRIM(SalesOrderNum), 2) = '.6' THEN 'OrderPartialDeliv7'
		END AS SalesOrderCategory
	,TRIM(SalesOrderStatus) AS SalesOrderStatus
	,TRIM(SalesInvoiceNum) AS SalesInvoiceNum
	,SalesOrderDate
	,ExpDelivDate AS NeedbyDate
	,ExpDelivDate
	,'1900-01-01' AS ConfirmedDelivDate
	,ActualDelivDate
	,UoM
	,SalesOrderQty
	,DelivQty
	,IIF(RemainingQty > 0, RemainingQty, SalesOrderQty - DelivQty) AS RemainingQty
	--,NULL AS SalesInvoiceQty
	,UnitPrice
	,UnitCost
	,DiscountPercent 
	,DiscountAmount 
	,Currency
	,(ExchangeRate) AS ExchangeRate
	,TRIM(SalesOrderStatus) AS OpenRelease
	--,'' AS PartStatus
	,TRIM(WarehouseCode) AS WarehouseCode
	--,'' AS SalesChannel
	--,'' AS AxInterSalesChannel
	,CASE WHEN SalesPersonName = 'Cessions Inter Agences' THEN 'Traction Levage Internal Order'
		WHEN CustomerNum in ('20589', '21842', '24961', '26612', '26663', '26725', '26805', '26899', '27161', '27175', '27252', '27318', '27382', '27410', '27488', '27633', '27747', '27981', '28140', '28553', '28559', '28591', '28597', '28599', '28608', '28631', '28651', '9251') THEN 'AxInter Internal Order'
		ELSE 'External Order' END AS Department
	--,'' AS ProjectNum
	,IndexKey
	--,'' AS Cancellation
	--,'' AS SORes1
	--,'' AS SORes2
	--,'' AS SORes3
	--,NULL AS [TotalMiscChrg]
FROM stage.TRA_FR_OLine

--GROUP BY
--	PartitionKey, Company, SalesPersonName, CustomerNum, PartNum, PartType, SalesOrderNum, SalesOrderLine, SalesOrderSubLine, SalesOrderType, SalesInvoiceNum, SalesInvoiceDate, ActualDelivDate, UoM, WarehouseCode, Currency, CreditMemo, Indexkey, SalesChannel, Department, CostBearerNum, CostUnitNum, ReturnComment, ReturnNum, ProjectNum, SIRes1, SIRes2, SIRes3, TotalMiscChrg, VATAmount, ExchangeRate--, UnitCost, LinePrice, SalesInvoiceQty
GO
