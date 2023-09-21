IF OBJECT_ID('[stage].[vMAK_NL_SOLine]') IS NOT NULL
	DROP VIEW [stage].[vMAK_NL_SOLine];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE VIEW [stage].[vMAK_NL_SOLine] AS
--COMMENT empty fields / ADD UPPER() TRIM() INTO PartID,CustomerID 13-12-2022 VA
SELECT 
	CONVERT([binary](32),HASHBYTES('SHA2_256',CONCAT(Company, '#', SalesInvoiceNum, '#', SalesOrderNum, '#', SalesOrderLine, '#', PartNum, '#', SalesOrderType, '#',  IndexKey ))) AS SalesInvoiceID
	,CONVERT([binary](32),HASHBYTES('SHA2_256',CONCAT(Company,'#',SalesOrderNum,'#',SalesOrderLine,'#',SalesInvoiceNum))) AS SalesOrderID
	,CONVERT([binary](32),HASHBYTES('SHA2_256',CONCAT(Company, '#', TRIM(SalesInvoiceNum)))) AS SalesLedgerID
	,CONVERT([binary](32),HASHBYTES('SHA2_256',CONCAT(Company,'#',TRIM(SalesOrderNum)))) AS SalesOrderNumID
	--,CONVERT([binary](32),HASHBYTES('SHA2_256',CONCAT(Company,'#',TRIM(CustomerNum)))) AS CustomerID
	,CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM(Company),'#',TRIM(CustomerNum))))) AS CustomerID
    ,CONVERT([binary](32),HASHBYTES('SHA2_256',Company)) AS CompanyID
	,CONVERT([binary](32), HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM(Company), '#', TRIM(PartNum))))) AS PartID
	--,CONVERT([binary](32), HASHBYTES('SHA2_256',CONCAT(Company, '#', TRIM(PartNum)))) AS PartID  
	--,CONVERT([binary](32),HASHBYTES('SHA2_256',CONCAT(Company,'#',WarehouseCode))) AS WareHouseID
	,CONVERT([binary](32),HASHBYTES('SHA2_256',upper(CONCAT(trim(Company),'#',trim(WarehouseCode))))) AS WareHouseID -- TO 2022-12-13
	,CONCAT(TRIM(Company),'#',TRIM(SalesOrderNum),'#',TRIM(SalesOrderLine)) as SalesOrderCode
	,CONVERT(int, replace(convert(date,SalesInvoiceDate),'-','')) AS SalesInvoiceDateID  --Redundant?
	,CONCAT(Company,'#',TRIM(SalesInvoiceNum),'#',TRIM(InvoiceLine)) AS SalesInvoiceCode --Redundant?
	,CONVERT([binary](32), HASHBYTES('SHA2_256',CONCAT( Company,'#','') ))	AS ProjectID
	,PartitionKey

	,Company
	,[dbo].[ProperCase](SalesPersonName) AS SalesPersonName
	,TRIM(CustomerNum) AS CustomerNum
	,TRIM(PartNum) AS PartNum
	,MainItem   AS PartType
	,TRIM(SalesOrderNum) AS SalesOrderNum
	,SalesOrderLine		AS SalesOrderLine
	--,''	AS SalesOrderSubLine
	,SalesOrderType AS SalesOrderType
	,COALESCE(SalesInvoiceNum,'0000000')	AS SalesInvoiceNum
	,InvoiceLine	AS SalesInvoiceLine
	,SalesInvoiceType AS SalesInvoiceType
	,SalesInvoiceDate
	,COALESCE(ActualDelivDate, SalesInvoiceDate) 		AS ActualDelivDate
	,UoM
	,SalesInvoiceQty
	,COALESCE(UnitPrice/100.0, 0)	AS UnitPrice
	,COALESCE(UnitCost/100.0, 0)	AS UnitCost
	,COALESCE(DiscountAmount/NULLIF(SalesInvoiceQty*UnitPrice/100.0,0),0) AS DiscountPercent
	,COALESCE(DiscountAmount/100.0, 0) AS DiscountAmount
	--,0 AS CashDiscountOffered
	--,0 AS CashDiscountUsed
	,COALESCE(TotalMiscChrg/100.0, 0) AS TotalMiscChrg
	,VATAmount
	,Currency
	,COALESCE([ExchangeRate], 1) AS ExchangeRate
	,IIF(SalesOrderType = '006', 1, 0)  AS CreditMemo
	,IIF(SalesOrderNum LIKE 'TNT%', 'EDI', 'Normal Order Handling')   AS SalesChannel
	--,'' AS Department
	,WarehouseCode
	--,NULL AS DeliveryAddress
	--,'' AS CostBearerNum
	--,''AS CostUnitNum
	--,'' AS ReturnComment
	--,'' AS ReturnNum
	--,'' AS ProjectNum
	,IndexKey
	--,'' AS SIRes1
	--,'' AS SIRes2
	--,'' AS SIRes3
FROM stage.MAK_NL_SOLine
/*
GROUP BY
	PartitionKey,Company,SalesPersonName, CustomerNum, PartNum, SalesOrderNum, SalesOrderLine, SalesOrderType, SalesInvoiceNum,InvoiceLine, SalesInvoiceDate, SalesInvoiceType, ActualDeliveryDate,UnitPrice, UnitCost, UoM ,DiscountAmount,TotalMiscChrg,WarehouseCode, [Currency], [ExchangeRate],  SalesOrderType, MainItem
 */
GO
