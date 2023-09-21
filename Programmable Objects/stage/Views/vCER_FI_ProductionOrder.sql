IF OBJECT_ID('[stage].[vCER_FI_ProductionOrder]') IS NOT NULL
	DROP VIEW [stage].[vCER_FI_ProductionOrder];

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE VIEW [stage].[vCER_FI_ProductionOrder] AS
SELECT
	CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM(Company), '#', TRIM(OrderNum), '#', TRIM([OrderLine]), '#', TRIM([OrderSubLine]), '#', TRIM(InvoiceNum), '#',TRIM(PartNum))))) AS [ProductionOrderID]
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM(Company), '#', TRIM(CustNum))))) AS CustomerID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(TRIM(Company)))) AS CompanyID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM(Company), '#', TRIM(PartNum))))) AS PartID 
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM([Company]), '#', TRIM([WarehouseCode]))))) AS WarehouseID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM(Company), '#', TRIM(OrderNum))))) AS SalesOrderNumID  
	,[PartitionKey]
	
	,UPPER(TRIM([Company])) AS Company                                  
	,UPPER(TRIM([OrderNum])) AS ProductionOrderNum                    
	,UPPER(TRIM([OrderLine])) AS ProductionOrderLineNum                 
	,UPPER(TRIM([PartNum])) AS PartNum                                 
	,'' AS [Uom]                                        
	,IIF(OrderSubLine = '000000', 'Assembly', 'Component') AS [PartType]
	,CONVERT(decimal(18,4), Replace([OrderQty], ',', '.')) AS OrderQuantity
	--,CONVERT(decimal(18,4), Replace([ScrappedQty Assembled Item], ',', '.')) AS ScrappedQty
	,CONVERT(decimal(18,4), Replace([DelivQty], ',', '.')) AS CompletedQuantity
	,CONVERT(decimal(18,4), Replace([RemainingQty], ',', '.')) AS RemainingQty                           
	,[OpenRelease] AS [Status] 
	,CASE WHEN [OrderDate] = '' OR [OrderDate] is NULL THEN CONVERT(date,'1900-01-01') ELSE CONVERT(date, [OrderDate]) END AS OrderCreateDate
	,CASE WHEN [NeedbyDate] = '' OR [NeedbyDate] is NULL THEN CONVERT(date,'1900-01-01') ELSE CONVERT(date, [NeedbyDate]) END AS RequestedEndDate
	--,CASE WHEN [StartDate] = '' OR [StartDate] is NULL THEN CONVERT(date,'1900-01-01') ELSE CONVERT(date, [StartDate]) END AS StartDate
	,CASE WHEN [ActualDelivDate] = '' OR [ActualDelivDate] is NULL THEN CONVERT(date,'1900-01-01') ELSE CONVERT(date, [ActualDelivDate]) END AS EndDate                              
	,TRIM([OrderType]) AS [OrderType]                             
	,UPPER(TRIM([WarehouseCode])) AS WarehouseCode                               
	,UPPER(TRIM([OrderNum])) AS SalesOrderNum                              
	,UPPER(TRIM([CustNum])) AS CustomerNum                          
	,[SalesPerson] AS ProductionOrderCreaterName
	,[OrderSubLine] AS [CurrentResourceGroup]
	,'EUR' AS [Currency]
	,1 AS [ExchangeRate]
	,WarehouseCode AS [BinNum]
	,'' AS [CostUnitNum]
	,[UnitPrice] AS [MaterialCost]
	,NULL AS TotalHoursPlanned		
	,NULL AS TotalHoursSpent
	,NULL AS LabourCost
	,CASE WHEN [OrderDate] = '' OR [OrderDate] is NULL THEN CONVERT(datetime,'1900-01-01') ELSE CONVERT(datetime, [OrderDate]) END AS CreatedTimeStamp
	,'' AS ModifiedTimeStamp
FROM [stage].[CER_FI_ProductionOrder]
GO
