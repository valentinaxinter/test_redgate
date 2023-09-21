IF OBJECT_ID('[stage].[vNOM_FI_OLine]') IS NOT NULL
	DROP VIEW [stage].[vNOM_FI_OLine];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [stage].[vNOM_FI_OLine] AS
--Using a CTE with ROW_NUMBER() to protect against duplicates that occasionally arises from NomoFIs system. 
--In select statement, I put WHERE  RowNum = 1 to only get one row of each order line /SM 2021-09-15
WITH CTE AS 
(
SELECT
		CONVERT([binary](32),HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM(Company),'#', TRIM(OrderNum),'#', TRIM(OrderLine) /*,'#', TRIM(OrderRelNum),'#', UnitPrice,'#', DiscountAmount */)))) AS SalesOrderID 
	,CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(TRIM(Company)))) AS CompanyID
	,CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM(Company),'#',TRIM(CustNum))))) AS CustomerID
	,CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM(Company),'#',TRIM(PartNum))))) AS PartID 
	,CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM([Company]),'#',TRIM([WarehouseCode]))))) AS WarehouseID
	,CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM(Company),'#',TRIM(OrderNum))))) AS SalesOrderNumID  
	,UPPER(CONCAT(TRIM(Company),'#',TRIM(OrderNum),'#',TRIM(OrderLine))) AS SalesOrderCode 
	,CONVERT(int, replace(convert(date, OrderDate),'-','')) AS SalesOrderDateID --Redundant?  
	,CONVERT([binary](32), HASHBYTES('SHA2_256',CONCAT( Company,'#','') ))	AS ProjectID
	,PartitionKey 

	,UPPER(TRIM(Company)) AS Company
	,UPPER(TRIM(CustNum)) AS CustomerNum 
	,UPPER(TRIM(OrderNum)) AS SalesOrderNum
	,UPPER(TRIM(OrderLine)) AS SalesOrderLine
	,OrderSubLine AS SalesOrderSubLine
	,IIF(SalesOrderType = '10 - Internal Order', 'Internal Order', SalesOrderType) AS SalesOrderType -- added 2022-08-26 LL/DZ
	,'' AS SalesOrderCategory
	,OrderDate AS SalesOrderDate
	,NeedbyDate
	,ExpDelivDate
	,ActualDelivDate
	,FirstConfirnedDate AS ConfirmedDelivDate
	,UPPER(TRIM(InvoiceNum)) AS SalesInvoiceNum
	,CASE WHEN OpenRelease = 'I' THEN IIF(SalesOrderType = '8 - Credit Order', -1*DelivQty, DelivQty)
		WHEN SalesOrderType = '8 - Credit Order' THEN -1*abs(OrderQty) ELSE OrderQty END  AS SalesOrderQty --Tobias Teams 20221010 /DZ
	,IIF(SalesOrderType = '8 - Credit Order', -1*DelivQty, DelivQty) AS DelivQty
	,RemainingQty
	,NULL AS SalesInvoiceQty
	,'' AS UoM
	,UnitPrice
	,UnitCost
	,Currency  --CASE WHEN (Company = 'NomoSE' and CurrExChRate = 1) THEN 'SEK'  WHEN (Company = 'NomoDK' and CurrExChRate = 1) THEN 'DKK'  WHEN (Company = 'NomoFI' and CurrExChRate = 1) THEN 'EUR' ELSE CURRENCY END AS 
	, ExchangeRate
	,CASE WHEN OpenRelease = 'I' THEN '0' ELSE '1' END AS OpenRelease
	,IIF(SalesOrderType = '8 - Credit Order', -1*abs(DiscountAmount), abs(DiscountAmount)) AS DiscountAmount
	,DiscountPercent
	,PartNum
	,ItemClass AS PartType
	,PartStatus
	,SalesPersonName
	,UPPER(TRIM(WarehouseCode)) AS WarehouseCode
	,SalesOrderChannel AS SalesChannel
	,SalesOrderChannel AS AxInterSalesChannel
	,UpdateStock AS IsUpdatingStock
	,'' AS Department
	,'' AS ProjectNum
	,'' AS IndexKey
	,ReturnComment
	,UPPER(TRIM(SalesReturnOrderNum)) AS SalesReturnOrderNum
	,UPPER(TRIM(SalesReturnInvoiceNum)) AS SalesReturnInvoiceNum
	,'0' AS Cancellation
	,'' AS SORes1
	,'' AS SORes2
	,'' AS SORes3
	,ROW_NUMBER() OVER (PARTITION BY Company,OrderNum,OrderLine ORDER BY UnitPrice) AS RowNum
	,NULL AS [TotalMiscChrg]
FROM stage.NOM_FI_OLine
GROUP BY
	PartitionKey, Company, CustNum, OrderNum, OrderLine, OrderSubLine, SalesOrderType, OrderRelNum, InvoiceNum, OrderQty, DelivQty, RemainingQty, UnitPrice, UnitCost, Currency, ExchangeRate, OpenRelease, DiscountAmount, DiscountPercent, PartNum, PartStatus, SalesPersonName, ReturnComment, SalesReturnOrderNum, SalesReturnInvoiceNum, WarehouseCode, OrderDate, NeedbyDate, DelivDate, SalesOrderChannel, ItemClass,ExpDelivDate,ActualDelivDate, FirstConfirnedDate, UpdateStock
)

SELECT [SalesOrderID], [CompanyID], [CustomerID], [PartID], [WarehouseID], [SalesOrderNumID], [SalesOrderCode], [SalesOrderDateID], [ProjectID], [PartitionKey], [Company], [CustomerNum], [SalesOrderNum], [SalesOrderLine], [SalesOrderSubLine], [SalesOrderType], [SalesOrderCategory], [SalesOrderDate], [NeedbyDate], [ExpDelivDate], [ActualDelivDate], [ConfirmedDelivDate], [SalesInvoiceNum], [SalesOrderQty], [DelivQty], [RemainingQty], [SalesInvoiceQty], [UoM], [UnitPrice], [UnitCost], [Currency], [ExchangeRate], [OpenRelease], [DiscountAmount], [DiscountPercent], [PartNum], [PartType], [PartStatus], [SalesPersonName], [WarehouseCode], [SalesChannel], [AxInterSalesChannel], [IsUpdatingStock], [Department], [ProjectNum], [IndexKey], [ReturnComment], [SalesReturnOrderNum], [SalesReturnInvoiceNum], [Cancellation], [SORes1], [SORes2], [SORes3], [RowNum], [TotalMiscChrg]
FROM CTE
WHERE RowNum = 1
GO
