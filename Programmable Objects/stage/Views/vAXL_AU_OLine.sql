IF OBJECT_ID('[stage].[vAXL_AU_OLine]') IS NOT NULL
	DROP VIEW [stage].[vAXL_AU_OLine];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




CREATE VIEW [stage].[vAXL_AU_OLine] AS

SELECT
	CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(Company, '#', TRIM(CustNum), '#', TRIM(OrderNum), '#', TRIM(OrderLine), '#', TRIM(OrderSubLine), '#', TRIM(PartDesc))))) AS SalesOrderID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(Company, '#', TRIM(OrderNum))))) AS SalesOrderNumID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(Company))) AS CompanyID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(Company, '#', TRIM(CustNum))))) AS CustomerID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(Company, '#', TRIM(PartNum), '#', (IIF(TRIM([PartNum]) LIKE 'IACO%' , 'MISC. CHARGES', TRIM(PartDesc) )) )))) AS PartID
	,CONVERT(int, replace(convert(date, OrderDate), '-', '')) AS SalesOrderDateID
	,UPPER(CONCAT(Company, '#', TRIM(OrderNum), '#', TRIM(OrderLine), '#', TRIM(OrderSubLine))) AS SalesOrderCode
	,PartitionKey

	,UPPER(Company) AS Company
	,TRIM(CustNum) AS CustomerNum 
	,TRIM(OrderNum) AS [SalesOrderNum]
	,TRIM(OrderLine) AS [SalesOrderLine]
	,TRIM(OrderSubLine) AS [SalesOrderSubLine]
	,CONVERT(nvarchar(50), TRIM(OrderType)) AS [SalesOrderType]
	,TRIM([SalesOrderCategory]) AS [SalesOrderCategory]
	,OrderDate AS [SalesOrderDate]
	,NeedbyDate
	,ExpDelivDate AS [ExpDelivDate]
	,EDCExpDelivDate
	,ActualDelivDate
	,TRIM(InvoiceNum) AS [SalesInvoiceNum]
	,OrderQty AS [SalesOrderQty]
	,DelivQty
	,RemainingQty
	,Unit AS [UoM]
	,UnitPrice
	,UnitCost
	,LEFT(TRIM(Currency), 3) AS Currency
	,ExchangeRate
	,LEFT(TRIM(OpenRelease), 1) AS OpenRelease
	,DiscountAmount
	,DiscountPercent
	,NULL AS CashDiscOffered
	,NULL AS CashDiscUsed
	,TRIM(PartNum) AS PartNum
	,UPPER(PartDesc) AS PartDesc
	,'' AS [PartType]
	,CONVERT(nvarchar(50), PartStatus) AS PartStatus
	,TRIM(SalesPerson) AS [SalesPersonName]
	,TRIM(WareHouseCode) AS WarehouseCode
	,'' AS IndexKey
	,TRIM(SalesChannel) AS SalesChannel
	,TRIM(BusinessChain) AS [Department]
	,Res3 AS [ProjectNum] -- = FreeOfCharge: Y = yes, N = no
	,'' AS Cancellation
	,Res1 AS SORes1
	,Res2 AS SORes2
	,Res3 AS SORes3
FROM stage.AXL_AU_OLine
WHERE OrderDate >= '2015-01-01'
GO
