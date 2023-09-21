IF OBJECT_ID('[stage].[vSPR_NL_OLine]') IS NOT NULL
	DROP VIEW [stage].[vSPR_NL_OLine];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [stage].[vSPR_NL_OLine] AS
--COMMENT EMPTY FIELDS // ADD TRIM() UPPER()INTO PartID,WarehouseID,CustomerID 23-01-09 VA
SELECT
	CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT(Company, '#', TRIM([SalesOrderNum]), '#', TRIM([SaleOrderLine]), '#', TRIM([SalesOrderSubLine]) ))) AS SalesOrderID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', [Company])) AS CompanyID
	,CONVERT([binary](32), HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM(Company), '#', TRIM(CustomerNum))))) AS CustomerID
	--,CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT(Company, '#', TRIM(CustomerNum)))) AS CustomerID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM(Company), '#', TRIM([PartNum]))))) AS PartID
	--,CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT(Company, '#', TRIM([PartNum])))) AS PartID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM(Company), '#', TRIM(WarehouseCode))))) AS WareHouseID
	--,CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT(Company, '#', TRIM(WarehouseCode)))) AS WareHouseID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT(Company, '#', TRIM(SalesOrderNum)))) AS SalesOrderNumID
	,CONCAT(Company, '#', TRIM(CustomerNum), '#', TRIM(SalesOrderNum), '#', TRIM(SaleOrderLine), '#', TRIM(PartNum)) AS SalesOrderCode
	,CONVERT(int, CONCAT('20', SUBSTRING([SalesOrderDate], 7,2),SUBSTRING([SalesOrderDate], 4,2),SUBSTRING([SalesOrderDate], 1,2))) AS SalesOrderDateID 
	,CONVERT([binary](32), HASHBYTES('SHA2_256',CONCAT( Company,'#','') ))	AS ProjectID
	,PartitionKey

	,[Company]
	,TRIM([CustomerNum]) AS [CustomerNum]
	,TRIM([SalesOrderNum]) AS [SalesOrderNum]
	,TRIM([SaleOrderLine]) AS [SalesOrderLine]
	,TRIM([SalesOrderSubLine]) AS [SalesOrderSubLine]
	,[SalesOrderType]
	,TRIM([SalesOrderCategory]) AS [SalesOrderCategory]
	,CONCAT('20', SUBSTRING([SalesOrderDate], 7,2), '-', SUBSTRING([SalesOrderDate], 4,2), '-', SUBSTRING([SalesOrderDate], 1,2)) AS [SalesOrderDate]
	,IIF([NeedbyDate] = '?', '1900-01-01', CONCAT('20', SUBSTRING([NeedbyDate], 7,2), '-', SUBSTRING([NeedbyDate], 4,2), '-', SUBSTRING([NeedbyDate], 1,2))) AS [NeedbyDate] 
	,IIF([ExpDelivDate] = '31/12/9999', '1900-01-01', CONCAT('20', SUBSTRING([ExpDelivDate], 7,2), '-', SUBSTRING([ExpDelivDate], 4,2), '-', SUBSTRING([ExpDelivDate], 1,2))) AS [ExpDelivDate]
	,IIF(ActualDelivDate = 'na', '1900-01-01', CONCAT('20', SUBSTRING(ActualDelivDate, 7,2), '-', SUBSTRING(ActualDelivDate, 4,2), '-', SUBSTRING(ActualDelivDate, 1,2))) AS ActualDelivDate
	,CONCAT('20', SUBSTRING([ExpDelivDate], 7,2), '-', SUBSTRING([ExpDelivDate], 4,2), '-', SUBSTRING([ExpDelivDate], 1,2)) AS ConfirmedDelivDate 
	,TRIM([SalesInvoiceNum]) AS [SalesInvoiceNum]
	,CONVERT(decimal(18,4), REPLACE([SalesOrderQty], ',', '.')) AS [SalesOrderQty]
	,CONVERT(decimal(18,4), REPLACE([DelivQty], ',', '.')) AS [DelivQty]
--	,[InvoiceQty]
	,CONVERT(decimal(18,4), REPLACE([RemainingQty], ',', '.')) AS [RemainingQty]
	,CONVERT(decimal(18,4), REPLACE(InvoiceQty, ',', '.')) AS SalesInvoiceQty
	,TRIM([UoM]) AS [UoM]
	,CONVERT(decimal(18,4), REPLACE(NettLineTotalOrdered, ',', '.'))/CONVERT(decimal(18,4), REPLACE([SalesOrderQty], ',', '.')) AS [UnitPrice] --REPLACE([UnitPrice], ',', '.')
	,REPLACE(REPLACE([UnitCost], '?', 0), ',', '.') AS [UnitCost]
	--,NULL AS [TotalMiscChrg] --CONVERT(decimal(18,4), REPLACE([SalesOrderQty], ',', '.'))*REPLACE([UnitPrice], ',', '.')*CAST(REPLACE([OrderDiscountPercentage], ',', '.') AS Decimal(18,4))*-1/1
	,CONVERT(decimal(18,4), REPLACE(NettLineTotalOrdered, ',', '.')) AS [SORes1]
	,REPLACE(DeliveredQtyAmount, ',', '.') AS [SORes2]
	,REPLACE(RemainingQtyAmount, ',', '.') AS [SORes3]
	,SalesOrderStatus AS [OpenRelease] --IIF([SalesInvoiceNum] IS NULL, 1, 0)  AS 
	,CONVERT(decimal(18,4), REPLACE(REPLACE([DiscountPercent], '?', 0), ',', '.')) AS [DiscountPercent] 
	--,NULL AS [DiscountAmount] --CONVERT(decimal(18,4), REPLACE([DiscountAmount], ',', '.'))
	,CONVERT(decimal(18,4), Replace(TotalMiscChrg, ',', '.')) AS TotalMiscChrg
	,TRIM([PartNum]) AS [PartNum]
	,TRIM([PartType]) AS [PartType]
	,TRIM([PartStatus]) AS [PartStatus]
	,TRIM([SalesPersonName]) AS [SalesPersonName]
	,TRIM([WarehouseCode]) AS [WarehouseCode]
	,[Currency]
	,CONVERT(decimal(18,4), [ExchangeRate]) AS [ExchangeRate]
	,TRIM([SalesChannel]) AS [SalesChannel]
	,TRIM([SalesChannel]) AS AxInterSalesChannel
	,TRIM([Department]) AS [Department]
	,IIF(SalesOrderStatus = 'Closed' AND DeliveredQtyAmount = '0', '1', '0') AS [ProjectNum]  --use as cancellation for Spruit as it is i the model and PBI, not the Cancellation itself
	,[IndexKey]
	,IIF(SalesOrderStatus = 'Closed' AND DeliveredQtyAmount = '0', '1', '0') AS Cancellation
FROM [stage].[SPR_NL_OLine]
--WHERE CONVERT(decimal(18,4), REPLACE([SalesOrderQty], ',', '.')) > 0
--GROUP BY
--	PartitionKey, Company, SalesPersonName, CustomerNum, PartNum, PartType, SalesOrderNum, SalesOrderLine,SalesOrderSubLine, SalesOrderType, SalesInvoiceNum, [SalesOrderDate], UoM, WarehouseCode, Currency, ExchangeRate, Indexkey, SalesChannel, Department,  ProjectNum, SORes1, SORes2, SORes3, [SalesOrderCategory], [NeedbyDate], [ExpDelivDate], [PartStatus], [OpenRelease], [DelivQty], [SalesOrderQty], [RemainingQty]   --, UnitPrice, UnitCost, DiscountPercent, DiscountAmount
GO
