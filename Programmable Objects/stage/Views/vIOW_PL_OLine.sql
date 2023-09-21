IF OBJECT_ID('[stage].[vIOW_PL_OLine]') IS NOT NULL
	DROP VIEW [stage].[vIOW_PL_OLine];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [stage].[vIOW_PL_OLine] AS

SELECT
	CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(Company, '#', TRIM([SalesOrderNum]), '#', TRIM([SalesOrderLine])) ))) AS SalesOrderID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER([Company]))) AS CompanyID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(Company, '#', TRIM(CustomerNum))))) AS CustomerID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(Company, '#', TRIM([PartNum]))))) AS PartID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(Company, '#', TRIM(WarehouseCode))))) AS WarehouseID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(Company, '#', TRIM(SalesOrderNum))))) AS SalesOrderNumID --, '#', TRIM(Department)
	,UPPER(CONCAT(Company, '#', TRIM(CustomerNum), '#', TRIM(SalesOrderNum), '#', TRIM(SalesOrderLine), '#', TRIM(SalesInvoiceNum))) AS SalesOrderCode
	,CONVERT(int, REPLACE([SalesOrderDate], '-', '')) AS SalesOrderDateID 
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT( Company,'#','') )))	AS ProjectID
	,PartitionKey --

	,UPPER([Company]) AS[Company]
	,UPPER(LEFT(TRIM([CustomerNum]), 50)) AS [CustomerNum]
	,UPPER(LEFT(TRIM([PartNum]), 50)) AS [PartNum]
	,LEFT(TRIM([SalesOrderNum]), 50) AS [SalesOrderNum]
	,LEFT(TRIM(SalesOrderLine), 50) AS [SalesOrderLine]
	,LEFT(TRIM([SalesOrderSubLine]), 50) AS [SalesOrderSubLine]
	,LEFT([SalesOrderType], 50) AS [SalesOrderType]
	,LEFT(TRIM([SalesOrderCategory]), 50) AS [SalesOrderCategory]
	,CONVERT(date, iif([SalesOrderDate] is null, '1900-01-01', [SalesOrderDate])) AS [SalesOrderDate]
	,CONVERT(date, iif([NeedbyDate] is null, '1900-01-01', IIF([NeedbyDate] IN ('02-02-0023', '03-07-0023', '11-08-0023', '29-05-0233'), [SalesOrderDate], [NeedbyDate]))) AS [NeedbyDate]
	,CONVERT(date, iif([ExpDelivDate] is null, '1900-01-01', IIF([ExpDelivDate] IN ('23-08-0022'), [NeedbyDate], [ExpDelivDate]) )) AS [ExpDelivDate]
	,CONVERT(date, iif(ActualDelivDate is null, '1900-01-01', ActualDelivDate) ) AS ActualDelivDate
	,CONVERT(DATE, '1900-01-01') AS ConfirmedDelivDate 
	--,CONVERT(date, iif([SalesOrderDate] is null, '1900-01-01', CONCAT(RIGHT([SalesOrderDate],4), '-', substring([SalesOrderDate],4,2), '-', LEFT([SalesOrderDate], 2)))) AS [SalesOrderDate]
	--,CONVERT(date, iif([NeedbyDate] is null, '1900-01-01', CONCAT(RIGHT([NeedbyDate],4), '-', substring([NeedbyDate],4,2), '-', LEFT([NeedbyDate], 2)))) AS [NeedbyDate]
	--,CONVERT(date, iif([ExpDelivDate] is null, '1900-01-01', CONCAT(RIGHT([ExpDelivDate],4), '-', substring([ExpDelivDate],4,2), '-', LEFT([ExpDelivDate], 2)))) AS [ExpDelivDate]
	--,CONVERT(date, iif(ActualDelivDate is null, '1900-01-01', CONCAT(RIGHT(ActualDelivDate,4), '-', substring(ActualDelivDate,4,2), '-', LEFT(ActualDelivDate, 2))) ) AS ActualDelivDate
	--,CONVERT(DATE, '1900-01-01') AS ConfirmedDelivDate 
	,LEFT(TRIM([SalesInvoiceNum]), 50) AS [SalesInvoiceNum]
	,CONVERT(decimal(18,4), REPLACE([SalesOrderQty], ',', '.')) AS [SalesOrderQty]
	,CONVERT(decimal(18,4), REPLACE([DelivQty], ',', '.')) AS [DelivQty]
	,CONVERT(decimal(18,4), REPLACE(RemainingQty, ',', '.')) AS [RemainingQty]
	,CONVERT(decimal(18,4), REPLACE(InvoiceQty, ',', '.')) AS SalesInvoiceQty
	,CONVERT(decimal(18,4), REPLACE([UnitPrice], ',', '.')) AS [UnitPrice]
	,CONVERT(decimal(18,4), REPLACE([UnitCost], ',', '.')) AS [UnitCost]
	,NULL AS TotalMiscChrg -- the differences between UnitCost and Unitcost2, taken in consideration of its currency rate to PLN AS [TotalMiscChrg] --CONVERT(decimal(18,4), (CONVERT(decimal(18,4), REPLACE(UnitCost, ',', '.'))/IIF(ExchangeRate2 IS NULL, NULL, CONVERT(decimal(18,4), REPLACE(ExchangeRate2, ',', '.'))) - CONVERT(decimal(18,4), REPLACE(UnitCost, ',', '.'))/CONVERT(decimal(18,4), REPLACE(ExchangeRate, ',', '.'))))*-1 -- see comments in soline /DZ
	,CONVERT(decimal(18,4), REPLACE([DiscountPercent], ',', '.')) AS [DiscountPercent]
	,CONVERT(decimal(18,4), REPLACE([DiscountAmount], ',', '.')) AS [DiscountAmount]
	,LEFT(TRIM([UoM]), 50) AS [UoM]
	,SalesOrderStatus AS [OpenRelease]  
	,LEFT(TRIM([PartType]), 50) AS [PartType]
	,LEFT(TRIM([PartStatus]), 50) AS [PartStatus]
	,LEFT(TRIM(OrderHandler), 50) AS [SalesPersonName]
	,LEFT(TRIM([WarehouseCode]), 50) AS [WarehouseCode]
	,LEFT([Currency], 50) AS [Currency]
	,CONVERT(decimal(18,4), REPLACE([ExchangeRate], ',', '.')) AS [ExchangeRate]
	,LEFT(TRIM([SalesChannel]), 50) AS [SalesChannel]
	,LEFT(TRIM([SalesChannel]), 50) AS AxInterSalesChannel
	,LEFT(TRIM([Department]), 50) AS [Department]
	,LEFT([ProjectNum], 50) AS [ProjectNum]
	,LEFT([IndexKey], 50) AS [IndexKey]
	,LEFT(Cancellation, 50) AS Cancellation
	,UnitCost2Curr AS [SORes1]
	,'' AS [SORes2]
	,'' AS [SORes3]
	,IIF(UnitCost2 IS NULL, NULL, CONVERT(decimal(18,4), REPLACE(UnitCost2, ',', '.'))) AS [SORes4]
	,IIF(ExchangeRate2 IS NULL, NULL, CONVERT(decimal(18,4), REPLACE(ExchangeRate2, ',', '.'))) AS [SORes5]
	,sysCurrency AS [SORes6] --for system currency
FROM axbus.[IOW_PL_OLine]
GROUP BY
	PartitionKey, Company, CustomerNum, PartNum, PartType, SalesOrderNum, SalesOrderLine,SalesOrderSubLine, SalesOrderType, SalesInvoiceNum, [SalesOrderDate], UoM, WarehouseCode, Currency, ExchangeRate, Indexkey, SalesChannel, Department,  ProjectNum, SORes1, SORes2, SORes3, [SalesOrderCategory], [NeedbyDate], [ExpDelivDate], [PartStatus], [DelivQty], [SalesOrderQty], [RemainingQty], ActualDelivDate, InvoiceQty, UnitPrice, UnitCost, DiscountPercent, DiscountAmount, SalesOrderStatus, OrderHandler, Cancellation, UnitCost2Curr, UnitCost2,ExchangeRate2,sysCurrency
GO
