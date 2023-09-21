IF OBJECT_ID('[stage].[vROR_SE_OLine]') IS NOT NULL
	DROP VIEW [stage].[vROR_SE_OLine];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE VIEW [stage].[vROR_SE_OLine] AS
--COMMENT EMPTY FIELDS// ADD UPPER()TRIM() INTO CustomerID,WarehouseID 2022-12-22 VA
--CUSTOMERNUM / PARTNUM 23-02-17 VA
SELECT
	CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT(Company, '#', TRIM([SalesOrderNum]), '#', TRIM([SalesOrderLine])))) AS SalesOrderID --, '#', TRIM([SalesOrderCategory])
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(Company))) AS CompanyID
	--,CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT(Company, '#', TRIM(IIF(CustomerNum IS NULL OR CustomerNum = '', 'MISSINGCUSTOMER', CustomerNum))))) AS CustomerID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM(Company), '#', TRIM(CustomerNum))))) AS CustomerID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(Company, '#', TRIM(PartNum))))) AS PartID
	--,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM(Company), '#', TRIM(PartNum))))) AS PartID
	,CONVERT([binary](32), HASHBYTES('SHA2_256',UPPER(CONCAT(Company, '#', TRIM([WarehouseCode]))))) AS WarehouseID
	--,CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT(Company, '#', TRIM([WarehouseCode])))) AS WarehouseID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(Company, '#', TRIM([SalesOrderNum]))))) AS SalesOrderNumID

	,CONCAT(Company, '#', TRIM(CustomerNum), '#', TRIM(SalesOrderNum), '#', TRIM(SalesOrderLine), '#', TRIM(PartNum)) AS SalesOrderCode
--	,CONCAT(Company, '#', TRIM(IIF(CustomerNum IS NULL OR CustomerNum = '', 'MISSINGCUSTOMER', CustomerNum)), '#', TRIM(SalesOrderNum), '#', TRIM(SalesOrderLine), '#', TRIM(SalesInvoiceNum)) AS SalesOrderCode 

	--CONCAT(Company, '#', TRIM(SalesOrderNum), '#', TRIM(SalesOrderLine), '#', SUBSTRING(TRIM(SalesInvoiceNum), PATINDEX('%[0-9]%', SalesInvoiceNum ), 50)) AS SalesOrderCode --otiginal. why?
	,CONVERT(int, replace(convert(date, [SalesOrderDate]), '-', '')) AS SalesOrderDateID  --redundent?
	,CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT(Company, '#', ''))) AS ProjectID
	,PartitionKey

	,TRIM(Company) AS Company
	,TRIM(CustomerNum) AS CustomerNum
	,TRIM([SalesOrderNum]) AS [SalesOrderNum]
	,TRIM([SalesOrderLine]) AS [SalesOrderLine]
	,TRIM([SalesOrderSubLine]) AS [SalesOrderSubLine]
	,case WHEN [SalesOrderType] = '1' THEN 'Stock sales'
	      WHEN [SalesOrderType] IN ('4','i','S') THEN 'Direct sales' -- i and S are due to human error in input within GARP, should normally just be '4'
		  ELSE 'Other sales' 
		  END AS [SalesOrderType]
	,TRIM([SalesOrderCategory]) AS [SalesOrderCategory]
	,IIF([SalesOrderDate] = '' OR [SalesOrderDate] IS NULL, '1990-01-01', TRY_CONVERT(date, [SalesOrderDate])) AS [SalesOrderDate]
	,IIF([NeedbyDate] = '' OR [NeedbyDate] IS NULL, '1990-01-01', TRY_CONVERT(date,[NeedbyDate])) AS [NeedbyDate]
	,IIF([ExpDelivDate] = '' OR [ExpDelivDate] IS NULL, '1990-01-01', TRY_CONVERT(date,[ExpDelivDate])) AS [ExpDelivDate]
	,IIF([ExpDelivDate] = '' OR [ExpDelivDate] IS NULL, '1990-01-01', TRY_CONVERT(date,[ExpDelivDate])) AS ConfirmedDelivDate
	,IIF(SalesOrderStatus = 'Slutlevererad', TRY_CONVERT(date,[ExpDelivDate]), '1990-01-01') AS ActualDelivDate
	,TRIM(REPLACE(SalesInvoiceNum, ' ', '')) AS [SalesInvoiceNum]
	,IIF(UnitPrice < 0, -1*[SalesOrderQty], [SalesOrderQty]) AS [SalesOrderQty]
	,IIF(UnitPrice < 0, -1*[DelivQty], [DelivQty]) AS [DelivQty]
	,IIF(UnitPrice < 0, -1*[RemainingQty], [RemainingQty]) AS [RemainingQty]
	,NULL AS SalesInvoiceQty
	,TRIM([UoM]) AS [UoM]
	,ABS(UnitPrice) AS UnitPrice
	,ABS(UnitCost) AS UnitCost 
	,IIF([ExchangeRate] = 1, 'SEK', [Currency]) AS [Currency]
	,[ExchangeRate]
	,IIF(SalesInvoiceNum IS NULL, 1, 0) AS [OpenRelease] --Roro treats those not invoiced transactions as open orders (in the backlog)
	,[DiscountPercent]
	,[DiscountAmount]
	,TRIM(PartNum) AS PartNum
	,[PartType]
	,[PartStatus]
	,SalesOrderStatus
	,TRIM([SalesPersonName]) AS [SalesPersonName]
	,TRIM([WarehouseCode]) AS [WarehouseCode]
	,[SalesChannel]
	,IIF([SalesChannel] = 'Normal order', 'Normal Order Handling', 'Webshop') AS AxInterSalesChannel
	--,'' AS [Department]
	--,'' AS [ProjectNum] -- for service order: A- avsllutade
	--,'' AS [IndexKey]
	,Cancellation
	--,'' AS [SORes1]
	--,'' AS [SORes2]
	--,'' AS [SORes3]
	--,NULL AS [TotalMiscChrg]
FROM [stage].[ROR_SE_OLine]
--WHERE PartNum <> '' AND [SalesOrderQty] IS NOT NULL AND [UnitPrice] IS NOT NULL AND [UnitCost] IS NOT NULL -- AND [DelivQty] IS NOT NULL   --NeedbyDate <> '2016-05' --AND [SalesOrderDate] <> '1990-01-01' --[Company] IS NOT NULL  AND 
GO
