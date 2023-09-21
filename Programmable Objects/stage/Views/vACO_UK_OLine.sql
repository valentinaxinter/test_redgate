IF OBJECT_ID('[stage].[vACO_UK_OLine]') IS NOT NULL
	DROP VIEW [stage].[vACO_UK_OLine];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE VIEW [stage].[vACO_UK_OLine] AS
--COMMENT empty fields / ADD UPPER() TRIM() INTO CustomerID/WarehouseID/PartID VA 13-12-2022
SELECT
	CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT(Company, '#', TRIM(OrderNum), '#', TRIM(OrderLine), '#', TRIM(OrderSubLine)))) AS SalesOrderID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', Company)) AS CompanyID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM(Company), '#', TRIM(CustNum))))) AS CustomerID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM(Company), '#', TRIM(PartNum))))) AS PartID 
	--,CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT(Company, '#', PartNum))) AS PartID 
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM(Company), '#', TRIM([WarehouseCode])))) ) AS WarehouseID
	,CONVERT([binary](32), HASHBYTES('SHA2_256',CONCAT( Company,'#',OrderNum) ))	AS SalesOrderNumID
	,CONCAT(Company, '#', TRIM(CustNum), '#', TRIM(OrderNum), '#', TRIM(OrderLine)) AS SalesOrderCode
	,CONVERT(int, replace(convert(date, OrderDate), '-', '')) AS SalesOrderDateID   --Redundant?
	,CONVERT([binary](32), HASHBYTES('SHA2_256',CONCAT( Company,'#','') ))	AS ProjectID
	,PartitionKey 

	,Company 
	,TRIM(CustNum) AS CustomerNum 
	,TRIM(OrderNum)	AS SalesOrderNum
	,CONVERT(nvarchar(50), TRIM(OrderLine)) AS SalesOrderLine
	,TRIM(OrderSubLine)	AS SalesOrderSubLine
	,CONVERT(nvarchar(50), OrderType) AS SalesOrderType
	--,'' AS SalesOrderCategory
	,OrderDate AS SalesOrderDate
	,[NeedByDate] AS NeedbyDate
	,[Delivdate] AS ExpDelivDate
	,CAST('1900-01-01' AS date) AS ActualDelivDate
	,CAST('1900-01-01' AS date) AS ConfirmedDelivDate
	,TRIM(InvoiceNum) AS SalesInvoiceNum
	,OrderQty AS SalesOrderQty
	,DelivQty
	,RemainingQty
	--,NULL AS SalesInvoiceQty
	,[Unit] AS UoM
	,UnitPrice
	,UnitCost
	,LEFT(Currency, 3) AS Currency
	,IIF(LEFT(Currency, 3) = 'GBP', 1, ExchangeRate) AS ExchangeRate
	,LEFT(CONVERT(char(1), MAX(OpenRelease)), 1) AS OpenRelease
	,DiscountAmount
	,DiscountPercent
	,TRIM(PartNum) AS PartNum
	,'' AS PartType
	,CONVERT(nvarchar(50), PartStatus) AS PartStatus
	,dbo.ProperCase(SalesPerson) AS SalesPersonName
	,TRIM(WarehouseCode) AS WarehouseCode
	,CASE	WHEN LEN(SalesChannel) = 8 THEN 'EXPRESS'	
			WHEN LEN(SalesChannel) = 12 THEN 'ADVANCE'
			WHEN CustNum LIKE 'RSCOMP%' THEN 'EDI'
			WHEN SalesPerson = '' THEN 'IMPORTED'
			ELSE SalesChannel END AS SalesChannel
	,CASE WHEN CustNum LIKE 'RSCOMP%' THEN 'EDI'
		WHEN LEN(SalesChannel) = 12 THEN 'Webshop'
		WHEN LEN(SalesChannel) = 8 THEN 'Webshop'
		ELSE 'Normal Order Handling' END AS AxInterSalesChannel
	,BusinessChain AS Department
	,null AS ProjectNum
	,'' AS IndexKey
	,'0' AS Cancellation
	--,Res1 AS SORes1
	--,Res2 AS SORes2
	--,Res3 AS SORes3
	--,NULL AS [TotalMiscChrg]
FROM stage.ACO_UK_OLine
GROUP BY PartitionKey, Company, OrderNum, OrderLine, OrderSubLine, CustNum, PartNum, OrderDate, OrderType, [NeedByDate], [Delivdate], InvoiceNum, OrderQty, DelivQty, RemainingQty, [Unit],
	UnitPrice, UnitCost, Currency, ExchangeRate, DiscountAmount, DiscountPercent, PartNum, PartStatus, SalesPerson, WarehouseCode, SalesChannel, BusinessChain--, Res1, Res2, Res3

UNION 

select 
SalesOrderID
,CompanyID
,CustomerID
,PartID
,WarehouseID
,SalesOrderNumID
,SalesOrderCode
,SalesOrderDateID
,ProjectID
,PartitionKey
,Company
,CustomerNum
,SalesOrderNum
,SalesOrderLine
,null as SalesOrderSubLine
,SalesOrderType
,SalesOrderDate
,NeedbyDate
,ExpDelivDate
,ActualDelivDate
,ConfirmedDelivDate
,SalesInvoiceNum
,SalesOrderQty
,DelivQty
,RemainingQty
,null as UoM
,UnitPrice
,UnitCost
,Currency
,ExchangeRate
,OpenRelease
,DiscountAmount
,DiscountPercent
,PartNum
,null as PartType
,null as PartStatus
,null as SalesPersonName
,null as WarehouseCode
,SalesChannel
,AxInterSalesChannel
,null as Department
,IndexKey
,Cancellation
,ProjectNum
from stage.vACO_UK_OLine_Manual_Adjustment
GO
