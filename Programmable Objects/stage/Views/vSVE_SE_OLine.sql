IF OBJECT_ID('[stage].[vSVE_SE_OLine]') IS NOT NULL
	DROP VIEW [stage].[vSVE_SE_OLine];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE VIEW [stage].[vSVE_SE_OLine] AS
--COMMENT EMPTY FIELDS // ADD TRIM() UPPER() INTO PartID,WarehouseID,CustomerID 23-01-03 VA
SELECT
	CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT(Company, '#', TRIM([SalesOrderNum]), '#', TRIM([SalesOrderLine]), '#', TRIM([SalesOrderCategory])))) AS SalesOrderID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', Company)) AS CompanyID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM(Company), '#', TRIM(CustomerNum))))) AS CustomerID
	--,CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT(Company, '#', TRIM(IIF(CustomerNum IS NULL OR CustomerNum = '', 'MISSINGCUSTOMER', CustomerNum))))) AS CustomerID
	,CONVERT([binary](32), HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM(Company), '#', TRIM(PartNum))))) AS PartID
	--,CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT(Company, '#', TRIM(IIF(PartNum IS NULL OR PartNum = '', 'MISSINGPART',  PartNum))))) AS PartID
	,CONVERT([binary](32), HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM(Company), '#', TRIM([WarehouseCode]))))) AS WarehouseID
	--,CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT(Company, '#', TRIM([WarehouseCode])))) AS WarehouseID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT(Company, '#', TRIM([SalesOrderNum])))) AS SalesOrderNumID
	,CONCAT(Company, '#', TRIM(CustomerNum), '#', TRIM(SalesOrderNum), '#', TRIM(SalesOrderLine), '#', TRIM(SalesInvoiceNum)) AS SalesOrderCode
	--CONCAT(Company, '#', TRIM(SalesOrderNum), '#', TRIM(SalesOrderLine), '#', SUBSTRING(TRIM(SalesInvoiceNum), PATINDEX('%[0-9]%', SalesInvoiceNum ), 50)) AS SalesOrderCode --otiginal. why?
	,CONVERT(int, replace(convert(date, [SalesOrderDate]), '-', '')) AS SalesOrderDateID  --redundent?
	,CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT(Company, '#', TRIM([ProjectNum])))) AS ProjectID
	,PartitionKey

	,TRIM(Company) AS Company
	,TRIM(CustomerNum) AS CustomerNum
	,TRIM([SalesOrderNum]) AS [SalesOrderNum]
	,TRIM([SalesOrderLine]) AS [SalesOrderLine]
	,TRIM([SalesOrderSubLine]) AS [SalesOrderSubLine]
	,[SalesOrderType]
	,TRIM([SalesOrderCategory]) AS [SalesOrderCategory]
	,IIF([SalesOrderDate] = '' OR [SalesOrderDate] IS NULL, '1990-01-01', TRY_CONVERT(date, [SalesOrderDate])) AS [SalesOrderDate]
	,IIF([NeedbyDate] = '' OR [NeedbyDate] IS NULL, '1990-01-01', TRY_CONVERT(date,[NeedbyDate])) AS [NeedbyDate]
	,IIF([ExpDelivDate] = '' OR [ExpDelivDate] IS NULL, '1990-01-01', TRY_CONVERT(date,[ExpDelivDate])) AS [ExpDelivDate]
	,IIF([ExpDelivDate] = '' OR [ExpDelivDate] IS NULL, '1990-01-01', TRY_CONVERT(date,[ExpDelivDate])) AS ConfirmedDelivDate
	,IIF(ActualDelivDate = '' OR ActualDelivDate IS NULL, '1990-01-01', TRY_CONVERT(date,ActualDelivDate)) AS ActualDelivDate
	,TRIM(REPLACE(SalesInvoiceNum, ' ', '')) AS [SalesInvoiceNum]
	,IIF(TRIM([SalesOrderCategory]) = 'K', [DelivQty], [SalesOrderQty]) AS [SalesOrderQty]
	,[DelivQty]
	,CASE WHEN TRIM([SalesOrderCategory]) = 'K' THEN 0
		WHEN TRIM(ProjectNum) = 'A' THEN 0 --service order case A = Avslutade order
--		WHEN [DelivQty] >= [SalesOrderQty] AND TRIM([SalesOrderCategory]) NOT LIKE 'S%' THEN 0 -- Normal order case; 
		WHEN [SalesOrderQty] >= 0 AND [RemainingQty] < 0  THEN 0 -- if budgetQty = [SalesOrderQty] < 0 then Credit; > 0 means not credit and then if [RemainingQty] means levQty exceeds Ordered, then the Remaining is still not negative.
		ELSE [RemainingQty] END AS [RemainingQty]
	--,NULL AS SalesInvoiceQty
	,TRIM([UoM]) AS [UoM]
	,[UnitPrice]
	,[UnitCost]
	,[Currency]
	,[ExchangeRate]
	,IIF([OpenRelease] = 0, 1, 0) AS [OpenRelease] --Sverull Pyramid, 0 = Open; 1 = Closed. We AxInter BI is just opposite
	,[DiscountPercent]
	,(CONVERT(decimal(18,4), UnitPrice)*IIF(TRIM([SalesOrderCategory]) = 'K', [DelivQty], [SalesOrderQty])*CONVERT(decimal(18,4), DiscountPercent)/100) AS [DiscountAmount]
	,TRIM(PartNum) AS PartNum
	,[PartType]
	,[PartStatus]
	,TRIM([SalesPersonName]) AS [SalesPersonName]
	,TRIM([WarehouseCode]) AS [WarehouseCode]
	,[SalesChannel]
	,CASE WHEN [SalesChannel] = 'Webshop' THEN 'Webshop'
		WHEN [SalesOrderType] = 'Kassaförsäljning' THEN 'Over-the-Counter'
		ELSE 'Normal Order Handling' END AS AxInterSalesChannel
	,TRIM([Department]) AS [Department]
	,[ProjectNum] -- for service order: A- avsllutade
	,[IndexKey]
	--,'' AS Cancellation
	,[SORes1]
	,[SORes2]
	,[SORes3]
	--,NULL AS [TotalMiscChrg]
FROM [stage].[SVE_SE_OLine]
WHERE PartNum <> '' AND [SalesOrderQty] IS NOT NULL AND [UnitPrice] IS NOT NULL AND [UnitCost] IS NOT NULL -- AND [DelivQty] IS NOT NULL   --NeedbyDate <> '2016-05' --AND [SalesOrderDate] <> '1990-01-01' --[Company] IS NOT NULL  AND 
GO
