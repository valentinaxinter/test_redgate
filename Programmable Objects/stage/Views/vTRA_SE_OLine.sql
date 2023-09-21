IF OBJECT_ID('[stage].[vTRA_SE_OLine]') IS NOT NULL
	DROP VIEW [stage].[vTRA_SE_OLine];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [stage].[vTRA_SE_OLine] AS
--COMMENT EMPTY FIELDS // ADD TRIM() UPPER() INTO WarehouseID,PartID,CustomerID 2022-12-27 VA
SELECT
	CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(Company, '#', TRIM([CustomerNum]), '#', TRIM([SalesOrderNum]), '#', TRIM([SalesOrderLine]), '#', TRIM([SalesOrderSubLine]), '#', TRIM(IndexKey))))) AS SalesOrderID --, '#', UPPER(TRIM([SalesInvoiceNum])), '#', TRIM([PartNum])
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(Company))) AS CompanyID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT(UPPER(Company), '#', TRIM(CustomerNum)))) AS CustomerID
	--,CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT(UPPER(Company), '#', UPPER(TRIM([PartNum]))))) AS PartID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(trim(Company), '#', (TRIM([PartNum])))))) AS PartID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM(Company), '#', TRIM(WarehouseCode))))) AS WarehouseID
	--,CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT(UPPER(Company), '#', TRIM(WarehouseCode)))) AS WarehouseID --TRIM(WarehouseCode)
	,CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT(UPPER(Company), '#', TRIM(SalesOrderNum)))) AS SalesOrderNumID
	,CONCAT(UPPER(Company), '#', TRIM(SalesOrderNum), '#', TRIM(SalesOrderLine), '#', TRIM(SalesOrderSubLine), '#', TRIM(SalesInvoiceNum)) AS SalesOrderCode
	,CONVERT(int, replace(convert(date, [SalesOrderDate]), '-', '')) AS SalesOrderDateID  --redundent?
	,CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT( UPPER(Company),'#','') ))	AS ProjectID
	,PartitionKey

	,UPPER(Company) AS Company
	,TRIM([CustomerNum]) AS [CustomerNum]
	,TRIM([SalesOrderNum]) AS [SalesOrderNum]
	,TRIM([SalesOrderLine]) AS [SalesOrderLine]
	,TRIM([SalesOrderSubLine]) AS [SalesOrderSubLine]
	,[SalesOrderType]
	--,'' AS [SalesOrderCategory]
	,IIF([SalesOrderDate] = '' OR [SalesOrderDate] IS NULL, CONVERT(date, '1900-01-01'), CONVERT(date, [SalesOrderDate])) AS [SalesOrderDate]
	,IIF([SalesOrderDate] = '' OR [SalesOrderDate] IS NULL, CONVERT(date, '1900-01-01'), CONVERT(date, [NeedbyDate])) AS [NeedbyDate] --, CONVERT(date, [NeedbyDate])
	,IIF([SalesOrderDate] = '' OR [SalesOrderDate] IS NULL, CONVERT(date, '1900-01-01'), CONVERT(date, [ExpDelivDate]))  AS [ExpDelivDate] --CONVERT(date, [ExpDelivDate])
	,CAST('1900-01-01' AS date) AS ActualDelivDate
	,CAST('1900-01-01' AS date) AS ConfirmedDelivDate
	,TRIM([SalesInvoiceNum]) AS [SalesInvoiceNum]
	,[SalesOrderQty]
	,IIF(TransactionType = 'K', -1*[DelivQty], [DelivQty]) AS [DelivQty] --MAX
	,[RemainingQty] --[SalesOrderQty] - ([DelivQty]) AS [RemainingQty]
	--,NULL AS SalesInvoiceQty
	,TRIM([UoM]) AS [UoM]
	,[UnitPrice]
	,[UnitCost]
	,[Currency]
	,[ExchangeRate]
	,CONVERT(nvarchar(20), IIF(OpenRelease = 'Fakturerad', '0', OpenRelease)) AS OpenRelease
	,[DiscountPercent]
	,[DiscountAmount]
	,UPPER(TRIM([PartNum])) AS [PartNum]
	,TransactionType AS [PartType]
	--,'' AS [PartStatus]
	,TRIM([SalesPersonName]) AS [SalesPersonName]
	,TRIM(WarehouseCode) AS [WarehouseCode] --TRIM([WarehouseCode])
	,[SalesChannel]
	,IIF([SalesChannel] = 'Internet', 'Webshop', 'Normal Order Handling') AS AxInterSalesChannel
	--,'' AS [Department]
	--,'' AS [ProjectNum]
	,[IndexKey]
	--,'0' AS Cancellation
	--,'' AS [SORes1]
	--,'' AS [SORes2]
	--,'' AS [SORes3]
	--,NULL AS [TotalMiscChrg]
FROM [stage].[TRA_SE_OLine]
WHERE SalesOrderDate >= '2015-01-01' --and [SalesChannel] NOT IN ('Flyttning mellan lagerställen', 'Garanti')
--and OpenRelease != 'Annullerad'
--GROUP BY PartitionKey, UPPER(Company), [CustomerNum], [SalesOrderNum], [SalesOrderLine], [SalesOrderSubLine], [SalesOrderType], [SalesOrderDate], [NeedbyDate], [ExpDelivDate], [SalesInvoiceNum], [SalesOrderQty], [UoM], [UnitPrice], [UnitCost], [Currency], [ExchangeRate], [OpenRelease], [DiscountPercent], [DiscountAmount], [PartNum], [SalesPersonName], [SalesChannel] , [WarehouseCode], IndexKey, TransactionType
--GO
GO
